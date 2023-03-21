CLASS lhc_translation DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE translation.


ENDCLASS.

CLASS lhc_translation IMPLEMENTATION.
  METHOD update.
    DATA lt_translations TYPE STANDARD TABLE OF z_cds_meta_translations.
    IF lines( entities ) GT 0.
      MOVE-CORRESPONDING entities[] TO lt_translations[].

      DATA(l_error) = zcl_pm_cds_translation_fact=>get_instance( )->update_translations( it_translations = lt_translations ).


      IF l_error IS NOT INITIAL.
        LOOP AT entities[] INTO DATA(ls_entity).
          APPEND VALUE #( %cid = ls_entity-%cid_ref ddlxname = ls_entity-%key-ddlxname element  = ls_entity-%key-element name  = ls_entity-%key-name ) TO failed-translation.


          APPEND VALUE #( %msg = new_message_with_text(
            text = l_error
            severity = if_abap_behv_message=>severity-error ) %cid = ls_entity-%cid_ref ddlxname = ls_entity-%key-ddlxname element  = ls_entity-%key-element name  = ls_entity-%key-name )
          TO reported-translation.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lhc_metadata DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS transport FOR MODIFY
      IMPORTING it_key_for_action FOR ACTION metadata~transport.

ENDCLASS.

CLASS lhc_metadata IMPLEMENTATION.
  METHOD transport.
    LOOP AT it_key_for_action ASSIGNING FIELD-SYMBOL(<fs_key>).
      DATA(lt_return) = zcl_pm_cds_translation_fact=>get_instance( )->transport(
          cds = <fs_key>-%param-cds
          transport = <fs_key>-%param-transport
      ).

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.


*CLASS lhc_translation_aux DEFINITION
* INHERITING FROM cl_abap_behv
* FINAL
*  CREATE PUBLIC .
*  PUBLIC SECTION.
*    TYPES tt_equipment_failed TYPE TABLE FOR FAILED z_cds_meta_translations.
*    TYPES tt_equipment_mapped TYPE TABLE FOR MAPPED z_cds_meta_translations.
*    TYPES tt_equipment_reported TYPE TABLE FOR REPORTED z_cds_meta_translations.
*
*    CLASS-METHODS handle_equipment_messages
*      IMPORTING
*        iv_cid          TYPE string OPTIONAL
*        it_messages     TYPE ZGW_BAPIRET2_T
*      CHANGING
*        failed          TYPE tt_equipment_failed
*        reported        TYPE tt_equipment_reported.
*  PRIVATE SECTION.
*    CLASS-DATA obj TYPE REF TO lhc_translation_aux.
*    CLASS-METHODS get_message_object
*      RETURNING VALUE(r_result) TYPE REF TO lhc_translation_aux
*ENDCLASS.
*CLASS lhc_translation_aux IMPLEMENTATION.
*  METHOD handle_equipment_messages.
*    LOOP AT it_messages INTO DATA(ls_message) WHERE type = 'E' OR type = 'A'.
*      APPEND VALUE #( %cid = iv_cid  ) TO failed.
*      APPEND VALUE #( %msg = get_message_object( )->new_message( id = ls_message-id
*        number = ls_message-number
*        severity = if_abap_behv_message=>severity-error
*          v1 = ls_message-message_v1
*          v2 = ls_message-message_v2
*          v3 = ls_message-message_v3
*          v4 = ls_message-message_v4 )
*      %key-Equipment = iv_equipment_id
*      %cid = iv_cid
*      Equipment = iv_equipment_id )
*      TO reported.
*    ENDLOOP.
*  ENDMETHOD.
*  METHOD get_message_object.
*    IF obj IS INITIAL.
*      CREATE OBJECT obj.
*    ENDIF.
*    r_result = obj.
*  ENDMETHOD.
*ENDCLASS.
