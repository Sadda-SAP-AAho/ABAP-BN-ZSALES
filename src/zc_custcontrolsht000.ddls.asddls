@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_CUSTCONTROLSHT000
  provider contract transactional_query
  as projection on ZR_CUSTCONTROLSHT000
{
 key GateEntryNo,
 key CompCode,
 key Plant,
 key Imfyear,
 key Dealer,
 Vehiclenum,
 Gpdate,
 Controlsheet,
 CostCenter,
 DealerWiseCash,
 SalesPerson,
 AmtDeposited,
 PostedInd,
 CreatedBy,
 CreatedAt,
 LastChangedBy,
 LastChangedAt
}
