@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Data Definition of Gatepass'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZCDS_GATEPASS
  as select from zgatepass_table
{
  key vmfy               as Vmfy,
  key vmno               as Vmno,
   key comp_code             as CompanyCode,
      vminvno            as Vminvno,
      vmoutmeterread     as Vmoutmeterread,
      vminmeterread      as Vminmeterread,
      vmoutdate          as Vmoutdate,
      vmindate           as Vmindate,
      vmvehcode          as Vmvehcode,
      vmroutecd          as Vmroutecd,
      //vmdrivercd as Vmdrivercd,
      vmdeisaloutside    as Vmdeisaloutside,
      vmdeisalcons       as Vmdeisalcons,
      vmmeterstatus      as Vmmeterstatus,
      vmouttime          as Vmouttime,
      vmintime           as Vmintime,
      vmremark           as Vmremark,
      vmid               as Vmid,
      vmtotalamt         as Vmtotalamt,
      vmtotalcrate1      as Vmtotalcrate1,
      vmtotalcrate2      as Vmtotalcrate2,
      vmsumno            as Vmsumno,
      vmtotalcrate3      as Vmtotalcrate3,
      vmtotalcrate4      as Vmtotalcrate4,
      vmroomno           as Vmroomno,
      vmdflgslpno        as Vmdflgslpno,
      vmdflgdt           as Vmdflgdt,
      vmsmcode           as Vmsmcode,
      vmdieselrate       as Vmdieselrate,
      vmspltag           as Vmspltag,
      vmfirstgpno        as Vmfirstgpno,
      vmsecondgpamt      as Vmsecondgpamt,
      vmverifiedby       as Vmverifiedby,
      vmverifieddt       as Vmverifieddt,
      vmpumpreadingfrom  as Vmpumpreadingfrom,
      vmpumpreadingto    as Vmpumpreadingto,
      vmissmdrvrtag      as Vmissmdrvrtag,
      vmroutefoodexpd    as Vmroutefoodexpd,
      vmroutefoodexpdcsm as Vmroutefoodexpdcsm,
      vmfeddt            as Vmfeddt,
      vmoutdateactual    as Vmoutdateactual,
      vmfeduser          as Vmfeduser,
      vmupuser           as Vmupuser,
      vmupdt             as Vmupdt,
      vmver              as Vmver,
      vmtotalbrdqty      as Vmtotalbrdqty,
      vmsumdate          as Vmsumdate,
      vmcmpcode          as Vmcmpcode

}
