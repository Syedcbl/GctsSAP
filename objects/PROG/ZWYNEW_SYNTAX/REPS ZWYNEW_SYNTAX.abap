*&---------------------------------------------------------------------*
*& Report ZWYNEW_SYNTAX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZWYNEW_SYNTAX.

************** Inline Declarations  **********

**DATA text TYPE string.
**text = 'ABC'.
*
**DATA(text) = 'ABC'.
*write:/ text.

*SELECT SINGLE ebeln as f1,
*              ebelp as abc
*         FROM ekpo
*         INTO @DATA(ls_struct).
*
*WRITE: / ls_struct-f1,
*         ls_struct-abc.

**** Conversion ****

*DATA(text) = 'po'.
*
*DATA(xstr) = cl_abap_codepage=>convert_to( source = CONV string( text ) ).
*
**OR
**
**DATA(xstr) = cl_abap_codepage=>convert_to( source = CONV #( text ) ).
*
*write:/ xstr.