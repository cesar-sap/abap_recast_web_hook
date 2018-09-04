FUNCTION Z_SUMA.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(A) TYPE  INT4
*"     REFERENCE(B) TYPE  INT4
*"  EXPORTING
*"     REFERENCE(RESULT) TYPE  INT4
*"     REFERENCE(RESULT_VARIADO) TYPE  STRING
*"     REFERENCE(RESULT__AMPLIO) TYPE  STRING
*"     REFERENCE(RESULT_TODAY) TYPE  STRING
*"----------------------------------------------------------------------


result = a + b.

result_variado = 'gnanshs'.
result__amplio = result_variado.
result_today = 'Estmos en Walldorg'.

ENDFUNCTION.
