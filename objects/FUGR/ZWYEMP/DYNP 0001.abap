PROCESS BEFORE OUTPUT.
 MODULE LISTE_INITIALISIEREN.
 LOOP AT EXTRACT WITH CONTROL
  TCTRL_ZWYEMP CURSOR NEXTLINE.
   MODULE LISTE_SHOW_LISTE.
 ENDLOOP.
*
PROCESS AFTER INPUT.
 MODULE LISTE_EXIT_COMMAND AT EXIT-COMMAND.
 MODULE LISTE_BEFORE_LOOP.
 LOOP AT EXTRACT.
   MODULE LISTE_INIT_WORKAREA.
   CHAIN.
    FIELD ZWYEMP-EMP_ID .
    FIELD ZWYEMP-LAST_NAME .
    FIELD ZWYEMP-FIRST_NAME .
    FIELD ZWYEMP-HLTH_PLAN .
    FIELD ZWYEMP-ADDR1 .
    FIELD ZWYEMP-ADDR2 .
    FIELD ZWYEMP-CITY .
    FIELD ZWYEMP-REGION .
    FIELD ZWYEMP-POST_CODE .
    FIELD ZWYEMP-COUNTRY .
    MODULE SET_UPDATE_FLAG ON CHAIN-REQUEST.
   ENDCHAIN.
   FIELD VIM_MARKED MODULE LISTE_MARK_CHECKBOX.
   CHAIN.
    FIELD ZWYEMP-EMP_ID .
    MODULE LISTE_UPDATE_LISTE.
   ENDCHAIN.
 ENDLOOP.
 MODULE LISTE_AFTER_LOOP.