CLASS zcl_glaccountposting DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES if_apj_dt_exec_object .
  INTERFACES if_apj_rt_exec_object .


  INTERFACES if_oo_adt_classrun.

  CLASS-METHODS runJob
    IMPORTING paramgateentryno TYPE C.

  CLASS-METHODS getCID RETURNING VALUE(cid) TYPE abp_behv_cid.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_glaccountposting IMPLEMENTATION.

    METHOD if_apj_dt_exec_object~get_parameters.
        " Return the supported selection parameters here
        et_parameter_def = VALUE #(
          ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     datatype = 'C' length = 80 param_text = 'Gate Entry No'   lowercase_ind = abap_true changeable_ind = abap_true )
        ).

        " Return the default parameters values here
        et_parameter_val = VALUE #(
          ( selname = 'P_DESCR' kind = if_apj_dt_exec_object=>parameter     sign = 'I' option = 'EQ' low = 'Gate Entry No' )
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
        runJob( p_descr ).
    ENDMETHOD.


    METHOD if_oo_adt_classrun~main .
        runJob( '01327' ).
    ENDMETHOD.

    METHOD getCID.
        TRY.
            cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
        CATCH cx_uuid_error.
            ASSERT 1 = 0.
        ENDTRY.
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
        DATA localgateentryno TYPE C LENGTH 20.

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


        DATA : ltcontrolsheet TYPE TABLE OF zcontrolsheet.
        localgateentryno = paramgateentryno.
        IF localgateentryno = '' .
            SELECT * FROM zcontrolsheet AS cs
                WHERE cs~glposted = 0
            INTO TABLE @ltcontrolsheet.
        ELSE.
            SELECT * FROM zcontrolsheet AS cs
                WHERE cs~glposted = 0 AND cs~gate_entry_no = @localgateentryno
            INTO TABLE @ltcontrolsheet.
        ENDIF.

*        lv_date = cl_abap_context_info=>get_system_date(  ).




        LOOP AT ltcontrolsheet ASSIGNING FIELD-SYMBOL(<ls_controlsheet>).
            SELECT FROM zcontrolsheet AS cs
                INNER JOIN I_BusinessPartner as ibpsalesperson ON ibpsalesperson~BusinessPartnerIDByExtSystem = cs~sales_person
                FIELDS ibpsalesperson~BusinessPartner as EmployeCode
                WHERE cs~gate_entry_no = @<ls_controlsheet>-gate_entry_no
            INTO TABLE @DATA(ltsalesPerson).
            IF ltsalesperson IS NOT INITIAL.
                lv_date = <ls_controlsheet>-gpdate.

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


*        ***         SJ 01-04-25 Start Append GLs and amount in internal table ************


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


                    SELECT a~glnumber , sum( a~expAmt ) as expAmt from @gt_glexpdtls as a
                        where a~expamt > 0
                        group by  a~glnumber
                        into table @data(waglexp).
