CLASS zcl_glaccountposting DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_apj_dt_exec_object .
  INTERFACES if_apj_rt_exec_object .


  INTERFACES if_oo_adt_classrun.

  CLASS-METHODS runJob  .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GLACCOUNTPOSTING IMPLEMENTATION.


    METHOD if_apj_dt_exec_object~get_parameters.
        " Return the supported selection parameters here
        et_parameter_def = VALUE #(
          ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 80 param_text = 'Create Interbranch PO'   lowercase_ind = abap_true changeable_ind = abap_true )
        ).

        " Return the default parameters values here
        et_parameter_val = VALUE #(
          ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = 'Create Interbranch PO' )
        ).

    ENDMETHOD.


    METHOD if_apj_rt_exec_object~execute.
        runJob(  ).
    ENDMETHOD.


    METHOD if_oo_adt_classrun~main .
        runJob(  ).
    ENDMETHOD.


    METHOD runJob.
        DATA totalSalesPExp TYPE P DECIMALS 3.
        DATA total880Exp TYPE P DECIMALS 3.
        DATA totalCngExp TYPE P DECIMALS 3.
        DATA totalDieselExp TYPE P DECIMALS 3.
        DATA totalrepair TYPE P DECIMALS 3.
        DATA amtdeposit TYPE P DECIMALS 3.
        DATA amtdealer TYPE P DECIMALS 3.
        DATA plantno TYPE C LENGTH 5.
        DATA companycode TYPE C LENGTH 5.
        DATA fnyr TYPE C LENGTH 4.
        DATA gateentryno TYPE C LENGTH 20.
        DATA costcenter TYPE C LENGTH 10.
        DATA customercode TYPE C LENGTH 20.
        DATA glaccount TYPE C LENGTH 10.
        DATA vehiclenum TYPE C LENGTH 10.
        DATA dealercode TYPE C LENGTH 10.
        DATA salespersoncode TYPE C LENGTH 20.
        DATA differamt TYPE P DECIMALS 2.
        DATA custamount TYPE P DECIMALS 2.
        DATA : lv_date TYPE D.
        DATA lv_count TYPE I.
        data: lv_cust_result type char256.
        data: jeno type char72.

****         SJ 01-04-25 Start to Get GLs ************
        TYPES: BEGIN OF ls_glExpDtls,
              expname TYPE char72,
              glnumber TYPE char72,
              expAmt TYPE decan,
            END OF ls_glExpDtls.


        DATA: gt_glExpDtls TYPE STANDARD TABLE OF ls_glExpDtls WITH KEY expname.
        DATA: ls_ls_glExpDtls_struct TYPE ls_glExpDtls.


        SELECT intgmodule,intgpath FROM zintegration_tab WITH PRIVILEGED ACCESS
           where intgmodule = `Controlsheet-TollExpGL`
           into  @data(wa_cstollGL).      "SJ 01-04-25 - GL of Toll"


        SELECT SINGLE FROM zintegration_tab WITH PRIVILEGED ACCESS
           FIELDS intgmodule,intgpath
           where intgmodule = `Controlsheet-RouteExpGL`
           into  @data(wa_csrouteGL).      "SJ 01-04-25 - GL of Route Exp"

        SELECT SINGLE FROM zintegration_tab WITH PRIVILEGED ACCESS
           FIELDS intgmodule,intgpath
           where intgmodule = `Controlsheet-OtherExpGL`
           into  @data(wa_csothGL).      "SJ 01-04-25 - GL of Other Exp"

        SELECT SINGLE FROM zintegration_tab WITH PRIVILEGED ACCESS
           FIELDS intgmodule,intgpath
           where intgmodule = `Controlsheet-CNGExpGL`
           into  @data(wa_cscngGL).      "SJ 01-04-25 - GL of CNG Exp"

        SELECT SINGLE FROM zintegration_tab WITH PRIVILEGED ACCESS
           FIELDS intgmodule,intgpath
           where intgmodule = `Controlsheet-DieselExpGL`
           into  @data(wa_csdieselGL).      "SJ 01-04-25 - GL of Diesel Exp"

        SELECT SINGLE FROM zintegration_tab WITH PRIVILEGED ACCESS
           FIELDS intgmodule,intgpath
           where intgmodule = `Controlsheet-RepairExpGL`
           into  @data(wa_csrepairGL).      "SJ 01-04-25 - GL of Repair Exp"

         ENDSELECT.

