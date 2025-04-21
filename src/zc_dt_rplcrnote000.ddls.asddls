@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_DT_RPLCRNOTE000
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_DT_RPLCRNOTE000
{
  key Imfyear,
  key Imtype,
  key Imnoseries,
  key CompCode,
  key Imno,
  key Imdealercode,
  key Implant,
  Location,
  Imdate,
  Imdoccatg,
  Imcramt,
  Imbreadcode,
  Imwrappercode,
  Imbreadwt,
  Imwrapperwt,
  Imfeddt,
  Imfebuser,
  Imstatus,
  ErrorLog,
  Processed,
  Dealercrdoc,
  Scrapindoc,
  CreatedBy,
  CreatedAt,
  LastChangedBy,
  LastChangedAt
  
}
