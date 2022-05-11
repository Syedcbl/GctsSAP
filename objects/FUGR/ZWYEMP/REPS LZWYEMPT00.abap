*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 27.01.2022 at 11:52:12
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZWYEMP..........................................*
DATA:  BEGIN OF STATUS_ZWYEMP                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZWYEMP                        .
CONTROLS: TCTRL_ZWYEMP
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZWYEMP                        .
TABLES: ZWYEMP                         .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .