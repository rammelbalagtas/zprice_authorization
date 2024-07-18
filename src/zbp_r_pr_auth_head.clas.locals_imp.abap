CLASS lhc_price DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS onModifyPriceNew FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Price~onModifyPriceNew.

ENDCLASS.

CLASS lhc_price IMPLEMENTATION.

  METHOD onModifyPriceNew.

    DATA lv_ppimpact TYPE p LENGTH 11 DECIMALS 2.
    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
      ENTITY Price
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_price).

    READ TABLE lt_price INTO DATA(ls_price) WITH KEY condtype = 'ZPX'.
    IF sy-subrc EQ 0.
      READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
        ENTITY Item
           ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_item).
      READ TABLE lt_item INTO DATA(ls_item) WITH KEY material = ls_price-material.
      IF sy-subrc EQ 0.
        lv_ppimpact = ( ls_price-pricecurr - ls_price-PriceNew ) * ls_item-PriceProt.
        MODIFY ENTITIES OF zr_pr_auth_head IN LOCAL MODE
           ENTITY Item
             UPDATE
               FIELDS ( PPImpact )
               WITH VALUE #( FOR item IN lt_item
                               ( %tky               = item-%tky
                                 PPImpact           = lv_ppimpact
                                 %control-PPImpact = if_abap_behv=>mk-on ) )
           MAPPED DATA(upd_mapped)
           FAILED DATA(upd_failed)
           REPORTED DATA(upd_reported).
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_customer DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setDefaultValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Customer~setDefaultValues.

ENDCLASS.

CLASS lhc_customer IMPLEMENTATION.

  METHOD setDefaultValues.
    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
      ENTITY Customer
         FIELDS ( CondType )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_customer).
    MODIFY ENTITIES OF zr_pr_auth_head IN LOCAL MODE
     ENTITY Customer
       UPDATE
         FIELDS ( CondType )
        WITH VALUE #( FOR customer IN lt_customer
                         ( %tky             = customer-%tky
                           CondType         = 'ZC'
                           %control-CondType  = if_abap_behv=>mk-on ) )
     FAILED DATA(upd_failed)
     REPORTED DATA(upd_reported).
    reported = CORRESPONDING #( DEEP upd_reported ).
  ENDMETHOD.

ENDCLASS.

CLASS lhc_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS setDefaultValues FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Item~setDefaultValues.
    METHODS onModifyPriceProt FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Item~onModifyPriceProt.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Item RESULT result.

*     METHODS GetDefaultsForaddNotes FOR READ
*      IMPORTING keys FOR FUNCTION Item~GetDefaultsForaddNotes RESULT result.
    METHODS addNotes FOR MODIFY
      IMPORTING keys FOR ACTION Item~addNotes.

ENDCLASS.

