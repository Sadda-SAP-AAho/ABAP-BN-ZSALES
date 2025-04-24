CLASS zcl_soamount_update DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_soamount_update IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    DATA: orderAmt  TYPE p LENGTH 15 DECIMALS 2,
          invAmount TYPE p DECIMALS 2.

    SELECT FROM zinv_mst
    FIELDS comp_code, imfyear, imno, imtype, plant, reference_doc_invoice, reference_doc
    WHERE reference_doc NE ''
    INTO TABLE @DATA(lt_so).

    LOOP AT lt_so INTO DATA(ls_so).
      orderAmt = 0.
      invAmount = 0.

      SELECT SINGLE FROM i_salesorderITEM AS a
              FIELDS SUM( a~NetAmount + a~TaxAmount ) AS Amt
              WHERE a~SalesOrder = @ls_so-reference_doc
              INTO @orderAmt.

      IF ls_so-reference_doc_invoice NE ''.

        SELECT SINGLE FROM I_BillingDocument
        FIELDS ( TotalNetAmount + TotalTaxAmount ) AS totamt
        WHERE BillingDocument = @ls_so-reference_doc_invoice
        INTO @invAmount.
      ENDIF.

      IF orderAmt IS NOT INITIAL.

        UPDATE zinv_mst SET orderamount = @orderAmt, invoiceamount = @invAmount
        WHERE comp_code = @ls_so-comp_code
          AND imfyear = @ls_so-imfyear
          AND imno = @ls_so-imno
          AND imtype = @ls_so-imtype
          AND plant = @ls_so-plant
          AND reference_doc_invoice = @ls_so-reference_doc_invoice.
      ENDIF.

    ENDLOOP.


  ENDMETHOD.
ENDCLASS.