****         SJ 01-04-25 end to Get GLs ************

*        DATA lt_header TYPE TABLE FOR CREATE I_MaterialDocumentTP.
*        DATA lt_line TYPE TABLE FOR CREATE I_MaterialDocumentTP\_MaterialDocumentItem.
*        FIELD-SYMBOLS <ls_line> like line of lt_line.
*        DATA lt_target LIKE <ls_line>-%target.



        SELECT FROM zcontrolsheet AS cs
            FIELDS cs~gate_entry_no, cs~vehiclenum, cs~comp_code, cs~imfyear, cs~gpdate, cs~controlsheet, cs~toll
            , cs~routeexp, cs~cngexp, cs~other, cs~dieselexp, cs~repair, cs~plant, cs~cost_center
            , cs~sales_person
            WHERE cs~glposted = 0
        INTO TABLE @DATA(ltcontrolsheet).


*        lv_date = cl_abap_context_info=>get_system_date(  ).




        LOOP AT ltcontrolsheet ASSIGNING FIELD-SYMBOL(<ls_controlsheet>).


            SELECT SINGLE FROM zcashroomcrtable as ccsg
                FIELDS ccsg~cdate
            WHERE cgpno = @<ls_controlsheet>-gate_entry_no
            INTO  @DATA(lv_cashSheetcdate).
            if lv_cashSheetcdate is not INITIAL.


                lv_date = lv_cashSheetcdate.

                total880exp = <ls_controlsheet>-toll + <ls_controlsheet>-routeexp + <ls_controlsheet>-other .
                totalCngExp = <ls_controlsheet>-cngexp.
                totalDieselExp = <ls_controlsheet>-dieselexp.
                totalrepair = <ls_controlsheet>-repair.
                totalSalesPExp = total880exp + totalCngExp + totalDieselExp + totalrepair.
                plantno = <ls_controlsheet>-plant.
                companycode = <ls_controlsheet>-comp_code.
                fnyr = <ls_controlsheet>-imfyear.
                gateentryno = <ls_controlsheet>-gate_entry_no.
                Select From I_BusinessPartner AS ibp
                    FIELDS BusinessPartner
                    where ibp~BusinessPartnerIDByExtSystem = @<ls_controlsheet>-sales_person
                INTO TABLE @DATA(lt_customer).
                IF lt_customer is not INITIAL .
                    LOOP AT lt_customer INTO DATA(wa_customer).
                        customercode = wa_customer-BusinessPartner.
                    ENDLOOP.


*    ***         SJ 01-04-25 Start Append GLs and amount in internal table ************


                 delete gt_glExpDtls where NOT expname = `aaaa`.

                ls_ls_glExpDtls_struct-expname = wa_cstollGL-intgmodule.
                ls_ls_glExpDtls_struct-glnumber = wa_cstollGL-intgpath.
                ls_ls_glExpDtls_struct-expamt = <ls_controlsheet>-toll.
                APPEND ls_ls_glExpDtls_struct TO gt_glexpdtls.

                ls_ls_glExpDtls_struct-expname = wa_csrouteGL-intgmodule.
                ls_ls_glExpDtls_struct-glnumber = wa_csrouteGL-intgpath.
                ls_ls_glExpDtls_struct-expamt = <ls_controlsheet>-routeexp.
                APPEND ls_ls_glExpDtls_struct TO gt_glexpdtls.

                ls_ls_glExpDtls_struct-expname = wa_csothGL-intgmodule.
                ls_ls_glExpDtls_struct-glnumber = wa_csothGL-intgpath.
                ls_ls_glExpDtls_struct-expamt = <ls_controlsheet>-other.
                APPEND ls_ls_glExpDtls_struct TO gt_glexpdtls.

                ls_ls_glExpDtls_struct-expname = wa_cscngGL-intgmodule.
                ls_ls_glExpDtls_struct-glnumber = wa_cscngGL-intgpath.
                ls_ls_glExpDtls_struct-expamt = <ls_controlsheet>-cngexp.
                APPEND ls_ls_glExpDtls_struct TO gt_glexpdtls.

                ls_ls_glExpDtls_struct-expname = wa_csdieselGL-intgmodule.
                ls_ls_glExpDtls_struct-glnumber = wa_csdieselGL-intgpath.
                ls_ls_glExpDtls_struct-expamt = <ls_controlsheet>-dieselexp.
                APPEND ls_ls_glExpDtls_struct TO gt_glexpdtls.

                ls_ls_glExpDtls_struct-expname = wa_csrepairGL-intgmodule.
                ls_ls_glExpDtls_struct-glnumber = wa_csrepairGL-intgpath.
                ls_ls_glExpDtls_struct-expamt = <ls_controlsheet>-repair.
                APPEND ls_ls_glExpDtls_struct TO gt_glexpdtls.


                select a~glnumber , sum( a~expAmt ) as expAmt from @gt_glexpdtls as a
                    where a~expamt > 0
                    group by  a~glnumber
                    into table @data(waglexp).


