
				--							*******************************************************				 --
				--							*	Project Title: E-Commerce Customer Churn Analysis *				 --
				--							*******************************************************				 --	
/* Problem Statement:
 In the realm of e-commerce, businesses face the challenge of understanding customer churn patterns to ensure customer satisfaction and sustained profitability. This project
 aims to delve into the dynamics of customer churn within an e-commerce domain,utilizing historical transactional data to uncover underlying patterns and drivers of churn.
 By analyzing customer attributes such as tenure, preferred payment modes,satisfaction scores, and purchase behavior, the project seeks to investigate and understand the 
 dynamics of customer attrition and their propensity to churn. The ultimate objective is to equip e-commerce enterprises with actionable insights to
 implement targeted retention strategies and mitigate churn, thereby fostering long-term customer relationships and ensuring business viability in a competitive landscape. */


													--  Quick explore Over view --
													-- ************************* --

/*===================================================================================*/
/*use ecomm database*/
/*===================================================================================*/


USE ecomm;

SELECT * FROM customer_churn;
SELECT count(CustomerID) FROM customer_churn ;
SELECT CustomerID, count(*) FROM customer_churn GROUP BY CustomerID;

SELECT WarehouseToHome,count(*) FROM customer_churn GROUP BY WarehouseToHome ;

/*===================================================================================================================================================================*/
-- Disable safe update
SET sql_safe_updates = 0;

/*===================================================================================================================================================================*/
												-- Data Cleaning:
											 -- ******************* --
                                             
--  Handling Missing Values and  Outliers:

-- WarehouseToHome impute
		SET @ware_house_to_home_avg =round((select AVG(WarehouseToHome) from customer_churn));
		select @ware_house_to_home_avg ;
		update customer_churn
		SET WarehouseToHome= @ware_house_to_home_avg WHERE WarehouseToHome IS NULL;

-- HourSpendOnApp
		SET @HourSpendOnApp =round((select AVG(HourSpendOnApp) from customer_churn));
		select @HourSpendOnApp ;
		UPDATE customer_churn
		SET HourSpendOnApp= @HourSpendOnApp
		WHERE HourSpendOnApp IS NULL;

-- OrderAmountHikeFromlastYear
		SET @OrderAmountHikeFromlastYear_AVG =round((select AVG(OrderAmountHikeFromlastYear) from customer_churn));
		select @OrderAmountHikeFromlastYear_AVG ;
		update customer_churn
		SET OrderAmountHikeFromlastYear= @OrderAmountHikeFromlastYear_AVG
		WHERE OrderAmountHikeFromlastYear IS NULL;
		select OrderAmountHikeFromlastYear from customer_churn;

-- DaySinceLastOrder
		SET @DaySinceLastOrder_avg =round((select AVG(DaySinceLastOrder) from customer_churn));
		select @DaySinceLastOrder_avg ;
		update customer_churn
		SET DaySinceLastOrder= @DaySinceLastOrder_avg
		WHERE DaySinceLastOrder IS NULL;
		select DaySinceLastOrder from customer_churn;

-- complite the impute For Lets Check 
		select WarehouseToHome,HourSpendOnApp,OrderAmountHikeFromlastYear,DaySinceLastOrder from customer_churn; 

/*===================================================================================================================================================================*/

/* Impute mode for the following columns: Tenure, CouponUsed, OrderCount */

		Select Tenure, CouponUsed, OrderCount from customer_churn;

/* find mode value for Tenure column */

		select tenure,count(*) from customer_churn group by tenure order by count(*)desc limit 1;
		set @mode_tenure=(select tenure from customer_churn group by tenure order by count(*) desc limit 1);
		select @mode_tenure;
	/* Impute mode*/
		update customer_churn
		set tenure = @mode_tenure where tenure is null;
		select tenure from customer_churn;

/* find mode value for Coupon used column */
		select CouponUsed,count(*)from customer_churn group by CouponUsed order by count(*) desc limit 1;
		set @mode_couponused =(select CouponUsed from customer_churn group by CouponUsed order by count(*) desc limit 1);
		select @mode_couponused ;
	/* Impute mode*/
		update customer_churn 
		set CouponUsed=@mode_couponused where CouponUsed is null;
		select CouponUsed from customer_churn;

/* find mode value for OrderCount column */
		select ordercount,count(*) from customer_churn group by ordercount order by count(*) desc limit 1;
		set @mode_ordercount=(select ordercount from customer_churn group by ordercount order by count(*) desc limit 1);
	/* Impute mode*/
		update customer_churn 
		set ordercount=@mode_ordercount where ordercount is null ;

/*===================================================================================================================================================================*/

