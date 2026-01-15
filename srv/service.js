const cds = require('@sap/cds');

module.exports = cds.service.impl(async function() {
    // 1. Conectamos al servicio externo usando el nombre definido en tu .env: "BusinessPartnerA2X"
    const bp = await cds.connect.to('BusinessPartnerA2X');

    // 2. Definimos el manejador para la entidad que arroja el error
    this.on('READ', 'A_BusinessPartner', async (req) => {
        try {
            // 3. Delegamos la consulta OData al servicio externo
            return await bp.run(req.query);
        } catch (error) {
            req.error(500, `Error al consultar BusinessPartner: ${error.message}`);
        }
    });
});