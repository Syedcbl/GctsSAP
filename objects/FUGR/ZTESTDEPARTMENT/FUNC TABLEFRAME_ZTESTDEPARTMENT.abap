*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_ZTESTDEPARTMENT
*   generation date: 15.02.2022 at 14:22:43
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_ZTESTDEPARTMENT    .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.