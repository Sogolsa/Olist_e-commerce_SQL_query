# E-Commerce Data Analysis with SQL

## Project Overview
This project focuses on cleaning and analyzing an e-commerce dataset to extract actionable business insights. The goal was to examine revenue trends and identify top-performing product categories across multiple years.

## Business Tasks
1. Compare monthly revenue between two different years.  
2. Determine which product category generates the highest revenue.

## Data Cleaning & Preparation
- Converted non-numeric columns (e.g., `order_item_id`, `payment_installments`) into proper numeric types for analysis.  
- Identified and removed duplicate rows across tables (`order_items`, `products`, `payments`, `orders_dataset`).  
- Standardized product category names using a translation table.  
- Checked for null or inconsistent values in key fields such as `order_approved_at` and `order_delivered_customer_date`.  

## Data Analysis
- Joined multiple tables (`order_items`, `orders_dataset`, `products`, `payments`, and category translations`) to create a clean analytical dataset.  
- Calculated monthly revenue for different years and created views for year-over-year comparisons.  
- Aggregated revenue by product category to identify top-performing categories.

## Skills Demonstrated
- SQL data cleaning, transformation, and type casting  
- Handling duplicates and missing values  
- Complex table joins and aggregation  
- Creating SQL views for repeatable analysis  
- Business-oriented data exploration

## Next Steps / Visualization
The cleaned and aggregated dataset was used to create a Tableau Businesss Performance dashboard, showing:

A comparative revenue analysis between 2017 and 2018, alongside a breakdown of product category performance. The insights were derived from SQL queries executed on the sales dataset, focusing on monthly trends and category-level contributions.

##  Revenue Trends: 2017 vs 2018

The line graph illustrates monthly revenue fluctuations across both years. Key observations:

- **2017 maintained consistent revenue** from January to August, peaking in March and April.
- **2018 showed rapid growth**, starting lower but surpassing 2017 by October.
- **September 2017 had a data anomaly** (only 166 in revenue), possibly due to missing or corrupted entries.
- **October and November 2018** saw the highest revenue spikes, indicating strong Q4 performance.

## Top Product Categories by Revenue

The bar chart ranks product categories based on total revenue. Highlights include:

- **bed-bath-table**: Highest overall revenue contributor.
- **health-beauty** and **furniture-decor**: Strong performers with consistent sales.
- Categories like **watches-gifts**, **auto**, and **cool-stuff** also showed notable traction.

