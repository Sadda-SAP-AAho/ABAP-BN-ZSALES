@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_CONTROLSHEET
  provider contract transactional_query
  as projection on ZR_CONTROLSHEET
{
  key CompCode,
  key Plant,
  key Imfyear,
  key GateEntryNo,
  Vehiclenum,
  Gpdate,
  Controlsheet,
  Toll,
  Routeexp,
  Cngexp,
  GLPosted,
  Other,
  Dieselexp,
  Repair,
  CostCenter,
  SalesPerson,
  PostedInd,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
