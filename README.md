# Data Analysis of a DVD-Rental
SQL Repository 

The data analysis focuses on understanding the DVD store's rental business by exploring customer behavior, rental patterns, revenue trends, and inventory management. The main objectives are to identify the number of rentals, revenue generated, and to assess if the DVD store needs more inventory.

## Table of Contents

- [Customer Analysis](#customer-analysis)
- [Rental Analysis](#rental-analysis)
- [Revenue Analysis](#revenue-analysis)
- [Inventory Analysis](#inventory-analysis)
- [Films with Special Features](#films-with-special-features)
- [SQL Functions](#sql-functions)
- [Conclusion](#conclusion)

Please refer to the individual sections for detailed SQL queries and their respective results.

## Customer Analysis

This section includes queries that provide insights into customer behavior and rental patterns.
Top Customers: The analysis identified the top 10 customers based on the number of rentals they made.
Customer Payments: The query sorted customers by payment amount, revealing the most significant spenders.
Rental Returns: The analysis provided insights into the number of items rented, returned, and not returned by each customer.
Repeat Rentals: The query highlighted customers who rented the same title multiple times.
Customers with failed payments: This query aims to identify customers who have failed to make payment for two or more rentals in a given month.

Alt-H2

## Rental Analysis

These queries focus on analyzing rental data, including rental rates, popular films, and rental patterns by time.
Rental Rates: The statistical analysis of rental rates showed key metrics such as minimum, maximum, average, standard deviation, variance, and median.
Popular Films: The analysis listed the most rented films in each category, helping identify popular titles.
Rental Patterns: The number of rentals by hour of the day and day of the week was examined to understand rental patterns.
Average Rental Duration: The average number of days a category and a film title were rented helped understand popularity and demand.

Alt-H2

## Revenue Analysis

These queries help analyze revenue trends, including total revenue, average revenue per transaction, and month-over-month revenue growth.
Monthly Revenue: The analysis summarized payments by month, showing total payment amounts and average payment amounts per month.
Daily Revenue: The query provided insights into total revenue, average revenue, and the number of transactions on a day-to-day basis.
Month-over-Month Revenue: The analysis highlighted month-over-month revenue changes, allowing the store to monitor revenue trends.
Cumulative Revenue: The analysis finds the cumulative revenue for each day of the month

Alt-H2

## Inventory Analysis

This section explores the DVD store's inventory management, including the count of inventory by film titles, copies rented by month, and comparison of copies rented versus the average for each title.
Inventory Count: The analysis counted the number of items in the inventory for each film title.
Rental Trends: The number of copies rented by month helped understand seasonal rental trends.
Inventory Management: The analysis compared the number of copies rented per month to the average number of copies rented by title, aiding inventory management decisions.

Alt-H2

## Films with Special Features

Here, you'll find queries that identify films based on the number of special features they have.
Special Features: The analysis identified the different special features available in films and their respective counts.
Special Feature Counts: Films were grouped by the number of special features, revealing how many films had specific combinations of features.

Alt-H2

## SQL Functions

Here is a list of the built-in SQL functions that was used in analyses related to the DVD store:
Aggregation Functions:
    COUNT()
    SUM()
    AVG()
    MIN()
    MAX()
    ROUND()
    STDDEV()
    VARIANCE()
    PERCENTILE_CONT()
Date/Time Functions:
    EXTRACT()
    DATE_TRUNC()
String Functions:
    CONCAT()
    UNNEST()
    ARRAY_LENGTH()
Other Functions:
    CASE WHEN ... THEN ... ELSE ... END
    COALESCE()
Window Functions:
    DENSE_RANK()
    ROW_NUMBER()
    OVER()
Joining Functions:
    LEFT JOIN

These functions are commonly used in SQL for various purposes such as aggregating data, manipulating strings, extracting information from dates, performing conditional operations, and joining tables.


## Conclusion

This repository provides a comprehensive analysis of the DVD store's data, offering insights into customer behavior, rental patterns, revenue trends, and inventory management. The SQL queries can be used as a starting point for further analysis and decision-making.

Overall, the data analysis provided valuable insights into customer preferences, rental patterns, revenue trends, and inventory management. This information can help the DVD store make informed decisions, improve customer satisfaction, and optimize its inventory to meet customer demands effectively.

Data Source - https://www.postgresqltutorial.com/postgresql-getting-started/postgresql-sample-database/


