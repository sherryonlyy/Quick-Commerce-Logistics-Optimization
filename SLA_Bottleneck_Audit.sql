SELECT 
    c3 AS City,
    c2 AS Dark_Store_Location,
    COUNT(c1) AS Total_Processed_Orders,
    ROUND(AVG(CAST(c8 AS REAL)), 2) AS Average_Packing_Delay_Mins,
    SUM(CAST(c6 AS INTEGER)) AS Total_Revenue_INR
FROM 
    qcommerce_55k
WHERE 
    c7 = 'Delivered' 
    AND c1 != 'Order_ID'
GROUP BY 
    c3, c2
HAVING 
    AVG(CAST(c8 AS REAL)) > 3.5
ORDER BY 
    Average_Packing_Delay_Mins DESC;
