
import argparse
import getpass
import json
import urllib.error
import urllib.request
from pathlib import Path
from urllib.parse import urlparse

CARPETA = Path(__file__).parent / "exportacion"
IDS_ORIGINALES = (27, 28, 29, 30, 31)

REFERENCIAS_ORIGEN = {
    "tabla": 9,
    "fecha": 72,
    "ruta": 74,
    "retraso_minutos": 78,
}


def leer(nombre):
    with (CARPETA / nombre).open(encoding="utf-8") as archivo:
        return json.load(archivo)


def peticion(servidor, ruta, sesion=None, metodo="GET", datos=None):
    encabezados = {"Content-Type": "application/json"}

    if sesion:
        encabezados["X-Metabase-Session"] = sesion

    cuerpo = None
    if datos is not None:
        cuerpo = json.dumps(datos, ensure_ascii=False).encode("utf-8")

    solicitud = urllib.request.Request(
        servidor + ruta,
        data=cuerpo,
        headers=encabezados,
        method=metodo,
    )

    try:
        with urllib.request.urlopen(solicitud, timeout=30) as respuesta:
            contenido = respuesta.read()
            return json.loads(contenido) if contenido else None
    except urllib.error.HTTPError as error:
        detalle = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(
            f"Error HTTP {error.code} en {ruta}: {detalle[:1000]}"
        ) from error


def obtener_lista(respuesta):
    if isinstance(respuesta, list):
        return respuesta
    if isinstance(respuesta, dict) and isinstance(respuesta.get("data"), list):
        return respuesta["data"]
    raise ValueError("Formato de respuesta inesperado")


def referencias_destino(servidor, sesion):
    bases = obtener_lista(
        peticion(servidor, "/api/database", sesion)
    )

    coincidencias = [
        base for base in bases
        if base["name"] == "Aerolínea Regional"
    ]

    if len(coincidencias) != 1:
        raise ValueError("No se encontró una única base Aerolínea Regional")

    base_id = coincidencias[0]["id"]

    metadata = peticion(
        servidor,
        f"/api/database/{base_id}/metadata",
        sesion,
    )

    tablas = [
        tabla for tabla in metadata["tables"]
        if tabla["schema"] == "dashboard_pruebas"
        and tabla["name"] == "vuelos"
    ]

    if len(tablas) != 1:
        raise ValueError("No se encontró dashboard_pruebas.vuelos")

    tabla = tablas[0]
    campos = {
        campo["name"]: campo["id"]
        for campo in tabla["fields"]
    }

    for nombre in ("ruta", "fecha", "retraso_minutos"):
        if nombre not in campos:
            raise ValueError(f"Falta la columna {nombre}")

    return {
        "base_datos": base_id,
        "tabla": tabla["id"],
        "ruta": campos["ruta"],
        "fecha": campos["fecha"],
        "retraso_minutos": campos["retraso_minutos"],
    }


def adaptar(valor, mapa):
    if isinstance(valor, list):
        resultado = [adaptar(elemento, mapa) for elemento in valor]

        if (
            len(resultado) >= 2
            and resultado[0] == "field"
            and isinstance(resultado[1], int)
        ):
            resultado[1] = mapa.get(resultado[1], resultado[1])

        return resultado

    if isinstance(valor, dict):
        resultado = {}

        for clave, contenido in valor.items():
            if clave == "source-table" and isinstance(contenido, int):
                resultado[clave] = mapa.get(contenido, contenido)
            else:
                resultado[clave] = adaptar(contenido, mapa)

        return resultado

    return valor


def validar_exportacion():
    dashboard = leer("dashboard.json")

    if len(dashboard["dashcards"]) != 5:
        raise ValueError("La exportación no tiene cinco gráficos")

    if len(dashboard["parameters"]) != 2:
        raise ValueError("La exportación no tiene dos filtros")

    nombres = {p["name"] for p in dashboard["parameters"]}

    if nombres != {"Ruta", "Fecha"}:
        raise ValueError("Los filtros exportados no coinciden")

    for identificador in IDS_ORIGINALES:
        pregunta = leer(f"pregunta_{identificador}.json")

        if pregunta["original_id"] != identificador:
            raise ValueError(f"ID incorrecto en pregunta {identificador}")

    for grafico in dashboard["dashcards"]:
        if grafico["card_id"] not in IDS_ORIGINALES:
            raise ValueError("Referencia a pregunta desconocida")

        if len(grafico["parameter_mappings"]) != 2:
            raise ValueError("Faltan conexiones de filtros")

    return dashboard


def encontrar_unico(elementos, nombre):
    coincidencias = [
        elemento for elemento in elementos
        if elemento.get("name") == nombre
        and not elemento.get("archived", False)
    ]

    if len(coincidencias) > 1:
        raise ValueError(f"Hay varios elementos llamados: {nombre}")

    return coincidencias[0] if coincidencias else None


