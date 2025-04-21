@EndUserText.label: 'Control Sheet'
@Search.searchable: false
@UI.headerInfo: {typeName: 'Control Sheet'}
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity Z1CONTROLSHEET as select from zcontrolsheet
{
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:1 }]
      @UI.lineItem   : [{ position:1, label:'GateEntryNo' }]
    key gate_entry_no as GateEntryNo,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:2 }]
      @UI.lineItem   : [{ position:2, label:'Vehiclenum' }]
    key vehiclenum as Vehiclenum,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:3 }]
      @UI.lineItem   : [{ position:3, label:'CompCode' }]
    key comp_code as CompCode,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:4 }]
      @UI.lineItem   : [{ position:4, label:'Controlsheet' }]
    controlsheet as Controlsheet,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:5 }]
      @UI.lineItem   : [{ position:5, label:'Toll' }]
    toll as Toll,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:6 }]
      @UI.lineItem   : [{ position:6, label:'Routeexp' }]
    routeexp as Routeexp,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:7 }]
      @UI.lineItem   : [{ position:7, label:'Cngexp' }]
    cngexp as Cngexp,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:8 }]
      @UI.lineItem   : [{ position:8, label:'Other' }]
    other as Other,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:9 }]
      @UI.lineItem   : [{ position:9, label:'Dieselexp' }]
    dieselexp as Dieselexp,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:10 }]
      @UI.lineItem   : [{ position:10, label:'Repair' }]
    repair as Repair,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:11 }]
      @UI.lineItem   : [{ position:11, label:'Plant' }]
    plant as Plant,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:12 }]
      @UI.lineItem   : [{ position:12, label:'CostCenter' }]
    cost_center as CostCenter,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:13 }]
      @UI.lineItem   : [{ position:13, label:'Dealer' }]
    sales_person as SalesPerson,
    @Search.defaultSearchElement: true
      @UI.selectionField   : [{ position:16 }]
      @UI.lineItem   : [{ position:16, label:'AmtDeposited' }]
    posted_ind as PostedInd,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
}