*    ***         SJ 01-04-25 end Append GLs and amount in internal table ************



                    Select From ztable_plant AS pt
                        FIELDS pt~costcenter
                        where pt~comp_code = @companycode
                        AND pt~plant_code = @plantno
                    INTO TABLE @DATA(ltPlant).
                    IF ltPlant IS NOT INITIAL.
                        LOOP AT ltPlant INTO DATA(waplant).
                            costcenter = waplant-costcenter.
                        ENDLOOP.
                        IF costcenter <> ''.
                            DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
                            lv_cid TYPE abp_behv_cid.

                            TRY.
                            lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
                            CATCH cx_uuid_error.
                            ASSERT 1 = 0.
                            ENDTRY.

                            APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
                            <je_deep>-%cid = lv_cid.

                            <je_deep>-%param = VALUE #(
                            companycode = <ls_controlsheet>-comp_code
                            businesstransactiontype = 'RFBU'
                            accountingdocumenttype = 'DG'

                            CreatedByUser = SY-uname
                            documentdate = lv_date
                            postingdate = lv_date
                            accountingdocumentheadertext = <ls_controlsheet>-controlsheet && <ls_controlsheet>-gate_entry_no  && 'Expense'

                            _aritems = VALUE #(
                                                ( glaccountlineitem = |001|
*                                                  glaccount = '12213000'
                                                    Customer = customercode
                                                    BusinessPlace = <ls_controlsheet>-plant
                                                  _currencyamount = VALUE #( (
                                                                    currencyrole = '00'
                                                                    journalentryitemamount = -1 * totalSalesPExp
                                                                    currency = 'INR' ) ) )
                                               )

                             _glitems = VALUE #(

                                                  FOR waglexp2 IN waglexp index INTO j
                                                    ( glaccountlineitem = |{ j + 1 WIDTH = 3 ALIGN = RIGHT PAD = '0' }|
                                                        glaccount =  waglexp2-glnumber
                                                         CostCenter = costcenter
                                                          _currencyamount = VALUE #( (
                                                                            currencyrole = '00'
                                                                            journalentryitemamount =  waglexp2-expamt
                                                                            currency = 'INR' ) ) )

                                                )
                            ).


                            MODIFY ENTITIES OF i_journalentrytp PRIVILEGED
                            ENTITY journalentry
                            EXECUTE post FROM lt_je_deep
                            FAILED DATA(ls_failed_deep)
                            REPORTED DATA(ls_reported_deep)
                            MAPPED DATA(ls_mapped_deep).
                            IF ls_failed_deep IS NOT INITIAL.

                            LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
*                             DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
                               lv_cust_result = lv_cust_result &&  <ls_reported_deep>-%msg->if_message~get_text( ).
                            ...
                            ENDLOOP.
                            UPDATE zcontrolsheet
                                SET error_log = @lv_cust_result
                                WHERE comp_code = @companycode AND plant = @plantno AND gate_entry_no = @gateentryno
                                and imfyear = @fnyr AND glposted = 0.

                            ELSE.

                                COMMIT ENTITIES BEGIN
                                RESPONSE OF i_journalentrytp
                                FAILED DATA(lt_commit_failed)
                                REPORTED DATA(lt_commit_reported).
                                ...
                                COMMIT ENTITIES END.

                                IF lt_commit_failed is INITIAL.
                                    jeno = <ls_controlsheet>-controlsheet && <ls_controlsheet>-gate_entry_no  && 'Expense'.
                                    select SINGLE from I_JournalEntry
                                    fields AccountingDocument
                                    where AccountingDocumentHeaderText = @jeno
                                    and CompanyCode = @companycode and FiscalYear = @fnyr
                                    and PostingDate = @lv_cashSheetcdate
                                    into @data(jead).


                                    UPDATE zcontrolsheet
                                        SET glposted = 1,
                                        error_log = ``,
                                        reference_doc = @jead
                                        WHERE comp_code = @companycode AND plant = @plantno AND gate_entry_no = @gateentryno
                                        and imfyear = @fnyr AND glposted = 0.
                                ENDIF.
                                CLEAR : lt_commit_failed, lt_commit_reported.
                                CLEAR : lt_je_deep.
                            ENDIF.
                        ENDIF.
                    ENDIF.
                    clear : ltplant.
                ENDIF.
             ENDIF.
        ENDLOOP.


