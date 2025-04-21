@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_CRATESDATA
  as select from ZCRATESDATA
{
  key cmno as Cmno,
  key comp_code as CompCode,
  key plant as Plant,
  key cmfyear as Cmfyear,
  key cmtype as Cmtype,
  cmaid as Cmaid,
  cmnoseries as Cmnoseries,
  cmdate as Cmdate,
  cmsalesmancode as Cmsalesmancode,
  cmsalesmancodeorg as Cmsalesmancodeorg,
  cmcrates1 as Cmcrates1,
  cmcrates2 as Cmcrates2,
  cmremarks as Cmremarks,
  cmdeltag as Cmdeltag,
  cmusercode as Cmusercode,
  cmfeddt as Cmfeddt,
  cmupddt as Cmupddt,
  cmcrates11 as Cmcrates11,
  cmcrates21 as Cmcrates21,
  cmrefno as Cmrefno,
  cmroutecd as Cmroutecd,
  cmcrates3 as Cmcrates3,
  cmcrates4 as Cmcrates4,
  cmddealercode as Cmddealercode,
  cmgpno as Cmgpno,
  cmgpdate as Cmgpdate,
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
  cmcmptype as Cmcmptype,
  error_log as ErrorLog,
  remarks as Remarks,
  processed as Processed,
  reference_doc as ReferenceDoc,
  movementposted as Movementposted,
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt
  
}
