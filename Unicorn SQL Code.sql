-- Step 1: Identify the top 3 industries with the most unicorn companies 
-- that joined in the years 2019, 2020, or 2021
WITH top_industries AS (
    SELECT 
        i.industry, 
        COUNT(i.company_id) AS Count_of_companies
    FROM industries AS i
    INNER JOIN dates AS d  
        ON i.company_id = d.company_id 
    WHERE EXTRACT(YEAR FROM d.date_joined) IN (2019, 2020, 2021)
    GROUP BY i.industry
    ORDER BY Count_of_companies DESC
    LIMIT 3
),

-- Step 2: Aggregate unicorn data by industry and year
-- Includes total count of unicorns and average valuation per industry per year

yearly_rankings AS (
    SELECT 
        COUNT(i.*) AS num_unicorns,
        i.industry,
        EXTRACT(YEAR FROM d.date_joined) AS year,
        AVG(f.valuation) AS average_valuation
    FROM industries AS i
    INNER JOIN dates AS d
        ON i.company_id = d.company_id
    INNER JOIN funding AS f
        ON d.company_id = f.company_id
    GROUP BY i.industry, year
)

-- Step 3: Final output
-- Filters for top industries and target years (2019–2021)
-- Converts average valuation to billions and rounds to 2 decimal places

SELECT 
    industry,
    year,
    num_unicorns,
    ROUND(AVG(average_valuation / 1000000000), 2) AS average_valuation_billions
FROM
    yearly_rankings
WHERE
    year IN (2019 , 2020, 2021)
        AND industry IN (SELECT 
            industry
        FROM
            top_industries)
GROUP BY industry , num_unicorns , year
ORDER BY year DESC , num_unicorns DESC;
