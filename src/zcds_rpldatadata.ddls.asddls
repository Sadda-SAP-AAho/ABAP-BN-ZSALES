@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition of Gatepass 2'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_RPLDATADATA as select from I_Plant
{
Plant
}
