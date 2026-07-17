-- ==============================================================================
-- SHREYA | ENTERPRISE DATA ARCHITECTURE
-- PROJECT 2: D2C PERFORMANCE MARKETING & CUSTOMER ACQUISITION COST (CAC) AUDIT
-- BACKEND SQL ANALYTICAL MATRIX SCRIPT (VERIFIED SCHEMATIC COMPLIANCE)
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- COLUMN STRUCTURAL SCHEMA MAPPING REFERENCE:
-- c1 = Campaign_ID (Text)
-- c2 = Channel (Text Platform Description)
-- c3 = Ad_Spend_INR (Raw Capital Expenditure Strings)
-- c4 = Conversions (Raw Conversion Event Logs)
-- c5 = Total_Revenue_INR (Gross Revenue Output Strings)
-- ------------------------------------------------------------------------------

-- AUDIT QUERY 1: MACRO CHANNEL EFFICIENCY & BUDGET ALLOCATION MATRIX
-- Groups platform records to calculate accurate Blended ROAS performance weights.
SELECT 
    c2 AS Channel,
    SUM(CAST(c3 AS INTEGER)) AS Total_Ad_Spend_INR,
    SUM(CAST(c4 AS INTEGER)) AS Cumulative_Conversions,
    SUM(CAST(c5 AS INTEGER)) AS Gross_Revenue_INR,
    ROUND(SUM(CAST(c5 AS REAL)) * 1.0 / SUM(CAST(c3 AS REAL)), 2) AS Blended_ROAS_Multiplier
FROM 
    d2c_marketing_52k
WHERE 
    c2 != 'Channel' -- Seamlessly filters out raw database header rows
GROUP BY 
    c2
ORDER BY 
    Gross_Revenue_INR DESC;


-- AUDIT QUERY 2: CAPITAL WASTE ISOLATION (RED-FLAGGING LOW-ROAS PIPELINES)
-- Isolates underperforming macro-spend campaigns bleeding revenue margins below 1.5x.
SELECT 
    c1 AS Campaign_ID,
    c2 AS Channel,
    CAST(c3 AS INTEGER) AS Campaign_Ad_Spend,
    CAST(c4 AS INTEGER) AS Campaign_Conversions,
    CAST(c5 AS INTEGER) AS Campaign_Revenue,
    ROUND(CAST(c5 AS REAL) * 1.0 / CAST(c3 AS REAL), 2) AS Campaign_ROAS
FROM 
    d2c_marketing_52k
WHERE 
    CAST(c3 AS INTEGER) > 40000 -- Focuses purely on heavy capital deployments
    AND c2 != 'Channel'
GROUP BY 
    c1, c2, c3, c4, c5
HAVING 
    Campaign_ROAS < 1.50
ORDER BY 
    Campaign_ROAS ASC;
