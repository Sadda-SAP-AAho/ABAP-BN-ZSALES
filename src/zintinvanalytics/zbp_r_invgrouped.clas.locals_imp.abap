CLASS LHC_ZR_INVGROUPED000 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ZrInvgrouped000
        RESULT result.

    METHODS calculate FOR MODIFY
      IMPORTING keys FOR ACTION ZrInvgrouped000~calculate .

    METHODS getCID RETURNING VALUE(cid) TYPE abp_behv_cid.

    METHODS generateForSales IMPORTING VALUE(curDate) TYPE D.
    METHODS generateForUnSold IMPORTING VALUE(curDate) TYPE D.

    CLASS-DATA wa_irn TYPE zr_invgrouped000.
    CLASS-DATA lt_irn TYPE TABLE OF zr_invgrouped000.


    METHODS UpdatedDoc
      IMPORTING delivery TYPE string.
  ENDCLASS.

CLASS LHC_ZR_INVGROUPED000 IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

   METHOD calculate.



     READ TABLE keys INTO DATA(ls_key) INDEX 1.
     DATA(curDate) = ls_key-%param-OrderDate.

     generateForSales( curDate = curDate ).
     generateForUnSold( curDate = curDate ).

     APPEND VALUE #(  %cid = ls_key-%cid
             %msg = new_message_with_text(
               severity = if_abap_behv_message=>severity-success
               text = 'Data Generated.' )
               ) TO reported-zrinvgrouped000.
     RETURN.
   ENDMETHOD.

    METHOD UpdatedDoc.


         SELECT SINGLE FROM I_BillingDocument AS a
         JOIN I_BILlingDocumentITEM AS b ON b~BillingDocument = a~BillingDocument
         FIELDS a~BillingDocument, ( a~TotalNetAmount + a~TotalTaxAmount ) as TotAmt
         WHERE b~ReferenceSDDocument = @delivery
         INTO @DATA(ls_billing).

         IF ls_billing IS NOT INITIAL.
           UPDATE zinv_mst
           SET
               reference_doc_invoice = @ls_billing-BillingDocument ,
               invoiceamount =  @ls_billing-totamt
           WHERE reference_doc_del = @delivery.
         ENDIF.


    ENDMETHOD.

         METHOD generateForUnSold.

           SELECT FROM zdt_usdatamst1
                   FIELDS reference_doc_del, comp_code, plant, imfyear, imno, imtype
                     WHERE reference_doc_del NE ''
                     AND reference_doc_invoice EQ ''
                     INTO TABLE @DATA(lt_result1).

           LOOP AT lt_result1 INTO DATA(wa_irn1).
             DATA(del) = CONV string( wa_irn1-reference_doc_del ).
             UpdatedDoc( delivery = del ).
           ENDLOOP.

           DELETE FROM zinv_grouped WHERE orderdate EQ @curDate.


*  Database returned the SQL code 7. Error text: feature not supported: CONTAINS predicates on expression CASE WHEN APS_IAM_C_FEAT_C.PRICING <> 'X' THEN '' ELSE APS_IAM_W_USRPRT.PRICECATEGORYTEXT END
*              SUM( CASE WHEN reference_doc_del IS INITIAL THEN 1 ELSE 0 END  ) AS delCount,
*              SUM( CASE WHEN reference_doc IS INITIAL THEN 1 ELSE 0 END  ) AS orderCount,
*              SUM( CASE WHEN reference_doc_invoice IS INITIAL THEN 1 ELSE 0 END  ) AS invCount,

           SELECT SINGLE FROM zdt_usdatamst1
                   FIELDS
                    SUM( imnetamtro ) AS actualamount,
                    SUM( invoiceamount ) AS billedamount,
                    SUM( orderamount ) AS orderamount,
                    CAST( SUM( datavalidated ) AS INT4 ) AS Datavalidated,
                    COUNT( imno ) AS nooforder
                     WHERE imdate = @curDate
                     INTO @DATA(ls_actual).