/*Handle outliers in the 'WarehouseToHome' column by deleting rows where the values are greater than 100.*/
select WarehouseToHome from customer_churn;
delete from customer_churn where WarehouseToHome >100;

/*===================================================================================================================================================================*/
-- Dealing with Inconsistencies

-- Replace  occurrences of “Phone” in the 'PreferredLoginDevice' column with “Mobile Phone”

		UPDATE customer_churn
		SET PreferredLoginDevice = CASE
									WHEN PreferredLoginDevice='Phone' Then 'Mobile Phone'
									ELSE PreferredLoginDevice
									END;
		SELECT * FROM customer_churn;

-- Replace  occurrences of “Mobile” in the 'PreferedOrderCat' column  with “Mobile Phone”

		UPDATE customer_churn
		SET PreferedOrderCat = CASE
									WHEN PreferedOrderCat='Mobile' Then 'Mobile Phone'
									ELSE PreferedOrderCat
									END;
		SELECT * FROM customer_churn;

-- Replace "COD" with "Cash on Delivery" and "CC" with "Credit Card" in the PreferredPaymentMode column.

		UPDATE customer_churn
		SET PreferredPaymentMode = CASE
									WHEN PreferredPaymentMode='CC' then 'Credit Card' 
									ELSE PreferredPaymentMode
									END;

		UPDATE customer_churn
		SET PreferredPaymentMode = CASE
									WHEN PreferredPaymentMode='COD' then 'Cash on Delivery' 
									ELSE PreferredPaymentMode
									END;
		SELECT * FROM customer_churn;

SET SQL_SAFE_UPDATES = 1;
/*===================================================================================================================================================================*/
											--  Data Transformation
										    -- ******************** --
-- Column Renaming:

-- Renamethecolumn"PreferedOrderCat" to "PreferredOrderCat".
		SELECT PreferedOrderCat FROM customer_churn;

		ALTER TABLE customer_churn
		RENAME COLUMN PreferedOrderCat TO PreferredOrderCat;

		SELECT PreferredOrderCat FROM customer_churn;

-- Rename the column "HourSpendOnApp" to "HoursSpentOnApp".
		SELECT HourSpendOnApp FROM customer_churn;

		ALTER TABLE customer_churn
		RENAME COLUMN HourSpendOnApp TO HoursSpentOnApp;

		SELECT HoursSpentOnApp FROM customer_churn;                                        
                                            
 -- Creating New Columns:

--   Create a new column named ‘ComplaintReceived’ with values "Yes" if the corresponding value in the ‘Complain’ is 1, and "No" otherwise.                                           
       SELECT * FROM customer_churn;
       
SET SQL_SAFE_UPDATES = 0;

		ALTER TABLE customer_churn
		ADD COLUMN ComplaintReceived ENUM('Yes', 'No');

		UPDATE customer_churn
		SET ComplaintReceived = IF(Complain = 1, 'Yes', 'No');

		SELECT Complain,ComplaintReceived FROM customer_churn;   
                                            
-- Create a new column named 'ChurnStatus'. Set its value to “Churned” if the corresponding value in the 'Churn' column is 1, else assign “Active”.                                          
		   select Churn,ChurnStatus from customer_churn; 
		ALTER TABLE customer_churn 
		ADD COLUMN ChurnStatus VARCHAR(60); 
													
		 UPDATE customer_churn
		 SET ChurnStatus= if(Churn=1,'Churned', 'Active');
			   select Churn,ChurnStatus from customer_churn;        
SET SQL_SAFE_UPDATES = 1;
                                            
-- Column Dropping:

-- Drop the columns "Churn" and "Complain" from the table. 
		SELECT Churn FROM customer_churn;

		ALTER TABLE customer_churn
		DROP COLUMN Churn;

		SELECT Churn FROM customer_churn;

		SELECT Complain FROM customer_churn;

		ALTER TABLE customer_churn
		DROP COLUMN Complain;

		SELECT Complain FROM customer_churn;
		 select *from customer_churn;                                             
                                            
/*===================================================================================================================================================================*/
											--   Data Exploration and Analysis --
										    -- ******************************** --                                            
                                            
-- 1. Retrieve the count of churned and active customers from the dataset.                                            
		select ChurnStatus from customer_churn;  
    
		SELECT COUNT(ChurnStatus) AS churned_customers FROM customer_churn
		WHERE ChurnStatus = 'Churned';
																														
		SELECT COUNT(ChurnStatus) AS churned_customers FROM customer_churn
		WHERE ChurnStatus = 'Active';

    /* ANOTHER METHOD IS BELOW*/
     select ChurnStatus from customer_churn;  
		select ChurnStatus,count(*) AS churned_customers FROM customer_churn group by ChurnStatus;

