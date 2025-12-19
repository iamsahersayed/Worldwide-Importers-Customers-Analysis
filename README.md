# Worldwide Importers SQL Analysis  
### Customer, Product & Sales Insights using SQL

## 📌 Project Overview

This repository contains an end-to-end **SQL business analysis** performed on the **Worldwide Importers (WWI)** database.  
The project focuses on answering realistic business questions related to **customer value, product performance, suppliers, delivery methods, inventory, and sales trends**.

Rather than only presenting final queries, this project documents the **full analytical process** — including initial drafts, mistakes, refinements, and the reasoning behind each SQL decision — to reflect how SQL is used in real-world analytical roles.

---

## 🎯 Objectives

- Analyse customer purchasing behaviour and value
- Identify high-performing products, stock groups, and suppliers
- Evaluate delivery method usage across sales and purchasing
- Perform exploratory data analysis (EDA) to uncover trends and risks
- Translate SQL results into **actionable business insights**

---

## 🧠 Key Business Questions Addressed

- What is the **average order value** for customers in 2016?
- Which **stock groups** generate the highest total sales?
- Which **suppliers** contribute the most revenue, including those with zero sales?
- How frequently are different **delivery methods** used in sales vs purchasing?
- Which customers purchase the **most diverse range of products**?
- Who are the **top high-value customers**, and what do they buy?
- Which cities have the highest order volumes and what are their top products?
- How has **year-on-year growth** changed across stock groups?
- Are there products with **low stock but high sales demand**?
- How much do **new products** contribute to total group sales?

---

## 🛠️ Tools & Techniques Used

- **SQL Server (T-SQL)**
- Multi-table joins across Sales, Warehouse, Purchasing & Application schemas
- Subqueries & Common Table Expressions (CTEs)
- Window functions (`ROW_NUMBER`)
- Aggregations & calculated metrics
- NULL handling and LEFT JOIN logic
- Iterative debugging and query refinement
- Business-focused interpretation of results

