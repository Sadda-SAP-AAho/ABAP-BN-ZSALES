CLASS LHC_ZR_INVGROUPED000 DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrInvgrouped000
        RESULT result.

       METHODS calculate FOR MODIFY
      IMPORTING keys FOR ACTION ZrInvgrouped000~calculate .

           METHODS getCID RETURNING VALUE(cid) TYPE abp_behv_cid.


     METHODS UpdatedDoc
    IMPORTING delivery TYPE string.
ENDCLASS.

CLASS LHC_ZR_INVGROUPED000 IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

   METHOD calculate.
     DATA : lt_irn TYPE TABLE OF zinv_grouped.
     DATA : wa_irn TYPE zinv_grouped.


     READ TABLE keys INTO DATA(ls_key) INDEX 1.
     DATA(curDate) = ls_key-%param-OrderDate.


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

     SELECT SINGLE FROM zinv_mst
             FIELDS COUNT( * ) AS count, SUM( imnetamtro ) AS total
               WHERE imdate = @curDate
               INTO @DATA(ls_actual).

     IF ls_actual IS INITIAL.
       APPEND VALUE #( %cid = ls_key-%cid
               %msg = new_message_with_text(
                 severity = if_abap_behv_message=>severity-error
                 text = 'No Order found for the selected date.' )
               ) TO reported-zrinvgrouped000.
       RETURN.
     ENDIF.

     SELECT SINGLE FROM zinv_mst
           FIELDS COUNT( * ) AS count
           WHERE reference_doc_del NE '' AND imdate = @curDate
           INTO @DATA(ls_del_count).

     SELECT SINGLE FROM zinv_mst
             FIELDS COUNT( * ) AS count, SUM( invoiceamount ) AS total
               WHERE reference_doc_invoice NE '' AND imdate = @curDate
               INTO @DATA(ls_inv_count).

     SELECT SINGLE FROM zinv_mst
             FIELDS COUNT( * ) AS count, SUM( orderamount ) AS total
               WHERE reference_doc NE '' AND imdate = @curDate
               INTO @DATA(ls_order_count).


     SELECT SINGLE FROM zinv_mst
             FIELDS COUNT( * ) AS count
               WHERE po_processed NE '' AND imdate = @curDate
               INTO @DATA(ls_po_count).

     SELECT SINGLE FROM zinv_mst
             FIELDS COUNT( * ) AS count
               WHERE migo_processed NE '' AND imdate = @curDate
               INTO @DATA(ls_migo_count).


     wa_irn-BilledAmount = ls_inv_count-total.
     wa_irn-OrderBilled = ls_inv_count-count.
     wa_irn-OrderAmount = ls_actual-total.
     wa_irn-NoOfOrder = ls_actual-count.
     wa_irn-OutboundCreated = ls_del_count.
     wa_irn-SOAmount = ls_order_count-total.
     wa_irn-SOCreated = ls_order_count-count.
     wa_irn-POCreated = ls_po_count.
     wa_irn-MiGoCreated = ls_migo_count.
     wa_irn-OrderDate = curDate.

     MODIFY ENTITIES OF zr_invgrouped000 IN LOCAL MODE
       ENTITY ZrInvgrouped000
       CREATE FIELDS ( BilledAmount OrderBilled OrderAmount NoOfOrder OutboundCreated SOCreated SOAmount OrderDate POCreated MiGoCreated Type )
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
              Type            = 'Sales'
          ) )
       MAPPED mapped
       FAILED   failed
       REPORTED reported.



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
         FIELDS a~BillingDocument, a~TotalNetAmount
         WHERE b~ReferenceSDDocument = @delivery
         INTO @DATA(ls_billing).

         IF ls_billing IS NOT INITIAL.
           UPDATE zinv_mst
           SET reference_doc_invoice = @ls_billing-BillingDocument, invoiceamount = @ls_billing-TotalNetAmount
           WHERE reference_doc_del = @delivery.
         ENDIF.


     ENDMETHOD.

  METHOD getCID.
            TRY.
                cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
            CATCH cx_uuid_error.
                ASSERT 1 = 0.
            ENDTRY.
  ENDMETHOD.

ENDCLASS.
