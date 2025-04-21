CLASS zcl_http_gatepass DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .
    TYPES:BEGIN OF ty_json,
            VMFY  TYPE string,
VMNo   TYPE string,
VMInvNo    TYPE string,
VMOutMeterRead    TYPE string,
VMInMeterRead    TYPE string,
VMOutDate    TYPE string,
VMInDate    TYPE string,
VMVehCode   TYPE string,
VMRouteCd   TYPE string,
VMDriverCd TYPE string,
VMDeisalOutside TYPE string,
VMDeisalCons TYPE string,
VMMeterStatus TYPE string,
VMOutTime TYPE string,
VMInTime TYPE string,
VMRemark TYPE string,
VMID TYPE string,
VMTotalAmt TYPE string,
VMTotalCrate1 TYPE string,
VMTotalCrate2 TYPE string,
VMSumNo TYPE string,
VMTotalCrate3 TYPE string,
VMTotalCrate4 TYPE string,
VMRoomNo TYPE string,
VMDFlgSlpNo TYPE string,
VMDFlgDt TYPE string,
vmSMCode TYPE string,
VmDieselRate TYPE string,
VmSplTag TYPE string,
VmFirstGPNo TYPE string,
VmSecondGPAmt TYPE string,
vmVerifiedBy TYPE string,
vmVerifiedDt TYPE string,
VmPumpReadingFrom TYPE string,
VmPumpReadingTo TYPE string,
VMIsSmDrvrTag TYPE string,
VmRouteFoodExpD TYPE string,
VmRouteFoodExpDCSM TYPE string,
VMFedDt TYPE string,
VMOutDateActual TYPE string,
VMFedUser TYPE string,
VMUpUser TYPE string,
VMUpDt TYPE string,
VMVer TYPE string,
VMTotalBrdQty TYPE string,
VMSumDate TYPE string,
VMCmpCode TYPE string,

          END OF ty_json.
    CLASS-DATA lv_json TYPE ty_json.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HTTP_GATEPASS IMPLEMENTATION.


  METHOD if_http_service_extension~handle_request.

    DATA(lv_body) = request->get_text( ).
    DATA(req) = request->get_form_fields(  ).

    xco_cp_json=>data->from_string( lv_body )->write_to( REF #( lv_json ) ).
    CASE request->get_method(  ).
      WHEN CONV string( if_web_http_client=>post ).


        DATA : wa_tab TYPE zgatepass_table .

       wa_tab-VMFY = lv_json-vmfy.
wa_tab-VMNo = lv_json-vmfy.
wa_tab-VMInvNo = lv_json-VMInvNo.
wa_tab-VMOutMeterRead = lv_json-vmoutmeterread.
wa_tab-VMInMeterRead = lv_json-vminmeterread.
wa_tab-VMOutDate = lv_json-vmoutdate.
wa_tab-VMInDate = lv_json-vmindate.
wa_tab-VMVehCode = lv_json-vmvehcode.
wa_tab-VMRouteCd = lv_json-vmroutecd.
wa_tab-VMDriverCd = lv_json-vmdrivercd.
wa_tab-VMDeisalOutside = lv_json-vmdeisaloutside.
wa_tab-VMDeisalCons = lv_json-vmdeisalcons.
wa_tab-VMMeterStatus = lv_json-vmmeterstatus.
wa_tab-VMOutTime = lv_json-vmouttime.
wa_tab-VMInTime = lv_json-vmintime.
wa_tab-VMRemark = lv_json-vmremark.
wa_tab-VMID = lv_json-vmid.
wa_tab-VMTotalAmt = lv_json-vmtotalamt.
wa_tab-VMTotalCrate1 = lv_json-vmtotalcrate1.
wa_tab-VMTotalCrate2 = lv_json-vmtotalcrate2.
wa_tab-VMSumNo = lv_json-vmsumno.
wa_tab-VMTotalCrate3 = lv_json-vmtotalcrate3.
wa_tab-VMTotalCrate4 = lv_json-VMTotalCrate4.
wa_tab-VMRoomNo = lv_json-VMRoomNo.
wa_tab-VMDFlgSlpNo = lv_json-VMDFlgSlpNo.
wa_tab-VMDFlgDt = lv_json-VMDFlgDt.
wa_tab-vmSMCode = lv_json-vmSMCode.
wa_tab-VmDieselRate = lv_json-VmDieselRate.
wa_tab-VmSplTag = lv_json-VmSplTag.
wa_tab-VmFirstGPNo = lv_json-VmFirstGPNo.
wa_tab-VmSecondGPAmt = lv_json-VmSecondGPAmt.
wa_tab-vmVerifiedBy = lv_json-vmVerifiedBy.
wa_tab-vmVerifiedDt = lv_json-vmVerifiedDt.
wa_tab-VmPumpReadingFrom = lv_json-VmPumpReadingFrom.
wa_tab-VmPumpReadingTo = lv_json-VmPumpReadingTo.
wa_tab-VMIsSmDrvrTag = lv_json-VMIsSmDrvrTag.
wa_tab-VmRouteFoodExpD = lv_json-VmRouteFoodExpD.
wa_tab-VmRouteFoodExpDCSM = lv_json-VmRouteFoodExpDCSM.
wa_tab-VMFedDt = lv_json-VMFedDt.
wa_tab-VMOutDateActual = lv_json-VMOutDateActual.
wa_tab-VMFedUser = lv_json-VMFedUser.
wa_tab-VMUpUser = lv_json-VMUpUser.
wa_tab-VMUpDt = lv_json-VMUpDt.
wa_tab-VMVer = lv_json-VMVer.
wa_tab-VMTotalBrdQty = lv_json-VMTotalBrdQty.
wa_tab-VMSumDate = lv_json-VMSumDate.
wa_tab-VMCmpCode = lv_json-vmcmpcode.


        MODIFY zgatepass_table FROM @wa_tab.
        CLEAR : wa_tab.
        response->set_text( 'data saved successfully' ).

      WHEN CONV string( if_web_http_client=>get ).
DATA(system_date) = cl_abap_context_info=>get_system_date( ).

" With field list and row limit
  SELECT * FROM zecms_tab
    WHERE created_at > @system_date                " Limits result set size
    INTO TABLE @DATA(it).

        DATA(ld_json) = /ui2/cl_json=>serialize(  data = it ).

        response->set_text( ld_json  ).





    ENDCASE.
  ENDMETHOD.
ENDCLASS.
