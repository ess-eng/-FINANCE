--Q1-what is the default rate by loan purpose,employment status,and housing type!
SELECT Purpose,Employment,Housing,
COUNT(*) AS Total_Loans,
SUM(CASE WHEN Credit_risk = 'Bad' THEN 1 ELSE 0 END) AS Bad_Loans,
ROUND(100.0 * SUM(CASE WHEN Credit_risk = 'Bad' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Default_Rate_Percent
FROM dbo.German_Credit
GROUP BY Purpose, Employment, Housing
ORDER BY Default_Rate_Percent DESC;
------------------
--Q2-what is the average loan amount and duration for each risk label!
SELECT Credit_risk,
COUNT(*) AS Total_Loans,
AVG(Credit_amount) AS Avg_Loan_Amount,
AVG(Duration_Month) AS Avg_Duration_Months
FROM dbo.German_Credit
GROUP BY Credit_risk
ORDER BY Credit_risk;
---------------------
--Q3-what applicant profiles combine above_average credict amount with below_average income or savings!
WITH AvgCredit AS (SELECT AVG(Credit_amount) AS Overall_Avg_Credit FROM dbo.German_Credit)
SELECT gc.* FROM dbo.German_Credit gc CROSS JOIN AvgCredit a
WHERE gc.Credit_amount > a.Overall_Avg_Credit AND gc.Saving_account IN ('Unknown', 'Low_savings')
ORDER BY gc.Credit_amount DESC;
---------------------
--Q4-how do applicants rank within each purpose category by loan amount!
SELECT Purpose,Credit_amount,Age,Employment,Credit_risk,
RANK() OVER (PARTITION BY Purpose ORDER BY Credit_amount DESC) AS Rank_Within_Purpose,
DENSE_RANK() OVER (PARTITION BY Purpose ORDER BY Credit_amount DESC) AS Dense_Rank_Within_Purpose
FROM dbo.German_Credit
ORDER BY Purpose, Rank_Within_Purpose;
------------------------
--Q5-what are the top 5 loan purpose categorise with the highest default rate!
SELECT TOP 5 Purpose,COUNT(*) AS Total_Loans,
SUM(CASE WHEN Credit_risk = 'Bad' THEN 1 ELSE 0 END) AS Bad_Loans,
ROUND(100.0 * SUM(CASE WHEN Credit_risk = 'Bad' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Default_Rate_Percent
FROM dbo.German_Credit
GROUP BY Purpose
ORDER BY Default_Rate_Percent DESC;
----------------------
--Q6-what is the impact of having a guarantor on the default rate!
SELECT Guarantors,COUNT(*) AS Total_Loans,
SUM(CASE WHEN Credit_risk = 'Bad' THEN 1 ELSE 0 END) AS Bad_Loans,
ROUND(100.0 * SUM(CASE WHEN Credit_risk = 'Bad' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Default_Rate_Percent
FROM dbo.German_Credit
GROUP BY Guarantors
ORDER BY Default_Rate_Percent DESC;
--------------------------
--Q7-what are the top 3 jobs with the highest average loan amount!
SELECT TOP 3 Job,
ROUND(AVG(Credit_amount), 2) AS Avg_Loan_Amount,
COUNT(*) AS Total_Loans
FROM dbo.German_Credit
GROUP BY Job
ORDER BY Avg_Loan_Amount DESC;
--------------
--Q8-what is the ratio of good vs bad loans based on telephone ownership!
SELECT Telephone,COUNT(*) AS Total_Loans,
SUM(CASE WHEN Credit_risk = 'Good' THEN 1 ELSE 0 END) AS Good_Loans,
SUM(CASE WHEN Credit_risk = 'Bad' THEN 1 ELSE 0 END) AS Bad_Loans
FROM dbo.German_Credit
GROUP BY Telephone;
------------------
--Q9-what is the impact of employment duration on the default rate!
SELECT Employment,
COUNT(*) AS Total_Loans,SUM(CASE WHEN Credit_risk = 'Bad' THEN 1 ELSE 0 END) AS Bad_Loans,
ROUND(100.0 * SUM(CASE WHEN Credit_risk = 'Bad' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Default_Rate_Percent
FROM dbo.German_Credit
GROUP BY Employment
ORDER BY Default_Rate_Percent DESC;
----------------------