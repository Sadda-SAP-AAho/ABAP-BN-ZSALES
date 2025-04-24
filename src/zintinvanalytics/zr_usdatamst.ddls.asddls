@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View Entity for ZDT_USDATAMST1'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_USDATAMST as select from zdt_usdatamst1
composition [0..*] of ZR_USDATADATA1 as _UnsoldLines
 association to parent ZR_INVGROUPED000 as _Group on $projection.Imdate = _Group.Orderdate and $projection.Type = _Group.Type
{
    key comp_code as CompCode,
    key plant as Plant,
    key imfyear as Imfyear,
    key imtype as Imtype,
    key imno as Imno,
    'Unsold' as Type,
    imnoseries as Imnoseries,
    imdate as Imdate,
    imjobno as Imjobno,
    imsalesmancode as Imsalesmancode,
    impartycode as Impartycode,
    imroutecode as Imroutecode,
    imremarks as Imremarks,
    imtotqty as Imtotqty,
    imvogamt as Imvogamt,
    imtxbamt as Imtxbamt,
    imnetamt as Imnetamt,
    imnetamtro as Imnetamtro,
    imcrates1 as Imcrates1,
    imcrates2 as Imcrates2,
    imrcds as Imrcds,
    imdeltag as Imdeltag,
    imusercode as Imusercode,
    imdfdt as Imdfdt,
    imdudt as Imdudt,
    imaid as Imaid,
    iminno as Iminno,
    imindate as Imindate,
    imfgpasstag as Imfgpasstag,
    imagnstgpno as Imagnstgpno,
    imagnstgpdate as Imagnstgpdate,
    imcgstamount as Imcgstamount,
    imsgstamount as Imsgstamount,
    imigstamount as Imigstamount,
    error_log as ErrorLog,
    remarks as Remarks,
    processed as Processed,
    reference_doc as ReferenceDoc,
    orderamount as Orderamount,
    reference_doc_del as ReferenceDocDel,
    reference_doc_invoice as ReferenceDocInvoice,
    invoiceamount as Invoiceamount,
    status as Status,
     @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt,
    ztime as Ztime,
    datavalidated as Datavalidated,
    cust_code as CustCode,
     case 
      when imnetamtro != invoiceamount then 1
      else 0
    end 
   as Highlight,
   _Group,
   _UnsoldLines
}
