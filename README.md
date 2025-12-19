# Worldwide-Importers-Customers-Analysis
Worldwide Importers SQL Analysis

Customer, Product & Sales Insights using SQL

📌 Project Overview

This project is an end-to-end SQL-based business analysis using the Worldwide Importers (WWI) database.
The goal was to answer realistic business questions around customer value, product performance, supplier contribution, and sales trends — while demonstrating iterative SQL problem-solving, debugging, and analytical reasoning.

The project goes beyond just writing queries. It documents:

how each problem was approached

mistakes and refinements made along the way

and how SQL outputs translate into business insights

🧠 Key Business Questions Answered

This analysis focuses on questions such as:

Which customers have the highest average order value?

Which stock groups and products generate the most revenue?

Which suppliers contribute the most — including those with zero sales?

How do delivery methods differ across sales and purchasing?

Which customers purchase the most diverse range of products?

What are the top-performing cities and products over time?

How do stock levels compare to sales velocity?

Which new products contribute meaningfully to sales?

🛠️ Tools & Skills Demonstrated

SQL Server (T-SQL)

Multi-table joins across Sales, Warehouse, Purchasing, and Application schemas

Subqueries & CTEs (WITH)

Window functions (ROW_NUMBER)

Aggregations & business metrics

Handling NULLs and edge cases

Iterative debugging & query optimisation

Translating data → insights → recommendations

📂 Repository Guide
1️⃣ SQL Queries

📁 /sql/
🔗 wwi-customer-analysis.sql

This file contains all final SQL queries, including:

Customer analysis (AOV, high-value customers)

Product & stock group performance

Supplier sales (including zero-sales suppliers)

Delivery method usage

Exploratory Data Analysis (EDA)

Stock level vs sales analysis

Each query aligns with a specific business question.

2️⃣ Full Analytical Report

📁 /report/
🔗 Worldwide Importers Assignment Report.docx

This document provides:

Step-by-step reasoning for each query

Early drafts, mistakes, and corrections

Explanation of SQL decisions

Business interpretation of results

Final insights and recommendations

Think of this as the “thinking process behind the SQL.”

3️⃣ Reflections & Learnings (Optional)

📁 /notes/
Includes reflections on:

SQL debugging strategies

Trade-offs in metric selection (e.g., what defines a “high-value customer”)

Strengths and limitations of LLM-assisted analysis

📈 Key Insights (Highlights)

Packaging materials consistently dominate sales across high-order cities, indicating logistics-heavy demand.

Average Order Value proved to be a more meaningful metric for identifying high-value customers than raw spend.

Several new novelty products (2016) already contribute measurable revenue, indicating growth potential.

Certain clothing items show high sales but low stock, highlighting inventory risk.

Some products appear across multiple stock groups, suggesting data governance issues.

🚀 Why This Project Matters

This project demonstrates:

Strong SQL fundamentals plus analytical judgment

Ability to work with messy, real-world schemas

Business-oriented thinking, not just technical output

Clear communication of insights to non-technical stakeholders

It reflects how SQL is actually used in data analyst / business analyst roles.
