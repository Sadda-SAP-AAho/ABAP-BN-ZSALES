@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'data definition for credit note'
@Metadata.ignorePropagatedAnnotations: true
define root view entity zdd_rplcrnote as select from zdt_rplcrnote
//composition of target_data_source_name as _association_name
{
    key comp_code as CompCode,
    key implant as implant,
    key imfyear as Imfyear,
    key imtype as Imtype,
    key imno as Imno,
    key imdealercode as Imdealercode,
    imnoseries as Imnoseries,
    location as Location,
    imdate as Imdate,
    imdoccatg as Imdoccatg,
    imcramt as Imcramt,
    imbreadcode as Imbreadcode,
    imwrappercode as Imwrappercode,
    imbreadwt as Imbreadwt,
    imwrapperwt as Imwrapeerwt,
    imfeddt as Imfeddt,
    imfebuser as Imfebuser,
    imstatus as Imstatus,
    error_log as ErrorLog,
    processed as Processed,
    dealercrdoc as Dealercrdoc,
    glposted as Glposted,
    glerror_log as Glerrorlog,
    scrapindoc as Scrapindoc,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
//    _association_name // Make association public
}
