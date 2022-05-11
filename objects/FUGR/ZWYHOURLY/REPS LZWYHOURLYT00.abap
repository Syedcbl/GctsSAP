*---------------------------------------------------------------------*
*    view related data declarations
*   generation date: 27.01.2022 at 11:58:08
*   view maintenance generator version: #001407#
*---------------------------------------------------------------------*
*...processing: ZWYHOURLY.......................................*
DATA:  BEGIN OF STATUS_ZWYHOURLY                     .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZWYHOURLY                     .
CONTROLS: TCTRL_ZWYHOURLY
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZWYHOURLY                     .
TABLES: ZWYHOURLY                      .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .