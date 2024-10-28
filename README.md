# *AdventureWorks Production & Purchasing Analysis Project*

## Table of Contents

#### 1-Introduction

#### 2-AdventureWorks Dataset Overview

#### 3-Data Exploration with SQL

 - Query 1: Production Workflow Analysis
 - Query 2: Production Efficiency
 - Query 3: Product Catalog Analysis
 - Query 4: Product Structure Analysis
 - Query 5: Purchase Order Breakdown
 - Query 6: Component and Assembly Analysis
  
#### 4-Data Cleaning
  
#### 5-Project Schema: Production & Purchasing Focus

#### 6-Data Analysis & Insights

#### 7-Dashboard Overview

#### 8-Challenges Faced

#### 9-Future Work

#### 10-Recommendations

#### 11-Conclusion

## 1. Introduction

This project aims to analyze production and purchasing efficiency, identify bottlenecks, and improve overall supply chain and operational efficiency for Adventure Works.

- **Tools Used:**
    - **SQL** for data extraction and analysis.
    - **Power BI** for data visualization and dashboard creation.
      
- **Key Objectives:**
    - Analyze production performance and identify delays.
    - Track purchasing and order processes for improvement.
    - Develop insights to enhance production planning and operational efficiency.
       
- **Data Source:** [AdventureWorks Database](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak)

## 2. AdventureWorks Dataset Overview

AdventureWorks is a comprehensive dataset for a fictional company manufacturing bicycles and related products. Our project focuses on the **Production** and **Purchasing** schemas, covering production workflows, components, orders, and procurement.

## 3. Data Exploration with SQL

We used several SQL queries to extract and analyze data relevant to production and purchasing. Here are the key queries with explanations and code snippets.

 - **Query 1:** Production Workflow Analysis

   - **Purpose:** Extracts work order data within a specified timeframe to assess production delays and efficiencies.

```sql

SELECT
    w.ProductID,
    p.Name,
    W.LocationID,
    L.Name AS LocationName,
    W.WorkOrderID,
	wo.OrderQty,
	pc.Name As ProductCategory,
	psc.Name As ProductSubCategory,
    w.ActualResourceHrs,
    W.ScheduledStartDate,
    YEAR(W.ScheduledStartDate) AS ScheduledStartYear,
    MONTH(W.ScheduledStartDate) AS ScheduledStartMonth,
    DAY(W.ScheduledStartDate) AS ScheduledStartDay,
    W.ActualStartDate,
    YEAR(W.ActualStartDate) AS ActualStartYear,
    MONTH(W.ActualStartDate) AS ActualStartMonth,
    DAY(W.ActualStartDate) AS ActualStartDay,
    W.ScheduledEndDate,
    YEAR(W.ScheduledEndDate) AS ScheduledEndYear,
    MONTH(W.ScheduledEndDate) AS ScheduledEndMonth,
    DAY(W.ScheduledEndDate) AS ScheduledEndDay,
    W.ActualEndDate,
    YEAR(W.ActualEndDate) AS ActualEndYear,
    MONTH(W.ActualEndDate) AS ActualEndMonth,
    DAY(W.ActualEndDate) AS ActualEndDay,
    DATEDIFF(DAY, W.ScheduledStartDate, W.ActualStartDate) AS LatencyStartDays,
    DATEDIFF(DAY, W.ScheduledEndDate, W.ActualEndDate) AS LatencyEndDays,
    DATEDIFF(DAY, W.ScheduledEndDate, W.ActualEndDate) - DATEDIFF(DAY, W.ScheduledStartDate, W.ActualStartDate) AS latencydates,
    (DATEDIFF(DAY, W.ScheduledEndDate, W.ActualEndDate) - DATEDIFF(DAY, W.ScheduledStartDate, W.ActualStartDate)) * w.ActualResourceHrs AS latencyHours,
    SR.Name AS scrappedName,
    wo.ScrappedQty
FROM
    Production.WorkOrderRouting AS W
JOIN
    Production.Product AS P ON W.ProductID = P.ProductID
JOIN
    Production.Location AS L ON W.LocationID = L.LocationID
JOIN
    Production.WorkOrder AS WO ON WO.WorkOrderID = w.WorkOrderID
JOIN
    Production.ScrapReason AS SR ON SR.ScrapReasonID = WO.ScrapReasonID
JOIN 
    Production.ProductSubcategory AS psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN 
    Production.ProductCategory AS pc ON psc.ProductCategoryID = pc.ProductCategoryID

WHERE
    W.ScheduledStartDate IS NOT NULL
    AND W.ActualEndDate IS NOT NULL
    AND W.ScheduledStartDate > '2011-01-01' 
    AND W.ActualEndDate < '2014-12-31';      
```
  **Insight:** This query helped identify major delays and bottlenecks in the production workflow.

