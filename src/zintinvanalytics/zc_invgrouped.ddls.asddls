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
  Highlight,  
  _InvoiceHeaders : redirected to composition child ZC_INV_MST000
  
}
