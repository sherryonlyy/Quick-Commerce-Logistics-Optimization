-- ==============================================================================
-- SHREYA | ENTERPRISE DATA ARCHITECTURE
-- PROJECT 2: D2C PERFORMANCE MARKETING & CUSTOMER ACQUISITION COST (CAC) AUDIT
-- BACKEND SQL ANALYTICAL MATRIX SCRIPT
-- ==============================================================================

-- ------------------------------------------------------------------------------
-- KEY METRIC DEFINITIONS FOR RECRUITERS:
-- 1. Click Through Rate (CTR %) = (Total Clicks / Ad Spend) * 100
-- 2. Cost Per Acquisition (CAC) = Total Ad Spend / Conversions (Lower is better)
-- 3. Return On Ad Spend (ROAS) = Total Revenue / Total Ad Spend (Higher is better)
-- ------------------------------------------------------------------------------

-- AUDIT QUERY 1: MACRO CHANNEL EFFICIENCY & BUDGET ALLOCATION MATRIX
-- Evaluates which digital advertising platforms are driving profitable conversions.
SELECT 
    Channel,
    SUM(Ad_Spend_INR) AS Total_Ad_Spend_INR,
    SUM(Total_Clicks) AS Cumulative_Clicks,
    SUM(Conversions) AS Total_Conversions,
    SUM(Total_Revenue_INR) AS Gross_Revenue_INR,
    ROUND(AVG(Click_Through_Rate_Pct), 2) AS Average_CTR_Percentage,
    ROUND(SUM(Ad_Spend_INR) / SUM(Conversions), 2) AS Blended_CAC_INR,
    ROUND(SUM(Total_Revenue_INR) / SUM(Ad_Spend_INR), 2) AS Blended_ROAS_Multiplier
FROM 
    d2c_marketing_52k
GROUP BY 
    Channel
ORDER BY 
    Gross_Revenue_INR DESC;


-- AUDIT QUERY 2: CAPITAL WASTE ISOLATION (RED-FLAGGING LOW-ROAS CAMPAIGNS)
-- Pinpoints specific underperforming campaigns where ROAS is bleeding below 1.5x.
SELECT 
    Campaign_ID,
    Channel,
    Ad_Spend_INR,
    Conversions,
    Total_Revenue_INR,
    ROUND(Cost_Per_Acquisition_INR, 2) AS Specific_Campaign_CAC,
    ROUND(Return_On_Ad_Spend_ROAS, 2) AS Campaign_ROAS
FROM 
    d2c_marketing_52k
WHERE 
    Ad_Spend_INR > 40000 -- Focuses purely on heavy corporate capital expenditures
GROUP BY 
    Campaign_ID, Channel, Ad_Spend_INR, Conversions, Total_Revenue_INR, Cost_Per_Acquisition_INR, Return_On_Ad_Spend_ROAS
HAVING 
    Return_On_Ad_Spend_ROAS < 1.50
ORDER BY 
    Campaign_ROAS ASC;


-- AUDIT QUERY 3: GEOGRAPHIC ACQUISITION WEIGHT & TARGET MARKET DENSITY
-- Analyzes which territorial micro-markets yield the lowest acquisition costs.
SELECT 
    Region,
    COUNT(Campaign_ID) AS Total_Active_Campaigns,
    SUM(Ad_Spend_INR) AS Regional_Budget_Allocation,
    SUM(Total_Revenue_INR) AS Regional_Revenue_Generated,
    ROUND(SUM(Ad_Spend_INR) / SUM(Conversions), 2) AS Regional_Blended_CAC,
    ROUND(SUM(Total_Revenue_INR) / SUM(Ad_Spend_INR), 2) AS Regional_ROAS_Performance
FROM 
    d2c_marketing_52k
GROUP BY 
    Region
ORDER BY 
    Regional_Blended_CAC ASC;
