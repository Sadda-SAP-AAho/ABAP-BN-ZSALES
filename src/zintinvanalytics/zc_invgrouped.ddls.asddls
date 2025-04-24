@Metadata.allowExtensions: true
@EndUserText.label: 'Invoice Grouped View'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_INVGROUPED
  provider contract transactional_query
  as projection on ZR_INVGROUPED000
{
  key Orderdate,
  key Type,
  Nooforder,
  Orderamount,
  Socreated,
  Soamount,
  Outboundcreated,
  Orderbilled,
  Billedamount,
  Pocreated,
  Migocreated,
  Datavalidated,
  Potobecreated,
  Highlight, 
  @UI.hidden: true 
  IsSales,
  @UI.hidden: true 
  IsUnsold,
  _InvoiceHeaders : redirected to composition child ZC_INV_MST000,
  _UnsoldHeaders   : redirected to composition child ZC_USDATAMST
  
}
