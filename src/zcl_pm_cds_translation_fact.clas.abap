class ZCL_PM_CDS_TRANSLATION_FACT definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .

  class-methods GET_INSTANCE
    returning
      value(RE_INSTANCE) type ref to ZCL_PM_CDS_TRANSLATION_FACT .
  methods UPDATE_TRANSLATIONS
    importing
      value(IT_TRANSLATIONS) type ZTT_TRANSLATIONS
    returning
      value(R_ERR_MSG) type LXESTRING .
  methods TRANSPORT
    importing
      !CDS type DDLXNAME
      !TRANSPORT type TRKORR
    returning
      value(RETURN) type BAPIRET2_T .
  class-methods GET_EXISTING_TRANSLATIONS
    importing
      value(IV_OBJ_NAME) type LXEOBJNAME
      value(IV_LANG) type LXEISOLANG
      value(IV_MASTER_LANG) type LXEISOLANG
    returning
      value(RT_TRANSLATIONS) type LXE_TT_PCX_S1 .
  PROTECTED SECTION.
private section.

  class-data INSTANCE type ref to ZCL_PM_CDS_TRANSLATION_FACT .

  class-methods GET_OBJ_NAME
    importing
      !I_CDS_NAME type DDLXNAME
    returning
      value(R_OBJ_NAME) type LXEOBJNAME .
  methods UPDATE_TRANSLATION
    importing
      value(I_SOURCE_LANG) type LXEISOLANG
      value(I_TARGET_LANG) type LXEISOLANG
      value(I_OBJ_NAME) type LXEOBJNAME
      value(IT_TRANSLATIONS) type ZTT_TRANSLATIONS .
ENDCLASS.



CLASS ZCL_PM_CDS_TRANSLATION_FACT IMPLEMENTATION.


  METHOD GET_INSTANCE.
*----------------------------------------------------------------------*
* P R O G R A M M I N G  L O G I C                                     *
*----------------------------------------------------------------------*
    IF instance IS INITIAL.
      instance = NEW ZCL_PM_CDS_TRANSLATION_FACT( ).
    ENDIF.
    re_instance = instance.
  ENDMETHOD.


  METHOD update_translations.

    "@TODO: methode die 3 stappen per taal afhandelt maken
    "@TODO: error handling

*-----------------------------------------------------------------------*
*   D A T A  D E C L A R A T I O N S                                    *
*-----------------------------------------------------------------------*
    DATA: lt_existing_dutch   TYPE STANDARD TABLE OF lxe_pcx_s1,
          lt_existing_french  TYPE STANDARD TABLE OF lxe_pcx_s1,
          lt_existing_german  TYPE STANDARD TABLE OF lxe_pcx_s1,
          lt_existing_english TYPE STANDARD TABLE OF lxe_pcx_s1,
          lv_o_lang           TYPE lxeisolang,
          l_index             TYPE i,
          l_write_status      TYPE lxestatprc,
          l_update_nl         TYPE flag,
          l_update_fr         TYPE flag,
          l_update_de         TYPE flag,
          l_update_en         TYPE flag,
          ls_translation      TYPE z_cds_meta_translations.

    CONSTANTS: lc_dutch   TYPE lxeisolang VALUE 'nlNL',
               lc_french  TYPE lxeisolang VALUE 'frFR',
               lc_german  TYPE lxeisolang VALUE 'deDE',
               lc_english TYPE lxeisolang VALUE 'enUS'.

*-----------------------------------------------------------------------*
*   P R O G R A M M I N G  L O G I C                                    *
*-----------------------------------------------------------------------*

* -- 1 Extract general info from first line
    DATA(l_ddlxname) = it_translations[ 1 ]-ddlxname.

    " Get dictionary info
    SELECT SINGLE obj_name, devclass, masterlang FROM tadir BYPASSING BUFFER
      INTO @DATA(ls_tadir)
      WHERE pgmid  = 'R3TR'
      AND object = 'DDLX'
      AND obj_name = @l_ddlxname.

    IF sy-subrc EQ 0.

      " Get master language
      CALL FUNCTION 'LXE_OBJ_GET_ORIG_LANG'
        EXPORTING
          i_lang   = ls_tadir-masterlang
        IMPORTING
          e_o_lang = lv_o_lang.

      " Construct object name
      DATA(l_objname) = get_obj_name( ls_tadir-obj_name(40) ).

      " Get extra info to compare 1 to 1
      SELECT * FROM ddlx_rt_data_t
        INTO TABLE @DATA(lt_ordered_properties)
        WHERE ddlxname = @l_ddlxname
        AND ddlanguage = @ls_tadir-masterlang.

      IF sy-subrc = 0.
        SORT lt_ordered_properties.
      ENDIF.