*        ***         SJ 01-04-25 end Append GLs and amount in internal table ************

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
                            accountingdocumentheadertext = <ls_controlsheet>-comp_code && <ls_controlsheet>-plant
                                                        && <ls_controlsheet>-imfyear && <ls_controlsheet>-gate_entry_no

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
                               lv_cust_result = lv_cust_result &&  <ls_reported_deep>-%msg->if_message~get_text( ).
                            ...
                            ENDLOOP.
                            UPDATE zcontrolsheet
                                SET error_log = @lv_cust_result
                                WHERE comp_code = @companycode AND plant = @plantno AND gate_entry_no = @gateentryno
                                and imfyear = @fnyr AND glposted = 0.
                            Clear lv_cust_result .
                            ELSE.

                                COMMIT ENTITIES BEGIN
                                RESPONSE OF i_journalentrytp
                                FAILED DATA(lt_commit_failed)
                                REPORTED DATA(lt_commit_reported).
                                ...
                                COMMIT ENTITIES END.

                                IF lt_commit_failed is INITIAL.
                                    DATA : acctdoc TYPE c LENGTH 25.
                                    jeno = <ls_controlsheet>-comp_code && <ls_controlsheet>-plant
                                        && <ls_controlsheet>-imfyear && <ls_controlsheet>-gate_entry_no.
                                    select from I_JournalEntry as ije
                                    fields ije~AccountingDocument
                                    where ije~AccountingDocumentHeaderText = @jeno
                                    INTO TABLE @data(ltJE).
                                    IF ltJE is not INITIAL.
                                        LOOP AT ltJE INTO DATA(wa_ltje).
                                            acctdoc = wa_ltje-AccountingDocument.
                                        ENDLOOP.
                                    ENDIF.

                                    UPDATE zcontrolsheet
                                        SET glposted = 1,
                                        error_log = ``,
                                        reference_doc = @acctdoc
                                        WHERE comp_code = @companycode AND plant = @plantno AND gate_entry_no = @gateentryno
                                        and imfyear = @fnyr AND glposted = 0.
                                ENDIF.
                                CLEAR : lt_commit_failed, lt_commit_reported.
                                CLEAR : lt_je_deep.
                            ENDIF.
                        ENDIF.
                    ENDIF.
                    clear : ltplant.
                ELSE.
                    DATA : strcuserror TYPE c LENGTH 25.
                    strcuserror =  <ls_controlsheet>-sales_person && ' sales person doesnot exist'.
                    UPDATE zcontrolsheet
                    SET error_log = @strcuserror
                    WHERE comp_code = @<ls_controlsheet>-comp_code AND plant = @<ls_controlsheet>-plant AND gate_entry_no = @<ls_controlsheet>-gate_entry_no
                    and imfyear = @<ls_controlsheet>-imfyear AND glposted = 0.

                ENDIF.

            ENDIF.
        ENDLOOP.


