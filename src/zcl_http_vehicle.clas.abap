CLASS zcl_http_vehicle DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

   INTERFACES if_http_service_extension .

    TYPES: BEGIN OF ty_json,
            client         TYPE string,
        vehicleid           TYPE string,
        comp_code           Type String,
         vehiclecode         TYPE string,
     vehicleregno         TYPE string,
  vehicledesc             TYPE string,
  vehiclerate              TYPE string,
  vehicletype             TYPE string,
  updtuser                TYPE string,
  feeddt                   TYPE string,
  updatedt                TYPE string,
  vehicleskmpl             TYPE string,
  vehiclespltag            TYPE string,
  vehicleskmplh            TYPE string,
  vehiclecategorycd        TYPE string,
  vehiclecategorysubcd     TYPE string,
  vehiclebodyl             TYPE string,
  vehiclebodyb             TYPE string,
  vehiclebodyh             TYPE string,
  costcode                 TYPE string,
  vehiclemodel             TYPE string,
  vehicletempno            TYPE string,
  vehiclercno              TYPE string,
  vehiclemake              TYPE string,
  vehicleengineno          TYPE string,
  vehiclechasisno          TYPE string,
  vehiclepurbillno        TYPE string,
  vehiclepurbilldt         TYPE string,
  vehicledealername        TYPE string,
  vehiclebillamt          TYPE string,
  vehicleinsamt            TYPE string,
  vehicleinsdate           TYPE string,
  vehiclewrntykm           TYPE string,
  vehiclewrntykmexd       TYPE string,
  vehicledeviceid          TYPE string,
  vehiclenooftyres         TYPE string,
  vehicletyresize          TYPE string,
  vehiclelictype           TYPE string,
  vehicleempcode           TYPE string,
  vehiclefuelcng           TYPE string,
  vehiclefuelcngdt         TYPE string,
  vehicleskmplcng          TYPE string,
  vehicleskmplhcng         TYPE string,
             error_log             TYPE string,
             remarks               TYPE string,
             processed             TYPE string,
             reference_doc         TYPE string,
              created_on type string,
             created_by            TYPE string,
             created_at            TYPE string,
             last_changed_by       TYPE string,
             last_changed_at       TYPE string,
