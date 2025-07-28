create or replace view `bijucatalog`.`oil_data`.`stg_equipment_downtime`
  
  
  
  as
    SELECT
  EQUIPMENT_ID,
  WELL_ID,
  DATE,
  DOWNTIME_HOURS
FROM `bijucatalog`.`oil_data`.`equipment_downtime_raw`
