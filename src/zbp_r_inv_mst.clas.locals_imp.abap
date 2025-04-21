CLASS LHC_ZR_INV_MST DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrInvMst
        RESULT result.

    METHODS:
      clearProcessing FOR MODIFY
      IMPORTING keys FOR ACTION ZrInvMst~clearProcessing.
ENDCLASS.

CLASS LHC_ZR_INV_MST IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

  METHOD clearProcessing.

    READ ENTITIES OF zr_inv_mst
    ENTITY ZrInvMst
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_entities).

    LOOP AT lt_entities INTO DATA(ls_entity).

      SELECT SINGLE FROM I_SalesOrder
      FIELDS  SalesOrder
      WHERE SalesOrder = @ls_entity-ReferenceDoc
      INTO @DATA(ls_salesorder).

      IF ls_salesorder IS NOT INITIAL.
        APPEND VALUE #( %tky = ls_entity-%tky ) TO failed-zrinvmst.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                   %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text = 'Sales Order is already in use'
                   ) ) TO reported-zrinvmst.

        RETURN.
      ENDIF.

      MODIFY ENTITIES OF zr_inv_mst IN LOCAL MODE
      ENTITY ZrInvMst
      UPDATE FIELDS ( Processed
                      ReferenceDoc
                      ReferenceDocDel
                      ReferenceDocInvoice
                      OrderAmount
                      InvoiceAmount
                      Status
                      PoProcessed
                      PoTobeCreated )
      WITH VALUE #( ( %tky = ls_entity-%tky
                      Processed = 'X'
                      ReferenceDoc = ''
                      ReferenceDocDel = ''
                      ReferenceDocInvoice = ''
                      OrderAmount = ''
                      InvoiceAmount = ''
                      Status = ''
                      PoProcessed = ''
                      PoTobeCreated = '' ) )
      FAILED DATA(lt_failed)
      REPORTED DATA(lt_reported).

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
