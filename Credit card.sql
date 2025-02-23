
-- Checking both table
Select * from credit_card;
Select * from customers;


-- total number of customers who have delinquent accounts
SELECT 
	COUNT(DISTINCT Client_Num) AS total_customer
FROM 
	credit_card
WHERE 
	Delinquent_acc = 1;


-- total delinquent accounts by card category
SELECT	 Card_Category, 
		 COUNT(DISTINCT Client_Num) AS Total_customer
FROM	 credit_card
WHERE	 Delinquent_acc = 1
GROUP BY Card_Category
ORDER BY Total_customer DESC;


-- customers who activated their credit card within 30 days.
SELECT	 *
FROM	 credit_card
WHERE	 Activation_30_Days = '1';



-- the total transactions for each card category.
SELECT	card_category,
		SUM(Total_Trans_Amt) AS Total_transactions 
FROM	credit_card
GROUP BY Card_Category
ORDER BY Total_transactions DESC;


-- total number of transactions for each card category.
select	Card_Category,
		COUNT(Total_Trans_Vol) AS total_transaction_volume
FROM	credit_card
GROUP BY Card_Category
ORDER BY total_transaction_volume DESC;

Select * from credit_card;


-- Changing qtarter column from float to int
ALTER TABLE credit_card
ALTER COLUMN qtr int;


-- the total transaction amount and volume by quarter.
SELECT	qtr, 
		SUM(Total_Trans_amt) AS total_trans_Amount,
		SUM(Total_Trans_Vol) AS total_trans_vol
FROM	 credit_card
GROUP BY Qtr
ORDER BY Qtr ASC;


-- the total transaction amount and volume by month.
SELECT	FORMAT(week_start_date, 'MMM') AS [month], 
		SUM(Total_Trans_amt) AS total_trans_Amount,
		SUM(Total_Trans_Vol) AS total_trans_vol
FROM	credit_card
GROUP BY FORMAT(week_start_date, 'MMM'), MONTH(week_start_date)
ORDER BY MONTH(week_start_date) ASC;

-- the average credit limit and utilization ratio for each card category.
SELECT	 Card_Category,
		 ROUND(AVG(credit_limit),2) AS avg_credit_limit,
		 ROUND(AVG(Avg_Utilization_Ratio*100),2) AS Avg_Utilization
FROM credit_card
GROUP BY Card_Category;


--the total interest earned by customers who are delinquent.
SELECT	SUM(Interest_Earned) AS total_intrest_earned
FROM	credit_card
WHERE	Delinquent_Acc = 1;

--  list of customers with their satisfaction scores and total transaction amounts.
SELECT	c.Client_Num,
		c.Cust_Satisfaction_Score, 
		cc.Total_Trans_amt
From customers c JOIN credit_card cc
ON c.Client_Num = cc.Client_Num;



SELECT	
		c.Cust_Satisfaction_Score, 
		SUM(cc.Total_Trans_amt) AS total_transaction
From	customers c JOIN credit_card cc
ON		c.Client_Num = cc.Client_Num
GRoup by c.Cust_Satisfaction_Score
ORDER BY c.Cust_Satisfaction_Score;


-- the average annual income of customers who have a personal loan and their card utilization.
SELECT	 c.Client_Num, 
		 AVG(income) AS avg_income,
		 ROUND(AVG(Avg_Utilization_Ratio),2) AS Avg_Utilization
FROM	 customers c JOIN credit_card cc
ON		 c.Client_Num = cc.Client_Num
WHERE	 Personal_loan = 1
GROUP BY c.Client_Num;

-- TOP customers by their total transaction amount within each card category.
WITH [rank] AS (
SELECT	 cc.Card_Category,c.Client_Num, 
		 SUM(Total_Trans_Amt) AS total_transaction,
		 DENSE_RANK() OVER(PARTITION BY card_category ORDER BY SUM(Total_Trans_Amt) DESC) AS [rank]
FROM	 customers c JOIN credit_card cc
ON		 c.Client_Num = cc.Client_Num
GROUP BY cc.Card_Category,c.Client_Num)
SELECT	* 
FROM	[rank]
WHERE	[rank] = 1;

-- the top 5 states with the highest customer satisfaction scores.
SELECT	TOP 5 state_cd,
		COUNT(Cust_Satisfaction_Score) AS Most_Cust_Satisfaction_Score
FROM	customers
WHERE	Cust_Satisfaction_Score = (SELECT MAX(Cust_Satisfaction_Score) From customers)
GROUP BY state_cd
ORDER BY Most_Cust_Satisfaction_Score DESC;


-- Calculate the total interest earned week-wise for the current year.
SELECT	Week_Num,
		ROUND(SUM(Interest_Earned),2) AS total_intrest
FROM	credit_card
GROUP BY Week_Num
ORDER BY Week_Num ASC;


SELECT	DATENAME(Month, Week_Start_Date) AS [month], 
		ROUND(SUM(Total_Trans_Amt+Interest_Earned ),2) AS total_revenue
FROM credit_card
GROUP BY DATENAME(Month, Week_Start_Date), MONTH(Week_Start_Date)
ORDER BY MONTH(Week_Start_Date);
