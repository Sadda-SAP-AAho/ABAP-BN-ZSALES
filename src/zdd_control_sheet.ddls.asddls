@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'data definition control sheet'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zdd_control_sheet as select from zcontrolsheet
//composition of target_data_source_name as _association_name
{
  key comp_code as CompCode,
  key plant as Plant,
  key imfyear as Imfyear,
  key gate_entry_no as GateEntryNo,
  vehiclenum as Vehiclenum,
  gpdate as Gpdate, 
  controlsheet as Controlsheet,
  toll as Toll,  
  routeexp as Routeexp,
  cngexp as Cngexp,
  other as Other,
  dieselexp as Dieselexp,
  repair as Repair,
  cost_center as CostCenter,
  sales_person as SalesPerson,
  posted_ind as PostedInd,
  created_by as CreatedBy,
  created_at as CreatedAt,
  last_changed_by as LastChangedBy,
  last_changed_at as LastChangedAt
}