CLASS lhc_item IMPLEMENTATION.

  METHOD setDefaultValues.

    DATA lt_price TYPE TABLE FOR CREATE zr_pr_auth_item\_Price.

    DATA: lt_data  TYPE STANDARD TABLE OF zpr_auth_price,
          ls_price LIKE LINE OF lt_data.

    ls_price-cond_type = 'ZGO'.
    APPEND ls_price TO lt_data.
    ls_price-cond_type = 'ZP1'.
    APPEND ls_price TO lt_data.
    ls_price-cond_type = 'ZPX'.
    APPEND ls_price TO lt_data.
    ls_price-cond_type = 'ZPR'.
    APPEND ls_price TO lt_data.

    lt_price = VALUE #( FOR ls_key IN keys (
                             %is_draft = ls_key-%is_draft
                             PriceAuth = ls_key-PriceAuth
                             Material  = ls_key-Material
                             %target   = VALUE #( FOR ls_data IN lt_data (
                                                                           %is_draft = ls_key-%is_draft
                                                                           PriceAuth = ls_key-PriceAuth
                                                                           Material = ls_key-Material
                                                                           CondType = ls_data-cond_type
                                                                           %control = VALUE #( PriceAuth   = if_abap_behv=>mk-on
                                                                                               Material    = if_abap_behv=>mk-on
                                                                                               CondType    = if_abap_behv=>mk-on ) ) ) ) ).

    "Create default pricing records
    MODIFY ENTITIES OF zr_pr_auth_head IN LOCAL MODE
    ENTITY Item
    CREATE BY \_Price
    AUTO FILL CID
    WITH lt_price
    MAPPED DATA(lt_create)
    REPORTED DATA(lt_reported)
    FAILED DATA(lt_failed).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD onModifyPriceProt.

    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
      ENTITY Item
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_item)
      ENTITY Item BY \_Price
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_price).

    LOOP AT lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
      READ TABLE lt_price INTO DATA(ls_price) WITH KEY material = <fs_item>-material
                                                       condtype = 'ZPX'.
      IF sy-subrc EQ 0.
        <fs_item>-PPImpact = ( ls_price-pricecurr - ls_price-PriceNew ) * <fs_item>-PriceProt.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zr_pr_auth_head IN LOCAL MODE
       ENTITY Item
         UPDATE
           FIELDS ( PPImpact )
           WITH VALUE #( FOR item IN lt_item
                           ( %tky               = item-%tky
                             PPImpact           = item-PPImpact
                              %control-PPImpact = if_abap_behv=>mk-on ) )
       MAPPED DATA(upd_mapped)
       FAILED DATA(upd_failed)
       REPORTED DATA(upd_reported).

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD GetDefaultsForaddNotes.
*    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
*        ENTITY Item
*        ALL FIELDS WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_item).
*    LOOP AT lt_item INTO DATA(ls_item).
*      APPEND VALUE #( %tky = ls_item-%tky
*                      %param-notes  = ls_item-Notes ) TO result.
*    ENDLOOP.
*  ENDMETHOD.

  METHOD addNotes.

    MODIFY ENTITIES OF zr_pr_auth_head IN LOCAL MODE
       ENTITY Item
         UPDATE
           FIELDS ( Notes )
           WITH VALUE #( FOR key IN keys
                           ( %tky            = key-%tky
                             Notes           = key-%param-Notes
                              %control-Notes = if_abap_behv=>mk-on ) )
       MAPPED mapped
       FAILED failed
       REPORTED reported.
*    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
*      ENTITY Item
*      ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT lt_item.
*
*    result = VALUE #( FOR item IN lt_item
*                        ( %tky   = item-%tky
*                          %param = item ) ).

  ENDMETHOD.

ENDCLASS.

