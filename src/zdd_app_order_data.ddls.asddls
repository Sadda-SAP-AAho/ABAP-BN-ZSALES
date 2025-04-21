@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'app order data data definition'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zdd_app_order_data as select from zapp_orderdata
//composition of target_data_source_name as _association_name
{
    key id as Id,
    key comp_code             as CompanyCode,
    idmst as Idmst,
    dlrcode as Dlrcode,
    prdcode as Prdcode,
    prdasgncode as Prdasgncode,
    prdname as Prdname,
    qty as Qty,
    createdonapp as Createdonapp,
    createdon as Createdon,
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
