*&---------------------------------------------------------------------*
*& Include          ZWYMODULETEST_TOP
*&---------------------------------------------------------------------*

TABLES ztestemployee.
TABLES ztestdepartment.

" Structure For ztestemployee "

TYPES: BEGIN OF y_emp,
         id           TYPE zwyempid2,
         departmentid TYPE zwydeptid,
         first_name   TYPE zwyfname2,
         second_name  TYPE zwysname,
         age          TYPE zwyage,
         place        TYPE zwyplace,
         phone_number TYPE zwyphno,

       END OF y_emp.

" Structure For ztestdepartment "

TYPES: BEGIN OF y_dept,
         departmentid    TYPE  zwydeptid,
         department_name TYPE zwydeptn,
         date2           TYPE  zwydate,
         time2           TYPE  zwytime,
       END OF y_dept.

" Structure For Final Table"

TYPES: BEGIN OF t_final,
         id              TYPE zwyempid2,
         departmentid    TYPE zwydeptid,
         department_name TYPE zwydeptn,
         first_name      TYPE zwyfname2,
         second_name     TYPE zwysname,
         age             TYPE zwyage,
         place           TYPE zwyplace,
         phone_number    TYPE zwyphno,
         date2           TYPE  zwydate,
         time2           TYPE  zwytime,

       END OF t_final.

DATA: it_emp  TYPE STANDARD TABLE OF y_emp, " Internal Table"
      it_dept TYPE STANDARD TABLE OF y_dept, " Internal Table"
      i_final TYPE STANDARD TABLE OF t_final,"Internal Table"
      e_id TYPE ztestemployee-id,
      t_date  TYPE zwydate.


FIELD-SYMBOLS : <fs_emp>   TYPE y_emp,
                <fs_dept>  TYPE y_dept,
                <fs_final> TYPE t_final.

DATA: it_fcat    TYPE slis_t_fieldcat_alv,
      wa_fcat    TYPE slis_fieldcat_alv,
      wa_layout  TYPE slis_layout_alv,
      gv_col_pos TYPE i.