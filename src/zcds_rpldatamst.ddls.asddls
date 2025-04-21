@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition of RPLDATAMST'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCDS_RPLDATAMST as select from I_Plant
{
    key Plant
}
