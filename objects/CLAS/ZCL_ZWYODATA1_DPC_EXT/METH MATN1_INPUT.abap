
 METHOD matn1_input.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = ch_value
      IMPORTING
        output = ch_value.
  ENDMETHOD.