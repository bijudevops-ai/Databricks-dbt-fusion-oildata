WITH prod AS (
    SELECT
        p.WELL_ID,
        w.FIELD,
        w.REGION,
        p.DATE,
        p.OIL_BARRELS,
        p.GAS_CUBIC_FEET,
        p.WATER_BARRELS
    FROM {{ ref('stg_oil_production') }} p
    JOIN {{ ref('stg_well_metadata') }} w
      ON p.WELL_ID = w.WELL_ID
),
downtime AS (
    SELECT
        WELL_ID,
        DATE,
        SUM(DOWNTIME_HOURS) AS TOTAL_DOWNTIME
    FROM {{ ref('stg_equipment_downtime') }}
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
 AND prod.DATE = downtime.DATE
