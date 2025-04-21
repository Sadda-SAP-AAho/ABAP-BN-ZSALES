CLASS lhc_ZI_ECMS DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR i_ecms RESULT result.

    methods validatekey for validate on save
      importing keys for I_ECMS~validatekey.

ENDCLASS.


CLASS lhc_ZI_ECMS IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD validatekey.

    READ ENTITIES OF zi_ecms IN LOCAL MODE
      ENTITY i_ecms
      FIELDS ( ID Transactionid Remittername Fromaccountnumber )
      WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(wa).
      IF wa-ID IS INITIAL OR wa-Transactionid IS INITIAL OR wa-Remittername IS INITIAL OR wa-Fromaccountnumber IS INITIAL.
        APPEND VALUE #( %tky = wa-%tky ) TO failed-i_ecms.



        DATA(missingFields) = COND string(
            WHEN wa-ID IS INITIAL THEN 'ID'
            WHEN wa-Transactionid IS INITIAL THEN 'Transactionid'
            WHEN wa-Remittername IS INITIAL THEN 'Remittername'
            WHEN wa-Fromaccountnumber IS INITIAL THEN 'Fromaccountnumber'

          ).

        APPEND VALUE #(
          %tky = wa-%tky
          %msg = new_message_with_text(
            severity = if_abap_behv_message=>severity-error
            text = |{ missingFields } is mandatory and cannot be empty.|
          )
        ) TO reported-i_ecms.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
