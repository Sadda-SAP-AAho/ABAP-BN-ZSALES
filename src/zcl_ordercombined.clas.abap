CLASS  Zcl_ordercombined DEFINITION
  PUBLIC

  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_http_service_extension.

    CLASS-DATA it_order TYPE TABLE OF  Zapp_orderdata .
    CLASS-DATA it_master TYPE TABLE OF zapp_ordmstdata1.

    TYPES: BEGIN OF ty_json,
             to_master LIKE it_master,
             to_order LIKE it_order,
             END OF ty_json.

    DATA: lv_json TYPE ty_json.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_ORDERCOMBINED IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

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

        DATA(it_final_master) = lv_json-to_master.
        DATA(it_final_order) = lv_json-to_order.

        IF it_final_master  IS NOT INITIAL.
          READ TABLE it_final_master INTO DATA(wa_final_master) INDEX 1.

           wa_final_master-created_at           = cl_abap_context_info=>get_system_time( ).
            wa_final_master-created_by =        cl_abap_context_info=>get_user_alias( ).
            wa_final_master-last_changed_by = cl_abap_context_info=>get_user_ALIAS( ).
           wa_final_master-last_changed_at      = Cl_abap_context_info=>get_system_time( ).

          LOOP AT  it_final_order INTO DATA(wa_final_order).
          wa_final_order-created_at           = cl_abap_context_info=>get_system_date( ).
            wa_final_order-created_by =        cl_abap_context_info=>get_user_alias( ).
            wa_final_order-last_changed_by = cl_abap_context_info=>get_user_ALIAS( ).
           wa_final_order-last_changed_at      = Cl_abap_context_info=>get_system_time( ).
             MODIFY  Zapp_orderdata FROM  @wa_final_order.
         CLEAR : wa_final_order.
          ENDLOOP.

          MODIFY zapp_ordmstdata1 FROM @wa_final_master.
          CLEAR : wa_final_master.


        ENDIF.

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
