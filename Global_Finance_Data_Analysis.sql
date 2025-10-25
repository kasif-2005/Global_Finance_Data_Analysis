create table global_finance(
Country	varchar(100),
Dates	date,
Stock_Index	varchar(100),
Index_Value	numeric(10,3),
Daily_Change_Percent	numeric(10,3),
Market_Cap_Trillion_USD	numeric(10,3),
GDP_Growth_Rate_Percent	numeric(10,3),
Inflation_Rate_Percent	numeric(10,3),
Interest_Rate_Percent	numeric(10,3),
Unemployment_Rate_Percent	numeric(10,3),
Currency_Code	varchar(50),
Exchange_Rate_USD	numeric(10,3),
Currency_Change_YTD_Percent	numeric(10,3),
Government_Debt_GDP_Percent	numeric(10,3),
Current_Account_Balance_Billion_USD	numeric(10,3),
FDI_Inflow_Billion_USD	numeric(10,3),
Commodity_Index	numeric(10,3),
Oil_Price_USD_Barrel numeric(10,3),
Gold_Price_USD_Ounce	numeric(10,3),
Bond_Yield_10Y_Percent	numeric(10,3),
Credit_Rating	varchar(50),
Political_Risk_Score	numeric(10,3),
Banking_Sector_Health	varchar(50),
Real_Estate_Index	 numeric(10,3),
Export_Growth_Percent	 numeric(10,3),
Import_Growth_Percent numeric(10,3)
);

select * from global_finance;

-- Which countries have the highest average stock index growth over time?

select country, dates, round(avg(daily_change_percent),2) as avg_stock_idx_growth
from global_finance
group by country, dates
order by avg(daily_change_percent) desc;

-- Which countries show positive stock market performance despite negative GDP growth?

select country , round(avg(daily_change_percent),2) as stock_market_perfomance, round(avg(gdp_growth_rate_percent),2) as gdp_growth
from global_finance
group by country
having avg(daily_change_percent)>0 and avg(gdp_growth_rate_percent)<0
order by avg(daily_change_percent)desc;

-- What is the relationship between average stock index value and GDP growth rate?

select 
country,
round(avg(index_value),2) as avg_stock_idx,
round(avg(gdp_growth_rate_percent),2) as avg_gdp_growth
from global_finance
group by country
order by avg_gdp_growth desc;

-- Which countries have the highest inflation rates and how do their interest rates compare?

select country, round(avg(inflation_rate_percent),2) as avg_inflation_rate, round(avg(interest_rate_percent),2) as avg_interst_rate
from global_finance
group by country
order by avg(inflation_rate_percent)desc;

-- Do higher interest rates result in lower average inflation across countries?

select country, round(avg(inflation_rate_percent),2) as avg_inflation_rate, round(avg(interest_rate_percent),2) as avg_interst_rate
from global_finance
group by country
order by avg(interest_rate_percent)desc;

-- Which countries maintained low inflation despite low interest rates?

select country, round(avg(inflation_rate_percent),2) as avg_inflation_rate, round(avg(interest_rate_percent),2) as avg_interst_rate
from global_finance
group by country
having avg(inflation_rate_percent)<3 and avg(interest_rate_percent)<3
order by avg(interest_rate_percent);

-- Which currencies appreciated the most against the USD this year?

select country, round(avg(currency_change_ytd_percent),2) as avg_currency_change_ytd
from global_finance
group by country
having avg(currency_change_ytd_percent)>0
order by avg(currency_change_ytd_percent) desc;

-- Which countries have weakening currencies but growing exports?

select 
country,
round(avg(currency_change_ytd_percent),2) as avg_currency_change_ytd,
round(avg(export_growth_percent),2) as avg_export_growth_percent
from global_finance
group by country
having avg(currency_change_ytd_percent)<0 and avg(export_growth_percent)>0
order by avg(currency_change_ytd_percent) desc;

-- What is the average exchange rate and market capitalization by country?

select
country,
round(avg(exchange_rate_usd),2) as avg_axchnage_rate_usd, round(avg(market_cap_trillion_usd),2) as avg_market_cap
from global_finance
group by country
order by avg(exchange_rate_usd);

-- How do oil prices correlate with inflation rates across countries?

SELECT
    country,
    CORR(oil_price_usd_barrel, inflation_rate_percent) AS oil_inflation_correlation
FROM 
    global_finance
GROUP BY 
    country
ORDER BY 
    oil_inflation_correlation DESC;


-- Which countries’ stock markets are most sensitive to gold price movements?

select 
country,
corr(daily_change_percent, gold_price_usd_Ounce) as stock_gold_corr
from global_finance
group by country
order by abs(corr(daily_change_percent, gold_price_usd_Ounce)) desc;

-- What is the relationship between oil prices and stock index performance?

select country,
corr(oil_price_usd_barrel, daily_change_percent) as oil_stock_corr
from global_finance
group by country
order by oil_stock_corr;

-- Which countries have the highest real estate index growth?

select 
country,
round(avg(real_estate_index),2) as avg_real_estate
from global_finance
group by country
order by avg(real_estate_index) desc;

-- How do interest rates affect real estate index levels across countries?

select 
country,
corr(interest_rate_percent, real_estate_index) as interest_real_estate_corr
from global_finance
where interest_rate_percent is not null
and real_estate_index is not null
group by country
order by interest_real_estate_corr;

-- Which countries show real estate growth faster than GDP growth (possible housing bubbles)?

SELECT 
    country,
    ROUND(AVG(real_estate_index), 2) AS avg_real_estate,
    ROUND(AVG(gdp_growth_rate_percent), 2) AS avg_gdp_growth
FROM 
    global_finance
GROUP BY 
    country
HAVING 
    AVG(real_estate_index) > AVG(gdp_growth_rate_percent)  -- real estate grows faster than GDP
ORDER BY 
    avg_real_estate DESC;


-- Which economies combine high GDP growth and low unemployment rates?

select 
country,
round(avg(gdp_growth_rate_percent),2) as avg_gdp_growth,
round(avg(unemployment_rate_percent),2) as avg_unemployment_rate
from global_finance
group by country
having avg(gdp_growth_rate_percent)>avg(unemployment_rate_percent)
order by avg(gdp_growth_rate_percent) desc;

-- Which countries have the best employment efficiency (GDP growth per unit of unemployment)?

SELECT
    country,
    ROUND(AVG(gdp_growth_rate_percent) / NULLIF(AVG(unemployment_rate_percent), 0), 2) AS employment_efficiency,
    ROUND(AVG(gdp_growth_rate_percent), 2) AS avg_gdp_growth,
    ROUND(AVG(unemployment_rate_percent), 2) AS avg_unemployment
FROM
    global_finance
WHERE
    gdp_growth_rate_percent IS NOT NULL
    AND unemployment_rate_percent IS NOT NULL
GROUP BY
    country
ORDER BY
    employment_efficiency DESC;


-- How does unemployment change with interest rate variations?

SELECT
    country,
    CORR(interest_rate_percent, unemployment_rate_percent) AS interest_unemployment_corr
FROM
    global_finance
WHERE
    interest_rate_percent IS NOT NULL
    AND unemployment_rate_percent IS NOT NULL
GROUP BY
    country
ORDER BY
    interest_unemployment_corr;