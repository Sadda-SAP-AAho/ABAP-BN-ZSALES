CLASS zcl_http_ecms DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
    TYPES:BEGIN OF ty_json,
            transactionid         TYPE string,
            remittername          TYPE string,
            fromaccountnumber     TYPE string,
            frombankname          TYPE string,
            utr                   TYPE  string,
            virtualaccount        TYPE  string,
            amount                TYPE  string,
            transfermode          TYPE  string,
            creditdatetime        TYPE  string,
            ipfrom                TYPE  string,
            createon              TYPE  string,
            error_log             TYPE string,
            remarks               TYPE string,
            processed             TYPE string,
            reference_doc         TYPE string,
            created_by            TYPE string,
            created_at            TYPE string,
            last_changed_by       TYPE string,
            last_changed_at       TYPE string,
            local_last_changed_at TYPE string,
          END OF ty_json.
    CLASS-DATA lv_json TYPE ty_json.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_ECMS IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    DATA(lv_body) = request->get_text( ).
    DATA(req) = request->get_form_fields(  ).

    xco_cp_json=>data->from_string( lv_body )->write_to( REF #( lv_json ) ).
    CASE request->get_method(  ).
      WHEN CONV string( if_web_http_client=>post ).


        DATA : wa_zecms_tab TYPE zecms_tab.

        wa_zecms_tab-transactionid = lv_json-transactionid.
        wa_zecms_tab-remittername = lv_json-remittername.
        wa_zecms_tab-frombankname = lv_json-frombankname.
        wa_zecms_tab-fromaccountnumber = lv_json-fromaccountnumber.
        wa_zecms_tab-utr = lv_json-utr.
        wa_zecms_tab-virtualaccount = lv_json-virtualaccount.
        wa_zecms_tab-amount = lv_json-amount.
        wa_zecms_tab-transfermode = lv_json-transfermode.
        wa_zecms_tab-creditdatetime = lv_json-creditdatetime.
        wa_zecms_tab-ipfrom = lv_json-ipfrom.
        wa_zecms_tab-createon = lv_json-createon.
        wa_zecms_tab-error_log            = lv_json-error_log.
        wa_zecms_tab-remarks              = lv_json-remarks.
        wa_zecms_tab-processed            = lv_json-processed.
        wa_zecms_tab-reference_doc        = lv_json-reference_doc.
        wa_zecms_tab-created_by           = cl_abap_context_info=>get_user_alias( ).
        DATA(lv_tz) = cl_abap_context_info=>get_user_time_zone( ).
        wa_zecms_tab-created_at           = cl_abap_context_info=>get_system_time( ).
        wa_zecms_tab-last_changed_by      = cl_abap_context_info=>get_user_alias( ).
        wa_zecms_tab-last_changed_at      = lv_json-last_changed_at.
        wa_zecms_tab-local_last_changed_at = lv_json-local_last_changed_at.

        MODIFY zecms_tab FROM @wa_zecms_tab.
        CLEAR : wa_zecms_tab.
        response->set_text( 'data saved successfully' ).

      WHEN CONV string( if_web_http_client=>get ).

        SELECT * FROM zecms_tab INTO TABLE @DATA(it).

        DATA(ld_json) = /ui2/cl_json=>serialize(  data = it ).

        response->set_text( ld_json  ).





    ENDCASE.
  ENDMETHOD.
ENDCLASS.
