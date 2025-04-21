@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption for ECMS'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_ECMS 
provider contract transactional_query  
as projection on ZI_ECMS as ECMS
{
    key ID,
    key Transactionid,
    key Comp_code,
    Remittername,
    Fromaccountnumber,
    Frombankname,
    Utr,
    Virtualaccount,
    Amount,
    Transfermode,
    Creditdatetime,
    Ipfrom,
    Createon,
    Error_Log,
   Remarks,
     Processed,
   Reference_Doc,
  CreatedBy,
   CreatedAt,
     LastChangedBy,
     LastChangedAt,
     LocalLastChangedAt
}
