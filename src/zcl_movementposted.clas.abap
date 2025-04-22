CLASS zcl_movementposted DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .

    INTERFACES if_oo_adt_classrun .
    CLASS-METHODS runJob
        IMPORTING paramcmno TYPE C.

    CLASS-METHODS getCID RETURNING VALUE(cid) TYPE abp_behv_cid.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MOVEMENTPOSTED IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
    " Return the supported selection parameters here
    et_parameter_def = VALUE #(
      ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 80 param_text = 'Post Crate Movement Parameter'   lowercase_ind = abap_true changeable_ind = abap_true )
    ).

    " Return the default parameters values here
    et_parameter_val = VALUE #(
      ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = 'Post Crate Movement' )
    ).

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA p_descr TYPE c LENGTH 80.

  " Getting the actual parameter values
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'P_DESCR'. p_descr = ls_parameter-low.
      ENDCASE.
    ENDLOOP.

    runjob( p_descr ).
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main .
    runjob( '001378' ).
  ENDMETHOD.

  METHOD getCID.
    TRY.
        cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
    CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.
  ENDMETHOD.

  METHOD runjob.
    CONSTANTS mycid TYPE abp_behv_cid VALUE 'My%cid_CRATEMOVE' ##NO_TEXT.
    DATA: lt_cratesdata     TYPE TABLE OF zcratesdata.
    FIELD-SYMBOLS <ls_cratesdata> LIKE LINE OF lt_cratesdata.
*        DATA lt_target LIKE <ls_cratesdata>-cmno.
    DATA plantno TYPE char05.
    DATA companycode TYPE c LENGTH 5.
    DATA cmno       TYPE  c LENGTH 10.
    DATA cmfyear    TYPE  c LENGTH 4.
    DATA cmtype     TYPE  c LENGTH 2.
    DATA productdesc TYPE c LENGTH 72 .
    DATA productcode TYPE c LENGTH 72.


    DATA lt_header TYPE TABLE FOR CREATE I_MaterialDocumentTP.
    DATA lt_line TYPE TABLE FOR CREATE I_MaterialDocumentTP\_MaterialDocumentItem.
    FIELD-SYMBOLS <ls_line> LIKE LINE OF lt_line.
    DATA lt_target LIKE <ls_line>-%target.
    DATA refno TYPE string.
    DATA localparamno TYPE C LENGTH 20.
    DATA lineexists TYPE int1.