****         Post Collection

        SELECT FROM zcashroomcrtable as ccsg
        INNER JOIN ztable_plant as pt ON pt~comp_code = ccsg~ccmpcode AND pt~plant_code = ccsg~plant
        FIELDS ccsg~plant,ccsg~cfyear, ccsg~cgpno, ccsg~camt,pt~glaccount, ccsg~ccmpcode, ccsg~cdate
        WHERE glposted = 0
*        AND cgpno = '00072'   "temp added to check a particular gate pass no"
        INTO TABLE @DATA(lv_cashSheet).

        LOOP AT lv_cashSheet INTO DATA(wa_cashSheet).

            lv_date = wa_cashSheet-cdate.  "         cl_abap_context_info=>get_system_date(  )."

            Types: BEGIN OF deductions,
                   CustCode TYPE string,
                   DeductionCash TYPE P LENGTH 12 DECIMALS 3 ,
                   GlAccount TYPE STRING,
                   END OF deductions.

            DATA CustomerDeductions TYPE TABLE OF deductions.
            DATA SalesPersonDeductions TYPE deductions.
            companycode = wa_cashsheet-ccmpcode.
            plantno = wa_cashsheet-plant.
            gateentryno = wa_cashsheet-cgpno.
            SELECT SINGLE FROM zcontrolsheet
            FIELDS controlsheet
            WHERE  plant = @wa_cashSheet-plant AND imfyear = @wa_cashSheet-cfyear AND gate_entry_no = @wa_cashSheet-cgpno and comp_code = @wa_cashSheet-ccmpcode
            INTO @DATA(ControlSheet).

            SELECT SINGLE FROM zcustcontrolsht
            FIELDS SUM( dealer_wise_cash )
            WHERE  plant = @wa_cashSheet-plant AND imfyear = @wa_cashSheet-cfyear AND gate_entry_no = @wa_cashSheet-cgpno
            INTO @CustAmount.
            if CustAmount is not INITIAL.
                DifferAmt = wa_cashSheet-camt - CustAmount.
                SELECT FROM zcustcontrolsht AS ccs
                INNER JOIN I_BusinessPartner as ibpcust ON ibpcust~BusinessPartnerIDByExtSystem = ccs~dealer
                INNER JOIN ztable_plant as pt ON pt~comp_code = ccs~comp_code AND pt~plant_code = ccs~plant
                FIELDS ibpcust~BusinessPartner as CustCode, ccs~dealer_wise_cash as DeductionCash, pt~glaccount as GlAccount
                WHERE ccs~gate_entry_no = @wa_cashSheet-cgpno AND ccs~dealer_wise_cash > 0
                INTO TABLE @CustomerDeductions.


                IF not DifferAmt = 0.

                     SELECT SINGLE FROM zcustcontrolsht AS ccs
                        INNER JOIN I_BusinessPartner as ibpsalesperson ON ibpsalesperson~BusinessPartnerIDByExtSystem = ccs~sales_person
                        INNER JOIN ztable_plant as pt ON pt~comp_code = ccs~comp_code AND pt~plant_code = ccs~plant
                        FIELDS ibpsalesperson~BusinessPartner as CustCode, ccs~dealer_wise_cash as DeductionCash, pt~glaccount as GlAccount
*                        FIELDS ibpsalesperson~BusinessPartner as CustCode
                        WHERE ccs~gate_entry_no = @wa_cashSheet-cgpno AND ccs~dealer_wise_cash > 0
                        INTO  @SalesPersonDeductions.

                        SalesPersonDeductions-deductioncash = DifferAmt.
