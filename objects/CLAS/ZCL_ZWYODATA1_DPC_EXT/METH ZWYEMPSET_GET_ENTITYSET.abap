  method ZWYEMPSET_GET_ENTITYSET.
*TRY.
*CALL METHOD SUPER->ZWYEMPSET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
*    io_tech_request_context  =
*  IMPORTING
*    et_entityset             =
*    es_response_context      =
*    .
*  CATCH /iwbep/cx_mgw_busi_exception.
*  CATCH /iwbep/cx_mgw_tech_exception.
*ENDTRY.
  SELECT EMP_ID FIRST_NAME LAST_NAME HLTH_PLAN
FROM zwyemp
INTO CORRESPONDING FIELDS OF TABLE et_entityset.
  endmethod.