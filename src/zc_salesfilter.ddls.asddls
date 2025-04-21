@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for DEALER'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_SALESFILTER 
  as projection on ZI_SALESFILTER
{
    
    key CompCode,
    key Plant,
    key  Imfyear,
    key  Imtype,
    key  Imno,
    key Datatype,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt
}