CLASS lhc_Header DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    TYPES: tt_header   TYPE TABLE FOR READ RESULT zr_pr_auth_head,
           tt_reported TYPE RESPONSE FOR REPORTED LATE zr_pr_auth_head,
           tt_failed   TYPE RESPONSE FOR FAILED LATE zr_pr_auth_head.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Header RESULT result.
    METHODS exportfile FOR MODIFY
      IMPORTING keys FOR ACTION header~exportfile RESULT result.

    METHODS importfile FOR MODIFY
      IMPORTING keys FOR ACTION header~importfile RESULT result.

    METHODS submit FOR MODIFY
      IMPORTING keys FOR ACTION header~submit RESULT result.

    METHODS validateentries FOR MODIFY
      IMPORTING keys FOR ACTION header~validateentries.
    METHODS validateonsave FOR VALIDATE ON SAVE
      IMPORTING keys FOR header~validateonsave.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE header.
    METHODS validateHeader IMPORTING it_header TYPE tt_header CHANGING ct_reported TYPE tt_reported
                                                                       ct_failed   TYPE tt_failed.

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

  METHOD exportFile.

    TYPES:
      BEGIN OF ty_excel,
        material TYPE c LENGTH 18,
      END OF ty_excel.

    DATA lt_excel TYPE STANDARD TABLE OF ty_excel.
    DATA ls_excel LIKE LINE OF lt_excel.

    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
      ENTITY Header
         ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_header)
      ENTITY Header BY \_Item
        ALL FIELDS
      WITH CORRESPONDING #(  keys  )
      RESULT DATA(lt_item).

    LOOP AT lt_item INTO DATA(ls_item).
      ls_excel-material = ls_item-material.
      APPEND ls_excel TO lt_excel.
    ENDLOOP.

    IF lt_excel IS INITIAL.
      ls_excel-material = 'Sample file'.
      APPEND ls_excel TO lt_excel.
    ENDIF.

    DATA(lo_xlsx) = xco_cp_xlsx=>document->empty( )->write_access(  ).
    DATA(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

    DATA(lv_count) = lines( lt_excel ).
    IF lv_count IS INITIAL.
      lv_count = 1.
    ENDIF.
    "from and to is required for performance purposes
    DATA(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
    )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
    )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 1 )
    )->to_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'B' )
    )->to_row( xco_cp_xlsx=>coordinate->for_numeric_value( lv_count )
    )->get_pattern( ).

    "Write rows of internal table it_data to worksheet
    lo_worksheet->select( lo_selection_pattern
    )->row_stream(
    )->operation->write_from( REF #( lt_excel )
    )->set_value_transformation( xco_cp_xlsx_write_access=>value_transformation->best_effort
    )->execute( ).

    DATA(lv_file_content) = lo_xlsx->get_file_content( ).

    MODIFY ENTITIES OF zr_pr_auth_head IN LOCAL MODE
     ENTITY Header
       UPDATE
         FIELDS ( AttachmentDownload MimeTypeDownload FilenameDownload )
        WITH VALUE #( FOR header IN lt_header
                         ( %tky             = header-%tky
                           AttachmentDownload = lv_file_content
                           MimeTypeDownload = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
                           FilenameDownload = 'Sample export file.xlsx'
                           %control-AttachmentDownload  = if_abap_behv=>mk-on
                           %control-MimeTypeDownload  = if_abap_behv=>mk-on
                           %control-FilenameDownload  = if_abap_behv=>mk-on ) )
     MAPPED mapped
     FAILED failed
     REPORTED reported.

    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
       ENTITY Header
          ALL FIELDS
       WITH CORRESPONDING #( keys )
       RESULT lt_header.

    result = VALUE #( FOR header IN lt_header
                        ( %tky   = header-%tky
                          %param = header ) ).

  ENDMETHOD.

  METHOD importFile.

    TYPES: BEGIN OF ty_excel,
             material TYPE string,
             quantity TYPE int4,
           END OF ty_excel,
           tt_row TYPE STANDARD TABLE OF ty_excel.
    DATA lt_rows TYPE tt_row.

    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
          ENTITY Header
          ALL FIELDS WITH
          CORRESPONDING #( keys )
          RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).
      APPEND VALUE #(  %tky        = ls_header-%tky
                       %state_area = 'CHECK_FILE'
                    ) TO reported-header.

      IF ls_header-attachmentUpload IS INITIAL.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        APPEND VALUE #( %tky = ls_header-%tky
                        %state_area         = 'CHECK_FILE'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Upload a file for import' )

                        %element-filenameUpload   = if_abap_behv=>mk-on
                       ) TO reported-header.
        RETURN.
      ENDIF.
    ENDLOOP.

    "Read upload file
    DATA(lv_attachment) = lt_header[ 1 ]-AttachmentUpload.
    DATA(lo_xlsx) = xco_cp_xlsx=>document->for_file_content( iv_file_content = lv_attachment )->read_access( ).
    DATA(lo_worksheet) = lo_xlsx->get_workbook( )->worksheet->at_position( 1 ).

    DATA(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to( )->get_pattern( ).

    DATA(lo_execute) = lo_worksheet->select( lo_selection_pattern
      )->row_stream(
      )->operation->write_to( REF #( lt_rows ) ).

    lo_execute->set_value_transformation( xco_cp_xlsx_read_access=>value_transformation->string_value
               )->if_xco_xlsx_ra_operation~execute( ).
    "add materials
    DATA lt_material TYPE TABLE FOR CREATE zr_pr_auth_head\_Item.
    lt_material = VALUE #( FOR ls_key IN keys (
                              %is_draft = ls_key-%is_draft
                              PriceAuth = ls_key-PriceAuth
                              %target   = VALUE #( FOR ls_row IN lt_rows (
                                                                            %is_draft = ls_key-%is_draft
                                                                            PriceAuth = ls_key-PriceAuth
                                                                            Material = ls_row-Material
                                                                            PriceProt = ls_row-Quantity
                                                                            %control = VALUE #( PriceAuth   = if_abap_behv=>mk-on
                                                                                                Material    = if_abap_behv=>mk-on
                                                                                                PriceProt    = if_abap_behv=>mk-on ) ) ) ) ).

    DATA lt_customer TYPE TABLE FOR CREATE zr_pr_auth_item\_Customer.

    DATA: lt_data     TYPE STANDARD TABLE OF zpr_auth_cust,
          ls_customer LIKE LINE OF lt_data.

    ls_customer-cond_type = 'ZC'.
    ls_customer-customer = '00000001'.
    ls_customer-Price_New = '100.00'.
    APPEND ls_customer TO lt_data.
    ls_customer-cond_type = 'ZC'.
    ls_customer-customer = '00000002'.
    ls_customer-Price_New = '200.00'.
    APPEND ls_customer TO lt_data.
    ls_customer-cond_type = 'ZC'.
    ls_customer-customer = '00000003'.
    ls_customer-Price_New = '300.00'.
    APPEND ls_customer TO lt_data.
    ls_customer-cond_type = 'ZC'.
    ls_customer-customer = '00000004'.
    ls_customer-Price_New = '400.00'.
    APPEND ls_customer TO lt_data.

    lt_customer = VALUE #( FOR ls_row IN lt_rows (
                             %is_draft = keys[ 1 ]-%is_draft
                             PriceAuth = keys[ 1 ]-PriceAuth
                             Material  = ls_row-Material
                             %target   = VALUE #( FOR ls_data IN lt_data (
                                                                           %is_draft = keys[ 1 ]-%is_draft
                                                                           PriceAuth = keys[ 1 ]-PriceAuth
                                                                           Material = ls_row-Material
                                                                           Customer = ls_data-Customer
                                                                           CondType = ls_data-cond_type
                                                                           PriceNew = ls_data-Price_New
                                                                           %control = VALUE #( PriceAuth   = if_abap_behv=>mk-on
                                                                                               Material    = if_abap_behv=>mk-on
                                                                                               Customer    = if_abap_behv=>mk-on
                                                                                               PriceNew    = if_abap_behv=>mk-on
                                                                                               CondType    = if_abap_behv=>mk-on ) ) ) ) ).

    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
        ENTITY Header
        BY \_Item
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT DATA(lt_item).

    "Delete already existing entries from child entity
    MODIFY ENTITIES OF zr_pr_auth_head IN LOCAL MODE
    ENTITY Item
    DELETE FROM VALUE #( FOR ls_item IN lt_item (  %is_draft = ls_item-%is_draft
                                                       %key  = ls_item-%key ) )
    MAPPED DATA(lt_mapped_delete)
    REPORTED DATA(lt_reported_delete)
    FAILED DATA(lt_failed_delete).

    "Create records from newly extract data
    MODIFY ENTITIES OF zr_pr_auth_head IN LOCAL MODE
    ENTITY Header
    CREATE BY \_Item
    AUTO FILL CID
    WITH lt_material
    MAPPED DATA(lt_item_mapped)
    REPORTED DATA(lt_item_reported)
    FAILED DATA(lt_item_failed).

    MODIFY ENTITIES OF zr_pr_auth_head IN LOCAL MODE
    ENTITY Item
    CREATE BY \_Customer
    AUTO FILL CID
    WITH lt_customer
    MAPPED DATA(lt_customer_mapped)
    REPORTED DATA(lt_customer_reported)
    FAILED DATA(lt_customer_failed).

    APPEND VALUE #( %tky = lt_header[ 1 ]-%tky ) TO mapped-header.

    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
        ENTITY Header
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT lt_header.

    result = VALUE #( FOR header IN lt_header
                          ( %tky   = header-%tky
                            %param = header ) ).

  ENDMETHOD.

  METHOD submit.

    MODIFY ENTITIES OF zr_pr_auth_head IN LOCAL MODE
     ENTITY Header
       UPDATE
         FIELDS ( Description )
        WITH VALUE #( FOR key IN keys
                         ( %tky   = key-%tky
                           Status = '03' ) ).

    MODIFY ENTITIES OF zr_pr_auth_head IN LOCAL MODE
     ENTITY Header
       EXECUTE Activate FROM
       VALUE #( FOR key IN keys ( %key = key-%key ) )
     MAPPED DATA(activate_mapped)
     FAILED DATA(activate_failed)
     REPORTED DATA(activate_reported).

    DATA(lt_keys) = keys.
    LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_key>).
      <fs_key>-%is_draft = if_abap_behv=>mk-off.
    ENDLOOP.

    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
        ENTITY Header
        ALL FIELDS WITH
        CORRESPONDING #( lt_keys )
        RESULT DATA(lt_header).

    result = VALUE #( FOR new_key IN lt_keys
                          ( %key   = keys[ 1 ]-%key
                            %tky   = keys[ 1 ]-%tky
                            %param-%key = new_key-%key ) ).

    mapped-header = CORRESPONDING #( lt_header ).

  ENDMETHOD.

  METHOD validateEntries.

    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
        ENTITY Header
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).
      APPEND VALUE #(  %tky        = ls_header-%tky
                       %state_area = 'VALIDATE_ONSAVE'
                    ) TO reported-header.

      IF ls_header-description IS INITIAL.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        APPEND VALUE #( %tky = ls_header-%tky
                        %state_area         = 'VALIDATE_ONSAVE'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Fill up mandatory fields' )

                        %element-Description   = if_abap_behv=>mk-on
                       ) TO reported-header.
      ENDIF.

      IF ls_header-validfrom IS INITIAL.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        APPEND VALUE #( %tky = ls_header-%tky
                        %state_area         = 'VALIDATE_ONSAVE'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Fill up mandatory fields' )

                        %element-validfrom   = if_abap_behv=>mk-on
                       ) TO reported-header.
      ENDIF.

      IF ls_header-validto IS INITIAL.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        APPEND VALUE #( %tky = ls_header-%tky
                        %state_area         = 'VALIDATE_ONSAVE'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Fill up mandatory fields' )

                        %element-validto   = if_abap_behv=>mk-on
                       ) TO reported-header.
      ENDIF.

      IF ls_header-submittedto IS INITIAL.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        APPEND VALUE #( %tky = ls_header-%tky
                        %state_area         = 'VALIDATE_ONSAVE'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Fill up mandatory fields' )

                        %element-submittedto   = if_abap_behv=>mk-on
                       ) TO reported-header.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateOnSave.

    READ ENTITIES OF zr_pr_auth_head IN LOCAL MODE
        ENTITY Header
        ALL FIELDS WITH
        CORRESPONDING #( keys )
        RESULT DATA(lt_header).

    LOOP AT lt_header INTO DATA(ls_header).
      APPEND VALUE #(  %tky        = ls_header-%tky
                       %state_area = 'VALIDATE_ONSAVE'
                    ) TO reported-header.

      IF ls_header-description IS INITIAL.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        APPEND VALUE #( %tky = ls_header-%tky
                        %state_area         = 'VALIDATE_ONSAVE'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Fill up mandatory fields' )

                        %element-Description   = if_abap_behv=>mk-on
                       ) TO reported-header.
      ENDIF.

      IF ls_header-validfrom IS INITIAL.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        APPEND VALUE #( %tky = ls_header-%tky
                        %state_area         = 'VALIDATE_ONSAVE'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Fill up mandatory fields' )

                        %element-validfrom   = if_abap_behv=>mk-on
                       ) TO reported-header.
      ENDIF.

      IF ls_header-validto IS INITIAL.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        APPEND VALUE #( %tky = ls_header-%tky
                        %state_area         = 'VALIDATE_ONSAVE'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Fill up mandatory fields' )

                        %element-validto   = if_abap_behv=>mk-on
                       ) TO reported-header.
      ENDIF.

      IF ls_header-submittedto IS INITIAL.
        APPEND VALUE #( %tky = ls_header-%tky ) TO failed-header.
        APPEND VALUE #( %tky = ls_header-%tky
                        %state_area         = 'VALIDATE_ONSAVE'
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                                          text = 'Fill up mandatory fields' )

                        %element-submittedto   = if_abap_behv=>mk-on
                       ) TO reported-header.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateheader.
  ENDMETHOD.

ENDCLASS.
