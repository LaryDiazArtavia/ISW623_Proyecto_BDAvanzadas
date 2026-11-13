const base = db.getSiblingDB("pruebas_seguridad");

if (!base.getCollectionInfos({ name: "vista_pasajeros_protegidos" }).length) {
    base.createView(
        "vista_pasajeros_protegidos",
        "reservas",
        [
            { $unwind: "$pasajeros" },
            {
                $project: {
                    _id: 0,
                    reserva_id: 1,
                    vuelo_id: 1,
                    nombre: {
                        $cond: [
                            { $ne: ["$pasajeros.nombre", null] },
                            "CONFIDENCIAL",
                            null
                        ]
                    },
                    pasaporte: {
                        $cond: [
                            { $ne: ["$pasajeros.pasaporte", null] },
                            "********",
                            null
                        ]
                    }
                }
            }
        ]
    );
}

printjson(base.vista_pasajeros_protegidos.find().toArray());
