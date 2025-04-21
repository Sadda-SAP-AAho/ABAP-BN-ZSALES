@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition of Gatepass 2'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCDS_GatePass2 as select from zgatepass_table2
//composition of target_data_source_name as _association_name
{
    key vimfyear as Vimfyear,
    key vimno as Vimno,
     key comp_code             as CompanyCode,
    vimimno as Vimimno,
    vimimdate as Vimimdate,
    vimimnetamt as Vimimnetamt,
    vimimaid as Vimimaid,
    vimaid as Vimaid,
    vimno1 as Vimno1,
    vimcratereq as Vimcratereq,
    vimdate as Vimdate,
    vimcmpcode as Vimcmpcode
//    _association_name // Make association public
}
