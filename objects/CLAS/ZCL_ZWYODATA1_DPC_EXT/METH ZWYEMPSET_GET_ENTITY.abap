  METHOD zwyempset_get_entity.
*TRY.
**CALL METHOD SUPER->ZWYEMPSET_GET_ENTITY
**  EXPORTING
**    IV_ENTITY_NAME          =
**    IV_ENTITY_SET_NAME      =
**    IV_SOURCE_NAME          =
**    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
**    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
**    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
    FIELD-SYMBOLS <lx_key_tab> TYPE /iwbep/s_mgw_name_value_pair.
    DATA lv_emp TYPE zwyemp-emp_id.
    READ TABLE it_key_tab ASSIGNING <lx_key_tab>
    WITH KEY name = 'EmpId'.
    IF <lx_key_tab> IS ASSIGNED.
      lv_emp = <lx_key_tab>-value.
**matn1_input( CHANGING ch_value = lv_emp ).
      SELECT SINGLE emp_id first_name last_name hlth_plan
      FROM zwyemp
      INTO CORRESPONDING FIELDS OF er_entity
      WHERE emp_id = lv_emp.

    ENDIF.
  ENDMETHOD.