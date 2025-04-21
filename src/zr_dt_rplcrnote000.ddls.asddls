@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_DT_RPLCRNOTE000
  as select from ZDT_RPLCRNOTE
{
  key imfyear as Imfyear,
  key imtype as Imtype,
  key imnoseries as Imnoseries,
  key comp_code as CompCode,
  key imno as Imno,
  key imdealercode as Imdealercode,
  key implant as Implant,
  location as Location,
  imdate as Imdate,
  imdoccatg as Imdoccatg,
  imcramt as Imcramt,
  imbreadcode as Imbreadcode,
  imwrappercode as Imwrappercode,
  imbreadwt as Imbreadwt,
  imwrapperwt as Imwrapperwt,
  imfeddt as Imfeddt,
  imfebuser as Imfebuser,
  imstatus as Imstatus,
  error_log as ErrorLog,
  processed as Processed,
  dealercrdoc as Dealercrdoc,
  scrapindoc as Scrapindoc,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt
  
}
