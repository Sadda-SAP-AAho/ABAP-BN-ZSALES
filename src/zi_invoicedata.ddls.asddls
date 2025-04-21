@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'invoice data Table Buffer CDS'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_invoicedata as select from zinvoicedatatab1
//composition of target_data_source_name as _association_name
{
    
 
   
     key comp_code   as CompanyCode,
     key plant as Plant,
      key idfyear as Idfyear,
     key idtype as Idtype,
     key idno as Idno,
     key idaid as Idaid,
     idid as Idid,
    idcat as Idcat,
    idnoseries as Idnoseries,
    
    cast(
      concat(
          concat( concat( substring( zinvoicedatatab1.iddate, 7, 2 ), '/' ),concat( substring( zinvoicedatatab1.iddate, 5, 2 ), '/' ) ),
                  substring( zinvoicedatatab1.iddate, 1, 4 ) )
      as abap.char(10) )  as Iddate,
    
    
    //iddate as Iddate,
    idpartycode as Idpartycode,
    idroutecode as Idroutecode,
    idsalesmancode as Idsalesmancode,
    iddealercode as Iddealercode,
    idprdcode as Idprdcode,
    idprdasgncode as Idprdasgncode,
    idqtybag as Idqtybag,
    idprdqty as Idprdqty,
    idprdqtyf as Idprdqtyf,
    idprdqtyr as Idprdqtyr,
    idprdqtyw as Idprdqtyw,
    idprdrate as Idprdrate,
    idprdnrate as Idprdnrate,
    iddiscrate as Iddiscrate,
    idprdamt as Idprdamt,
    idprdnamt as Idprdnamt,
    idremarks as Idremarks,
    iduserid as Iduserid,
    iddfdt as Iddfdt,
    iddudt as Iddudt,
    iddelttag as Iddelttag,
    idprdacode as Idprdacode,
    idnar as Idnar,
    idreprate as Idreprate,
    idwsb1 as Idwsb1,
    idwsb2 as Idwsb2,
    idrdc1 as Idrdc1,
    idwsb3 as Idwsb3,
    idrdc2 as Idrdc2,
    idtxbamt as Idtxbamt,
    idsono as Idsono,
    
    cast(
      concat(
          concat( concat( substring( zinvoicedatatab1.idsodate, 7, 2 ), '/' ),concat( substring( zinvoicedatatab1.idsodate, 5, 2 ), '/' ) ),
                  substring( zinvoicedatatab1.idsodate, 1, 4 ) )
      as abap.char(10) )    as Idsodate,
    //idsodate as Idsodate,
    idtdiscrate as Idtdiscrate,
    idtdiscamt as Idtdiscamt,
    idorderno as Idorderno,
    //idorderdate as Idorderdate,
    
    cast(
      concat(
          concat( concat( substring( zinvoicedatatab1.idorderdate, 7, 2 ), '/' ),concat( substring( zinvoicedatatab1.idorderdate, 5, 2 ), '/' ) ),
                  substring( zinvoicedatatab1.idorderdate, 1, 4 ) )
      as abap.char(10) )    as Idorderdate,
    idplantrunhrs as Idplantrunhrs,
    idprdbatch as Idprdbatch,
    idreprate1 as Idreprate1,
    idddealercode as Idddealercode,
    idcgstrate as Idcgstrate,
    idsgstrate as Idsgstrate,
    idigstrate as Idigstrate,
    idcgstamount as Idcgstamount,
    idsgstamount as Idsgstamount,
    idigstamount as Idigstamount,
    idprdhsncode as Idprdhsncode,
    idtotaldiscamt as Idtotaldiscamt,
    idprdqtyss as Idprdqtyss,
    idssamount as Idssamount,
    idssrate as Idssrate,
    imsdtag as Imsdtag,
    idforqty as Idforqty,
    idfreeqty as Idfreeqty,
    idonbillos as Idonbillos,
    idoffbillos as Idoffbillos,
    idoffbillcrdo as Idoffbillcrdo,
    idtgtqty as Idtgtqty,
    idmrp as Idmrp,
    idver as Idver,
    idprdstock as Idprdstock,
    idprdcodefree as Idprdcodefree,
    idrepldiscamt as Idrepldiscamt,
    idvehcodesale as Idvehcodesale,
    error_log as ErrorLog,
    remarks as Remarks,
    processed as Processed,
    reference_doc as ReferenceDoc,
    created_by as CreatedBy,
    created_at as CreatedAt,
    last_changed_by as LastChangedBy,
    last_changed_at as LastChangedAt
   // local_last_changed_at as LocalLastChangedAt
  //  _association_name // Make association public
}
