const base = db.getSiblingDB("pruebas_sgbd");
const reservas = base.getCollection("reservas");

reservas.drop();

const documentos = [];

for (let i = 1; i <= 10000; i++) {
    documentos.push({
        reserva_id: i,
        codigo_vuelo: `VL-${i}`,
        origen: `Aeropuerto ${i % 10}`,
        destino: `Aeropuerto ${(i + 3) % 10}`,
        pasajeros: 20 + (i % 100),
        retraso_minutos: i % 60
    });
}

reservas.insertMany(documentos);

const consulta1 = reservas.explain("executionStats").aggregate([
    {
        $group: {
            _id: "$origen",
            total_vuelos: { $sum: 1 }
        }
    }
]);

const consulta2 = reservas.explain("executionStats").find({
    retraso_minutos: { $gt: 30 }
});

print("Consulta 1: vuelos agrupados por origen");
printjson(consulta1);

print("Consulta 2: vuelos con retraso mayor a 30 minutos");
printjson(consulta2);
