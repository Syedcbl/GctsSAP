*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 15.02.2022 at 14:22:44
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZTESTDEPARTMENT.................................*
DATA:  BEGIN OF STATUS_ZTESTDEPARTMENT               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTESTDEPARTMENT               .
CONTROLS: TCTRL_ZTESTDEPARTMENT
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTESTDEPARTMENT               .
TABLES: ZTESTDEPARTMENT                .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .