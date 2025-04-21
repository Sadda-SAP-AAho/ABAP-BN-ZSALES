@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'data definition customer control sheet'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZDD_CustCONTROLSHT as select from zcustcontrolsht
//composition of target_data_source_name as _association_name
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
   created_by as CreatedBy,
   created_at as CreatedAt,
   last_changed_by as LastChangedBy,
   last_changed_at as LastChangedAt
}
