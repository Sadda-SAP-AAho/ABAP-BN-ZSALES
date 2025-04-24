@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Entity for ZDT_USDATADATA1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_USDATADATA1 as select from zdt_usdatadata1
 association to parent ZR_USDATAMST as _UnsoldHeader on $projection.CompCode = _UnsoldHeader.CompCode and $projection.Plant = _UnsoldHeader.Plant
    and $projection.Idfyear = _UnsoldHeader.Imfyear and $projection.Idtype = _UnsoldHeader.Imtype and $projection.Idno = _UnsoldHeader.Imno  
{
    key comp_code as CompCode,
    key plant as Plant,
    key idfyear as Idfyear,
    key idtype as Idtype,
    key idno as Idno,
    key idaid as Idaid,
    idnoseries as Idnoseries,
    iddate as Iddate,
    idtxncd as Idtxncd,
    idsntag as Idsntag,
    idpartycode as Idpartycode,
    idroutecode as Idroutecode,
    idsalesmancode as Idsalesmancode,
    iddealercode as Iddealercode,
    idprdcode as Idprdcode,
    idprdasgncode as Idprdasgncode,
    idprdbatch as Idprdbatch,
    idprdqty as Idprdqty,
    idprdqtyf as Idprdqtyf,
    idprdqtyr as Idprdqtyr,
    idprdrate as Idprdrate,
    iddiscrate as Iddiscrate,
    idprdamt as Idprdamt,
    idremarks as Idremarks,
    iduserid as Iduserid,
    iddfdt as Iddfdt,
    iddudt as Iddudt,
    iddeltag as Iddeltag,
    idreplrate as Idreplrate,
    idtxbamt as Idtxbamt,
    idwsb1 as Idwsb1,
    idwsb2 as Idwsb2,
    idwsb3 as Idwsb3,
    idrdc1 as Idrdc1,
    idreplrate1 as Idreplrate1,
    idcgstrate as Idcgstrate,
    idsgstrate as Idsgstrate,
    idigstrate as Idigstrate,
    idcgstamount as Idcgstamount,
    idsgstamount as Idsgstamount,
    idigstamount as Idigstamount,
    idtotaldiscamount as Idtotaldiscamount,
    idprdhsncode as Idprdhsncode,
    idforqty as Idforqty,
    idfreeqty as Idfreeqty,
    idonbillos as Idonbillos,
    idoffbillos as Idoffbillos,
    idoffbillcrdo as Idoffbillcrdo,
    idtgtqty as Idtgtqty,
    idver as Idver,
    idprdqtyc as Idprdqtyc,
    idcmpcode as Idcmpcode,
    error_log as ErrorLog,
    remarks as Remarks,
    processed as Processed,
    reference_doc as ReferenceDoc,
    @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt,
    ztime as Ztime,
    _UnsoldHeader
}
