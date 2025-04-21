@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Summary Data CDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSummaryData_cds as select from zsummarydata_tab
//composition of target_data_source_name as _association_name
{
    key sdid as Sdid,
    key comp_code             as CompanyCode,
    sdmid as Sdmid,
    sdfyear as Sdfyear,
    sdtype as Sdtype,
    sdnoseries as Sdnoseries,
    sdno as Sdno,
    sddate as Sddate,
    sdinvno as Sdinvno,
    sdinvdate as Sdinvdate,
    sdinvamt as Sdinvamt,
    sdroute as Sdroute,
    sdusername as Sdusername,
    sdfeddt as Sdfeddt,
    sdchno as Sdchno,
    sdchdate as Sdchdate,
    sdcmpcode as Sdcmpcode,
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