-- 2.Display the average tenure and total cashback amount of customers who churned.

-- Average_tenure_customers_churned
		SELECT * FROM customer_churn;
		SELECT ROUND(AVG(Tenure)) AS Average_tenure_customers_churned ,Churnstatus FROM customer_churn WHERE Churnstatus='churned';

-- Total_CashBack_Earned_by_churned
		SELECT * FROM customer_churn;
		SELECT SUM(CashbackAmount) AS Total_CashBack_Earned_by_churned ,Churnstatus FROM customer_churn WHERE Churnstatus='churned';

-- 3.Determine the percentage of churned customers who complained.
			SELECT ChurnStatus,ComplaintReceived FROM customer_churn;

		-- Calculate the total number of churned customers
		SET @total_churned_customers = (SELECT COUNT(*) FROM customer_churn
			WHERE ChurnStatus = 'Churned');

		-- Calculate the number of churned customers who complained
		SET @churned_customers_who_complained = (SELECT COUNT(*) FROM customer_churn
		WHERE ChurnStatus = 'Churned' AND ComplaintReceived = 'Yes');

		-- Calculate the percentage of churned customers who complained
		SELECT (@churned_customers_who_complained / @total_churned_customers) * 100 AS percentage_of_churned_customers_who_complained;
        

-- 4. Find the gender distribution of customers who complained.
		SELECT Gender FROM customer_churn;
		SELECT ComplaintReceived FROM customer_churn;
		SELECT Gender ,COUNT( complaintReceived ) AS Complaint_Received FROM  customer_churn  WHERE complaintReceived ='yes' GROUP BY Gender order by Gender asc;

-- 5. Identify the city tier with the highest number of churned customers whose preferred order category is Laptop & Accessory
	select citytier,preferredordercat,ChurnStatus from customer_churn;

		SELECT citytier,count(ChurnStatus) as highest_churn_customers ,preferredordercat FROM customer_churn 
        where ChurnStatus='Churned' AND preferredordercat='Laptop & Accessory' 
        group by citytier
        order by ChurnStatus limit 1 ;

-- 6 Identify the most preferred payment mode among active customers.
		select PreferredPaymentMode from customer_churn;
        SELECT count(PreferredPaymentMode)AS most_preferred_payment_mode,PreferredPaymentMode FROM Customer_churn 
		WHERE ChurnStatus='Active'GROUP BY PreferredPaymentMode order by most_preferred_payment_mode desc limit 1;

-- 7 Calculate the total order amount hike from last year for customers who are single and prefer mobile phones for ordering.
		select * FROM customer_churn; 
        SELECT OrderAmountHikeFromlastYear,OrderCount,PreferredOrderCat,MaritalStatus FROM customer_churn;
        
        SELECT MaritalStatus,PreferredOrderCat,SUM(OrderAmountHikeFromlastYear)AS Total_order_amount_by_mobilephones FROM customer_churn
        WHERE PreferredOrderCat='Mobile Phone' AND MaritalStatus = 'Single' GROUP BY MaritalStatus LIMIT 1;

-- 8 Find the average number of devices registered among customers who used UPI as their preferred payment mode
		SELECT NumberOfDeviceRegistered,PreferredPaymentMode FROM customer_churn;

		SELECT PreferredPaymentMode, AVG(NumberOfDeviceRegistered) average_NumberOfDeviceRegistered FROM customer_churn
		WHERE PreferredPaymentMode = 'UPI'
		GROUP BY PreferredPaymentMode;

-- 9 Determine the citytier with the highest number of customers.
	select CityTier FROM customer_churn;
		SELECT CityTier, COUNT(CityTier) CityTier_highest_no_of_customers FROM customer_churn GROUP BY CityTier
		ORDER BY CityTier_highest_no_of_customers DESC LIMIT 1;

-- 10  Identify the gender that utilized the highest number of coupons
	 select CouponUsed,Gender  FROM customer_churn;
		SELECT Gender, COUNT(CouponUsed) highest_CouponUsed FROM customer_churn GROUP BY Gender 
        ORDER BY highest_CouponUsed DESC LIMIT 1;

-- 11 List the number of customers and the maximum hours spent on the app in each preferred order category.
		SELECT count(CustomerID) AS Total_nos_of_customers,max(HoursSpentOnApp)AS Max_HoursSpentOnApp,PreferredOrderCat from customer_churn 
		GROUP BY PreferredOrderCat order by Max_HoursSpentOnApp desc limit 1;

