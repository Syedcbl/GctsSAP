*&---------------------------------------------------------------------*
*& Report ZWYMODULETEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zwymoduletest.

INCLUDE: zwymoduletest_top,
         zwymoduletest_scr.


START-OF-SELECTION.

  SELECT
          id
          departmentid
          first_name
          second_name
          age
          place
          phone_number
      FROM ztestemployee INTO TABLE it_emp
      WHERE departmentid = s_deptid OR  id IN s_emp.
  IF sy-subrc = 0.
    SORT  it_emp  BY departmentid .
    IF it_emp IS NOT INITIAL.
      SELECT departmentid
             department_name
             date2
             time2
        FROM ztestdepartment INTO TABLE it_dept
        FOR ALL ENTRIES IN it_emp
        WHERE departmentid = it_emp-departmentid.
      IF sy-subrc = 0.
        SORT it_dept  BY departmentid.
      ENDIF.
    ENDIF.
  ENDIF.

  END-OF-SELECTION.

  LOOP AT it_emp ASSIGNING <fs_emp>.
    APPEND  INITIAL LINE TO i_final ASSIGNING <fs_final>.
    IF <fs_emp> IS  ASSIGNED.
      <fs_final>-id =  <fs_emp>-id.
      <fs_final>-departmentid =  <fs_emp>-departmentid.
      <fs_final>-first_name =  <fs_emp>-first_name.
      <fs_final>-second_name =  <fs_emp>-second_name.
      <fs_final>-age =  <fs_emp>-age.
      <fs_final>-place =  <fs_emp>-place.
      <fs_final>-phone_number =  <fs_emp>-phone_number.

    ENDIF.
    READ TABLE it_dept ASSIGNING <fs_dept> WITH KEY
                                    departmentid = <fs_emp>-departmentid
                                    BINARY SEARCH.
    IF sy-subrc = 0.
      IF <fs_dept> IS ASSIGNED.
        <fs_final>-department_name = <fs_dept>-department_name.
        <fs_final>-date2 = <fs_dept>-date2.
        <fs_final>-time2 =  <fs_dept>-time2.

      ENDIF.
    ENDIF.
  ENDLOOP.
  UNASSIGN <fs_emp>.
  UNASSIGN <fs_dept>.


  " Display Operation Performed "
  wa_layout-zebra = 'X'.
  PERFORM create_field_cat.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      is_layout     = wa_layout
      it_fieldcat   = it_fcat
    TABLES
      t_outtab      = i_final
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
*&---------------------------------------------------------------------*
*& Form create_field_cat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM create_field_cat .


  PERFORM append_fcat USING: 'ID ' 'EMP ID' 'C201',
                             'departmentid' 'DEPT ID '  space,
                             'department_name' 'DEPT NME ' 'C201',
                             'first_name' 'F NAME ' space,
                             'second_name' 'S NAME' 'C201',
                             'age' 'AGE' space,
                             'place' 'PLACE' 'C201',
                             'phone_number' 'PHN NO.' space,
                             'date2' 'DATE' 'C202',
                             'time2' 'TIME' space.

  CLEAR gv_col_pos.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form append_fcat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM append_fcat USING i_fieldname TYPE slis_fieldcat_alv-fieldname
                       seltext_m TYPE slis_fieldcat_alv-seltext_m
                       emphasize TYPE slis_fieldcat_alv-emphasize .
  gv_col_pos = gv_col_pos + 1.
  wa_fcat-col_pos = gv_col_pos.
  wa_fcat-fieldname  = i_fieldname.
  wa_fcat-seltext_m  = seltext_m.
  wa_fcat-emphasize  = emphasize.
  APPEND wa_fcat TO it_fcat.
  CLEAR : wa_fcat.
ENDFORM.