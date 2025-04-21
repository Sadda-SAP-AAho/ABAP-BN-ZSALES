CLASS  zcl_http_hrd_item DEFINITION
  PUBLIC

  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.

    CLASS-DATA it_INVMST TYPE  zinv_mst .
    CLASS-DATA it_invdata TYPE TABLE OF zinvoicedatatab1.
    CLASS-DATA  it_rpldata TYPE TABLE OF  zin_rpl_data.

    TYPES: BEGIN OF ty_json,
             to_INVMST  LIKE it_INVMST,
             to_invdata LIKE it_invdata,
             to_rpldata LIKE it_rpldata,
           END OF ty_json.

    DATA: lv_json TYPE ty_json.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_HRD_ITEM IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    DATA(req) = request->get_form_fields(  ).

    DATA(lv_body) = request->get_text( ).

    CASE request->get_method(  ).

      WHEN CONV string( if_web_http_client=>post ).

        response->set_text( 'saved data successfully' ).

        CALL METHOD /ui2/cl_json=>deserialize
          EXPORTING
            json = lv_body
          CHANGING
            data = lv_json.

*        DATA(it_final_zsales) = lv_json-to_invmst.
*        DATA(it_final_invdata) = lv_json-to_invdata.
*        DATA(it_final_rpldata) = lv_json-to_rpldata.

         DATA(it_final_zsales) = lv_json-to_INVMST.
        DATA(it_final_invdata) = lv_json-to_invdata.
        DATA(it_final_rpldata) = lv_json-to_rpldata.

        IF it_final_zsales  IS NOT INITIAL.

*         READ TABLE it_final_zsales INTO DATA(wa_final_master) INDEX 1.

          it_final_zsales-created_at           = cl_abap_context_info=>get_system_time( ).
          it_final_zsales-created_by =        cl_abap_context_info=>get_user_alias( ).
          it_final_zsales-last_changed_by = cl_abap_context_info=>get_user_ALIAS( ).
          it_final_zsales-last_changed_at      = Cl_abap_context_info=>get_system_time( ).

          LOOP at it_final_invdata INTO DATA(wa_final_invdata).

          wa_final_invdata-created_at           = cl_abap_context_info=>get_system_date( ).
          wa_final_invdata-created_by =        cl_abap_context_info=>get_user_alias( ).
          wa_final_invdata-last_changed_by = cl_abap_context_info=>get_user_ALIAS( ).
          wa_final_invdata-last_changed_at      = Cl_abap_context_info=>get_system_time( ).

           MODIFY  zinvoicedatatab1 FROM  @wa_final_invdata.
          CLEAR : wa_final_invdata.
          endloop.

          LOOP At  it_final_rpldata INTO DATA(wa_final_rpldata).

          wa_final_rpldata-created_at           = cl_abap_context_info=>get_system_date( ).
          wa_final_rpldata-created_by =        cl_abap_context_info=>get_user_alias( ).
          wa_final_rpldata-last_changed_by = cl_abap_context_info=>get_user_ALIAS( ).
          wa_final_rpldata-last_changed_at      = Cl_abap_context_info=>get_system_time( ).

           MODIFY  zin_rpl_data FROM  @wa_final_rpldata.
          CLEAR : wa_final_rpldata.
          ENDLOOP.

          MODIFY  zinv_mst  FROM  @it_final_zsales.
          CLEAR : it_final_zsales.

        ENDIF.


    ENDCASE.

  ENDMETHOD.
ENDCLASS.
