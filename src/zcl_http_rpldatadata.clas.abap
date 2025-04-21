    CLASS  ZCL_HTTP_RPLDATADATA DEFINITION
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

    CLASS-DATA IT_RPLDATAMST TYPE TABLE OF  ZDT_RPLDATAMST .
    CLASS-DATA IT_RPLDATADATA TYPE TABLE OF ZCS_RPLDATADATA1.
*  CLASS-DATA  it_SYS TYPE TABLE OF ty_sys .


    TYPES: BEGIN OF ty_json,
             TO_RPLDATAMST LIKE IT_RPLDATAMST,
             TO_RPLDATADATA LIKE IT_RPLDATADATA,
*             to_rpldata LIKE it_rpldata,
*            to_sys_data like it_syS ,
             END OF ty_json.

    DATA: lv_json TYPE ty_json.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_RPLDATADATA IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.



    DATA(req) = request->get_form_fields(  ).

    DATA(lv_body) = request->get_text( ).

*    DATA(mode) = VALUE #( req[ name = 'create_invoice' ]-value OPTIONAL ) .
* xco_cp_json=>data->from_string( lv_body )->write_to( REF #( lv_json ) ).

    CASE request->get_method(  ).

      WHEN CONV string( if_web_http_client=>post ).

 response->set_text( 'saved data  successfully' ).

        CALL METHOD /ui2/cl_json=>deserialize
          EXPORTING
            json = lv_body
          CHANGING
            data = lv_json.

        DATA(it_final_RPLDATAMST) = lv_json-TO_RPLDATAMST.
        DATA(it_final_RPLDATADATA) = lv_json-TO_RPLDATADATA.
*        DATA(it_final_rpldata) = lv_json-to_rpldata.

        IF it_final_RPLDATAMST  IS NOT INITIAL. "AND it_final_invdata IS NOT INITIAL.
          READ TABLE it_final_RPLDATAMST INTO DATA(wa_final_RPLDATAMST) INDEX 1.

           wa_final_RPLDATAMST-created_at  = cl_abap_context_info=>get_system_time( ).
            wa_final_RPLDATAMST-created_by =        cl_abap_context_info=>get_user_alias( ).
            wa_final_RPLDATAMST-last_changed_by = cl_abap_context_info=>get_user_ALIAS( ).
           wa_final_RPLDATAMST-last_changed_at      = Cl_abap_context_info=>get_system_time( ).

          LOOP AT  it_final_RPLDATADATA INTO DATA(wa_final_RPLDATADATA).

          wa_final_RPLDATADATA-created_at           = cl_abap_context_info=>get_system_date( ).
            wa_final_RPLDATADATA-created_by =        cl_abap_context_info=>get_user_alias( ).
            wa_final_RPLDATADATA-last_changed_by = cl_abap_context_info=>get_user_ALIAS( ).
           wa_final_RPLDATADATA-last_changed_at      = Cl_abap_context_info=>get_system_time( ).
             MODIFY  ZCS_RPLDATADATA1 FROM  @wa_final_RPLDATADATA.
         CLEAR : wa_final_RPLDATADATA.
         ENDLOOP.

          MODIFY  ZDT_RPLDATAMST  FROM  @wa_final_RPLDATAMST.
          CLEAR : wa_final_RPLDATAMST.



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
