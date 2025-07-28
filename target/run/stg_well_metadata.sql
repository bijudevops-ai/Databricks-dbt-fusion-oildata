create or replace view `bijucatalog`.`oil_data`.`stg_well_metadata`
  
  
  
  as
    SELECT
  WELL_ID,
  FIELD,
  REGION,
  INSTALL_DATE
FROM `bijucatalog`.`oil_data`.`well_metadata`