*     IF ls_actual IS INITIAL.
*       APPEND VALUE #( %cid = ls_key-%cid
*               %msg = new_message_with_text(
*                 severity = if_abap_behv_message=>severity-error
*                 text = 'No Order found for the selected date.' )
*               ) TO reported-zrinvgrouped000.
*       RETURN.
*     ENDIF.

           SELECT SINGLE FROM zdt_usdatamst1
           FIELDS COUNT( reference_doc_del ) AS delCount
           WHERE imdate = @curDate AND reference_doc_del NE ''
           INTO @DATA(ls_delcount).

           SELECT SINGLE FROM zdt_usdatamst1
           FIELDS COUNT( reference_doc ) AS orderCount
           WHERE imdate = @curDate AND reference_doc NE ''
           INTO @DATA(ls_ordercount).

           SELECT SINGLE FROM zdt_usdatamst1
           FIELDS COUNT( reference_doc_invoice ) AS invCount
           WHERE imdate = @curDate AND reference_doc_invoice NE ''
           INTO @DATA(ls_invcount).


           wa_irn-BilledAmount = ls_actual-billedamount.
           wa_irn-OrderBilled = ls_invcount.
           wa_irn-OrderAmount = ls_actual-actualamount.
           wa_irn-NoOfOrder = ls_actual-nooforder.
           wa_irn-datavalidated = ls_actual-datavalidated.
           wa_irn-OutboundCreated = ls_delcount.
           wa_irn-SOAmount = ls_actual-orderamount.
           wa_irn-SOCreated = ls_ordercount.
           wa_irn-OrderDate = curDate.



           MODIFY ENTITIES OF zr_invgrouped000 IN LOCAL MODE
             ENTITY ZrInvgrouped000
             CREATE FIELDS ( BilledAmount OrderBilled OrderAmount NoOfOrder OutboundCreated SOCreated SOAmount
                              OrderDate POCreated MiGoCreated Type Datavalidated Potobecreated )
             WITH VALUE #( (
                    %cid = getCID( )
                    Billedamount    = wa_irn-BilledAmount
                    OrderBilled     = wa_irn-OrderBilled
                    OrderAmount     = wa_irn-OrderAmount
                    NoOfOrder       = wa_irn-NoOfOrder
                    OutboundCreated = wa_irn-OutboundCreated
                    SOCreated       = wa_irn-SOCreated
                    SOAmount        = wa_irn-SOAmount
                    OrderDate       = wa_irn-OrderDate
                    POCreated       = wa_irn-POCreated
                    MiGoCreated     = wa_irn-MiGoCreated
                    Datavalidated   = wa_irn-Datavalidated
                    Potobecreated   = wa_irn-Potobecreated
                    Type            = 'Unsold'
                ) )
             MAPPED DATA(mapped)
             FAILED   DATA(failed)
             REPORTED DATA(reported).


         ENDMETHOD.




    METHOD generateForSales.

         SELECT FROM zinv_mst
                 FIELDS reference_doc_del, comp_code, plant, imfyear, imno, imtype
                   WHERE reference_doc_del NE ''
                   AND reference_doc_invoice EQ ''
                   INTO TABLE @DATA(lt_result1).

     LOOP AT lt_result1 INTO DATA(wa_irn1).
       DATA(del) = CONV string( wa_irn1-reference_doc_del ).
       UpdatedDoc( delivery = del ).
     ENDLOOP.

     DELETE FROM zinv_grouped WHERE orderdate EQ @curDate.


