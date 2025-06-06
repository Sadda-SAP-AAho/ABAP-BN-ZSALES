@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View Entity for ZR_USDATAMST'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_USDATAMST as projection on ZR_USDATAMST
{
 key CompCode,
 key Plant,
 key Imfyear,
 key Imtype,
 key Imno,
 Type,
 Imnoseries,
 Imdate,
 Imjobno,
 Imsalesmancode,
 Impartycode,
 Imroutecode,
 Imremarks,
 Imtotqty,
 Imvogamt,
 Imtxbamt,
 Imnetamt,
 Imnetamtro,
 Imcrates1,
 Imcrates2,
 Imrcds,
 Imdeltag,
 Imusercode,
 Imdfdt,
 Imdudt,
 Imaid,
 Iminno,
 Imindate,
 Imfgpasstag,
 Imagnstgpno,
 Imagnstgpdate,
 Imcgstamount,
 Imsgstamount,
 Imigstamount,
 ErrorLog,
 Remarks,
 Processed,
 ReferenceDoc,
 Orderamount,
 ReferenceDocDel,
 ReferenceDocInvoice,
 Invoiceamount,
 Status,
 CreatedBy,
 LastChangedBy,
 Ztime,
 Datavalidated,
 CustCode,
 Highlight,
 /* Associations */
 _Group   : redirected to parent ZC_INVGROUPED,
 _UnsoldLines : redirected to composition child ZC_USDATADATA1
}
