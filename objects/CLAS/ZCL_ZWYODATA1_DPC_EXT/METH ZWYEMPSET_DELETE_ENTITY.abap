  METHOD zwyempset_delete_entity.
**TRY.
*CALL METHOD SUPER->ZWYEMPSET_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
    FIELD-SYMBOLS <lx_key_tab> TYPE /iwbep/s_mgw_name_value_pair.
    DATA lv_empid TYPE zwyempid.
    READ TABLE it_key_tab ASSIGNING <lx_key_tab>
    WITH KEY name = 'EmpId'.
    IF <lx_key_tab> IS ASSIGNED.
      lv_empid = <lx_key_tab>-value.
*matn1_input( CHANGING ch_value = lv_matnr ).
      DELETE FROM zwyemp WHERE emp_id = lv_empid.
    ENDIF.
  ENDMETHOD.