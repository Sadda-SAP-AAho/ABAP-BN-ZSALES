@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DATA DEFINITION FOR crates dealer'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zdd_crates_dealer as select from zcratesdealer1
//composition of target_data_source_name as _association_name
{
    key cmno as Cmno,
    key comp_code as CompanyCode,
    key cmfyear as Cmfyear,
    key cmtype as Cmtype,
    cmaid as Cmaid,
    cmnoseries as Cmnoseries,
    cmdate as Cmdate,
    cmsalesmancode as Cmsalesmancode,
    cmdealercode as Cmdealercode,
    cmcrates1 as Cmcrates1,
    cmcrates2 as Cmcrates2,
    cmremarks as Cmremarks,
    cmdeltag as Cmdeltag,
    cmusercode as Cmusercode,
    cmfeddt as Cmfeddt,
    cmupddt as Cmupddt,
    cmcrates3 as Cmcrates3,
    cmcrates4 as Cmcrates4,
    cmseries as Cmseries,
    cmcrates1d as Cmcrates1d,
    cmcrates2d as Cmcrates2d,
    cmcrates3d as Cmcrates3d,
    cmcrates4d as Cmcrates4d,
    cmupuser as Cmupuser,
    cmcratesrate1 as Cmcratesrate1,
    cmcratesrate2 as Cmcratesrate2,
    cmcratesrate3 as Cmcratesrate3,
    cmcratesrate4 as Cmcratesrate4,
    cmsecuritytype as Cmsecuritytype,
    cmdocno as Cmdocno,
    cmdocdate as Cmdocdate,
    cmdocid as Cmdocid,
    cmdocremarks as Cmdocremarks,
    cmreqamount as Cmreqamount,
    cmcmptype as Cmcmptype,
    error_log as ErrorLog,
    remarks as Remarks,
    processed as Processed,
    reference_doc as ReferenceDoc,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
    
//    _association_name // Make association public
}