* -- 2 Handle Dutch translations

      IF lv_o_lang NE lc_dutch.
        " Get Dutch translations
        lt_existing_dutch = get_existing_translations(
          EXPORTING
            iv_obj_name     = l_objname
            iv_lang         = lc_dutch
            iv_master_lang  = lv_o_lang
        ).

        " Compare and change
        LOOP AT it_translations INTO ls_translation WHERE dutchtranslationchanged EQ abap_true.
          l_index = line_index( lt_ordered_properties[ element = ls_translation-element name = ls_translation-name ] ).
          IF lt_existing_dutch[ l_index ]-t_text <> ls_translation-dutchtranslation.
            l_update_nl = abap_true.
            lt_existing_dutch[ l_index ]-t_text = ls_translation-dutchtranslation.
          ENDIF.
        ENDLOOP.

        " Save
        IF l_update_nl EQ abap_true.
          CALL FUNCTION 'LXE_OBJ_TEXT_PAIR_WRITE'
            EXPORTING
              t_lang    = lc_dutch
              s_lang    = lv_o_lang
              custmnr   = '999999'
              objtype   = 'TLGS'
              objname   = l_objname
            IMPORTING
              pstatus   = l_write_status
              err_msg   = r_err_msg
            TABLES
              lt_pcx_s1 = lt_existing_dutch.

          IF l_write_status NE 'S'.
            ROLLBACK WORK.
            RETURN.
          ENDIF.
        ENDIF.
      ENDIF.

* -- 2 Handle French translations

      IF lv_o_lang NE lc_french.
        " Get French translations
        lt_existing_french = get_existing_translations(
          EXPORTING
            iv_obj_name     = l_objname
            iv_lang         = lc_french
            iv_master_lang  = lv_o_lang
        ).

        " Compare and change
        LOOP AT it_translations INTO ls_translation WHERE frenchtranslationchanged EQ abap_true.
          l_index = line_index( lt_ordered_properties[ element = ls_translation-element name = ls_translation-name ] ).
          IF lt_existing_french[ l_index ]-t_text <> ls_translation-frenchtranslation.
            l_update_fr = abap_true.
            lt_existing_french[ l_index ]-t_text = ls_translation-frenchtranslation.
          ENDIF.
        ENDLOOP.

        " Save
        IF l_update_fr EQ abap_true.
          CALL FUNCTION 'LXE_OBJ_TEXT_PAIR_WRITE'
            EXPORTING
              t_lang    = lc_french
              s_lang    = lv_o_lang
              custmnr   = '999999'
              objtype   = 'TLGS'
              objname   = l_objname
            IMPORTING
              pstatus   = l_write_status
              err_msg   = r_err_msg
            TABLES
              lt_pcx_s1 = lt_existing_french.
          IF l_write_status NE 'S'.
            ROLLBACK WORK.
            RETURN.
          ENDIF.
        ENDIF.
      ENDIF.

* -- 3 Handle German translations

      IF lv_o_lang NE lc_german.
        " Get German translations
        lt_existing_german = get_existing_translations(
          EXPORTING
            iv_obj_name     = l_objname
            iv_lang         = lc_german
            iv_master_lang  = lv_o_lang
        ).

        " Compare and change
        LOOP AT it_translations INTO ls_translation WHERE germantranslationchanged EQ abap_true.
          l_index = line_index( lt_ordered_properties[ element = ls_translation-element name = ls_translation-name ] ).
          IF  lt_existing_german[ l_index ]-t_text <> ls_translation-germantranslation.
            l_update_de = abap_true.
            lt_existing_german[ l_index ]-t_text = ls_translation-germantranslation.
          ENDIF.
        ENDLOOP.

        " Save
        IF l_update_de EQ abap_true.
          CALL FUNCTION 'LXE_OBJ_TEXT_PAIR_WRITE'
            EXPORTING
              t_lang    = lc_german
              s_lang    = lv_o_lang
              custmnr   = '999999'
              objtype   = 'TLGS'
              objname   = l_objname
            IMPORTING
              pstatus   = l_write_status
              err_msg   = r_err_msg
            TABLES
              lt_pcx_s1 = lt_existing_german.
          IF l_write_status NE 'S'.
            ROLLBACK WORK.
            RETURN.
          ENDIF.
        ENDIF.
      ENDIF.

