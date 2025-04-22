CLASS zcl_rplcninvmovpost DEFINITION
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



CLASS ZCL_RPLCNINVMOVPOST IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.
    " Return the supported selection parameters here
    et_parameter_def = VALUE #(
      ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 80 param_text = 'Post Scrap Generation'   lowercase_ind = abap_true changeable_ind = abap_true )
    ).

    " Return the default parameters values here
    et_parameter_val = VALUE #(
      ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = 'Post Scrap Generation' )
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
    runjob( 'ABC' ).
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
    DATA companycode TYPE C LENGTH 5.
    DATA cmno       TYPE  C LENGTH 10.
    DATA cmfyear    TYPE  C LENGTH 4.
    DATA cmtype     TYPE  C LENGTH 2.
    DATA productdesc TYPE C LENGTH 72 .
    DATA productcode TYPE C LENGTH 72.


    DATA lt_header TYPE TABLE FOR CREATE I_MaterialDocumentTP.
    DATA lt_line TYPE TABLE FOR CREATE I_MaterialDocumentTP\_MaterialDocumentItem.
    FIELD-SYMBOLS <ls_line> like line of lt_line.
    DATA lt_target LIKE <ls_line>-%target.
    DATA refno TYPE string.
    DATA localparamno TYPE C LENGTH 20.

**********************************************************************

    SELECT SINGLE FROM zintegration_tab AS a
        FIELDS a~intgpath
        WHERE a~intgmodule = 'FGSTORAGELOCATION'
        INTO @DATA(wa_fgstoragelocation).

*   "Post Scrap Generation Data
    DATA : ltcrdata TYPE TABLE OF zdt_rplcrnote.
    localparamno = paramcmno.
    IF localparamno = ''.
        SELECT * FROM zdt_rplcrnote
            WHERE processed = ''
        INTO TABLE @ltcrdata.
    ELSE.
        SELECT * FROM zdt_rplcrnote
            WHERE processed = '' AND imno = @localparamno
        INTO TABLE @ltcrdata.
    ENDIF.
    LOOP AT ltcrdata ASSIGNING FIELD-SYMBOL(<ls_crdata>).
        companycode = <ls_crdata>-comp_code.
        plantno = <ls_crdata>-implant.
        cmno    = <ls_crdata>-imno.
        cmfyear = <ls_crdata>-imfyear.

        DATA(Mycid2) = getCID(  ).
        CONCATENATE  <ls_crdata>-implant <ls_crdata>-imfyear <ls_crdata>-imtype <ls_crdata>-imno <ls_crdata>-imdealercode INTO refno SEPARATED BY '-'.

        clear lt_target[].

        IF <ls_crdata>-imbreadwt > 0.
            SELECT SINGLE FROM I_ProductStdVH
                FIELDS Product
                WHERE ProductExternalID = @<ls_crdata>-imbreadcode
                INTO @DATA(pcodeBread).
            productcode = pcodeBread.

            APPEND INITIAL LINE TO lt_target ASSIGNING FIELD-SYMBOL(<ls_targets1>).
                <ls_targets1>-%cid = |{ Mycid2 }_1_001|.
                <ls_targets1>-plant                              =  plantno.
                <ls_targets1>-Material                           =  productcode.
                <ls_targets1>-goodsmovementtype                  =  '501'.
                <ls_targets1>-InventorySpecialStockType          =  ''.
                <ls_targets1>-storagelocation                    =  wa_fgstoragelocation.
                <ls_targets1>-quantityinentryunit                =  <ls_crdata>-imbreadwt.
                <ls_targets1>-entryunit                          =  ''.
                <ls_targets1>-batch                              =  ''.
                <ls_targets1>-SpecialStockIdfgSalesOrder         =  ''.
                <ls_targets1>-SpecialStockIdfgSalesOrderItem     =  ''.
                <ls_targets1>-materialdocumentitemtext           =  refno.
        ENDIF.
        IF <ls_crdata>-imwrapperwt > 0.
            SELECT SINGLE FROM I_ProductStdVH
                FIELDS Product
                WHERE ProductExternalID = @<ls_crdata>-imwrappercode
                INTO @DATA(pcodeWrapper).
            productcode = pcodeWrapper.

            APPEND INITIAL LINE TO lt_target ASSIGNING FIELD-SYMBOL(<ls_targets2>).
                <ls_targets2>-%cid = |{ Mycid2 }_2_001|.
                <ls_targets2>-plant                              =  plantno.
                <ls_targets2>-Material                           =  productcode.
                <ls_targets2>-goodsmovementtype                  =  '501'.
                <ls_targets2>-InventorySpecialStockType          =  ''.
                <ls_targets2>-storagelocation                    =  wa_fgstoragelocation.
                <ls_targets2>-quantityinentryunit                =  <ls_crdata>-imwrapperwt.
                <ls_targets2>-entryunit                          =  ''.
                <ls_targets2>-batch                              =  ''.
                <ls_targets2>-SpecialStockIdfgSalesOrder         =  ''.
                <ls_targets2>-SpecialStockIdfgSalesOrderItem     =  ''.
                <ls_targets2>-materialdocumentitemtext           =  refno.
        ENDIF.
        IF <ls_crdata>-imbreadwt > 0 OR <ls_crdata>-imwrapperwt > 0.

            MODIFY ENTITIES OF i_materialdocumenttp
                ENTITY materialdocument
                CREATE FROM VALUE #( ( %cid       = Mycid2
                    goodsmovementcode             = '01'
                    postingdate                   =  <ls_crdata>-imdate
                    documentdate                  =  <ls_crdata>-imdate
                    MaterialDocumentHeaderText    =  refno

                    %control-goodsmovementcode          = cl_abap_behv=>flag_changed
                    %control-postingdate                = cl_abap_behv=>flag_changed
                    %control-documentdate               = cl_abap_behv=>flag_changed
                    %control-MaterialDocumentHeaderText = cl_abap_behv=>flag_changed
                    ) )

                    ENTITY materialdocument
                    CREATE BY \_materialdocumentitem
                    FROM VALUE #( (
                            %cid_ref = Mycid2
                            %target = lt_target
                                 ) )
                    MAPPED   DATA(ls_create_mappedcr)
                    FAILED   DATA(ls_create_failedcr)
                    REPORTED DATA(ls_create_reportedcr).

            COMMIT ENTITIES BEGIN
              RESPONSE OF i_materialdocumenttp
              FAILED DATA(commit_failedcr)
              REPORTED DATA(commit_reportedcr).


