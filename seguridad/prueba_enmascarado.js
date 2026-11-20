
const base = db.getSiblingDB("pruebas_seguridad");
const reservas = base.getCollection("reservas");

reservas.updateOne(
    { reserva_id: 1 },
    {
        $set: {
            vuelo_id: 101,
            pasajeros: [
                {
                    nombre: "Ana Vargas",
                    pasaporte: "CR123456"
                },
                {
                    nombre: "Luis Mora",
                    pasaporte: "CR789012"
                }
            ]
        }
    },
    { upsert: true }
);

printjson(reservas.findOne(
    { reserva_id: 1 },
    { _id: 0 }
));
