*&---------------------------------------------------------------------*
*& Report ZWYUPLOADBDC_TEST2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zwyuploadbdc_test2.

PARAMETERS: p_file TYPE string.
PARAMETERS ctumode LIKE ctu_params-dismode DEFAULT 'N'.
PARAMETERS cupdate LIKE ctu_params-updmode DEFAULT 'A'.

TYPES: BEGIN OF ty_file_data,
         matnr TYPE rmmg1-matnr,
         mbrsh TYPE rmmg1-mbrsh,
         mtart TYPE rmmg1-mtart,
         werks TYPE rmmg1-werks,
         maktx TYPE makt-maktx,
         meins TYPE mara-meins,
         matkl TYPE mara-Matkl,
         ekgrp TYPE marc-ekgrp,

       END OF ty_file_data,

       BEGIN OF ty_final,
         matnr  TYPE rmmg1-matnr,
         mbrsh  TYPE rmmg1-mbrsh,
         mtart  TYPE rmmg1-mtart,
         werks  TYPE rmmg1-werks,
         maktx  TYPE makt-maktx,
         meins  TYPE mara-meins,
         matkl  TYPE mara-Matkl,
         ekgrp  TYPE marc-ekgrp,
         status TYPE char01,
         msg    TYPE bapiret2-message,
       END OF ty_final.

DATA: gt_file_data TYPE STANDARD TABLE OF ty_file_data,
      gt_final     TYPE STANDARD TABLE OF ty_final,
      gt_bdcdata   TYPE STANDARD TABLE OF bdcdata,
      gw_bdcdata   TYPE bdcdata,
      gt_messages  TYPE STANDARD TABLE OF bdcmsgcoll.

START-OF-SELECTION.
  PERFORM upload_file.

end-of-SELECTION.
  PERFORM process_file.
  PERFORM display_data.
*&---------------------------------------------------------------------*
*& Form upload_file
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM upload_file .

  CALL METHOD cl_gui_frontend_services=>gui_upload
    EXPORTING
      filename                = p_file
*     filetype                = 'ASC'
      has_field_separator     = 'X'
*     header_length           = 0
*     read_by_line            = 'X'
*     dat_mode                = SPACE
*     codepage                = SPACE
*     ignore_cerr             = ABAP_TRUE
*     replacement             = '#'
*     virus_scan_profile      =
*  IMPORTING
*     filelength              =
*     header                  =
    CHANGING
      data_tab                = gt_file_data
*     isscanperformed         = SPACE
    EXCEPTIONS
      file_open_error         = 1
      file_read_error         = 2
      no_batch                = 3
      gui_refuse_filetransfer = 4
      invalid_type            = 5
      no_authority            = 6
      unknown_error           = 7
      bad_data_format         = 8
      header_not_allowed      = 9
      separator_not_allowed   = 10
      header_too_long         = 11
      unknown_dp_error        = 12
      access_denied           = 13
      dp_out_of_memory        = 14
      disk_full               = 15
      dp_timeout              = 16
      not_supported_by_gui    = 17
      error_no_gui            = 18
      OTHERS                  = 19.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form process_file
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM process_file .
  DATA: lv_msgid      TYPE bapiret2-id,
        lv_msgnr      TYPE bapiret2-number,
        lv_textformat TYPE bapitga-textformat.


  lv_textformat = 'ASC'.
  CALL FUNCTION 'BDC_OPEN_GROUP'
    EXPORTING
*     CLIENT              = SY-MANDT
*     DEST                = FILLER8
      group               = 'TRNG_MM01'
*     HOLDDATE            = FILLER8
      keep                = 'X'
*     USER                = FILLER12
*     RECORD              = FILLER1
*     PROG                = SY-CPROG
*     DCPFM               = '%'
*     DATFM               = '%'
*     APP_AREA            = FILLER12
*     LANGU               = SY-LANGU
* IMPORTING
*     QID                 =
    EXCEPTIONS
      client_invalid      = 1
      destination_invalid = 2
      group_invalid       = 3
      group_is_locked     = 4
      holddate_invalid    = 5
      internal_error      = 6
      queue_error         = 7
      running             = 8
      system_lock_error   = 9
      user_invalid        = 10
      OTHERS              = 11.
  IF sy-subrc = 0.

    LOOP AT gt_file_data ASSIGNING FIELD-SYMBOL(<ls_file_data>).
      PERFORM bdc_dynpro      USING 'SAPLMGMM' '0060'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'RMMG1-MTART'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=ENTR'.
      PERFORM bdc_field       USING 'RMMG1-MATNR'
                                    <ls_file_data>-matnr.
      PERFORM bdc_field       USING 'RMMG1-MBRSH'
                                    <ls_file_data>-mbrsh.
      PERFORM bdc_field       USING 'RMMG1-MTART'
                                    <ls_file_data>-mtart.
      PERFORM bdc_dynpro      USING 'SAPLMGMM' '0070'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'MSICHTAUSW-DYTXT(10)'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=ENTR'.
      PERFORM bdc_field       USING 'MSICHTAUSW-KZSEL(01)'
                                    'X'.
      PERFORM bdc_field       USING 'MSICHTAUSW-KZSEL(02)'
                                    'X'.
      PERFORM bdc_field       USING 'MSICHTAUSW-KZSEL(10)'
                                    'X'.
      PERFORM bdc_dynpro      USING 'SAPLMGMM' '0080'.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'RMMG1-WERKS'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=ENTR'.
      PERFORM bdc_field       USING 'RMMG1-WERKS'
                                    <ls_file_data>-werks.
      PERFORM bdc_dynpro      USING 'SAPLMGMM' '4004'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=SP10'.
      PERFORM bdc_field       USING 'MAKT-MAKTX'
                                    <ls_file_data>-maktx.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'MARA-MATKL'.
      PERFORM bdc_field       USING 'MARA-MEINS'
                                    <ls_file_data>-meins.
      PERFORM bdc_field       USING 'MARA-MATKL'
                                    <ls_file_data>-matkl.
      PERFORM bdc_field       USING 'MARA-MTPOS_MARA'
                                    'NORM'.
      PERFORM bdc_dynpro      USING 'SAPLMGMM' '4000'.
      PERFORM bdc_field       USING 'BDC_OKCODE'
                                    '=BU'.
      PERFORM bdc_field       USING 'MAKT-MAKTX'
                                    <ls_file_data>-maktx.
      PERFORM bdc_field       USING 'BDC_CURSOR'
                                    'MARC-EKGRP'.
      PERFORM bdc_field       USING 'MARA-MEINS'
                                    <ls_file_data>-meins.
      PERFORM bdc_field       USING 'MARC-EKGRP'
                                    <ls_file_data>-ekgrp.
      PERFORM bdc_field       USING 'MARA-MATKL'
                                    <ls_file_data>-matkl.

      CALL FUNCTION 'BDC_INSERT'
        EXPORTING
          tcode            = 'MM01'
