  method ZPURCHASE_REQ_HE_UPDATE_ENTITY.
  RAISE EXCEPTION TYPE /iwbep/cx_mgw_not_impl_exc
    EXPORTING
      textid = /iwbep/cx_mgw_not_impl_exc=>method_not_implemented
      method = 'ZPURCHASE_REQ_HE_UPDATE_ENTITY'.
  endmethod.