*  Database returned the SQL code 7. Error text: feature not supported: CONTAINS predicates on expression CASE WHEN APS_IAM_C_FEAT_C.PRICING <> 'X' THEN '' ELSE APS_IAM_W_USRPRT.PRICECATEGORYTEXT END
*              SUM( CASE WHEN reference_doc_del IS INITIAL THEN 1 ELSE 0 END  ) AS delCount,
*              SUM( CASE WHEN reference_doc IS INITIAL THEN 1 ELSE 0 END  ) AS orderCount,
*              SUM( CASE WHEN reference_doc_invoice IS INITIAL THEN 1 ELSE 0 END  ) AS invCount,

     SELECT SINGLE FROM zinv_mst
             FIELDS
              SUM( imnetamtro ) AS actualamount,
              sum( invoiceamount ) AS billedamount,
              sum( orderamount ) AS orderamount,
              CAST( SUM( po_processed  ) as int4 ) AS poCount,
              CAST( SUM( migo_processed ) as int4 ) AS migoCount,
              CAST( sum( po_tobe_created ) as int4 ) AS po_tobe_created,
              CAST( sum( datavalidated ) as int4 ) AS Datavalidated,
              count( imno ) as nooforder
               WHERE imdate = @curDate
               INTO @DATA(ls_actual).

*     IF ls_actual IS INITIAL.
*       APPEND VALUE #( %cid = ls_key-%cid
*               %msg = new_message_with_text(
*                 severity = if_abap_behv_message=>severity-error
*                 text = 'No Order found for the selected date.' )
*               ) TO reported-zrinvgrouped000.
*       RETURN.
*     ENDIF.

     SELECT SINGLE FROM ZINV_MST
     FIELDS COUNT( reference_doc_del ) as delCount
     WHERE imdate = @curDate AND reference_doc_del NE ''
     INTO @DATA(ls_delcount).

     SELECT SINGLE FROM ZINV_MST
     FIELDS COUNT( reference_doc ) as orderCount
     WHERE imdate = @curDate AND reference_doc NE ''
     INTO @DATA(ls_ordercount).

     SELECT SINGLE FROM ZINV_MST
     FIELDS COUNT( reference_doc_invoice ) as invCount
     WHERE imdate = @curDate AND reference_doc_invoice NE ''
     INTO @DATA(ls_invcount).


     wa_irn-BilledAmount = ls_actual-billedamount.
     wa_irn-OrderBilled = ls_invcount.
     wa_irn-OrderAmount = ls_actual-actualamount.
     wa_irn-NoOfOrder = ls_actual-nooforder.
     wa_irn-datavalidated = ls_actual-datavalidated.
     wa_irn-OutboundCreated = ls_delcount.
     wa_irn-SOAmount = ls_actual-orderamount.
     wa_irn-SOCreated = ls_ordercount.
     wa_irn-POCreated = ls_actual-poCount.
     wa_irn-MiGoCreated = ls_actual-migoCount.
     wa_irn-potobecreated = ls_actual-po_tobe_created.
     wa_irn-OrderDate = curDate.



     MODIFY ENTITIES OF zr_invgrouped000 IN LOCAL MODE
       ENTITY ZrInvgrouped000
       CREATE FIELDS ( BilledAmount OrderBilled OrderAmount NoOfOrder OutboundCreated SOCreated SOAmount
                        OrderDate POCreated MiGoCreated Type Datavalidated Potobecreated )
       WITH VALUE #( (
              %cid = getCID( )
              Billedamount    = wa_irn-BilledAmount
              OrderBilled     = wa_irn-OrderBilled
              OrderAmount     = wa_irn-OrderAmount
              NoOfOrder       = wa_irn-NoOfOrder
              OutboundCreated = wa_irn-OutboundCreated
              SOCreated       = wa_irn-SOCreated
              SOAmount        = wa_irn-SOAmount
              OrderDate       = wa_irn-OrderDate
              POCreated       = wa_irn-POCreated
              MiGoCreated     = wa_irn-MiGoCreated
              Datavalidated   = wa_irn-Datavalidated
              Potobecreated   = wa_irn-Potobecreated
              Type            = 'Sales'
          ) )
       MAPPED DATA(mapped)
       FAILED   DATA(failed)
       REPORTED DATA(reported).


    ENDMETHOD.

  METHOD getCID.
            TRY.
                cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
            CATCH cx_uuid_error.
                ASSERT 1 = 0.
            ENDTRY.
  ENDMETHOD.

ENDCLASS.
