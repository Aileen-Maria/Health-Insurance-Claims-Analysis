CREATE DATABASE IF NOT EXISTS insurance_analysis;
USE insurance_analysis;

CREATE TABLE claims (
    PatientID INT PRIMARY KEY,
    Age INT,
    Age_Group VARCHAR(10),
    Gender VARCHAR(10),
    BMI DECIMAL(5,2),
    BMI_Group VARCHAR(15),
    BloodPressure INT,
    Diabetic VARCHAR(3),
    Children INT,
    Smoker VARCHAR(3),
    Region VARCHAR(20),
    Claim DECIMAL(10,2)
);

SHOW TABLES;
SELECT * FROM `insurance_data cleaned` LIMIT 10;
USE insurance_analysis;
SHOW TABLES;

ALTER TABLE `insurance_data cleaned` RENAME TO insurance_data_cleaned;
SELECT * FROM insurance_data_cleaned LIMIT 10;

ALTER TABLE insurance_data_cleaned
CHANGE COLUMN `ï»¿index` `Index` INT;

ALTER TABLE insurance_data_cleaned
ADD COLUMN Age_Group VARCHAR(10);

ALTER TABLE insurance_data_cleaned
ADD COLUMN Age_Group VARCHAR(10);

UPDATE insurance_data_cleaned
SET Age_Group = CASE
    WHEN age < 25 THEN '18-24'
    WHEN age BETWEEN 25 AND 34 THEN '25-34'
    WHEN age BETWEEN 35 AND 44 THEN '35-44'
    WHEN age BETWEEN 45 AND 54 THEN '45-54'
    ELSE '55+'
END;
SET SQL_SAFE_UPDATES = 0;
SET SQL_SAFE_UPDATES = 1;

-- Average claim by age group and gender
SELECT 
  Age_Group,
  Gender,
  ROUND(AVG(Claim),2) AS Avg_Claim,
  COUNT(*) AS Total_People
FROM insurance_data_cleaned
GROUP BY Age_Group, Gender
ORDER BY Avg_Claim DESC;

ALTER TABLE insurance_data_cleaned
ADD COLUMN BMI_Category VARCHAR(20);

ALTER TABLE insurance_data_cleaned
DROP COLUMN `Age Group`;

SHOW COLUMNS FROM insurance_data_cleaned;

-- Average Claim by BMI Group
SELECT 
  `bmi group` AS BMI_Group,
  ROUND(AVG(Claim), 2) AS Avg_Claim,
  COUNT(*) AS Total_People
FROM insurance_data_cleaned
GROUP BY `bmi group`
ORDER BY Avg_Claim DESC;

-- Average BMI by Age Group
SELECT 
  Age_Group,
  ROUND(AVG(bmi), 2) AS Avg_BMI
FROM insurance_data_cleaned
GROUP BY Age_Group
ORDER BY Avg_BMI DESC;

-- BMI Group + Smoker Combined
SELECT 
  `bmi group` AS BMI_Group,
  Smoker,
  ROUND(AVG(Claim), 2) AS Avg_Claim,
  COUNT(*) AS Total_People
FROM insurance_data_cleaned
GROUP BY `bmi group`, Smoker
ORDER BY Avg_Claim DESC;

-- Average Claim by Blood Pressure Category
SELECT
  CASE
    WHEN bloodpressure < 80 THEN 'Low'
    WHEN bloodpressure BETWEEN 80 AND 89 THEN 'Normal'
    WHEN bloodpressure BETWEEN 90 AND 99 THEN 'Pre-High'
    ELSE 'High'
  END AS BP_Category,
  ROUND(AVG(Claim), 2) AS Avg_Claim,
  COUNT(*) AS Total_People
FROM insurance_data_cleaned
GROUP BY BP_Category
ORDER BY Avg_Claim DESC;

-- Average Claim by Diabetic Status
SELECT
  Diabetic,
  ROUND(AVG(Claim), 2) AS Avg_Claim,
  COUNT(*) AS Total_People
FROM insurance_data_cleaned
GROUP BY Diabetic
ORDER BY Avg_Claim DESC;

-- Average Claim by Region
SELECT
  Region,
  ROUND(AVG(Claim), 2) AS Avg_Claim,
  COUNT(*) AS Total_People
FROM insurance_data_cleaned
GROUP BY Region
ORDER BY Avg_Claim DESC;


-- Combined Risk: Smoker + Diabetic Status
SELECT
  Smoker,
  Diabetic,
  ROUND(AVG(Claim), 2) AS Avg_Claim,
  COUNT(*) AS Total_People
FROM insurance_data_cleaned
GROUP BY Smoker, Diabetic
ORDER BY Avg_Claim DESC;


-- Average and Total Claim by Gender
SELECT
  Gender,
  ROUND(AVG(Claim), 2) AS Avg_Claim,
  ROUND(SUM(Claim), 2) AS Total_Claim,
  COUNT(*) AS Total_People
FROM insurance_data_cleaned
GROUP BY Gender
ORDER BY Avg_Claim DESC;

-- Claim Amount Distribution
SELECT
  CASE
    WHEN Claim < 5000 THEN '<5K'
    WHEN Claim BETWEEN 5000 AND 10000 THEN '5K–10K'
    WHEN Claim BETWEEN 10000 AND 20000 THEN '10K–20K'
    WHEN Claim BETWEEN 20000 AND 30000 THEN '20K–30K'
    ELSE '30K+'
  END AS Claim_Range,
  COUNT(*) AS People_Count,
  ROUND(AVG(Claim), 2) AS Avg_Claim
FROM insurance_data_cleaned
GROUP BY Claim_Range
ORDER BY Avg_Claim DESC;

-- High-Risk Individuals (Smoker + Diabetic + Obese)
SELECT
  COUNT(*) AS High_Risk_Count,
  ROUND(AVG(Claim), 2) AS Avg_Claim
FROM insurance_data_cleaned
WHERE Smoker = 'Yes'
  AND Diabetic = 'Yes'
  AND `bmi group` = 'Obese';
