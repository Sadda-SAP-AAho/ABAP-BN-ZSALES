CLASS  Zcl_http_control_sheet DEFINITION
  PUBLIC

  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.

    CLASS-DATA it_master TYPE TABLE OF  zcontrolsheet.
    TYPES: BEGIN OF ty_json,
             to_master LIKE it_master,
             END OF ty_json.

    DATA: lv_json TYPE ty_json.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_CONTROL_SHEET IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

DATA(req) = request->get_form_fields(  ).
    DATA(lv_body) = request->get_text( ).

    CASE request->get_method(  ).

      WHEN CONV string( if_web_http_client=>post ).

        IF lv_body IS NOT INITIAL.

          TRY.
              CALL METHOD /ui2/cl_json=>deserialize
                EXPORTING
                  json = lv_body
                CHANGING
                  data = lv_json.

              DATA(it_final_master) = lv_json-to_master.

              IF it_final_master IS NOT INITIAL.
                LOOP AT it_final_master INTO DATA(wa_final_master) .

*                wa_final_master-created_at       = cl_abap_context_info=>get_system_time( ).
                wa_final_master-created_by       = cl_abap_context_info=>get_user_alias( ).
                wa_final_master-last_changed_by  = cl_abap_context_info=>get_user_ALIAS( ).
*                wa_final_master-last_changed_at  = cl_abap_context_info=>get_system_time( ).

                MODIFY zcontrolsheet FROM @wa_final_master.
                clear : wa_final_master.
                ENDLOOP.

                IF sy-subrc = 0.
                  response->set_text( 'Data saved successfully' ).
                ELSE.
                  response->set_status( 500 ).
                  response->set_text( 'Error: Failed to save data in the database' ).
                ENDIF.

              ELSE.
                response->set_status( 400 ).
                response->set_text( 'Error: No data found in request body' ).
              ENDIF.

            CATCH cx_root INTO DATA(lx_root).
              response->set_status( 500 ).
              response->set_text( 'Error: Failed to process JSON request - ' && lx_root->get_text( ) ).
          ENDTRY.

        ELSE.
          response->set_status( 400 ).
          response->set_text( 'Error: Request body is empty' ).
        ENDIF.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
