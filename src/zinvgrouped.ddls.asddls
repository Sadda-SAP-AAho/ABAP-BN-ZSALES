@EndUserText.label: 'Invoice Grouped Data'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_INVGROUPED'
@Metadata.allowExtensions: true
define root custom entity ZINVGROUPED
{
  key OrderDate : bldat ;
  NoOfOrder:int4;
  orderAmount: abap.dec(15,2);
  SOCreated: int4;
  SOAmount: abap.dec(15,2);
  OutboundCreated: int4;
  OrderBilled: int4;
  BilledAmount: abap.dec(15,2);
  
  POCreated: int4;
  MiGoCreated: int4;
  _Lines: composition [0..*] of ZINVMSTGROUPED;
}
