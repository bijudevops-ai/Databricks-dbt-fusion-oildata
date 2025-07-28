SELECT
  EQUIPMENT_ID,
  WELL_ID,
  DATE,
  DOWNTIME_HOURS
FROM {{ source('oil_data', 'equipment_downtime_raw') }}