**********************************************************************
*   "Post Crate Movements
    SELECT intgmodule,intgpath FROM zintegration_tab WITH PRIVILEGED ACCESS
        WHERE intgmodule = `CrateData-StorageLocation-S-I-From`
        INTO @DATA(wa_cdslsif).      "SJ 02-04-25 - From StorageLocation SalesPerson Crate Issue "
    ENDSELECT.

    SELECT intgmodule,intgpath FROM zintegration_tab WITH PRIVILEGED ACCESS
        WHERE intgmodule = `CrateData-StorageLocation-S-I-To`
        INTO @DATA(wa_cdslsit).      "SJ 02-04-25 - To StorageLocation SalesPerson Crate Issue "
    ENDSELECT.

    SELECT intgmodule,intgpath FROM zintegration_tab WITH PRIVILEGED ACCESS
        WHERE intgmodule = `CrateData-StorageLocation-D-I-From`
        INTO @DATA(wa_cdsldrf).      "SJ 02-04-25 - From StorageLocation Dealer Security Crate Receive "
    ENDSELECT.

    SELECT intgmodule,intgpath FROM zintegration_tab WITH PRIVILEGED ACCESS
        WHERE intgmodule = `CrateData-StorageLocation-D-I-To`
        INTO @DATA(wa_cdsldrt).      "SJ 02-04-25 - To StorageLocation Dealer Security Crate Receive "
    ENDSELECT.


    SELECT intgmodule,intgpath FROM zintegration_tab WITH PRIVILEGED ACCESS
        WHERE intgmodule = `CrateData-Crate Material#1`
        INTO @DATA(wa_cdcrate1).      "SJ 02-04-25 - Crate Movement - Crate Matereial#1"
    ENDSELECT.

    SELECT intgmodule,intgpath FROM zintegration_tab WITH PRIVILEGED ACCESS
        WHERE intgmodule = `CrateData-Crate Material#2`
        INTO @DATA(wa_cdcrate2).      "SJ 02-04-25 - Crate Movement - Crate Matereial#2"
    ENDSELECT.

    SELECT intgmodule,intgpath FROM zintegration_tab WITH PRIVILEGED ACCESS
        WHERE intgmodule = `CrateData-Crate Material#3`
        INTO @DATA(wa_cdcrate3).      "SJ 02-04-25 - Crate Movement - Crate Matereial#3"
    ENDSELECT.

    SELECT intgmodule,intgpath FROM zintegration_tab WITH PRIVILEGED ACCESS
        WHERE intgmodule = `CrateData-Crate Material#4`
        INTO @DATA(wa_cdcrate4).      "SJ 02-04-25 - Crate Movement - Crate Matereial#4"
    ENDSELECT.

    DATA : ltcratesdata TYPE TABLE OF zcratesdata.
    localparamno = paramcmno.
    IF localparamno = ''.
      SELECT * FROM zcratesdata AS crda
          WHERE crda~movementposted = 0
          INTO TABLE @ltcratesdata.
    ELSE.
      SELECT * FROM zcratesdata AS crda
          WHERE crda~movementposted = 0
          AND crda~cmno = @localparamno
          INTO TABLE @ltcratesdata.
    ENDIF.

    LOOP AT ltcratesdata ASSIGNING FIELD-SYMBOL(<ls_crates>).
      companycode = <ls_crates>-comp_code.
      plantno = <ls_crates>-plant.
      cmno    = <ls_crates>-cmno .
      cmtype  = <ls_crates>-cmtype.
      cmfyear = <ls_crates>-cmfyear.
      lineexists = 0.

      DATA(Mycid2) = getCID(  ).

      CONCATENATE  <ls_crates>-plant <ls_crates>-cmfyear <ls_crates>-cmtype <ls_crates>-cmno INTO refno SEPARATED BY '-'.

      SELECT SINGLE FROM I_product
          FIELDS  BaseUnit
          WHERE Product = @wa_cdcrate1-intgpath
          INTO @DATA(unit).

      CLEAR lt_target[].

      IF <ls_crates>-cmcrates1 > 0.
        lineexists = 1.
        APPEND INITIAL LINE TO lt_target ASSIGNING FIELD-SYMBOL(<ls_target>).
        <ls_target>-%cid = |{ Mycid2 }_1_001|.
        <ls_target>-plant                              =  plantno.
        <ls_target>-Material                           =  wa_cdcrate1-intgpath. "'CMCRATES1'"
        <ls_target>-goodsmovementtype                  =  '311'.
        <ls_target>-InventorySpecialStockType          =  ''.
        IF <ls_crates>-cmtype = 'R' AND <ls_crates>-cmnoseries = 'S'.
          <ls_target>-storagelocation                    =  wa_cdslsit-intgpath. "'CR02'."
          <ls_target>-IssuingOrReceivingStorageLoc       =  wa_cdslsif-intgpath. "'CR01'."
        ELSEIF <ls_crates>-cmtype = 'I' AND <ls_crates>-cmnoseries = 'S'.
          <ls_target>-storagelocation                    =  wa_cdslsif-intgpath.
          <ls_target>-IssuingOrReceivingStorageLoc       =  wa_cdslsit-intgpath.
        ELSEIF <ls_crates>-cmtype = 'R' AND <ls_crates>-cmnoseries = 'D'.
          <ls_target>-storagelocation                    =  wa_cdsldrt-intgpath.
          <ls_target>-IssuingOrReceivingStorageLoc       =  wa_cdsldrf-intgpath.
        ELSEIF <ls_crates>-cmtype = 'I' AND <ls_crates>-cmnoseries = 'D'.
          <ls_target>-storagelocation                    =  wa_cdsldrf-intgpath.
          <ls_target>-IssuingOrReceivingStorageLoc       =  wa_cdsldrt-intgpath.
        ENDIF.
        <ls_target>-quantityinentryunit                =  <ls_crates>-cmcrates1.
        <ls_target>-entryunit                          =  unit.
        <ls_target>-batch                              =  ''.
        <ls_target>-IssuingOrReceivingPlant            =  plantno.
        <ls_target>-IssgOrRcvgBatch                    =  ''.
        <ls_target>-IssgOrRcvgSpclStockInd             =  ''.
        <ls_target>-SpecialStockIdfgSalesOrder         =  ''.
        <ls_target>-SpecialStockIdfgSalesOrderItem     =  ''.
        <ls_target>-materialdocumentitemtext           =  refno.
      ENDIF.
      IF <ls_crates>-cmcrates2 > 0.
        lineexists = 1.
        APPEND INITIAL LINE TO lt_target ASSIGNING FIELD-SYMBOL(<ls_target2>).
        <ls_target2>-%cid = |{ Mycid2 }_2_001|.
        <ls_target2>-plant                              =  plantno.
        <ls_target2>-Material                           =  wa_cdcrate2-intgpath. "'CMCRATES2'"
        <ls_target2>-goodsmovementtype                  =  '311'.
        <ls_target2>-InventorySpecialStockType          =  ''.
        IF <ls_crates>-cmtype = 'R' AND <ls_crates>-cmnoseries = 'S'.
          <ls_target2>-storagelocation                    =  wa_cdslsit-intgpath. "'CR02'."
          <ls_target2>-IssuingOrReceivingStorageLoc       =  wa_cdslsif-intgpath. "'CR01'."
        ELSEIF <ls_crates>-cmtype = 'I' AND <ls_crates>-cmnoseries = 'S'.
          <ls_target2>-storagelocation                    =  wa_cdslsif-intgpath.
          <ls_target2>-IssuingOrReceivingStorageLoc       =  wa_cdslsit-intgpath.
        ELSEIF <ls_crates>-cmtype = 'R' AND <ls_crates>-cmnoseries = 'D'.
          <ls_target2>-storagelocation                    =  wa_cdsldrt-intgpath.
          <ls_target2>-IssuingOrReceivingStorageLoc       =  wa_cdsldrf-intgpath.
        ELSEIF <ls_crates>-cmtype = 'I' AND <ls_crates>-cmnoseries = 'D'.
          <ls_target2>-storagelocation                    =  wa_cdsldrf-intgpath.
          <ls_target2>-IssuingOrReceivingStorageLoc       =  wa_cdsldrt-intgpath.
        ENDIF.
        <ls_target2>-quantityinentryunit                =  <ls_crates>-cmcrates2.
        <ls_target2>-entryunit                          =  unit.
        <ls_target2>-batch                              =  ''.
        <ls_target2>-IssuingOrReceivingPlant            =  plantno.
        <ls_target2>-IssgOrRcvgBatch                    =  ''.
        <ls_target2>-IssgOrRcvgSpclStockInd             =  ''.
        <ls_target2>-SpecialStockIdfgSalesOrder         =  ''.
        <ls_target2>-SpecialStockIdfgSalesOrderItem     =  ''.
        <ls_target2>-materialdocumentitemtext           =  refno.
      ENDIF.
      IF <ls_crates>-cmcrates3 > 0.
        lineexists = 1.
        APPEND INITIAL LINE TO lt_target ASSIGNING FIELD-SYMBOL(<ls_target3>).
        <ls_target3>-%cid = |{ Mycid2 }_3_001|.
        <ls_target3>-plant                              =  plantno.
        <ls_target3>-Material                           =  wa_cdcrate3-intgpath. "'CMCRATES3'"
        <ls_target3>-goodsmovementtype                  =  '311'.
        <ls_target3>-InventorySpecialStockType          =  ''.
        IF <ls_crates>-cmtype = 'R' AND <ls_crates>-cmnoseries = 'S'.
          <ls_target3>-storagelocation                    =  wa_cdslsit-intgpath. "'CR02'."
          <ls_target3>-IssuingOrReceivingStorageLoc       =  wa_cdslsif-intgpath. "'CR01'."
        ELSEIF <ls_crates>-cmtype = 'I' AND <ls_crates>-cmnoseries = 'S'.
          <ls_target3>-storagelocation                    =  wa_cdslsif-intgpath.
          <ls_target3>-IssuingOrReceivingStorageLoc       =  wa_cdslsit-intgpath.
        ELSEIF <ls_crates>-cmtype = 'R' AND <ls_crates>-cmnoseries = 'D'.
          <ls_target3>-storagelocation                    =  wa_cdsldrt-intgpath.
          <ls_target3>-IssuingOrReceivingStorageLoc       =  wa_cdsldrf-intgpath.
        ELSEIF <ls_crates>-cmtype = 'I' AND <ls_crates>-cmnoseries = 'D'.
          <ls_target3>-storagelocation                    =  wa_cdsldrf-intgpath.
          <ls_target3>-IssuingOrReceivingStorageLoc       =  wa_cdsldrt-intgpath.
        ENDIF.
        <ls_target3>-quantityinentryunit                =  <ls_crates>-cmcrates3.
        <ls_target3>-entryunit                          =  unit.
        <ls_target3>-batch                              =  ''.
        <ls_target3>-IssuingOrReceivingPlant            =  plantno.
        <ls_target3>-IssgOrRcvgBatch                    =  ''.
        <ls_target3>-IssgOrRcvgSpclStockInd             =  ''.
        <ls_target3>-SpecialStockIdfgSalesOrder         =  ''.
        <ls_target3>-SpecialStockIdfgSalesOrderItem     =  ''.
        <ls_target3>-materialdocumentitemtext           =  refno.
      ENDIF.
      IF <ls_crates>-cmcrates4 > 0.
        lineexists = 1.
        APPEND INITIAL LINE TO lt_target ASSIGNING FIELD-SYMBOL(<ls_target4>).
        <ls_target4>-%cid = |{ Mycid2 }_4_001|.
        <ls_target4>-plant                              =  plantno.
        <ls_target>-Material                           =  wa_cdcrate4-intgpath. "'CMCRATES4'"
        <ls_target4>-goodsmovementtype                  =  '311'.
        <ls_target4>-InventorySpecialStockType          =  ''.
        IF <ls_crates>-cmtype = 'R' AND <ls_crates>-cmnoseries = 'S'.
          <ls_target4>-storagelocation                    =  wa_cdslsit-intgpath. "'CR02'."
          <ls_target4>-IssuingOrReceivingStorageLoc       =  wa_cdslsif-intgpath. "'CR01'."
        ELSEIF <ls_crates>-cmtype = 'I' AND <ls_crates>-cmnoseries = 'S'.
          <ls_target4>-storagelocation                    =  wa_cdslsif-intgpath.
          <ls_target4>-IssuingOrReceivingStorageLoc       =  wa_cdslsit-intgpath.
        ELSEIF <ls_crates>-cmtype = 'R' AND <ls_crates>-cmnoseries = 'D'.
          <ls_target4>-storagelocation                    =  wa_cdsldrt-intgpath.
          <ls_target4>-IssuingOrReceivingStorageLoc       =  wa_cdsldrf-intgpath.
        ELSEIF <ls_crates>-cmtype = 'I' AND <ls_crates>-cmnoseries = 'D'.
          <ls_target4>-storagelocation                    =  wa_cdsldrf-intgpath.
          <ls_target4>-IssuingOrReceivingStorageLoc       =  wa_cdsldrt-intgpath.
        ENDIF.
        <ls_target4>-quantityinentryunit                =  <ls_crates>-cmcrates4.
        <ls_target4>-entryunit                          =  unit.
        <ls_target4>-batch                              =  ''.
        <ls_target4>-IssuingOrReceivingPlant            =  plantno.
        <ls_target4>-IssgOrRcvgBatch                    =  ''.
        <ls_target4>-IssgOrRcvgSpclStockInd             =  ''.
        <ls_target4>-SpecialStockIdfgSalesOrder         =  ''.
        <ls_target4>-SpecialStockIdfgSalesOrderItem     =  ''.
        <ls_target4>-materialdocumentitemtext           =  refno.
      ENDIF.

      IF lineexists <> 0.
          MODIFY ENTITIES OF i_materialdocumenttp
              ENTITY materialdocument
              CREATE FROM VALUE #( ( %cid       = Mycid2
                  goodsmovementcode             = '04'
                  postingdate                   =  <ls_crates>-cmdate
                  documentdate                  =  <ls_crates>-cmdate
                  MaterialDocumentHeaderText    =  refno

                  %control-goodsmovementcode            = cl_abap_behv=>flag_changed
                  %control-postingdate                  = cl_abap_behv=>flag_changed
                  %control-documentdate                 = cl_abap_behv=>flag_changed
                  %control-MaterialDocumentHeaderText   = cl_abap_behv=>flag_changed
                  ) )

                  ENTITY materialdocument
                  CREATE BY \_materialdocumentitem
                  FROM VALUE #( (
                          %cid_ref = Mycid2
                          %target = lt_target
                               ) )
                  MAPPED   DATA(ls_create_mapped2)
                  FAILED   DATA(ls_create_failed2)
                  REPORTED DATA(ls_create_reported2).

          COMMIT ENTITIES BEGIN
            RESPONSE OF i_materialdocumenttp
            FAILED DATA(commit_failed2)
            REPORTED DATA(commit_reported2).
          COMMIT ENTITIES END.

          IF commit_failed2 IS INITIAL.

            SELECT SINGLE FROM I_MaterialDocumentItem_2
               FIELDS MaterialDocument
              WHERE MaterialDocumentItemText = @refno
              AND CompanyCode = @companycode AND Plant = @plantno
              AND PostingDate = @<ls_crates>-cmdate
              INTO @DATA(mdit).


            UPDATE zcratesdata
                SET movementposted = 1,
                error_log = ``,
                reference_doc = @mdit
                WHERE comp_code = @companycode AND plant = @plantno AND cmno = @cmno
                AND cmtype = @cmtype AND cmfyear = @cmfyear
                AND movementposted = 0.
          ELSE.
            DATA: lv_cust_result TYPE char256.
            LOOP AT commit_failed2-materialdocument ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).

              lv_cust_result = lv_cust_result && <ls_reported_deep>-%fail-cause. " ->if_message~get_text( )."

*                     DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
              ...
            ENDLOOP.

            UPDATE zcratesdata
                  SET error_log = @lv_cust_result
            WHERE comp_code = @companycode AND plant = @plantno AND cmno = @cmno
            AND cmtype = @cmtype AND cmfyear = @cmfyear
            AND movementposted = 0.

            CLEAR: lv_cust_result.
          ENDIF.
      ELSE.
        UPDATE zcratesdata
            SET movementposted = 1, error_log = 'Zero Qty.'
        WHERE comp_code = @companycode AND plant = @plantno AND cmno = @cmno
        AND cmtype = @cmtype AND cmfyear = @cmfyear
        AND movementposted = 0.
      ENDIF.

      CLEAR : ls_create_failed2, ls_create_failed2, ls_create_reported2.
*      ENDIF.
    ENDLOOP.



  ENDMETHOD.
ENDCLASS.
