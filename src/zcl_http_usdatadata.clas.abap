CLASS  ZCL_HTTP_USDATADATA DEFINITION
  PUBLIC

  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.

*   TYPES: BEGIN OF ty_sys,
*             created_by            type  abp_creation_user,
*             created_at           type abp_creation_tstmpl,
*       last_changed_by       type  abp_locinst_lastchange_user,
*  last_changed_at        type  abp_locinst_lastchange_tstmpl,
*  local_last_changed_at  type  abp_lastchange_tstmpl,
*           END OF  ty_sys.
*

    CLASS-DATA IT_USDATAMST TYPE TABLE OF  ZDT_USDATAMST1 .
    CLASS-DATA IT_USDATADATA TYPE TABLE OF ZDT_USDATADATA1.
*  CLASS-DATA  it_SYS TYPE TABLE OF ty_sys .


    TYPES: BEGIN OF ty_json,
             TO_USDATAMST LIKE IT_USDATAMST,
             TO_USDATADATA LIKE IT_USDATADATA,
*             to_rpldata LIKE it_rpldata,
*            to_sys_data like it_syS ,
             END OF ty_json.

    DATA: lv_json TYPE ty_json.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_USDATADATA IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.



    DATA(req) = request->get_form_fields(  ).

    DATA(lv_body) = request->get_text( ).

*    DATA(mode) = VALUE #( req[ name = 'create_invoice' ]-value OPTIONAL ) .
* xco_cp_json=>data->from_string( lv_body )->write_to( REF #( lv_json ) ).

    CASE request->get_method(  ).

      WHEN CONV string( if_web_http_client=>post ).

        response->set_text( 'saved data successfully' ).

        CALL METHOD /ui2/cl_json=>deserialize
          EXPORTING
            json = lv_body
          CHANGING
            data = lv_json.

        DATA(it_final_USDATAMST) = lv_json-to_usdatamst.
        DATA(it_final_USDATADATA) = lv_json-to_usdatadata.
*        DATA(it_final_rpldata) = lv_json-to_rpldata.

        IF it_final_USDATAMST  IS NOT INITIAL. "AND it_final_invdata IS NOT INITIAL.
          READ TABLE it_final_USDATAMST INTO DATA(wa_final_USDATAMST) INDEX 1.

          " Assign IST time to the structure
          wa_final_USDATAMST-ztime = cl_abap_context_info=>get_system_time( ).
          wa_final_USDATAMST-created_at  = cl_abap_context_info=>get_system_time( ).
          wa_final_USDATAMST-created_by =        cl_abap_context_info=>get_user_alias( ).
          wa_final_USDATAMST-last_changed_by = cl_abap_context_info=>get_user_ALIAS( ).
          wa_final_USDATAMST-last_changed_at      = Cl_abap_context_info=>get_system_time( ).

          MODIFY  zdt_usdatamst1  FROM  @wa_final_USDATAMST.
          CLEAR : wa_final_USDATAMST.



          LOOP AT it_final_USDATADATA INTO DATA(wa_final_USDATADATA).
            wa_final_USDATADATA-ztime = cl_abap_context_info=>get_system_time( ).
            wa_final_USDATADATA-created_at           = cl_abap_context_info=>get_system_time( ).
            wa_final_USDATADATA-created_by =        cl_abap_context_info=>get_user_alias( ).
            wa_final_USDATADATA-last_changed_by = cl_abap_context_info=>get_user_ALIAS( ).
            wa_final_USDATADATA-last_changed_at      = Cl_abap_context_info=>get_system_time( ).
            MODIFY  zdt_usdatadata1 FROM  @wa_final_USDATADATA.
            CLEAR : wa_final_USDATADATA.
          ENDLOOP.




*         MODIFY  ZIN_RPL_DATA FROM  @wa_final_rpldata.
*          CLEAR : wa_final_rpldata.
*        DELETE FROM ZIN_RPL_DATA.
        ENDIF.




*
* DELETE FROM ZINV_MST.
* DELETE FROM ZINVOICEDATA_TAB.
*DELETE FROM ZIN_RPL_DATA.

*



    ENDCASE.



  ENDMETHOD.
ENDCLASS.
