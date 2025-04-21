@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_CUSTCONTROLSHT000
  as select from zcustcontrolsht
{
    key gate_entry_no as GateEntryNo,
    key comp_code as CompCode,
    key plant as Plant,
    key imfyear as Imfyear,
    key dealer as Dealer,
    vehiclenum as Vehiclenum,
    gpdate as Gpdate,
    controlsheet as Controlsheet,
    cost_center as CostCenter,
    dealer_wise_cash as DealerWiseCash,
    sales_person as SalesPerson,
    amt_deposited as AmtDeposited,
    posted_ind as PostedInd,
  @Semantics.user.createdBy: true
    created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
    created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
    last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
    last_changed_at as LastChangedAt
  
}
