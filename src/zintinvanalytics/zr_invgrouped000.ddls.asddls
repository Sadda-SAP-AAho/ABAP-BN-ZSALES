@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Invoice Grouped'
define root view entity ZR_INVGROUPED000
  as select from zinv_grouped
  composition [0..*] of ZR_INV_MST000 as _InvoiceHeaders
{
  key orderdate as Orderdate,
  key type as Type,
  nooforder as Nooforder,
  orderamount as Orderamount,
  socreated as Socreated,
  soamount as Soamount,
  outboundcreated as Outboundcreated,
  orderbilled as Orderbilled,
  billedamount as Billedamount,
  pocreated as Pocreated,
  migocreated as Migocreated,
  case 
      when orderamount != billedamount then 1
      else 0
    end 
   as Highlight, 
  @Semantics.user.createdBy: true
  created_by as CreatedBy,
  @Semantics.systemDateTime.createdAt: true
  created_at as CreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  last_changed_by as LastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  last_changed_at as LastChangedAt,
  
    _InvoiceHeaders
  
}
