FUNCTION zpm_tr_request_choice.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(IV_REQUEST) TYPE  TRKORR OPTIONAL
*"     VALUE(IT_E071) TYPE  TR_OBJECTS OPTIONAL
*"     VALUE(IT_E071K) TYPE  TR_KEYS OPTIONAL
*"----------------------------------------------------------------------

  CALL FUNCTION 'TR_REQUEST_CHOICE'
        EXPORTING
          iv_suppress_dialog   = 'X'
          iv_request_types     = 'TK'
          iv_request           = IV_REQUEST
          it_e071              = IT_E071
          it_e071k             = it_e071k
          iv_with_error_log    = 'X'
          iv_no_owner_check    = 'X'.
*    IMPORTING
*      es_request           = es_request                " Selected request





ENDFUNCTION.