*         POST_LOCAL       = NOVBLOCAL
*         PRINTING         = NOPRINT
*         SIMUBATCH        = ' '
*         CTUPARAMS        = ' '
        TABLES
          dynprotab        = gt_bdcdata
        EXCEPTIONS
          internal_error   = 1
          not_open         = 2
          queue_error      = 3
          tcode_invalid    = 4
          printing_invalid = 5
          posting_invalid  = 6
          OTHERS           = 7.

*CALL TRANSACTION 'MM01' USING gt_bdcdata MODE CTUMODE UPDATE cupdate MESSAGES INTO gt_messages.
*PERFORM handle_error.

      READ TABLE gt_messages ASSIGNING FIELD-SYMBOL(<ls_messages>) WITH KEY msgtyp = 'E'.
      IF <ls_messages> IS ASSIGNED.
        APPEND INITIAL LINE TO gt_final ASSIGNING FIELD-SYMBOL(<ls_final>).
        IF <ls_final> IS ASSIGNED.
          MOVE-CORRESPONDING <ls_file_data> TO <ls_final>.
          <ls_final>-status = 'E'.
          lv_msgid = <ls_messages>-msgid.
          lv_msgnr = <ls_messages>-msgnr.
          CALL FUNCTION 'BAPI_MESSAGE_GETDETAIL'
            EXPORTING
              id         = lv_MSGID
              number     = lv_msgnr
*             LANGUAGE   = SY-LANGU
              textformat = lv_textformat
*             LINKPATTERN        =
*             MESSAGE_V1 =
*             MESSAGE_V2 =
*             MESSAGE_V3 =
*             MESSAGE_V4 =
*             LANGUAGE_ISO       =
*             LINE_SIZE  =
            IMPORTING
              message    = <ls_final>-msg
*             RETURN     =
*     TABLES
*             TEXT       =
            .

*    <ls_final>-msg = 'Error'.
          UNASSIGN <ls_final>.
        ENDIF.
      ELSE.
        APPEND INITIAL LINE TO gt_final ASSIGNING <ls_final>.
        IF <ls_final> IS ASSIGNED.
          MOVE-CORRESPONDING <ls_file_data> TO <ls_final>.
          <ls_final>-status = 'S'.
          <ls_final>-msg = 'Success'.
          UNASSIGN <ls_final>.
        ENDIF.
      ENDIF.

      CLEAR: gt_bdcdata, gt_messages.
    ENDLOOP.

    CALL FUNCTION 'BDC_CLOSE_GROUP'
      EXCEPTIONS
        not_open    = 1
        queue_error = 2
        OTHERS      = 3.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form bdc_dynpro
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_
*&      --> P_
*&---------------------------------------------------------------------*
FORM bdc_dynpro  USING program dynpro.
  CLEAR gw_BDCDATA.
  gw_BDCDATA-program  = program.
  gw_BDCDATA-dynpro   = dynpro.
  gw_BDCDATA-dynbegin = 'X'.
  APPEND gw_BDCDATA TO gt_bdcdata.

ENDFORM.

FORM bdc_field USING fnam fval.
*  IF FVAL <> NODATA.
  CLEAR gw_BDCDATA.
  gw_BDCDATA-fnam = fnam.
  gw_BDCDATA-fval = fval.
  APPEND gw_BDCDATA TO gt_bdcdata.
*  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form display_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_data .

  DATA: lr_salv TYPE REF TO cl_salv_table.

*TRY.
  CALL METHOD cl_salv_table=>factory
*  EXPORTING
*    list_display   = IF_SALV_C_BOOL_SAP=>FALSE
*    r_container    =
*    container_name =
    IMPORTING
      r_salv_table = lr_salv
    CHANGING
      t_table      = gt_final.
*  CATCH cx_salv_msg.
*ENDTRY.

  CALL METHOD lr_salv->display.


ENDFORM.