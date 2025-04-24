CLASS LHC_ZR_USDATAMST DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrUsdatamst
        RESULT result.

       METHODS clearProcessingUnsold FOR MODIFY
      IMPORTING keys FOR ACTION ZrUsdatamst~clearProcessingUnsold.

ENDCLASS.

CLASS LHC_ZR_USDATAMST IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.

  METHOD clearProcessingUnsold.

    READ ENTITIES OF zr_invgrouped000 IN LOCAL MODE
    ENTITY ZrUsdatamst
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_entities).

    LOOP AT lt_entities INTO DATA(ls_entity).

      SELECT SINGLE FROM I_CustomerReturn
      FIELDS  CustomerReturn
      WHERE CustomerReturn = @ls_entity-ReferenceDoc
      INTO @DATA(ls_salesorder).

      IF ls_salesorder IS NOT INITIAL.
        APPEND VALUE #( %tky = ls_entity-%tky ) TO failed-zrusdatamst.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                   %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                            text = 'Return Order exists.'
                   ) ) TO reported-zrusdatamst.

        RETURN.
      ENDIF.

    ENDLOOP.

      MODIFY ENTITIES OF zr_invgrouped000 IN LOCAL MODE
            ENTITY zrusdatamst
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
