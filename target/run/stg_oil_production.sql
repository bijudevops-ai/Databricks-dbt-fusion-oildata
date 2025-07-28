create or replace view `bijucatalog`.`oil_data`.`stg_oil_production`
  
  
  
  as
    SELECT
  WELL_ID,
  DATE,
  OIL_BARRELS,
  GAS_CUBIC_FEET,
  WATER_BARRELS
FROM `bijucatalog`.`oil_data`.`oil_well_production_raw`
