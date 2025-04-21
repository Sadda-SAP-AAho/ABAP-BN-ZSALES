@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'app order master data data definition'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zdd_app_order_master_data as select from zapp_ordmstdata1
//composition of target_data_source_name as _association_name
{
    key id as Id,
    key comp_code             as CompanyCode,
    appodrid as Appodrid,
    dlrcode as Dlrcode,
    totalqty as Totalqty,
    orderdate as Orderdate,
    createdonapp as Createdonapp,
    createdon as Createdon,
    odrimno as Odrimno,
    odrimdate as Odrimdate,
    completedodr as Completedodr,
    prdcode as Prdcode,
    prdqty as Prdqty,
    noofitems as Noofitems,
    appver as Appver,
    userid as Userid,
    remarks as Remarks,
    cloudsync as Cloudsync,
    error_log as ErrorLog,
    processed as Processed,
    reference_doc as ReferenceDoc,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
//    _association_name // Make association public
}
