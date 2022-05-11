*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 27.01.2022 at 11:57:16
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZWYHEALTH.......................................*
DATA:  BEGIN OF STATUS_ZWYHEALTH                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZWYHEALTH                     .
CONTROLS: TCTRL_ZWYHEALTH
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZWYHEALTH                     .
TABLES: ZWYHEALTH                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .