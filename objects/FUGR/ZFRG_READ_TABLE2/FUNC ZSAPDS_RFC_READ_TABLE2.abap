FUNCTION ZSAPDS_RFC_READ_TABLE2 .
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(QUERY_TABLE) TYPE  DD02L-TABNAME
*"     VALUE(DELIMITER) TYPE  SONV-FLAG OPTIONAL
*"     VALUE(NO_DATA) TYPE  SONV-FLAG OPTIONAL
*"     VALUE(ROWSKIPS) TYPE  SOID-ACCNT OPTIONAL
*"     VALUE(ROWCOUNT) TYPE  SOID-ACCNT OPTIONAL
*"     VALUE(DATE) TYPE  DATS OPTIONAL
*"  EXPORTING
*"     VALUE(OUT_TABLE) TYPE  DD02L-TABNAME
*"  TABLES
*"      OPTIONS STRUCTURE  /SAPDS/RFC_DB_OPT
*"      FIELDS STRUCTURE  RFC_DB_FLD
*"      TBLOUT128 STRUCTURE  /SAPDS/TAB128
*"      TBLOUT512 STRUCTURE  /SAPDS/TAB512
*"      TBLOUT2048 STRUCTURE  /SAPDS/TAB2048
*"      TBLOUT8192 STRUCTURE  /SAPDS/TAB8192
*"      TBLOUT30000 STRUCTURE  /SAPDS/TAB30K
*"  EXCEPTIONS
*"      TABLE_NOT_AVAILABLE
*"      TABLE_WITHOUT_DATA
*"      OPTION_NOT_VALID
*"      FIELD_NOT_VALID
*"      NOT_AUTHORIZED
*"      DATA_BUFFER_EXCEEDED
*"----------------------------------------------------------------------


DATA: ln type i, msg(128).

*
*INIT_AUTH_CHECK 'ZSAPDS_RFC_READ_TABLE2'.
*ADD_AUTH_CHECK_PARAM 'QUERY_TABLE' QUERY_TABLE.
*CALL_AUTH_CHECK.

PERFORM Z_BODS_RFC_READ_TABLE2_FORM
  TABLES
     OPTIONS
     FIELDS
     TBLOUT128
     TBLOUT512
     TBLOUT2048
     TBLOUT8192
     TBLOUT30000
  USING
     QUERY_TABLE
     DELIMITER
     NO_DATA
     ROWSKIPS
     ROWCOUNT
  CHANGING
     OUT_TABLE.

ENDFUNCTION.


FORM Z_BODS_RFC_READ_TABLE2_FORM
TABLES
OPTIONS STRUCTURE  RFC_DB_OPT
FIELDS STRUCTURE  RFC_DB_FLD
TBLOUT128 STRUCTURE  /SAPDS/TAB128
TBLOUT512 STRUCTURE  /SAPDS/TAB512
TBLOUT2048 STRUCTURE  /SAPDS/TAB2048
TBLOUT8192 STRUCTURE  /SAPDS/TAB8192
TBLOUT30000 STRUCTURE  /SAPDS/TAB30K
USING
QUERY_TABLE LIKE  DD02L-TABNAME
DELIMITER LIKE  SONV-FLAG
NO_DATA LIKE  SONV-FLAG
ROWSKIPS LIKE  SOID-ACCNT
VALUE(ROWCOUNT) LIKE  SOID-ACCNT
CHANGING
OUTTAB LIKE  DD02L-TABNAME.

DATA: mylist TYPE string_hashed_table.
DATA line1 TYPE string.
DATA OPTIONS_NEW LIKE TABLE OF RFC_DB_OPT WITH HEADER LINE.

DATA TABTYPE TYPE I.
CALL FUNCTION 'VIEW_AUTHORITY_CHECK'
EXPORTING
VIEW_ACTION                    = 'S'
VIEW_NAME              = QUERY_TABLE
EXCEPTIONS
NO_AUTHORITY                   = 2
NO_CLIENTINDEPENDENT_AUTHORITY = 2
NO_LINEDEPENDENT_AUTHORITY     = 2
OTHERS                         = 1.

IF SY-SUBRC = 2.
RAISE NOT_AUTHORIZED.
ELSEIF SY-SUBRC = 1.
RAISE TABLE_NOT_AVAILABLE.
ENDIF.

* ---------------------------------------------
*  find out about the structure of QUERY_TABLE
* ---------------------------------------------
DATA BEGIN OF TABLE_STRUCTURE OCCURS 10.
INCLUDE STRUCTURE DFIES.
DATA END OF TABLE_STRUCTURE.
"DATA TABLE_HEADER LIKE X030L.
DATA TABLE_TYPE TYPE DD02V-TABCLASS.

CALL FUNCTION 'DDIF_FIELDINFO_GET'
EXPORTING
TABNAME              = QUERY_TABLE
*   FIELDNAME            = '' ''
*   LANGU                = SY-LANGU
*   LFIELDNAME           = '' ''
*   ALL_TYPES            = '' ''
*   GROUP_NAMES          = '' ''
IMPORTING
*   X030L_WA             =
DDOBJTYPE            = TABLE_TYPE
*   DFIES_WA             =
*   LINES_DESCR          =
TABLES
DFIES_TAB            = TABLE_STRUCTURE
*   FIXED_VALUES         =
EXCEPTIONS
NOT_FOUND            = 1
INTERNAL_ERROR       = 2
OTHERS               = 3
.
IF SY-SUBRC <> 0.
RAISE TABLE_NOT_AVAILABLE.
ENDIF.
IF TABLE_TYPE = 'INTTAB'.
RAISE TABLE_WITHOUT_DATA.
ENDIF.

* --------------------------------------------
*  isolate first field of DATA as output field
*  (i.e. allow for changes to structure DATA!)
* --------------------------------------------
FIELD-SYMBOLS <D>.

* ------------------------------------
*  if FIELDS are not specified, read
*  all available fields
* ------------------------------------
DATA NUMBER_OF_FIELDS TYPE I.
DESCRIBE TABLE FIELDS LINES NUMBER_OF_FIELDS.
IF NUMBER_OF_FIELDS = 0.
LOOP AT TABLE_STRUCTURE.
MOVE TABLE_STRUCTURE-FIELDNAME
TO FIELDS-FIELDNAME.
APPEND FIELDS.
ENDLOOP.
ENDIF.

DATA: BEGIN OF tblout50000,
  wa TYPE STRING.
  DATA: END OF tblout50000.
  DATA wa LIKE tblout50000.
  DATA wa1 TYPE STRING.
  DATA: isString.

* ---------------------------------------------
*  for each field which has to be read, copy
*  structure information into tables FIELDS_INT
* (internal use) and FIELDS (output)
* ---------------------------------------------
DATA: BEGIN OF FIELDS_INT OCCURS 10,
FIELDNAME  LIKE TABLE_STRUCTURE-FIELDNAME,
TYPE       LIKE TABLE_STRUCTURE-INTTYPE,
DECIMALS   LIKE TABLE_STRUCTURE-DECIMALS,
LENGTH_SRC LIKE TABLE_STRUCTURE-INTLEN,
LENGTH_DST LIKE TABLE_STRUCTURE-LENG,
OFFSET_SRC LIKE TABLE_STRUCTURE-OFFSET,
OFFSET_DST LIKE TABLE_STRUCTURE-OFFSET,
END OF FIELDS_INT,
LINE_CURSOR TYPE I.

LINE_CURSOR = 0.
*  for each field which has to be read ...
LOOP AT FIELDS.

READ TABLE TABLE_STRUCTURE WITH
KEY FIELDNAME = FIELDS-FIELDNAME.
IF SY-SUBRC NE 0.
RAISE FIELD_NOT_VALID.
ENDIF.

* compute the place for field contents in DATA rows:
* if not first field in row, allow space
* for delimiter
IF LINE_CURSOR <> 0.
IF NO_DATA EQ SPACE AND DELIMITER NE SPACE.
MOVE DELIMITER TO TBLOUT30000-WA+LINE_CURSOR.
ENDIF.
LINE_CURSOR = LINE_CURSOR + STRLEN( DELIMITER ).
ENDIF.

* ... copy structure information into tables FIELDS_INT
* (which is used internally during SELECT) ...
FIELDS_INT-FIELDNAME  = TABLE_STRUCTURE-FIELDNAME.
FIELDS_INT-LENGTH_SRC = TABLE_STRUCTURE-INTLEN.
FIELDS_INT-LENGTH_DST = TABLE_STRUCTURE-LENG.
FIELDS_INT-OFFSET_SRC = TABLE_STRUCTURE-OFFSET.
FIELDS_INT-OFFSET_DST = LINE_CURSOR.
FIELDS_INT-TYPE       = TABLE_STRUCTURE-INTTYPE.
FIELDS_INT-DECIMALS   = TABLE_STRUCTURE-DECIMALS.
IF FIELDS_INT-TYPE = 'P'.
"#EC CI_INT8_OK
FIELDS_INT-LENGTH_DST = FIELDS_INT-LENGTH_DST + 1.
IF FIELDS_INT-DECIMALS IS NOT INITIAL.
FIELDS_INT-LENGTH_DST = FIELDS_INT-LENGTH_DST + 1.
ENDIF.
ELSEIF FIELDS_INT-TYPE = 'X'.
FIELDS_INT-LENGTH_DST = FIELDS_INT-LENGTH_DST * 2.
ELSEIF table_structure-inttype = 'b' OR
  table_structure-inttype = 's' OR
  table_structure-inttype = 'I'.
  fields_int-length_dst = fields_int-length_dst + 1.
ELSEIF table_structure-inttype = 'g'.
  isString = 'Y'.
ENDIF.
* compute the place for contents of next field
* in DATA rows
*  APPEND 'LINE_CURSOR = LINE_CURSOR + TABLE_STRUCTURE-LENG.
LINE_CURSOR = LINE_CURSOR + FIELDS_INT-LENGTH_DST.
APPEND FIELDS_INT.

* ... and into table FIELDS (which is output to
* the caller)
FIELDS-FIELDTEXT = TABLE_STRUCTURE-FIELDTEXT.
FIELDS-TYPE      = TABLE_STRUCTURE-INTTYPE.
FIELDS-LENGTH    = FIELDS_INT-LENGTH_DST.
FIELDS-OFFSET    = FIELDS_INT-OFFSET_DST.
MODIFY FIELDS.

ENDLOOP.
* end of loop at FIELDS

IF LINE_CURSOR < 129.
  OUTTAB = 'TBLOUT128'.
  TABTYPE = 1.
  MOVE TBLOUT30000-WA+0(128) TO TBLOUT128-WA.
  ASSIGN COMPONENT 0 OF STRUCTURE TBLOUT128 TO <D>.
ELSEIF LINE_CURSOR < 513.
  OUTTAB = 'TBLOUT512'.
  TABTYPE = 2.
  MOVE TBLOUT30000-WA+0(512) TO TBLOUT512-WA.
  ASSIGN COMPONENT 0 OF STRUCTURE TBLOUT512 TO <D>.
ELSEIF LINE_CURSOR < 2049.
  OUTTAB = 'TBLOUT2048'.
  TABTYPE = 3.
  MOVE TBLOUT30000-WA+0(2048) TO TBLOUT2048-WA.
  ASSIGN COMPONENT 0 OF STRUCTURE TBLOUT2048 TO <D>.
ELSEIF LINE_CURSOR < 8193.
  OUTTAB = 'TBLOUT8192'.
  TABTYPE = 4.
  MOVE TBLOUT30000-WA+0(8192) TO TBLOUT8192-WA.
  ASSIGN COMPONENT 0 OF STRUCTURE TBLOUT8192 TO <D>.
ELSEIF LINE_CURSOR < 30001.
  OUTTAB = 'TBLOUT30000'.
  TABTYPE = 5.
  ASSIGN COMPONENT 0 OF STRUCTURE TBLOUT30000 TO <D>.
ELSEIF NO_DATA EQ SPACE.
RAISE DATA_BUFFER_EXCEEDED.
ENDIF.

IF isString = 'Y'.
  OUTTAB = 'TBLOUT30000'.
  TABTYPE = 5.
  ASSIGN COMPONENT 0 OF STRUCTURE TBLOUT50000 TO <D>.
  line_cursor = 50000.
ENDIF.

* ---------------------------------------------------
*  read data from the database and copy relevant
*  portions into DATA
* ---------------------------------------------------
* output data only if NO_DATA equals space (otherwise
* the structure information in FIELDS is the only
* result of the module)
IF NO_DATA EQ SPACE.

DATA: BEGIN OF WORK, align type f, BUFFER(30000), END OF WORK.

FIELD-SYMBOLS: <WA> TYPE ANY, <COMP> TYPE ANY.

IF isString IS INITIAL.
  ASSIGN WORK-BUFFER TO <WA> CASTING TYPE (QUERY_TABLE).
ELSE.
  DATA dref TYPE REF TO data.
  CREATE DATA dref TYPE (query_table).
  ASSIGN dref->* TO <wa>.
ENDIF.

IF ROWCOUNT > 0.
ROWCOUNT = ROWCOUNT + ROWSKIPS.
ENDIF.

DATA lv_table TYPE string.   "#EC NEEDED
TRY.
    lv_table = cl_abap_dyn_prg=>check_table_name_str(
      val = QUERY_TABLE
      packages = '' ).
  CATCH cx_abap_not_a_table
        cx_abap_not_in_package.
ENDTRY.

 LOOP AT OPTIONS.
   TRY.
    REFRESH mylist.
    line1 = OPTIONS-TEXT.
    CONDENSE line1.
    INSERT line1 INTO TABLE mylist.
    OPTIONS_NEW-TEXT = cl_abap_dyn_prg=>check_whitelist_tab(
                                  val       = OPTIONS-TEXT
                                  whitelist = mylist ).
   CATCH cx_abap_not_in_whitelist.
   ENDTRY.
   APPEND OPTIONS_NEW.
 ENDLOOP.

 DATA QUERY_TABLE1 TYPE DD02L-TABNAME.
   TRY.
    REFRESH mylist.
    line1 = QUERY_TABLE.
    CONDENSE line1.
    INSERT line1 INTO TABLE mylist.
    QUERY_TABLE1 = cl_abap_dyn_prg=>check_whitelist_tab(
                                  val       = QUERY_TABLE
                                  whitelist = mylist ).
   CATCH cx_abap_not_in_whitelist.
   ENDTRY.

SELECT * FROM (QUERY_TABLE1) INTO <WA>
WHERE (OPTIONS_NEW).

IF SY-DBCNT GT ROWSKIPS.

*   copy all relevant fields into DATA
*   (output) table
LOOP AT FIELDS_INT.

IF isString = 'Y'.
  ASSIGN COMPONENT sy-tabix
         OF STRUCTURE <WA> TO <COMP>.
  MOVE <comp> TO WA1.
  CONCATENATE WA-WA WA1 delimiter INTO WA-WA IN CHARACTER MODE.
  CLEAR WA1.
ELSE.
IF FIELDS_INT-TYPE = 'P'.
ASSIGN COMPONENT FIELDS_INT-FIELDNAME
OF STRUCTURE <WA> TO <COMP>
TYPE     FIELDS_INT-TYPE
DECIMALS FIELDS_INT-DECIMALS.
ELSE.
ASSIGN COMPONENT FIELDS_INT-FIELDNAME
OF STRUCTURE <WA> TO <COMP>
TYPE     FIELDS_INT-TYPE.
ENDIF.
MOVE <COMP> TO
<D>+FIELDS_INT-OFFSET_DST(FIELDS_INT-LENGTH_DST).
ENDIF.
ENDLOOP.
*   end of loop at FIELDS_INT

IF isString = 'Y'.
   TBLOUT30000 = WA-WA.
ENDIF.

CASE TABTYPE.
  WHEN 1.      APPEND TBLOUT128.
  WHEN 2.      APPEND TBLOUT512.
  WHEN 3.      APPEND TBLOUT2048.
  WHEN 4.      APPEND TBLOUT8192.
  WHEN OTHERS. APPEND TBLOUT30000.
ENDCASE.

IF isString = 'Y'.
   CLEAR WA.
ENDIF.

IF ROWCOUNT > 0 AND SY-DBCNT GE ROWCOUNT.
EXIT.
ENDIF.

ENDIF.

ENDSELECT.

ENDIF.

ENDFORM.


FORM SAPDS_RFC_READ_TABLE2_GETV CHANGING VERSION TYPE C.

VERSION = '14.1.0.0'.

ENDFORM.