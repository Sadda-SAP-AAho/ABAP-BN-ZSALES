CLASS LHC_ZR_INVMST DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrInvMst000
        RESULT result.

       METHODS clearProcessing FOR MODIFY
      IMPORTING keys FOR ACTION ZrInvMst000~clearProcessing.

ENDCLASS.

CLASS LHC_ZR_INVMST IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

  METHOD clearProcessing.

    READ ENTITIES OF zr_invgrouped000 IN LOCAL MODE
    ENTITY ZrInvMst000
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_entities).

    LOOP AT lt_entities INTO DATA(ls_entity).

      SELECT SINGLE FROM I_SalesOrder
      FIELDS  SalesOrder
      WHERE SalesOrder = @ls_entity-ReferenceDoc
      INTO @DATA(ls_salesorder).

      IF ls_salesorder IS NOT INITIAL.
        APPEND VALUE #( %tky = ls_entity-%tky ) TO failed-zrinvmst000.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                   %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text = 'Sales Order exists.'
                   ) ) TO reported-zrinvmst000.

        RETURN.
      ENDIF.

    ENDLOOP.

      MODIFY ENTITIES OF zr_invgrouped000 IN LOCAL MODE
            ENTITY ZrInvMst000
            UPDATE FIELDS ( Processed ReferenceDoc Orderamount Status )
            WITH VALUE #( FOR key in keys INDEX INTO i (
                %tky       = key-%tky
                Processed  = ''
                ReferenceDoc = ''
                Orderamount = ''
                Status = ''
              ) )
            FAILED DATA(lt_failed)
            REPORTED DATA(lt_reported).


  ENDMETHOD.


ENDCLASS.
