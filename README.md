# 🛒 Retail Sales Analysis using SQL

📌 Project Overview
This project focuses on analyzing a retail business dataset using MySQL.
The goal is to clean raw transactional data, ensure data consistency, and extract meaningful business insights that help in decision-making such as customer behavior, product performance, and revenue trends.

The project demonstrates real-world Data Analyst workflow:

Database Creation ➜ Data Cleaning ➜ Data Validation ➜ Business Analysis ➜ Insights

🗂️ Database Structure

The database contains 3 main tables:

Table Name	Description
customer_profiles	Customer personal and demographic details
product_inventory	Product details, category, stock & price
sales_transaction	Sales records including quantity & purchase date
⚙️ Steps Performed
1️⃣ Database Setup

Created database Retail_analysis_project

Imported tables using SQL import wizard

Verified structure and data integrity

2️⃣ Data Cleaning & Preparation

Performed multiple real-world data cleaning operations:

Renamed corrupted column headers (BOM characters issue)

Removed duplicate transactions

Fixed incorrect data types (Text ➜ Date)

Handled missing values (Location → 'Unknown')

Verified NULL values across tables

Standardized date columns

Synced mismatched product prices across tables

3️⃣ Data Consistency Fix

Identified price mismatches between:

sales_transaction

product_inventory

Then updated transactions to match inventory prices to maintain financial accuracy.

📊 Business Analysis Queries

The project answers key business questions:

Sales & Product Performance

Total sales & units sold per product

Top 10 highest revenue products

Lowest selling products

Category performance evaluation

Customer Behavior Analysis

Purchase frequency per customer

High value customers

Occasional customers

Repeat purchases

Customer loyalty duration

Customer segmentation (Low / Medium / High buyers)

Trend Analysis

Daily sales trends

Month-on-Month growth rate

📈 Key Insights Generated

Identified revenue generating products

Found high frequency loyal customers

Detected low performing categories for marketing focus

Measured customer retention duration

Calculated monthly business growth

🧠 Skills Demonstrated

SQL Data Cleaning

Joins & Subqueries

Aggregations

Window Functions (LAG)

CTE (Common Table Expressions)

Business Problem Soling

Data Validation & Consistency Checks

🛠️ Tools Used

MySQL

SQL Queries

🚀 How to Run

Create database in MySQL

Import the dataset tables

Run the SQL script file

Execute analysis queries section-wise

📌 Conclusion

This project simulates a real retail company analysis scenario where raw data is transformed into actionable insights using SQL.
It highlights how data analysts support business decisions using structured querying and logical thinking.
