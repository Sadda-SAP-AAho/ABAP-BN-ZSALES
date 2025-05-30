class ZCL_HTTP_RPLCRNOTE definition
  public
  create public .

public section.

  interfaces IF_HTTP_SERVICE_EXTENSION .
  CLASS-DATA it_order TYPE TABLE OF zdt_rplcrnote .

    TYPES: BEGIN OF ty_json,
             to_order LIKE it_order,
             END OF ty_json.

    DATA: lv_json TYPE ty_json.

protected section.
private section.
ENDCLASS.



CLASS ZCL_HTTP_RPLCRNOTE IMPLEMENTATION.


  method IF_HTTP_SERVICE_EXTENSION~HANDLE_REQUEST.

   DATA(req) = request->get_form_fields(  ).

    DATA(lv_body) = request->get_text( ).

    CASE request->get_method(  ).

      WHEN CONV string( if_web_http_client=>post ).

response->set_text( 'data saved successfully' ).

        CALL METHOD /ui2/cl_json=>deserialize
          EXPORTING
            json = lv_body
          CHANGING
            data = lv_json.

        DATA(it_final_order) = lv_json-to_order.

        IF it_final_order  IS NOT INITIAL.

          LOOP At  it_final_order INTO DATA(wa_final_order).

          wa_final_order-created_at           = cl_abap_context_info=>get_system_date( ).
            wa_final_order-created_by =        cl_abap_context_info=>get_user_alias( ).
            wa_final_order-last_changed_by = cl_abap_context_info=>get_user_ALIAS( ).
           wa_final_order-last_changed_at      = Cl_abap_context_info=>get_system_time( ).


          MODIFY zdt_rplcrnote FROM @wa_final_order.
          CLEAR : wa_final_order.
            ENDLOOP.
        ENDIF.

    ENDCASE.

  endmethod.
ENDCLASS.
