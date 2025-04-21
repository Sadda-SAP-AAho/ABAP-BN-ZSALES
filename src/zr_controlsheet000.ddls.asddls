@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_CONTROLSHEET000
  as select from zcontrolsheet
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
    glposted as GLPosted,
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
