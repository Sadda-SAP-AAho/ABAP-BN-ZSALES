@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_CONTROLSHEET
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
    dieselexp as Dieselexp,
    glposted as GLPosted,
    repair as Repair,
    cost_center as CostCenter,
    sales_person as SalesPerson,
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
