@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Summary master CDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSummary_mst_cds as select from zsummary_mst_tab
//composition of target_data_source_name as _association_name
{
    key smid as Smid,
    key comp_code             as CompanyCode,
    smfyear as Smfyear,
    smno as Smno,
    smdate as Smdate,
    smusername as Smusername,
    smfeddt as Smfeddt,
    smroutecode as Smroutecode,
    smfprintdt as Smfprintdt,
    smprintdt as Smprintdt,
    smcanceltag as Smcanceltag,
    smcanceldate as Smcanceldate,
    smcmpcode as Smcmpcode,
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