*                        SalesPersonDeductions-glaccount = wa_cashSheet-glaccount.
                        APPEND SalesPersonDeductions TO CustomerDeductions.

                ENDIF.

                lv_count = lines( CustomerDeductions ).
                DATA: lt_cust_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
                        lv_cust_cid TYPE abp_behv_cid.
                TRY.
                    lv_cust_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
                CATCH cx_uuid_error.
                    ASSERT 1 = 0.
                ENDTRY.


                APPEND INITIAL LINE TO lt_cust_je_deep ASSIGNING FIELD-SYMBOL(<cust_je_deep>).

                <cust_je_deep>-%cid = lv_cust_cid.
                <cust_je_deep>-%param = VALUE #(
                    businesstransactiontype = 'RFBU'
                    accountingdocumenttype = 'DZ'
                    CompanyCode = wa_cashSheet-ccmpcode
                    CreatedByUser = SY-uname
                    documentdate = lv_date
                    postingdate = lv_date
                    accountingdocumentheadertext = ControlSheet && '-' && wa_cashSheet-cgpno && '-DealerCollect'
                    _aritems = VALUE #( FOR wa_deduction IN CustomerDeductions index INTO j
                                        ( glaccountlineitem = |{ j WIDTH = 3 ALIGN = RIGHT PAD = '0' }|
                                            Customer = wa_deduction-custcode
                                            BusinessPlace = wa_cashSheet-plant
                                              _currencyamount = VALUE #( (
                                                                currencyrole = '00'
                                                                journalentryitemamount = -1 * wa_deduction-deductioncash
                                                                currency = 'INR' ) ) )
                                            )

                    _glitems = VALUE #(
                                            ( glaccountlineitem = |{ lv_count + 1 WIDTH = 3 ALIGN = RIGHT PAD = '0' }|
                                            glaccount = wa_cashSheet-glaccount
                                              CostCenter = costcenter
                                            _currencyamount = VALUE #( (
                                                                currencyrole = '00'
                                                                journalentryitemamount = wa_cashSheet-camt
                                                                currency = 'INR' ) ) )
                                             )
                ).
                MODIFY ENTITIES OF i_journalentrytp PRIVILEGED
                ENTITY journalentry
                EXECUTE post FROM lt_cust_je_deep
                FAILED DATA(ls_failed_deep_cus)
                REPORTED DATA(ls_reported_deep_cus)
                MAPPED DATA(ls_mapped_deep_cus).

                IF ls_failed_deep_cus IS NOT INITIAL.

                LOOP AT ls_reported_deep_cus-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep_cus>).
                   lv_cust_result = lv_cust_result &&  <ls_reported_deep_cus>-%msg->if_message~get_text( ).
                ...
                ENDLOOP.
                UPDATE zcashroomcrtable
                            SET error_log = @lv_cust_result
                            WHERE ccmpcode = @companycode AND plant = @plantno AND cgpno = @gateentryno
*                            AND cfyear = @cf AND dealer = @dealercode
                            AND glposted = 0.

                ELSE.

                    COMMIT ENTITIES BEGIN
                    RESPONSE OF i_journalentrytp
                    FAILED DATA(lt_cust_commit_failed)
                    REPORTED DATA(lt_cust_commit_reported).
                    ...
                    COMMIT ENTITIES END.

                    IF lt_cust_commit_failed is INITIAL.
                        jeno = ControlSheet && '-' && wa_cashSheet-cgpno && '-DealerCollect'.

                        select SINGLE from I_JournalEntry
                        fields AccountingDocument
                        where AccountingDocumentHeaderText = @jeno
                        and CompanyCode = @wa_cashSheet-ccmpcode and FiscalYear = @wa_cashSheet-cfyear
                        and PostingDate = @wa_cashSheet-cdate
                        into @data(jead2).

                        UPDATE zcashroomcrtable
                            SET glposted = 1,
                            error_log = ``,
                            reference_doc = @jead2
                            WHERE ccmpcode = @companycode AND plant = @plantno AND cgpno = @gateentryno
*                            AND cfyear = @cf AND dealer = @dealercode
                            AND glposted = 0.
                    ENDIF.
                    CLEAR : lt_cust_commit_failed, lt_cust_commit_reported.
                    CLEAR : lt_cust_je_deep.
               ENDIF.
            ENDIF.

            clear : ltplant.

        ENDLOOP.

    ENDMETHOD.
ENDCLASS.