* -- 4 Handle English translations

      IF lv_o_lang NE lc_english.
        " Get Engish translations
        lt_existing_english = get_existing_translations(
          EXPORTING
            iv_obj_name     = l_objname
            iv_lang         = lc_english
            iv_master_lang  = lv_o_lang
        ).

        " Compare and change
        LOOP AT it_translations INTO ls_translation WHERE englishtranslationchanged EQ abap_true.
          l_index = line_index( lt_ordered_properties[ element = ls_translation-element name = ls_translation-name ] ).
          IF  lt_existing_english[ l_index ]-t_text <> ls_translation-englishtranslation.
            l_update_en = abap_true.
            lt_existing_english[ l_index ]-t_text = ls_translation-englishtranslation.
          ENDIF.
        ENDLOOP.

        " Save
        IF l_update_en EQ abap_true.
          CALL FUNCTION 'LXE_OBJ_TEXT_PAIR_WRITE'
            EXPORTING
              t_lang    = lc_english
              s_lang    = lv_o_lang
              custmnr   = '999999'
              objtype   = 'TLGS'
              objname   = l_objname
            IMPORTING
              pstatus   = l_write_status
              err_msg   = r_err_msg
            TABLES
              lt_pcx_s1 = lt_existing_english.
          IF l_write_status NE 'S'.
            ROLLBACK WORK.
            RETURN.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_obj_name.

    r_obj_name(4)    = 'DDLX'.
    r_obj_name+4(40) = i_cds_name(40).
    r_obj_name+44    = '06'.

  ENDMETHOD.


  METHOD transport.
"@TODO: error handling
*-----------------------------------------------------------------------*
*   D A T A  D E C L A R A T I O N S                                    *
*-----------------------------------------------------------------------*
    DATA: l_pstatus  TYPE lxestatprc,
          lt_objlist TYPE STANDARD TABLE OF e071,
          lt_keylist TYPE STANDARD TABLE OF e071k.

*-----------------------------------------------------------------------*
*   P R O G R A M M I N G  L O G I C                                    *
*-----------------------------------------------------------------------*

    " Construct object name
    DATA(l_obj_name) = get_obj_name( cds ).

    " Get all the translations
    SELECT * FROM lxe_log
      WHERE objname = @l_obj_name
      INTO TABLE @DATA(lt_changed_langu).

    LOOP AT lt_changed_langu INTO DATA(ls_changed_langu).

      " Construct objetcs to add to transport
      CALL FUNCTION 'LXE_OBJ_CREATE_TRANSPORT_ENTRY'
        EXPORTING
          language = ls_changed_langu-targlng
          custmnr  = '999999'
          objtype  = 'TLGS'
          objname  = l_obj_name
          tabkey   = ''
        IMPORTING
          pstatus  = l_pstatus
        TABLES
          ex_e071  = lt_objlist
          ex_e071k = lt_keylist.

      IF l_pstatus <> 'S' OR lt_objlist IS INITIAL.
        "TODO
      ENDIF.

      " Add objects to transport
      CALL FUNCTION 'ZPM_TR_REQUEST_CHOICE' "RAP + commit...
        DESTINATION 'NONE'
        EXPORTING
          iv_request           = transport
          it_e071              = lt_objlist
          it_e071k             = lt_keylist
        EXCEPTIONS
          invalid_request      = 1
          invalid_request_type = 2
          user_not_owner       = 3
          no_objects_appended  = 4
          enqueue_error        = 5
          cancelled_by_user    = 6
          recursive_call       = 7
          OTHERS               = 8.
      IF sy-subrc NE 0.
        "TODO
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  method GET_EXISTING_TRANSLATIONS.
          CALL FUNCTION 'LXE_OBJ_TEXT_PAIR_READ'
        EXPORTING
          t_lang             = iv_lang
          s_lang             = iv_master_lang
          custmnr            = '999999'
          objtype            = 'TLGS'
          bypass_attr_buffer = abap_false
          objname            = iv_obj_name
          read_only          = abap_false
        TABLES
          lt_pcx_s1          = rt_translations.
  endmethod.


  method UPDATE_TRANSLATION.

*        IF i_source_lang NE i_target_lang.
*
*        " Get existing translations
*        data(lt_existing) = get_existing_translations(
*          EXPORTING
*            iv_obj_name     = i_obj_name
*            iv_lang         = i_target_lang
*            iv_master_lang  = i_source_lang
*        ).
*
*        " Compare and change
*        LOOP AT it_translations INTO data(ls_translation) WHERE dutchtranslationchanged EQ abap_true.
*          l_index = line_index( lt_ordered_properties[ element = ls_translation-element name = ls_translation-name ] ).
*          IF lt_existing_dutch[ l_index ]-t_text <> ls_translation-dutchtranslation.
*            l_update_nl = abap_true.
*            lt_existing_dutch[ l_index ]-t_text = ls_translation-dutchtranslation.
*          ENDIF.
*        ENDLOOP.
*
*        " Save
*        IF l_update_nl EQ abap_true.
*          CALL FUNCTION 'LXE_OBJ_TEXT_PAIR_WRITE'
*            EXPORTING
*              t_lang    = lc_dutch
*              s_lang    = lv_o_lang
*              custmnr   = '999999'
*              objtype   = 'TLGS'
*              objname   = l_objname
*            IMPORTING
*              pstatus   = l_write_status
*            TABLES
*              lt_pcx_s1 = lt_existing_dutch.
*        ENDIF.
*      ENDIF.

  endmethod.
ENDCLASS.
