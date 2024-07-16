CLASS lhc_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Header RESULT result.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE header.

ENDCLASS.

CLASS lhc_Header IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.

    DATA:
      entity        TYPE STRUCTURE FOR CREATE zr_pr_auth_head,
      priceauth_max TYPE n LENGTH 10.

    " Ensure PR Auth ID is not set yet (idempotent)- must be checked when BO is draft-enabled
    LOOP AT entities INTO entity WHERE priceauth IS NOT INITIAL.
      APPEND CORRESPONDING #( entity ) TO mapped-header.
    ENDLOOP.

    DATA(entities_wo_id) = entities.
    DELETE entities_wo_id WHERE priceauth IS NOT INITIAL.

    " Get Numbers
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = '/DMO/TRV_M'
            quantity          = CONV #( lines( entities_wo_id ) )
          IMPORTING
            number            = DATA(number_range_key)
            returncode        = DATA(number_range_return_code)
            returned_quantity = DATA(number_range_returned_quantity)
        ).
      CATCH cx_number_ranges INTO DATA(lx_number_ranges).
        LOOP AT entities_wo_id INTO entity.
          APPEND VALUE #(  %cid = entity-%cid
                           %key = entity-%key
                           %msg = lx_number_ranges
                        ) TO reported-header.
          APPEND VALUE #(  %cid = entity-%cid
                           %key = entity-%key
                        ) TO failed-header.
        ENDLOOP.
        EXIT.
    ENDTRY.

    priceauth_max = number_range_key - number_range_returned_quantity.

    " Set Price Authorization ID
    LOOP AT entities_wo_id INTO entity.
      priceauth_max += 1.
      entity-priceauth = priceauth_max .

      APPEND VALUE #( %cid  = entity-%cid
*                      %key  = entity-%key
                      priceauth = priceauth_max
                      %is_draft = if_abap_behv=>mk-on
                    ) TO mapped-header.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
