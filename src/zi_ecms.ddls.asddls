@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition for ECMS'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_ECMS as select from zecms_tab
{
    key id as ID,
    key transactionid as Transactionid,
    key comp_code as Comp_code,
    remittername as Remittername,
    fromaccountnumber as Fromaccountnumber,
    frombankname as Frombankname,
    utr as Utr,
    virtualaccount as Virtualaccount,
    amount as Amount,
    transfermode as Transfermode,
    creditdatetime as Creditdatetime,
    ipfrom as Ipfrom,
    createon as Createon,
    error_log as Error_Log,
    remarks as Remarks,
    processed as Processed,
    reference_doc as Reference_Doc,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    local_last_changed_at as LocalLastChangedAt
}