*                DATA: ls_mat_temp_key TYPE STRUCTURE FOR KEY OF I_MaterialDocumentTP.
*                CONVERT KEY OF I_MaterialDocumentTP FROM ls_mat_temp_key TO DATA(ls_mat_final_key).
*
*                TYPES: BEGIN OF ty_materialitem_key,
*                    documentno      TYPE I_MaterialDocumentItemTP-MaterialDocument,
*                    documentitem    TYPE I_MaterialDocumentItemTP-MaterialDocumentItem,
*                END OF ty_materialitem_key.
*
*                DATA: lt_mat_item_temp_keys TYPE TABLE OF ty_materialitem_key,
*                    lt_mat_item_final_keys  TYPE TABLE OF ty_materialitem_key,
*                    ls_mat_item_temp_key    TYPE ty_materialitem_key,
*                    ls_mat_item_final_key   TYPE ty_materialitem_key.
*
*                LOOP AT ls_create_mappedcr-materialdocumentitem ASSIGNING FIELD-SYMBOL(<ls_mapped_item>).
*                    MOVE-CORRESPONDING <ls_mapped_item> TO ls_mat_item_temp_key.
*                    APPEND ls_mat_item_temp_key TO lt_mat_item_temp_keys.
*                ENDLOOP.

*                LOOP AT lt_mat_item_temp_keys INTO ls_mat_item_temp_key.
*                    CONVERT KEY OF I_MaterialDocumentItemTP FROM ls_mat_item_temp_key TO ls_mat_item_final_key.
*                    APPEND ls_mat_item_final_key TO lt_mat_item_final_keys.
*                ENDLOOP.

            COMMIT ENTITIES END.

*            data md type STANDARD TABLE OF  ls_create_reportedcr.


            IF commit_failedcr is INITIAL.

              SELECT SINGLE FROM I_MaterialDocumentItem_2
                FIELDS MaterialDocument
                where MaterialDocumentItemText = @refno
                and CompanyCode = @companycode and Plant = @plantno
                and PostingDate = @<ls_crdata>-imdate
                into @data(mdit).

                UPDATE zdt_rplcrnote
                    SET processed = '1',
                    error_log = ``,
                    scrapindoc = @mdit
                    WHERE comp_code = @companycode AND implant = @plantno AND imno = @cmno
                    AND imfyear = @cmfyear AND imtype = @<ls_crdata>-imtype AND imdealercode = @<ls_crdata>-imdealercode.
            else.
                data: lv_cust_result type char256.
                LOOP AT commit_failedcr-materialdocument ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).

                   lv_cust_result = lv_cust_result && <ls_reported_deep>-%fail-cause. " ->if_message~get_text( )."

*                 DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
                ...
                ENDLOOP.

                UPDATE zdt_rplcrnote
                    SET error_log = @lv_cust_result
                    WHERE comp_code = @companycode AND implant = @plantno AND imno = @cmno
                    AND imfyear = @cmfyear AND imtype = @<ls_crdata>-imtype AND imdealercode = @<ls_crdata>-imdealercode.
            ENDIF.

            CLEAR : ls_create_failedcr, ls_create_failedcr, ls_create_reportedcr.

        ELSE.
            UPDATE zdt_rplcrnote
                SET error_log = 'Zero Qty.', processed = '1'
                WHERE comp_code = @companycode AND implant = @plantno AND imno = @cmno
                AND imfyear = @cmfyear AND imtype = @<ls_crdata>-imtype AND imdealercode = @<ls_crdata>-imdealercode.
        ENDIF.

    ENDLOOP.


  ENDMETHOD.
ENDCLASS.
