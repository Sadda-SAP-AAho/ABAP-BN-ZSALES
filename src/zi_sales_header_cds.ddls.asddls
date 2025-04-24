@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS of Sales Header Table Buffer'
//@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SALES_HEADER_CDS as select from zinv_mst
//composition of target_data_source_name as _association_name
{
    key comp_code as CompanyCode,
    key plant as Plant,
    key imfyear as Imfyear,
    key  imtype  as Imtype,
    key imno  as Imno,
    imnoseries      as Imnoseries,
    imcat           as Imcat,
      //imdate          as Imdate,
    cast(
      concat(
          concat( concat( substring( zinv_mst.imdate, 7, 2 ), '/' ),concat( substring( zinv_mst.imdate, 5, 2 ), '/' ) ),
                  substring( zinv_mst.imdate, 1, 4 ) )
      as abap.char(10) ) 
         as imdate,
      
    imsalesmancode  as Imsalesmancode,
    impartycode     as Impartycode,
    imroutecode     as Imroutecode,
    imvehcode       as Imvehcode,
    imtransname     as Imtransname,
    imgrno          as Imgrno,
      //imgrdate        as Imgrdate,
      
    cast(
      concat(
          concat( concat( substring( zinv_mst.imgrdate , 7, 2 ), '/' ),concat( substring( zinv_mst.imgrdate, 5, 2 ), '/' ) ),
                  substring( zinv_mst.imgrdate, 1, 4 ) )
      as abap.char(10) )    as imgrdate ,
    imremarks       as Imremarks,
    imtotqty        as Imtotqty,
    imgrswgt        as Imgrswgt,
    imvogamt        as Imvogamt,
    imtxbamt        as Imtxbamt,
    imnetamt        as Imnetamt,
    imnetamtro      as Imnetamtro,
    imcrates1       as Imcrates1,
    imcrates2       as Imcrates2,
    imrcds          as Imrcds,
    imdeltag        as Imdeltag,
    imusercode      as Imusercode,
    imdfdt          as Imdfdt,
    imdudt          as Imdudt,
    imaid           as Imaid,
    imlocktag       as Imlocktag,
    imdespatchtag   as Imdespatchtag,
    imsumno         as Imsumno,
    imcrates3       as Imcrates3,
    imcrates4       as Imcrates4,
    imorderno       as Imorderno,
      
    imprintedon     as Imprintedon,
    imprintedby     as Imprintedby,
      
    cast(
      concat(
          concat( concat( substring( zinv_mst.imsaledate, 7, 2 ), '/' ),concat( substring( zinv_mst.imsaledate  , 5, 2 ), '/' ) ),
                  substring( zinv_mst.imsaledate, 1, 4 ) )
      as abap.char(10) )    as imsaledate ,
      //imsaledate      as Imsaledate,
    imddealercode   as Imddealercode,
    imcgstamt       as Imcgstamt,
    imsgstamt       as Imsgstamt,
    imigstamt       as Imigstamt,
    imdealercode    as Imdealercode,
    imvroutecode    as Imvroutecode,
    imewaybillno    as Imewaybillno,
    imewaybilltag   as Imewaybilltag,
    imewaybilldate  as Imewaybilldate,
    imdeviceid      as Imdeviceid,
    imver           as Imver,
    imsscode        as Imsscode,
    imempcode       as Imempcode,
    imewaystatus    as Imewaystatus,
    imirnstatus     as Imirnstatus,
    imdealergstno   as Imdealergstno,
    imsuptype       as Imsuptype,
    imminno         as Imminno,
    cast(
      concat(
          concat( concat( substring( zinv_mst.immindt, 7, 2 ), '/' ),concat( substring( zinv_mst.immindt , 5, 2 ), '/' ) ),
                  substring( zinv_mst.immindt, 1, 4 ) )
      as abap.char(10) )    as immindt ,
    scrapbill       as Scrapbill,
    error_log       as ErrorLog,
    remarks         as Remarks,
    processed               as Processed,
    reference_doc           as SalesOrderNo,
    reference_doc_del       as OutboundDeliveryNo,
    reference_doc_invoice   as BillingDocumentNo,
    status as Status,
    created_by      as CreatedBy,
    created_at      as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at         as LastChangedAt,
    cust_code               as Cust_Code,
    po_tobe_created         as PO_Tobe_created,
    po_processed            as PO_Processed,
    po_no                   as PO_No,
    migo_processed          as   Migo_Processed,
    migo_no                 as MaterialDocNo,
    orderamount             as OrderAmount,
    invoiceamount           as InvoiceAmount,
    case 
      when imnetamtro != invoiceamount then 1
      else 0
    end 
   as Highlight,
    datavalidated as datavalidated
    
    //_association_name // Make association public
}
