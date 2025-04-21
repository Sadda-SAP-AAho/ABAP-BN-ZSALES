CLASS zcl_test_tables DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST_TABLES IMPLEMENTATION.


METHOD if_oo_adt_classrun~main.

*SELECT Product, Plant, StorageLocation, InventoryStockType,
*       MaterialBaseUnit, MatlWrhsStkQtyInMatlBaseUnit
*  FROM I_STOCKQUANTITYCURRENTVALUE_2(
*       p_displaycurrency = 'INR'
*       ) WITH PRIVILEGED ACCESS
*  INTO TABLE @DATA(lt_stock_data).
*delete from zinvoicedatatab1 where comp_code = 'BN09'.
*delete from zinv_mst.
*select * from zinv_mst
*into table @data(it).
*
*loop at it into data(wa).
*wa-processed = ''.
*wa-reference_doc = ''.
*wa-reference_doc_del = ''.
*wa-reference_doc_invoice = ''.
*wa-status = ''.
*modify zinv_mst from @wa.
*endloop.

*select * from zinvoicedatatab1
*into table @data(it).
*
*loop at it into data(wa).
**wa-processed = ''.
**wa-reference_doc = ''.
**wa-reference_doc_del = ''.
**wa-reference_doc_invoice = ''.
**wa-status = 'Sales Order Created'.
**modify zinv_mst from @wa.
*endloop.

*delete from zinvoicedatatab1 where plant is INITIAL.

ENDMETHOD.
ENDCLASS.
