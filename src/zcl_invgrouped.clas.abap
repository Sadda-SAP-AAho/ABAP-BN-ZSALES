CLASS zcl_invgrouped DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    METHODS UpdatedDoc
    IMPORTING VALUE(delivery) TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_invgrouped IMPLEMENTATION.
     METHOD if_rap_query_provider~select.

       DATA(lv_top)   =   io_request->get_paging( )->get_page_size( ).
       DATA(lv_skip)  =   io_request->get_paging( )->get_offset( ).
       DATA(lv_max_rows) = COND #( WHEN lv_top = if_rap_query_paging=>page_size_unlimited THEN 0 ELSE lv_top ).

*      DATA(lt_clause)  = io_request->get_filter( )->get_as_ranges( ).
       DATA(lt_parameters)  = io_request->get_parameters( ).
       DATA(lt_fileds)  = io_request->get_requested_elements( ).
       DATA(lt_sort)  = io_request->get_sort_elements( ).

       TRY.
           DATA(lt_Filter_cond) = io_request->get_filter( )->get_as_ranges( ).
         CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
           CLEAR lt_Filter_cond.  " Ignore error and continue
       ENDTRY.

       LOOP AT lt_filter_cond INTO DATA(ls_filter_cond).
         IF ls_filter_cond-name = to_upper( 'OrderDate' ).
           DATA(lt_Odate) = ls_filter_cond-range[].
         ENDIF.
          IF ls_filter_cond-name = to_upper( 'Imdate' ).
           DATA(lt_idate) = ls_filter_cond-range[].
         ENDIF.
       ENDLOOP.

    DATA(entt) = io_request->get_entity_id( ).

    CASE io_request->get_entity_id( ).

        WHEN 'ZINVGROUPED'.


           DATA: lt_result      TYPE STANDARD TABLE OF zinvgrouped,
                 ls_line        TYPE zinvgrouped,
                 lt_responseout LIKE lt_result,
                 ls_responseout LIKE LINE OF lt_responseout.

           SELECT FROM zinv_mst
               FIELDS reference_doc_del, comp_code, plant, imfyear, imno, imtype
                 WHERE reference_doc_del NE ''
                 AND reference_doc_invoice EQ ''
                 INTO TABLE @DATA(lt_result1).

           LOOP AT lt_result1 INTO DATA(ls_line1).
             DATA(DEL) = CONV STRING( ls_line1-reference_doc_del ).
             UpdatedDoc( delivery = DEL ).
           ENDLOOP.

           SELECT FROM zinv_mst
                 FIELDS imdate
                 WHERE imdate IN @lt_Odate
                 GROUP BY imdate
                 INTO TABLE @DATA(lt_query).

           LOOP AT lt_query INTO DATA(ls_query).
             SELECT SINGLE FROM zinv_mst
                   FIELDS COUNT( * ) AS count
                   WHERE reference_doc_del NE '' AND imdate = @ls_query-imdate
                   INTO @DATA(ls_del_count).

             SELECT SINGLE FROM zinv_mst
                     FIELDS COUNT( * ) AS count, SUM( invoiceamount ) AS total
                       WHERE reference_doc_invoice NE '' AND imdate = @ls_query-imdate
                       INTO @DATA(ls_inv_count).

             SELECT SINGLE FROM zinv_mst
                     FIELDS COUNT( * ) AS count, SUM( orderamount ) AS total
                       WHERE reference_doc NE '' AND imdate = @ls_query-imdate
                       INTO @DATA(ls_order_count).

             SELECT SINGLE FROM zinv_mst
                     FIELDS COUNT( * ) AS count, SUM( imnetamtro ) AS total
                       WHERE imdate = @ls_query-imdate
                       INTO @DATA(ls_actual).

             SELECT SINGLE FROM zinv_mst
                     FIELDS COUNT( * ) AS count
                       WHERE po_processed NE '' AND imdate = @ls_query-imdate
                       INTO @DATA(ls_po_count).

             SELECT SINGLE FROM zinv_mst
                     FIELDS COUNT( * ) AS count
                       WHERE migo_processed NE '' AND imdate = @ls_query-imdate
                       INTO @DATA(ls_migo_count).

             ls_line-BilledAmount = ls_inv_count-total.
             ls_line-OrderBilled = ls_inv_count-count.
             ls_line-OrderAmount = ls_actual-total.
             ls_line-NoOfOrder = ls_actual-count.
             ls_line-OutboundCreated = ls_del_count.
             ls_line-SOCreated = ls_order_count-count.
             ls_line-SOAmount = ls_order_count-total.
             ls_line-OrderDate = ls_query-imdate.
             ls_line-POCreated = ls_po_count.
             ls_line-MiGoCreated = ls_migo_count.


             APPEND ls_line TO lt_result.
           ENDLOOP.



          lv_max_rows = lv_skip + lv_top.
          IF lv_skip > 0.
            lv_skip = lv_skip + 1.
          ENDIF.

          CLEAR lt_responseout.
          LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<lfs_out_line_item>) FROM lv_skip TO lv_max_rows.
            ls_responseout = <lfs_out_line_item>.
            APPEND ls_responseout TO lt_responseout.
          ENDLOOP.

          io_response->set_total_number_of_records( lines( lt_responseout ) ).
          io_response->set_data( lt_responseout ).

       WHEN 'ZINVMSTGROUPED'.

              DATA: lt_result2      TYPE STANDARD TABLE OF zinvmstgrouped,
                 ls_line2        TYPE zinvmstgrouped,
                 lt_responseout2 LIKE lt_result2,
                 ls_responseout2 LIKE LINE OF lt_responseout2.


          select from ZR_INV_MST
          FIELDS  CompCode, Plant, Imfyear, Imno, Imtype,  Imnoseries, Imcat,Imdate, Impartycode, Imremarks, Imtotqty,
                  Imcgstamt, Imsgstamt, Imigstamt, Imnetamtro, Imnetamt, Imdealercode, Processed, ReferenceDoc, Orderamount,
                  ReferenceDocDel, ReferenceDocInvoice, Invoiceamount, PoTobeCreated, PoProcessed, PoNo, MigoProcessed, MigoNo
          where Imdate in @lt_idate
          order by Imno
          into TABLE @DATA(new).

          LOOP AT new INTO DATA(wa_line).

            ls_line2-CompCode = wa_line-CompCode.
            ls_line2-Plant = wa_line-Plant.
            ls_line2-Imfyear = wa_line-Imfyear.
            ls_line2-Imno = wa_line-Imno.
            ls_line2-Imtype = wa_line-Imtype.
            ls_line2-Imnoseries = wa_line-Imnoseries.
            ls_line2-Imcat = wa_line-Imcat.
            ls_line2-Imdate = wa_line-Imdate.
            ls_line2-Impartycode = wa_line-Impartycode.
            ls_line2-Imremarks = wa_line-Imremarks.
            ls_line2-Imtotqty = wa_line-Imtotqty.
            ls_line2-Imcgstamt = wa_line-Imcgstamt.
            ls_line2-Imsgstamt = wa_line-Imsgstamt.
            ls_line2-Imigstamt = wa_line-Imigstamt.
            ls_line2-Imnetamtro = wa_line-Imnetamtro.
            ls_line2-Imnetamt = wa_line-Imnetamt.
            ls_line2-Imdealercode = wa_line-Imdealercode.
            ls_line2-Processed = wa_line-Processed.
            ls_line2-ReferenceDoc = wa_line-ReferenceDoc.
            ls_line2-Orderamount = wa_line-Orderamount.
            ls_line2-ReferenceDocDel = wa_line-ReferenceDocDel.
            ls_line2-ReferenceDocInvoice = wa_line-ReferenceDocInvoice.
            ls_line2-Invoiceamount = wa_line-Invoiceamount.
            ls_line2-PoTobeCreated = wa_line-PoTobeCreated.
            ls_line2-PoProcessed = wa_line-PoProcessed.
            ls_line2-PoNo = wa_line-PoNo.
            ls_line2-MigoProcessed = wa_line-MigoProcessed.
            ls_line2-MigoNo = wa_line-MigoNo.


            APPEND ls_line2 TO lt_result2.
          ENDLOOP.



         lv_max_rows = lv_skip + lv_top.
          IF lv_skip > 0.
            lv_skip = lv_skip + 1.
          ENDIF.

          CLEAR lt_responseout2.
          LOOP AT lt_result2 ASSIGNING FIELD-SYMBOL(<lfs_out_line_item1>) FROM lv_skip TO lv_max_rows.
            ls_responseout2 = <lfs_out_line_item1>.
            APPEND ls_responseout2 TO lt_responseout2.
          ENDLOOP.

          io_response->set_total_number_of_records( lines( lt_responseout2 ) ).
          io_response->set_data( lt_responseout2 ).



       ENDCASE.


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
ENDCLASS.
