using { BusinessPartnerA2X } from './external/BusinessPartnerA2X.cds';

using { RiskManagement as my } from '../db/schema.cds';

@path : '/service/RiskManagementService'
service RiskManagementService
{
    annotate Mitigations with @restrict :
    [
        { grant : [ '*' ], to : [ 'RiskManager' ] },
        { grant : [ 'READ' ], to : [ 'RiskViewer' ] }
    ];

    annotate Risks with @restrict :
    [
        { grant : [ '*' ], to : [ 'RiskManager' ] },
        { grant : [ 'READ' ], to : [ 'RiskViewer' ] }
    ];

    @cds.redirection.target
    @odata.draft.enabled
    entity Risks as
        projection on my.Risks;

    @cds.redirection.target
    @odata.draft.enabled
    entity Mitigations as
        projection on my.Mitigations;

    @cds.redirection.target
    entity A_BusinessPartner as
        projection on BusinessPartnerA2X.A_BusinessPartner
        {
            BusinessPartner,
            Customer,
            Supplier,
            BusinessPartnerCategory,
            BusinessPartnerFullName,
            BusinessPartnerIsBlocked
        };
}

// Anular la anotación que causa el error de validación en el cliente móvil
annotate RiskManagementService.A_BusinessPartner with @(
    Common.AddressViaNavigationPath : null
);

annotate RiskManagementService with @requires :
[
    'authenticated-user',
    'RiskViewer',
    'RiskManager'
];