*             local_last_changed_at TYPE string,
*            timestamp1 TYPE utclong,
           END OF ty_json.

    CLASS-DATA lv_json TYPE ty_json.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_VEHICLE IMPLEMENTATION.


 METHOD if_http_service_extension~handle_request.


    DATA(lv_body) = request->get_text( ).
    DATA(req) = request->get_form_fields(  ).


    CASE request->get_method(  ).

      WHEN CONV string( if_web_http_client=>post ).

        xco_cp_json=>data->from_string( lv_body )->write_to( REF #( lv_json ) ).
        DATA : wa_vehicle_tab TYPE zvehicle1.


        wa_vehicle_tab-client               = lv_json-client.
        wa_vehicle_tab-VehicleCode  = lv_json-VehicleCode.
        wa_vehicle_tab-comp_code   = lv_json-comp_code.
        wa_vehicle_tab-VehicleDesc     = lv_json-VehicleDesc.
        wa_vehicle_tab-VehicleRegNo = lv_json-VehicleRegNo.
        wa_vehicle_tab-VehicleRate             = lv_json-VehicleRate.
        wa_vehicle_tab-VehicleType            = lv_json-VehicleType.
        wa_vehicle_tab-VehicleId = lv_json-VehicleId.
        wa_vehicle_tab-UpDtUser               = lv_json-UpDtUser.
        wa_vehicle_tab-FeedDt = lv_json-FeedDt.
        wa_vehicle_tab-UpDateDt              = lv_json-UpDateDt.
        wa_vehicle_tab-VehicleSKMPL     = lv_json-VehicleSKMPL.
        wa_vehicle_tab-VehicleSplTag       = lv_json-VehicleSplTag.
        wa_vehicle_tab-VehicleSKMPLH          = lv_json-VehicleSKMPLH.
        wa_vehicle_tab-vehicleCategoryCd          = lv_json-vehicleCategoryCd.
        wa_vehicle_tab-vehicleCategorySubCd            = lv_json-vehicleCategorySubCd.
        wa_vehicle_tab-VehicleBodyL          = lv_json-VehicleBodyL.
        wa_vehicle_tab-VehicleBodyB               = lv_json-VehicleBodyB.
        wa_vehicle_tab-VehicleBodyH             = lv_json-VehicleBodyH.
        wa_vehicle_tab-CostCode            = lv_json-CostCode.
        wa_vehicle_tab-VehicleModel             = lv_json-VehicleModel.
        wa_vehicle_tab-VehicleTempNo             = lv_json-VehicleTempNo.
        wa_vehicle_tab-VehicleRCNo             = lv_json-VehicleRCNo.
        wa_vehicle_tab-VehicleMAKE             = lv_json-VehicleMAKE.
        wa_vehicle_tab-VehicleEngineNo             = lv_json-VehicleEngineNo.
        wa_vehicle_tab-VehicleChasisNo           = lv_json-VehicleChasisNo.
        wa_vehicle_tab-VehiclePurBillNo            = lv_json-VehiclePurBillNo.
        wa_vehicle_tab-VehiclePurBillDt            = lv_json-VehiclePurBillDt.
        wa_vehicle_tab-VehicleDealerName               = lv_json-VehicleDealerName.
        wa_vehicle_tab-VehicleBillAmt             = lv_json-VehicleBillAmt.
        wa_vehicle_tab-VehicleInsAmt           = lv_json-VehicleInsAmt.
        wa_vehicle_tab-VehicleInsDate               = lv_json-VehicleInsDate.
        wa_vehicle_tab-VehicleWrntyKM               = lv_json-VehicleWrntyKM.
        wa_vehicle_tab-VehicleWrntyKMExd                = lv_json-VehicleWrntyKMExd.
        wa_vehicle_tab-VehicleDeviceId            = lv_json-VehicleDeviceId.
        wa_vehicle_tab-VehicleNoofTyres        = lv_json-VehicleNoofTyres.
        wa_vehicle_tab-VehicleTyreSize              = lv_json-VehicleTyreSize.
        wa_vehicle_tab-VehicleLicType            = lv_json-VehicleLicType.
        wa_vehicle_tab-VehicleEmpCode            = lv_json-VehicleEmpCode.
        wa_vehicle_tab-VehicleFuelCNG            = lv_json-VehicleFuelCNG.
        wa_vehicle_tab-VehicleFuelCNGDt          = lv_json-VehicleFuelCNGDt.
        wa_vehicle_tab-VehicleSKmplCNG          = lv_json-VehicleSKmplCNG.
        wa_vehicle_tab-VehicleSKmplhCNG           = lv_json-VehicleSKmplhCNG.
                wa_vehicle_tab-error_log            = lv_json-error_log.
        wa_vehicle_tab-remarks              = lv_json-remarks.
        wa_vehicle_tab-processed            = lv_json-processed.
        wa_vehicle_tab-reference_doc        = lv_json-reference_doc.
        TRY.
            data(lv_tz)                         = cl_abap_context_info=>get_user_time_zone( ).
          CATCH cx_abap_context_info_error.
            wa_vehicle_tab-remarks              = ''.
        ENDTRY.

*        wa_vehicle_tab-created_on           = lv_json-created_on.
        wa_vehicle_tab-created_by           = cl_abap_context_info=>get_user_alias( ).
        wa_vehicle_tab-created_at           = cl_abap_context_info=>get_system_date( ).
        wa_vehicle_tab-last_changed_by      = cl_abap_context_info=>get_user_alias( ).
        wa_vehicle_tab-last_changed_at      = sy-uzeit.  "cl_abap_context_info=>get_system_time( ).

DATA timestamp1 TYPE utclong.
timestamp1 = utclong_current( ).

DATA timestamp_dec TYPE abp_locinst_lastchange_tstmpl.
timestamp_dec = cl_abap_tstmp=>UTCLONG2TSTMP( timestamp1 ).

*wa_vehicle_tab-last_changed_at = timestamp_dec.


*       wa_vehicle_tab-local_last_changed_at = lv_json-local_last_changed_at.



        MODIFY zvehicle1 FROM  @wa_vehicle_tab.
        CLEAR : wa_vehicle_tab.

        response->set_text( 'data saved successfully' ).

      WHEN CONV string( if_web_http_client=>get ).

        SELECT * FROM zvehicle1
        WHERE vehiclecode IS NOT INITIAL
        INTO TABLE @DATA(it).

        DATA(ld_json) = /ui2/cl_json=>serialize(  data = it ).

        response->set_text( ld_json  ).

    ENDCASE.
*    response->set_text( 'Invalid Method' ).

  ENDMETHOD.
ENDCLASS.