****         Post Collection
        TYPES: BEGIN OF lt_CRCTable,
            ccmpcode       TYPE C LENGTH 10,
            plant          TYPE C LENGTH 4,
            cfyear         TYPE C LENGTH 4,
            cgpno          TYPE C LENGTH 7,
            cno            TYPE C LENGTH 6,
            camt           TYPE P LENGTH 12 DECIMALS 2,
            cdate          TYPE d,
        END OF lt_CRCTable.

        DATA : lt_cashSheet TYPE TABLE OF lt_CRCTable.
        IF localgateentryno = ''.
            SELECT ccsg~ccmpcode, ccsg~plant,ccsg~cfyear, ccsg~cgpno, ccsg~cno, ccsg~camt, ccsg~cdate
                FROM zcashroomcrtable as ccsg
                WHERE glposted = 0
                ORDER BY ccsg~ccmpcode, ccsg~plant,ccsg~cfyear, ccsg~cgpno, ccsg~cno
                INTO TABLE @lt_cashSheet.
        ELSE.
            SELECT ccsg~ccmpcode, ccsg~plant,ccsg~cfyear, ccsg~cgpno, ccsg~cno, ccsg~camt, ccsg~cdate
            FROM zcashroomcrtable as ccsg
            WHERE glposted = 0
            AND cgpno = @localgateentryno   "temp added to check a particular gate pass no"
            ORDER BY ccsg~ccmpcode, ccsg~plant,ccsg~cfyear, ccsg~cgpno, ccsg~cno
            INTO TABLE @lt_cashSheet.

        ENDIF.
        LOOP AT lt_cashSheet INTO DATA(wa_cashSheet).
            SELECT FROM zcustcontrolsht AS ccs
                INNER JOIN I_BusinessPartner as ibpsalesperson ON ibpsalesperson~BusinessPartnerIDByExtSystem = ccs~sales_person
                FIELDS ibpsalesperson~BusinessPartner as EmployeCode
                WHERE ccs~gate_entry_no = @wa_cashSheet-cgpno
                AND ccs~dealer_wise_cash > 0
            INTO TABLE @DATA(lt_salesPerson).
            IF lt_salesperson IS NOT INITIAL.
                select SINGLE From ztable_plant as zpt
                    FIELDS zpt~glaccount
                    where zpt~comp_code = @wa_cashsheet-ccmpcode
                    AND zpt~plant_code = @wa_cashsheet-plant
                INTO @DATA(ltcashaccount).


                lv_date = wa_cashSheet-cdate.  "         cl_abap_context_info=>get_system_date(  )."

                Types: BEGIN OF deductions,
                       CustCode TYPE string,
                       DeductionCash TYPE P LENGTH 12 DECIMALS 3 ,
                       GlAccount TYPE STRING,
                       END OF deductions.

                SELECT SINGLE dealer  FROM zcustcontrolsht AS zccs
                WHERE zccs~gate_entry_no = @wa_cashSheet-cgpno AND zccs~dealer_wise_cash > 0
                AND NOT EXISTS ( SELECT BusinessPartner FROM I_BusinessPartner as ibp
                                WHERE zccs~dealer = ibp~BusinessPartnerIDByExtSystem )
                INTO @DATA(wa_custdata).
                IF wa_custdata IS INITIAL.

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
                                WHERE ccs~gate_entry_no = @wa_cashSheet-cgpno AND ccs~dealer_wise_cash > 0
                                INTO  @SalesPersonDeductions.

                                SalesPersonDeductions-deductioncash = DifferAmt.
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
                            accountingdocumentheadertext = wa_cashSheet-ccmpcode && wa_cashSheet-plant && wa_cashSheet-cfyear
                                                           && wa_cashSheet-cgpno && wa_cashSheet-cno
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
                                                    glaccount = ltcashaccount
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
*                                    AND cfyear =  AND dealer = @dealercode
                                    AND glposted = 0.

                        ELSE.

                            COMMIT ENTITIES BEGIN
                            RESPONSE OF i_journalentrytp
                            FAILED DATA(lt_cust_commit_failed)
                            REPORTED DATA(lt_cust_commit_reported).
                            ...
                            COMMIT ENTITIES END.

                            IF lt_cust_commit_failed is INITIAL.
                                DATA : acctdoc1 TYPE c LENGTH 30.
                                jeno = wa_cashSheet-ccmpcode && wa_cashSheet-plant && wa_cashSheet-cfyear
                                    && wa_cashSheet-cgpno && wa_cashSheet-cno.

                                select from I_JournalEntry as ij
                                    fields AccountingDocument, AccountingDocumentType
                                    where ij~AccountingDocumentHeaderText = @jeno
                                INTO TABLE @data(ltJE1).
                                IF ltje1 is not INITIAL.
                                    LOOP AT ltje1 INTO DATA(wa_ltje1).
                                        acctdoc1 = wa_ltje1-AccountingDocument.
                                    ENDLOOP.
                                ENDIF.

                                UPDATE zcashroomcrtable
                                    SET glposted = 1,
                                    error_log = ``,
                                    reference_doc = @acctdoc1
                                    WHERE ccmpcode = @companycode AND plant = @plantno AND cgpno = @gateentryno
                                    AND glposted = 0.
                            ENDIF.
                            CLEAR : lt_cust_commit_failed, lt_cust_commit_reported.
                            CLEAR : lt_cust_je_deep.
                       ENDIF.
                    ENDIF.

                    clear : ltplant.
                ELSE.
                    Data strcustError TYPE C LENGTH 40.
                    strcustError = wa_custdata && ' customer not mapped'.
                    UPDATE zcashroomcrtable
                    SET error_log = @strcustError
                    WHERE ccmpcode = @wa_cashSheet-ccmpcode AND plant = @wa_cashSheet-plant AND cgpno = @wa_cashSheet-cgpno
                    AND glposted = 0.
                ENDIF.
            ELSE.
                Data strError TYPE C LENGTH 40.
                strError = 'Gate No ' &&  wa_cashSheet-cgpno && ' Sales Person not mapped'.
                UPDATE zcashroomcrtable
                SET error_log = @strerror
                WHERE ccmpcode = @wa_cashSheet-ccmpcode AND plant = @wa_cashSheet-plant AND cgpno = @wa_cashSheet-cgpno
                AND glposted = 0.

            ENDIF.
        ENDLOOP.
    ENDMETHOD.

ENDCLASS.
