-- created_at: 2025-07-26T22:45:47.277897+00:00
-- dialect: databricks
-- node_id: not available
-- desc: Ensure catalogs and schemas exist
CREATE SCHEMA IF NOT EXISTS `bijucatalog`.`oil_data`;
-- created_at: 2025-07-26T22:45:47.800169+00:00
-- dialect: databricks
-- node_id: model.oil_dbt_fusion.stg_well_metadata
-- desc: get_relation adapter call
DESCRIBE TABLE EXTENDED `bijucatalog`.`oil_data`.`stg_well_metadata` AS JSON;
-- created_at: 2025-07-26T22:45:47.800169+00:00
-- dialect: databricks
-- node_id: model.oil_dbt_fusion.stg_oil_production
-- desc: get_relation adapter call
DESCRIBE TABLE EXTENDED `bijucatalog`.`oil_data`.`stg_oil_production` AS JSON;
-- created_at: 2025-07-26T22:45:47.800170+00:00
-- dialect: databricks
-- node_id: model.oil_dbt_fusion.stg_equipment_downtime
-- desc: get_relation adapter call
DESCRIBE TABLE EXTENDED `bijucatalog`.`oil_data`.`stg_equipment_downtime` AS JSON;
-- created_at: 2025-07-26T22:45:48.132638+00:00
-- dialect: databricks
-- node_id: model.oil_dbt_fusion.stg_well_metadata
-- desc: execute adapter call
create or replace view `bijucatalog`.`oil_data`.`stg_well_metadata`
  
  
  
  as
    SELECT
  WELL_ID,
  FIELD,
  REGION,
  INSTALL_DATE
FROM `bijucatalog`.`oil_data`.`well_metadata`;
-- created_at: 2025-07-26T22:45:48.674300+00:00
-- dialect: databricks
-- node_id: model.oil_dbt_fusion.stg_equipment_downtime
-- desc: execute adapter call
create or replace view `bijucatalog`.`oil_data`.`stg_equipment_downtime`
  
  
  
  as
    SELECT
  EQUIPMENT_ID,
  WELL_ID,
  DATE,
  DOWNTIME_HOURS
FROM `bijucatalog`.`oil_data`.`equipment_downtime_raw`;
-- created_at: 2025-07-26T22:45:48.674299+00:00
-- dialect: databricks
-- node_id: model.oil_dbt_fusion.stg_oil_production
-- desc: execute adapter call
create or replace view `bijucatalog`.`oil_data`.`stg_oil_production`
  
  
  
  as
    SELECT
  WELL_ID,
  DATE,
  OIL_BARRELS,
  GAS_CUBIC_FEET,
  WATER_BARRELS
FROM `bijucatalog`.`oil_data`.`oil_well_production_raw`;
-- created_at: 2025-07-26T22:45:49.426119+00:00
-- dialect: databricks
-- node_id: model.oil_dbt_fusion.oil_production_metrics
-- desc: get_relation adapter call
DESCRIBE TABLE EXTENDED `bijucatalog`.`oil_data`.`oil_production_metrics` AS JSON;
-- created_at: 2025-07-26T22:45:49.774447+00:00
-- dialect: databricks
-- node_id: model.oil_dbt_fusion.oil_production_metrics
-- desc: execute adapter call
create or replace view `bijucatalog`.`oil_data`.`oil_production_metrics`
  
  
  
  as
    WITH prod AS (
    SELECT
        p.WELL_ID,
        w.FIELD,
        w.REGION,
        p.DATE,
        p.OIL_BARRELS,
        p.GAS_CUBIC_FEET,
        p.WATER_BARRELS
    FROM `bijucatalog`.`oil_data`.`stg_oil_production` p
    JOIN `bijucatalog`.`oil_data`.`stg_well_metadata` w
      ON p.WELL_ID = w.WELL_ID
),
downtime AS (
    SELECT
        WELL_ID,
        DATE,
        SUM(DOWNTIME_HOURS) AS TOTAL_DOWNTIME
    FROM `bijucatalog`.`oil_data`.`stg_equipment_downtime`
    GROUP BY WELL_ID, DATE
)
SELECT
    prod.WELL_ID,
    prod.FIELD,
    prod.REGION,
    prod.DATE,
    prod.OIL_BARRELS,
    prod.GAS_CUBIC_FEET,
    prod.WATER_BARRELS,
    downtime.TOTAL_DOWNTIME,
    (prod.OIL_BARRELS / NULLIF(downtime.TOTAL_DOWNTIME + 24, 0)) AS EFFICIENCY_BARRELS_PER_HOUR
FROM prod
LEFT JOIN downtime
  ON prod.WELL_ID = downtime.WELL_ID
 AND prod.DATE = downtime.DATE;
