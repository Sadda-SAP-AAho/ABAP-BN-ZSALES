@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Team Cds'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSales_team_cds as select from zsales_team_tab
//composition of target_data_source_name as _association_name
{
    key ssaid as Ssaid,
    key comp_code             as CompanyCode,
    key sscode as Sscode,
    ssdesc as Ssdesc,
    ssdesg as Ssdesg,
    ssrep2secode as Ssrep2secode,
    sslvlcode as Sslvlcode,
    ssename as Ssename,
    ssecode as Ssecode,
    contactno as Contactno,
    ssecatg as Ssecatg,
    ssactive as Ssactive,
    isreport as Isreport,
    sseremarks as Sseremarks ,
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
