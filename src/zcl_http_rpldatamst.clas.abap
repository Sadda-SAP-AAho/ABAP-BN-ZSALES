CLASS ZCL_HTTP_RPLDATAMST DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
    TYPES:BEGIN OF ty_json,
ImFyear TYPE STRING,
ImType TYPE STRING,
ImNoSeries TYPE STRING,
ImNo TYPE STRING,
ImDate TYPE STRING,
ImJobNo TYPE STRING,
ImSalesManCode TYPE STRING,
ImPartyCode TYPE STRING,
ImDealerCode TYPE STRING,
ImRouteCode TYPE STRING,
ImRemarks TYPE STRING,
ImTotQty TYPE STRING,
ImVogAmt TYPE STRING,
ImTxbAmt TYPE STRING,
ImNetAmt TYPE STRING,
ImNetAmtRO TYPE STRING,
ImCrates1 TYPE STRING,
ImCrates2 TYPE STRING,
ImRcds TYPE STRING,
ImUserCode TYPE STRING,
ImDFDt TYPE STRING,
ImDUDt TYPE STRING,
ImAid TYPE STRING,
ImPassTag TYPE STRING,
imPassDate TYPE STRING,
ImAgnstGPNo TYPE STRING,
ImAgnstGPDate TYPE STRING,
ImCGSTAmount TYPE STRING,
ImSGSTAmount TYPE STRING,
ImIGSTAmount TYPE STRING,
ImIRNStatus TYPE STRING,
ImCmpCode TYPE STRING,
          END OF ty_json.
    CLASS-DATA lv_json TYPE ty_json.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_RPLDATAMST IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    DATA(lv_body) = request->get_text( ).
    DATA(req) = request->get_form_fields(  ).

    xco_cp_json=>data->from_string( lv_body )->write_to( REF #( lv_json ) ).
    CASE request->get_method(  ).
      WHEN CONV string( if_web_http_client=>post ).


        DATA : wa_tab TYPE ZDT_RPLDATAMST .

wa_tab-ImFyear = lv_json-ImFyear.
wa_tab-ImType = lv_json-ImType.
wa_tab-ImNoSeries = lv_json-ImNoSeries.
wa_tab-ImNo = lv_json-ImNo.
wa_tab-ImDate = lv_json-ImDate.
wa_tab-ImJobNo = lv_json-ImJobNo.
wa_tab-ImSalesManCode = lv_json-ImSalesManCode.
wa_tab-ImPartyCode = lv_json-ImPartyCode.
wa_tab-ImDealerCode = lv_json-ImDealerCode.
wa_tab-ImRouteCode = lv_json-ImRouteCode.
wa_tab-ImRemarks = lv_json-ImRemarks.
wa_tab-ImTotQty = lv_json-ImTotQty.
wa_tab-ImVogAmt = lv_json-ImVogAmt.
wa_tab-ImTxbAmt = lv_json-ImTxbAmt.
wa_tab-ImNetAmt = lv_json-ImNetAmt.
wa_tab-ImNetAmtRO = lv_json-ImNetAmtRO.
wa_tab-ImCrates1 = lv_json-ImCrates1.
wa_tab-ImCrates2 = lv_json-ImCrates2.
wa_tab-ImRcds = lv_json-ImRcds.
wa_tab-ImUserCode = lv_json-ImUserCode.
wa_tab-ImDFDt = lv_json-ImDFDt.
wa_tab-ImDUDt = lv_json-ImDUDt.
wa_tab-ImAid = lv_json-ImAid.
wa_tab-ImPassTag = lv_json-ImPassTag.
wa_tab-imPassDate = lv_json-imPassDate.
wa_tab-ImAgnstGPNo = lv_json-ImAgnstGPNo.
wa_tab-ImAgnstGPDate = lv_json-ImAgnstGPDate.
wa_tab-ImCGSTAmount = lv_json-ImCGSTAmount.
wa_tab-ImSGSTAmount = lv_json-ImSGSTAmount.
wa_tab-ImIGSTAmount = lv_json-ImIGSTAmount.
wa_tab-ImIRNStatus = lv_json-ImIGSTAmount.
wa_tab-ImCmpCode = lv_json-ImCmpCode.



        MODIFY ZDT_RPLDATAMST FROM @wa_tab.
        CLEAR : wa_tab.
        response->set_text( 'data saved successfully' ).

      WHEN CONV string( if_web_http_client=>get ).

        SELECT * FROM ZDT_RPLDATAMST INTO TABLE @DATA(it).

        DATA(ld_json) = /ui2/cl_json=>serialize(  data = it ).

        response->set_text( ld_json  ).





    ENDCASE.
  ENDMETHOD.
ENDCLASS.
