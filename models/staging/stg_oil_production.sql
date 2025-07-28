SELECT
  WELL_ID,
  DATE,
  OIL_BARRELS,
  GAS_CUBIC_FEET,
  WATER_BARRELS
FROM {{ source('oil_data', 'oil_well_production_raw') }}
