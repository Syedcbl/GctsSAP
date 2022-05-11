*&---------------------------------------------------------------------*
*& Include          ZWYMODULETEST_SCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

  SELECT-OPTIONS : s_emp FOR e_id.
  PARAMETERS : s_deptid  TYPE ztestdepartment-departmentid.
  SELECT-OPTIONS : s_date FOR t_date DEFAULT sy-datum.

SELECTION-SCREEN END OF BLOCK b1.