def restaurar(servidor):
    exportacion = validar_exportacion()

    correo = input("Correo de Metabase de destino: ").strip()
    clave = getpass.getpass("Contraseña: ")

    sesion = peticion(
        servidor,
        "/api/session",
        metodo="POST",
        datos={"username": correo, "password": clave},
    )["id"]

    del clave

    referencias = referencias_destino(servidor, sesion)

    mapa = {
        REFERENCIAS_ORIGEN[nombre]: referencias[nombre]
        for nombre in REFERENCIAS_ORIGEN
    }

    print("\nReferencias detectadas:", referencias)

    dashboards = obtener_lista(
        peticion(servidor, "/api/dashboard", sesion)
    )

    dashboard_actual = encontrar_unico(
        dashboards, exportacion["name"]
    )

    if dashboard_actual:
        dashboard_id = dashboard_actual["id"]
        print("Dashboard existente:", dashboard_id)
    else:
        creado = peticion(
            servidor,
            "/api/dashboard",
            sesion,
            "POST",
            {
                "name": exportacion["name"],
                "description": exportacion.get("description") or "",
            },
        )

        dashboard_id = creado["id"]
        print("Dashboard creado:", dashboard_id)

    actual = peticion(
        servidor,
        f"/api/dashboard/{dashboard_id}",
        sesion,
    )

    tarjetas_existentes = {}

    for grafico in actual.get("dashcards", []):
        tarjeta = grafico.get("card") or {}

        if tarjeta.get("name"):
            tarjetas_existentes[tarjeta["name"]] = grafico

    preguntas_disponibles = obtener_lista(
        peticion(servidor, "/api/card", sesion)
    )

    ids_nuevos = {}

    for identificador in IDS_ORIGINALES:
        pregunta = leer(f"pregunta_{identificador}.json")
        nombre = pregunta["name"]

        existente = tarjetas_existentes.get(nombre)

        if existente:
            ids_nuevos[identificador] = existente["card_id"]
            print("Pregunta ya vinculada:", nombre)
            continue

        consulta = adaptar(pregunta["dataset_query"], mapa)
        consulta["database"] = referencias["base_datos"]

        coincidentes = [
            p for p in preguntas_disponibles
            if p.get("name") == nombre
            and not p.get("archived", False)
        ]

        if len(coincidentes) > 1:
            raise ValueError(f"Hay preguntas duplicadas: {nombre}")

        if coincidentes:
            tarjeta_id = coincidentes[0]["id"]
            print("Pregunta existente:", nombre)
        else:
            creada = peticion(
                servidor,
                "/api/card",
                sesion,
                "POST",
                {
                    "name": nombre,
                    "description": pregunta.get("description"),
                    "dataset_query": consulta,
                    "display": pregunta["display"],
                    "visualization_settings": pregunta.get(
                        "visualization_settings"
                    ) or {},
                    "collection_id": None,
                },
            )

            tarjeta_id = creada["id"]
            print("Pregunta creada:", nombre)

        ids_nuevos[identificador] = tarjeta_id

    graficos = []

    for indice, grafico in enumerate(
        exportacion["dashcards"], start=1
    ):
        original_id = grafico["card_id"]
        nuevo_id = ids_nuevos[original_id]
        nombre = leer(f"pregunta_{original_id}.json")["name"]

        existente = tarjetas_existentes.get(nombre)

        conexiones = adaptar(
            grafico["parameter_mappings"], mapa
        )

        for conexion in conexiones:
            conexion["card_id"] = nuevo_id

        graficos.append({
            "id": existente["id"] if existente else -indice,
            "card_id": nuevo_id,
            "row": grafico["row"],
            "col": grafico["col"],
            "size_x": grafico["size_x"],
            "size_y": grafico["size_y"],
            "parameter_mappings": conexiones,
            "visualization_settings": grafico.get(
                "visualization_settings"
            ) or {},
        })

    parametros = adaptar(exportacion["parameters"], mapa)

    if (
        len(tarjetas_existentes) == 5
        and len(actual.get("parameters", [])) == 2
        and all(
            len(g.get("parameter_mappings", [])) == 2
            and all(
                c.get("card_id") == g["card_id"]
                for c in g["parameter_mappings"]
            )
            for g in actual.get("dashcards", [])
        )
    ):
        print("\nEl dashboard ya está completo. No se modificó.")
        print(f"URL: {servidor}/dashboard/{dashboard_id}")
        return

    peticion(
        servidor,
        f"/api/dashboard/{dashboard_id}",
        sesion,
        "PUT",
        {
            "parameters": parametros,
            "dashcards": graficos,
        },
    )

    print("\nRESTAURACIÓN COMPLETADA")
    print("Gráficos:", len(graficos))
    print("Filtros:", len(parametros))
    print(f"URL: {servidor}/dashboard/{dashboard_id}")


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--url",
        default="http://localhost:3002",
        help="Dirección del Metabase de destino",
    )
    argumentos = parser.parse_args()

    servidor = argumentos.url.rstrip("/")
    destino = urlparse(servidor)

    if destino.hostname not in ("localhost", "127.0.0.1"):
        raise ValueError("Solo se permiten instalaciones locales")

    if destino.port == 3001:
        raise ValueError("Protección: no se modifica Metabase original")

    if destino.scheme != "http":
        raise ValueError("La conexión local debe utilizar HTTP")

    restaurar(servidor)


if __name__ == "__main__":
    main()
