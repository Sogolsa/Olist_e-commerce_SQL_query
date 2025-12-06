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
The cleaned and aggregated dataset was used to create a Tableau dashboard, showing:
- Monthly revenue trends across different years  
- Top-performing product categories by revenue  

This provides an interactive way to explore the results and derive business insights.
