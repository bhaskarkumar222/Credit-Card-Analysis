# Credit Card Analysis

## Overview

This project focuses on Credit Card Transaction and Customer Analysis using Power BI for data visualization and SQL for business problem-solving. The goal is to extract valuable insights from transaction data, helping financial institutions understand customer behavior, revenue trends, and delinquency risks.

## Tools Used
- **Power BI** – For data visualization and creating interactive dashboards.
- **MySQL** – For data extraction, transformation, and answering business problem queries.
- **Excel** – For initial data cleaning and preprocessing
- <a href="https://app.powerbi.com/view?r=eyJrIjoiNWQzMjBkNzgtMTkyMS00NDJiLWFjZTItMTRjYTI3NjIyMDEyIiwidCI6ImRmODY3OWNkLWE4MGUtNDVkOC05OWFjLWM4M2VkN2ZmOTVhMCJ9">View Dashboard</a>

**Key components of the project include:**
- Transaction Analysis Dashboard – Tracks revenue, interest, transaction types, and delinquency rates.
- Customer Analysis Dashboard – Examines customer demographics, spending patterns, and satisfaction scores.

## Situation
The goal of this project is to analyze credit card transactions and customer behavior using **Power BI for data visualization** and **SQL for business problem queries** to derive key financial and customer insights.

## Task
- Develop interactive dashboards to track **transaction trends, revenue and delinquent accounts**.
- Analyze customer satisfaction, spending patterns, and demographic influences on transactions.

## Action
- Used SQL for data extraction and transformation to derive key business insights.

**1. Total number of customers who have delinquent accounts.**
```sql
SELECT 
	COUNT(DISTINCT Client_Num) AS total_customer
FROM 
	credit_card
WHERE 
	Delinquent_acc = 1;
```
**2. Total delinquent accounts by card category.**
```sql
SELECT	 Card_Category, 
         COUNT(DISTINCT Client_Num) AS Total_customer
FROM     credit_card
WHERE    Delinquent_acc = 1
GROUP BY Card_Category
ORDER BY Total_customer DESC;
```
**3. the total transactions for each card category.**
```sql
SELECT  card_category,
        SUM(Total_Trans_Amt) AS Total_transactions 
FROM    credit_card
GROUP BY Card_Category
ORDER BY Total_transactions DESC;
```
**4. Total number of transactions for each card category.**
```sql
select  Card_Category,
        COUNT(Total_Trans_Vol) AS total_transaction_volume
FROM    credit_card
GROUP BY Card_Category
ORDER BY total_transaction_volume DESC;
```
**5. The total transaction amount and volume by quarter.**
```sql
SELECT  qtr, 
        SUM(Total_Trans_amt) AS total_trans_Amount,
        SUM(Total_Trans_Vol) AS total_trans_vol
FROM    credit_card
GROUP BY Qtr
ORDER BY Qtr ASC;
```
**6. The total transaction amount and volume by month.**
```sql
SELECT  FORMAT(week_start_date, 'MMM') AS [month], 
        SUM(Total_Trans_amt) AS total_trans_Amount,
        SUM(Total_Trans_Vol) AS total_trans_vol
FROM    credit_card
GROUP BY FORMAT(week_start_date, 'MMM'), MONTH(week_start_date)
ORDER BY MONTH(week_start_date) ASC;
```
**7. The average credit limit and utilization ratio for each card category.**
```sql
SELECT  Card_Category,
        ROUND(AVG(credit_limit),2) AS avg_credit_limit,
        ROUND(AVG(Avg_Utilization_Ratio*100),2) AS Avg_Utilization
FROM    credit_card
GROUP BY Card_Category;
```
**8. List of customers with their satisfaction scores and total transaction amounts.**
```sql
SELECT  c.Cust_Satisfaction_Score, 
        SUM(cc.Total_Trans_amt) AS total_transaction
From    customers c JOIN credit_card cc
ON      c.Client_Num = cc.Client_Num
GRoup by c.Cust_Satisfaction_Score
ORDER BY c.Cust_Satisfaction_Score;
```
**9. TOP customers by their total transaction amount within each card category.**
```sql
WITH [rank] AS (
SELECT  cc.Card_Category,c.Client_Num, 
        SUM(Total_Trans_Amt) AS total_transaction,
        DENSE_RANK() OVER(PARTITION BY card_category ORDER BY SUM(Total_Trans_Amt) DESC) AS [rank]
FROM    customers c JOIN credit_card cc
ON      c.Client_Num = cc.Client_Num
GROUP BY cc.Card_Category,c.Client_Num)
SELECT	* 
FROM	[rank]
WHERE	[rank] = 1;
```
**10. The top 5 states with the highest customer satisfaction scores.**
```sql
SELECT  Week_Num,
        ROUND(SUM(Interest_Earned),2) AS total_intrest
FROM    credit_card
GROUP BY Week_Num
ORDER BY Week_Num ASC;
```

- Designed Power BI dashboards with interactive filters to visualize monthly revenue, transaction types, and customer segmentation.
- Incorporated KPIs and measures such as Total Revenue, Total Interest, Transaction Amount, Customer Satisfaction Score, and Delinquent Accounts.
## Dashboard Preview 1
![image alt](https://github.com/bhaskarkumar222/Credit-Card-Analysis/blob/ac522c7254d0ce0e10a0219559d1706672a81ae3/Dashboard%20Image/Dashboard%201%20Screenshot.png)
## Dashboard Preview 2
![image alt](https://github.com/bhaskarkumar222/Credit-Card-Analysis/blob/ac522c7254d0ce0e10a0219559d1706672a81ae3/Dashboard%20Image/Dashboard%202%20Screenshot.png)

## Result
- **Revenue & Transactions Overview:** The total revenue generated is **$55.3M**, with an interest income of **$7.8M** and a transaction amount of **$44.5M**. There are **614 delinquent** accounts, indicating a need for better risk management.

- **Card & Payment Trends:** The **Blue category card is the most** used, contributing the highest transaction value. Swipe payments dominate of **62.65%**, followed by chip and online transactions.

- **Customer Spending Behavior:** The average customer income is **$56.98K**, and their satisfaction score is **3.19**. Customers aged between **40-50 are the biggest spenders**, making them a key demographic for financial services.

- **Geographical & Demographic Insights:** California (492), New York (471) and Texas (438) have the highest satisfaction scores. Married individuals **contribute 50.55%** of the most to total spending, indicating a stable financial engagement pattern.

## Final Conclusion
- The **majority of transactions** come from **Blue category cards**, contributing the highest revenue and interest.
- **Bills, entertainment and fuel** are the **top spending** categories.
- **Swipe transactions (62.65%)** dominate over online and chip transactions.
- Customers **aged between 40-50** have the **highest transaction** amounts and satisfaction scores.
- California, New York, and Texas rank **highest in customer satisfaction**.
- Married customers (50.55%) spend more than singles.
- **Business professionals and white-collar workers** contribute the most **transaction value**.



