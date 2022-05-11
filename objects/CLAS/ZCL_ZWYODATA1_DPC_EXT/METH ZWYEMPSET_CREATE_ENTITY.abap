  METHOD zwyempset_create_entity.
**TRY.
*CALL METHOD SUPER->ZWYEMPSET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
    DATA lw_emp TYPE zwyemp.
    TRY.
        CALL METHOD io_data_provider->read_entry_data
          IMPORTING
            es_data = er_entity.
        IF er_entity IS NOT INITIAL.
          MOVE-CORRESPONDING er_entity TO lw_emp.
          lw_emp-mandt = sy-mandt.
          IF lw_emp-emp_id IS NOT INITIAL.
            TRY .
                INSERT INTO zwyemp VALUES lw_emp.
              CATCH cx_sy_open_sql_db .
            ENDTRY.
          ENDIF.
        ENDIF.
      CATCH /iwbep/cx_mgw_tech_exception .
    ENDTRY.
  ENDMETHOD.