@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition of USDATAMST'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_USDATAMST as select from zdt_usdatamst1 
//composition of target_data_source_name as _association_name
{
    key comp_code as CompanyCode,
    key plant as plant,
    key imfyear as Imyear,
    key imtype  as Imtype,
    key imno as Imno,
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
    reference_doc_del as reference_doc_del,
    reference_doc_invoice as reference_doc_invoice,
    status as status,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt,
    ztime as Time    
//    _association_name // Make association public
}


