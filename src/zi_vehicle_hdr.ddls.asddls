@AbapCatalog.sqlViewName: 'ZI_VEHICLE_HDRS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'VEHICLE BUFFER TABLE'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_VEHICLE_HDR
  as select from zvehicle1
{
  key comp_code             as CompanyCode,
  key vehiclecode           as Vehiclecode,
  vehicleid             as Vehicleid,
  vehicleregno          as Vehicleregno,
      vehicledesc           as Vehicledesc,
      vehiclerate           as Vehiclerate,
      vehicletype           as Vehicletype,
      updtuser              as Updtuser,
      //    feeddt as Feeddt,
      cast(
      concat(
          concat( concat( substring( zvehicle1.feeddt, 7, 2 ), '/' ),concat( substring( zvehicle1.feeddt, 5, 2 ), '/' ) ),
                  substring( zvehicle1.feeddt, 1, 4 ) )
      as abap.char(10) )    as Feeddt,
      //      cast( updatedt as abap.datn ) as Updatedt,
      //      updatedt              as Updatedt,
       cast(
      concat(
          concat( concat( substring( zvehicle1.updatedt, 7, 2 ), '/' ),concat( substring( zvehicle1.updatedt, 5, 2 ), '/' ) ),
                  substring( zvehicle1.updatedt, 1, 4 ) )
      as abap.char(10) )    as Updatedt,
      //    to_char(to_date(updatedt, 'YYYYMMDD'), 'MM/DD/YYYY') as updatedt,
      vehicleskmpl          as Vehicleskmpl,
      vehiclespltag         as Vehiclespltag,
      vehicleskmplh         as Vehicleskmplh,
      vehiclecategorycd     as Vehiclecategorycd,
      vehiclecategorysubcd  as Vehiclecategorysubcd,
      vehiclebodyl          as Vehiclebodyl,
      vehiclebodyb          as Vehiclebodyb,
      vehiclebodyh          as Vehiclebodyh,
      costcode              as Costcode,
      vehiclemodel          as Vehiclemodel,
      vehicletempno         as Vehicletempno,
      vehiclercno           as Vehiclercno,
      vehiclemake           as Vehiclemake,
      vehicleengineno       as Vehicleengineno,
      vehiclechasisno       as Vehiclechasisno,
      vehiclepurbillno      as Vehiclepurbillno,
//      vehiclepurbilldt      as Vehiclepurbilldt,
             cast(
      concat(
          concat( concat( substring( zvehicle1.vehiclepurbilldt, 7, 2 ), '/' ),concat( substring( zvehicle1.vehiclepurbilldt, 5, 2 ), '/' ) ),
                  substring( zvehicle1.vehiclepurbilldt, 1, 4 ) )
      as abap.char(10) )    as vehiclepurbilldt,
      vehicledealername     as Vehicledealername,
      vehiclebillamt        as Vehiclebillamt,
      vehicleinsamt         as Vehicleinsamt,
//      vehicleinsdate        as Vehicleinsdate,
             cast(
      concat(
          concat( concat( substring( zvehicle1.vehicleinsdate, 7, 2 ), '/' ),concat( substring( zvehicle1.vehicleinsdate, 5, 2 ), '/' ) ),
                  substring( zvehicle1.vehicleinsdate, 1, 4 ) )
      as abap.char(10) )    as vehicleinsdate,
      vehiclewrntykm        as Vehiclewrntykm,
      vehiclewrntykmexd     as Vehiclewrntykmexd,
      vehicledeviceid       as Vehicledeviceid,
      vehiclenooftyres      as Vehiclenooftyres,
      vehicletyresize       as Vehicletyresize,
      vehiclelictype        as Vehiclelictype,
      vehicleempcode        as Vehicleempcode,
      vehiclefuelcng        as Vehiclefuelcng,
//      vehiclefuelcngdt      as Vehiclefuelcngdt,
             cast(
      concat(
          concat( concat( substring( zvehicle1.vehiclefuelcngdt, 7, 2 ), '/' ),concat( substring( zvehicle1.vehiclefuelcngdt, 5, 2 ), '/' ) ),
                  substring( zvehicle1.vehiclefuelcngdt, 1, 4 ) )
      as abap.char(10) )    as vehiclefuelcngdt,
      vehicleskmplcng       as Vehicleskmplcng,
      vehicleskmplhcng      as Vehicleskmplhcng,
      error_log             as ErrorLog,
      remarks               as Remarks,
      processed             as Processed,
      reference_doc         as ReferenceDoc,
//       created_on as  created_on,
      created_by            as CreateBy,
      created_at            as CreatedAt,
      last_changed_by       as LastChangedBy,
      last_changed_at       as LastChangedAt
//      local_last_changed_at as locallastchangedat
}
