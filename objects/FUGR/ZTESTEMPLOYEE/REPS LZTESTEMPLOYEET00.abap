*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 15.02.2022 at 14:18:29
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZTESTEMPLOYEE...................................*
DATA:  BEGIN OF STATUS_ZTESTEMPLOYEE                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTESTEMPLOYEE                 .
CONTROLS: TCTRL_ZTESTEMPLOYEE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTESTEMPLOYEE                 .
TABLES: ZTESTEMPLOYEE                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .