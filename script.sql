
-- All data loaded in Semantic model for oil production and equipment metrics
select * from oil_production_metrics

-- Aggregation of oil production data from your oil_production_metrics model.
SELECT
    DATE,
    REGION,
    SUM(OIL_BARRELS) AS TOTAL_OIL,
    SUM(GAS_CUBIC_FEET) AS TOTAL_GAS,
    ROUND(AVG(EFFICIENCY_BARRELS_PER_HOUR), 2) 
FROM oil_production_metrics
GROUP BY DATE, REGION


SELECT
  DATE,
  REGION,
  SUM(OIL_BARRELS) AS TOTAL_OIL
FROM oil_production_metrics
GROUP BY DATE, REGION

-- Total Oil & Gas Production by Region and Date
SELECT
  DATE,
  REGION,
  SUM(OIL_BARRELS) AS TOTAL_OIL,
  SUM(GAS_CUBIC_FEET) AS TOTAL_GAS
FROM  oil_production_metrics
GROUP BY DATE, REGION

--Average Efficiency by Field
SELECT
  FIELD,
  ROUND(AVG(EFFICIENCY_BARRELS_PER_HOUR),2) AS AVG_EFFICIENCY
FROM oil_production_metrics
GROUP BY FIELD
ORDER BY AVG_EFFICIENCY DESC;

-- Top 5 Wells by Oil Production

SELECT
  WELL_ID,
  SUM(OIL_BARRELS) AS TOTAL_OIL
FROM oil_production_metrics
GROUP BY WELL_ID
ORDER BY TOTAL_OIL DESC
LIMIT 5;

--Equipment Downtime Analysis
SELECT
  REGION,
 round( SUM(TOTAL_DOWNTIME),2) AS TOTAL_DOWNTIME_HOURS,
  ROUND(SUM(OIL_BARRELS) / NULLIF(SUM(TOTAL_DOWNTIME) + 24, 0),2) AS OIL_PER_OPERATIONAL_HOUR
FROM oil_production_metrics
GROUP BY REGION
ORDER BY TOTAL_DOWNTIME_HOURS DESC;
--Monthly Oil Production Trend
SELECT
  DATE_TRUNC('month', DATE) AS MONTH,
  REGION,
  SUM(OIL_BARRELS) AS TOTAL_OIL
FROM oil_production_metrics
GROUP BY DATE_TRUNC('month', DATE), REGION
ORDER BY MONTH, REGION;
