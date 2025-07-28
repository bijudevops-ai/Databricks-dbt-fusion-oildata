SELECT
  WELL_ID,
  FIELD,
  REGION,
  INSTALL_DATE
FROM {{ source('oil_data', 'well_metadata') }}