- **Query 2:** Production Efficiency
  
  - **Purpose:** Measures the efficiency by comparing scheduled and actual timelines, factoring in resource hours.

```sql
SELECT
    w.ProductID,
	p.Name,
    W.LocationID,
    L.Name AS LocationName,
    W.WorkOrderID ,
    w.ActualResourceHrs ,
	W.ScheduledStartDate,
	YEAR(W.ScheduledStartDate) AS ScheduledStartYear,
    MONTH(W.ScheduledStartDate) AS ScheduledStartMonth,
    DAY(W.ScheduledStartDate) AS ScheduledStartDay,
	W.ActualStartDate,
	YEAR(W.ActualStartDate) AS ActualStartYear,
    MONTH(W.ActualStartDate) AS ActualStartMonth,
    DAY(W.ActualStartDate) AS ActualStartDay,
	ScheduledEndDate,
	YEAR(W.ScheduledEndDate) AS ScheduledEndYear,
    MONTH(W.ScheduledEndDate) AS ScheduledEndMonth,
    DAY(W.ScheduledEndDate) AS ScheduledEndDay,
	W.ActualEndDate,
	YEAR(W.ActualEndDate) AS ActualEndYear,
    MONTH(W.ActualEndDate) AS ActualEndMonth,
    DAY(W.ActualEndDate) AS ActualEndDay,
    DATEDIFF(DAY, W.ScheduledStartDate, W.ActualStartDate) AS LatencyStartDays,
	DATEDIFF(Day, W.ScheduledEndDate, W.ActualEndDate) AS LatencyEndDays,
    DATEDIFF(Day, W.ScheduledEndDate, W.ActualEndDate)-DATEDIFF(DAY, W.ScheduledStartDate, W.ActualStartDate) as latencydates,
	(DATEDIFF(day, W.ScheduledEndDate, W.ActualEndDate)-DATEDIFF(day, W.ScheduledStartDate, W.ActualStartDate))*w.ActualResourceHrs as latencyHours

FROM
    Production.WorkOrderRouting as W
JOIN
    Production.Product as P ON W.ProductID = P.ProductID
JOIN
    production.Location as L ON W.LocationID = L.LocationID
WHERE
    W.ScheduledStartDate IS NOT NULL
    AND W.ActualEndDate IS NOT NULL
    AND W.ScheduledStartDate > '2011-01-01' 
    AND W.ActualEndDate < '2014-12-31'
```
**Insight:** Uncovered inefficiencies in scheduling and highlighted areas where improvements could reduce delays.

- **Query 3:** Product Catalog Analysis
   - **Purpose:** Gathers detailed product information, including categories and pricing, for inventory and sales analysis.

```sql
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    psc.Name AS SubCategoryName,
    pc.Name AS ProductCategory,
    p.ProductLine,
    p.ProductNumber,
    p.Class,
    p.StandardCost,
    p.ListPrice,
    p.MakeFlag,
    p.FinishedGoodsFlag
FROM 
    Production.Product AS p
LEFT JOIN 
    Production.ProductSubcategory AS psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
LEFT JOIN 
    Production.ProductCategory AS pc ON psc.ProductCategoryID = pc.ProductCategoryID;
```
**Insight:** Helped management understand product composition and organize the catalog efficiently.

- **Query 4:** Product Structure Analysis
   - **Purpose:** Structures data for analysis of products, categorized by subcategories and components.
  
```sql
SELECT 
    BOM.ComponentID,
    P.Name AS ComponentName,
	P.MakeFlag,
    BOM.ProductAssemblyID,
    PL.Name AS ProductAssemblyName
FROM 
    Production.BillOfMaterials AS BOM
JOIN 
    Production.Product AS P ON P.ProductID = BOM.ComponentID
LEFT OUTER JOIN 
    Production.Product AS PL ON PL.ProductID = BOM.ProductAssemblyID;
```