-- 12 Calculate the total order count for customers who prefer using credit cards and have the maximum satisfaction score.
		SELECT * FROM customer_churn;
		SELECT SUM(OrderCount) AS Total_order_count,PreferredPaymentMode,max(SatisfactionScore) from customer_churn where PreferredPaymentMode='Credit Card' ;
   
-- 13 How many customers are there who spent only one hour on the app and days since their last order was more than 5? 
		SELECT COUNT(HoursSpentOnApp) customers_spent_only_one_hour_on_app FROM customer_churn
		WHERE HoursSpentOnApp = 1 AND DaySinceLastOrder > 5;

-- 14 What is the average satisfaction score of customers who have complained?
		SELECT Round(AVG(SatisfactionScore)) AS average_SatisfactionScore_customers_complained FROM customer_churn
		WHERE ComplaintReceived = 'Yes';

-- 15 List the preferred order category among customers who used more than 5 coupons.
		SELECT CouponUsed FROM customer_churn;

		SELECT PreferredOrderCat AS customers_Count_PreferredOrderCat_more_than_5_coupons,CouponUsed FROM customer_churn
		WHERE CouponUsed > 5;

-- 16 List the top 3 preferred order categories with the highest average cashback amount.
		SELECT PreferredOrderCat AS top_3_PreferredOrderCat, Round(AVG(CashbackAmount)) AS highest_average_CashbackAmount FROM customer_churn
		GROUP BY top_3_PreferredOrderCat ORDER BY highest_average_CashbackAmount DESC LIMIT 3;
        
-- 17 Find the preferred payment modes of customers whose average tenure is 10 months and have placed more than 500 orders.
		SELECT PreferredPaymentMode, COUNT(OrderCount) AS placed_more_than_500_orders, AVG(Tenure) AS average_tenure_10_months FROM customer_churn
		GROUP BY PreferredPaymentMode HAVING placed_more_than_500_orders > 500 ORDER BY average_tenure_10_months DESC LIMIT 1;
        
 /*-- 18  Categorize customers based on their distance from the warehouse to home such
 as 'Very Close Distance' for distances <=5km, 'Close Distance' for <=10km,
 'Moderate Distance' for <=15km, and 'Far Distance' for >15km. Then, display the
 churn status breakdown for each distance category */
		 select WarehouseToHome,ChurnStatus FROM customer_churn;
		SELECT
			CASE
				WHEN WarehouseToHome <= 5 THEN 'Very Close Distance'
				WHEN WarehouseToHome <= 10 THEN 'Close Distance'
				WHEN WarehouseToHome <= 15 THEN 'Moderate Distance'
				ELSE 'Far Distance'
			END AS distances,
		ChurnStatus, COUNT(ChurnStatus) AS ChurnStatus_breakdown_each_distance_category
		FROM customer_churn GROUP BY ChurnStatus,distances ORDER BY distances;

-- 19 List the customer’s order details who are married, live in City Tier-1, and their order counts are more than the average number of orders placed by all customers.
        SELECT OrderCount FROM customer_churn;

		SELECT AVG(OrderCount) INTO @average_OrderCount FROM customer_churn;
		SELECT * FROM customer_churn WHERE MaritalStatus = 'Married' AND CityTier = 1 AND OrderCount > @average_OrderCount;
        
 -- 20 a) Create a ‘customer_returns’ table in the ‘ecomm’ database and insert the following data:       
		CREATE TABLE customer_returns(
					ReturnID      INT,
                    CustomerID    INT  PRIMARY KEY,
                    ReturnDate    DATE,
                    RefundAmount  INT
                    );
INSERT INTO customer_returns(ReturnID, CustomerID, ReturnDate, RefundAmount) 
VALUES		(1001, 50022, '2023-01-01', 2130),
			(1002, 50316, '2023-01-23', 2000),
			(1003, 51099, '2023-02-14', 2290),
			(1004, 52321, '2023-03-08', 2510),
			(1005, 52928, '2023-03-20', 3000),
			(1006, 53749, '2023-04-17', 1740),
			(1007, 54206, '2023-04-21', 3250),
			(1008, 54838, '2023-04-30', 1990);
	select * from customer_returns;
    
  --  b) Display the return details along with the customer details of those who have churned and have made complaints      
		SELECT * FROM customer_churn; -- CC
		SELECT * FROM customer_returns; -- CR
		SELECT CR.* , CC.* FROM Customer_Returns CR 
		JOIN Customer_churn CC  ON CR.customerId =  CC.customerId 
		WHERE CC.ChurnStatus = 'Churned' AND CC.ComplaintReceived='Yes' ;    
                
        
-- ***************************************************************😊😊 THANK YOU 😊😊 *****************************************************************************        
        
        
