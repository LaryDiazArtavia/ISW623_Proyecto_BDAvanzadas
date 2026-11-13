
const nombreBase = process.env.MONGO_DB || "pruebas_seguridad";
const base = db.getSiblingDB(nombreBase);
const nombreRol = "rol_consulta_protegida";

const permisos = [
    {
        resource: {
            db: nombreBase,
            collection: "vista_pasajeros_protegidos"
        },
        actions: ["find"]
    }
];

if (!base.getRole(nombreRol)) {
    base.createRole({
        role: nombreRol,
        privileges: permisos,
        roles: []
    });
} else {
    base.updateRole(nombreRol, {
        privileges: permisos,
        roles: []
    });
}

print("Rol de consulta protegida configurado.");
