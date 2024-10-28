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
  
#### 5-Data Modeling

#### 6-Data Analysis & Insights

#### 7-Dashboard Overview

#### 8-Challenges Faced

#### 9-Future Work

#### 10-Recommendations

#### 11-Conclusion

## 1. Introduction

This project aims to analyze production and purchasing efficiency, identify bottlenecks, and improve overall supply chain and operational efficiency for Adventure Works.

- **Tools Used:**
    - **SQL Server:** For data extraction and joining multiple tables
    - **Power BI:** For data analysis, building the data model, creating relationships, and generating insights.
    - **Excel:** For initial data exploration, anomaly detection, and data quality checks.

      
- **Key Objectives:**
    - Analyze production performance and identify delays.
    - Track purchasing and order processes for improvement.
    - Develop insights to enhance production planning and operational efficiency.
       
- **Data Source:** [AdventureWorks Database](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak)

## 2. AdventureWorks Dataset Overview

AdventureWorks is a comprehensive dataset for a fictional company manufacturing bicycles and related products. Our project focuses on the **Production** and **Purchasing** schemas, covering production workflows, components, orders, and procurement.

## 3. Data Exploration & Transformation with SQL

- **Exploration:**
Data was extracted from the **AdventureWorks** database using SQL queries to target key tables within multiple schemas, primarily **Production** and **Purchasing**. Over **30 tables** were integrated across these schemas through SQL queries, producing **six key tables** used for the analysis.

- **Schemas Used:** Production, Purchasing

- **Transformation Process:**
Multiple SQL queries were designed to integrate data from various tables, creating a unified dataset for deeper analysis in Power BI. Below is a summary of each query used in the process:

 - **Query 1:** Production and Work Order Data Extraction

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
 **Purpose:** Extracts production and work order data with additional latency calculations for scheduling and actual resource hours, enabling analysis of production delays.
 
 **Details:** This query pulls data from various related tables, including **WorkOrderRouting**, **Product**, **Location**, and **ScrapReason**, joining them to get a full view of work orders, product categories, and any scrap reasons.

- **Query 2:** Work Order Scheduling and Actual Start/End Dates Analysis
  
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
**Purpose:** Focuses on capturing the start and end dates for work orders and calculates latency in days.

**Details:** This query specifically examines scheduling vs. actual dates for work orders to identify delays and calculate the resource hours affected by these delays.

- **Query 3:** Product Details Extraction

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
 **Purpose:** Extracts product details, including category and subcategory information.
 
 **Details:** This query joins Product, ProductSubcategory, and ProductCategory tables to retrieve product-related information, such as cost, pricing, and categorization.

- **Query 4:** Purchase Order and Employee Details

```sql
SELECT 
    pod.PurchaseOrderID,
    p.BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    e.JobTitle,
    v.BusinessEntityID AS VendorBusinessEntityID,
    v.Name AS VendorName,
    sm.Name AS ShipMethodName,
    poh.OrderDate,
    YEAR(poh.OrderDate) AS OrderYear,
    MONTH(poh.OrderDate) AS OrderMonth,
    DAY(poh.OrderDate) AS OrderDay,
    poh.ShipDate,
    YEAR(poh.ShipDate) AS ShipYear,
    MONTH(poh.ShipDate) AS ShipMonth,
    DAY(poh.ShipDate) AS ShipDay,
    pod.DueDate,
    YEAR(pod.DueDate) AS DueYear,
    MONTH(pod.DueDate) AS DueMonth,
    DAY(pod.DueDate) AS DueDay,
    DATEDIFF(DAY, poh.ShipDate, pod.DueDate) AS shipped_dates,
    poh.SubTotal,
    poh.TaxAmt,
    poh.Freight,
    poh.TotalDue
FROM 
    Purchasing.PurchaseOrderDetail AS pod
JOIN 
    Purchasing.PurchaseOrderHeader AS poh ON pod.PurchaseOrderID = poh.PurchaseOrderID
JOIN 
    Person.Person AS p ON poh.EmployeeID = p.BusinessEntityID
JOIN 
    Purchasing.Vendor AS v ON poh.VendorID = v.BusinessEntityID
JOIN 
    HumanResources.Employee AS e ON p.BusinessEntityID = e.BusinessEntityID
JOIN
    Purchasing.ShipMethod AS sm ON poh.ShipMethodID = sm.ShipMethodID
GROUP BY 
    pod.PurchaseOrderID,
    p.BusinessEntityID,
    p.FirstName,
    p.LastName,
    e.JobTitle,
    v.BusinessEntityID,
    v.Name,
    sm.Name,
    poh.OrderDate,
    poh.ShipDate,
    pod.DueDate,
    poh.SubTotal,
    poh.TaxAmt,
    poh.Freight,
    poh.TotalDue
```
 **Purpose:** Retrieves data on purchase orders, employees, vendors, and shipping details.
 
 **Details:** Joins **PurchaseOrderDetail**, **PurchaseOrderHeader**, and other relevant tables to get a comprehensive view of each purchase order’s details, including dates and cost breakdowns.

- **Query 5:** Purchase Order Quantity and Cost Analysis

```sql
SELECT 
    pod.PurchaseOrderID,
    pod.ProductID,
    pod.UnitPrice,
    pod.OrderQty,
    pod.LineTotal,
    pod.ReceivedQty,
    CASE 
        WHEN pod.ReceivedQty > 0 THEN pod.ReceivedQty * pod.UnitPrice 
        ELSE 0 
    END AS ReceivedTotal,
    CASE 
        WHEN pod.ReceivedQty > 0 THEN (pod.OrderQty - pod.ReceivedQty) * pod.UnitPrice 
        ELSE 0 
    END AS DifflineRec,
    pod.RejectedQty,
    CASE 
        WHEN pod.RejectedQty > 0 THEN pod.RejectedQty * pod.UnitPrice 
        ELSE 0 
    END AS RejectedTotal,
    pod.StockedQty,
    CASE 
        WHEN pod.StockedQty > 0 THEN pod.StockedQty * pod.UnitPrice 
        ELSE 0 
    END AS StockedTotal,
    CASE 
        WHEN pod.StockedQty > 0 and pod.StockedQty != (pod.ReceivedQty-pod.RejectedQty) THEN (pod.ReceivedQty - pod.StockedQty) * pod.UnitPrice 
        ELSE 0 
    END AS DifflineStock,
    p.BusinessEntityID,
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    v.BusinessEntityID,
    v.Name,
    e.JobTitle
FROM 
    Purchasing.PurchaseOrderDetail AS pod
JOIN 
    Purchasing.PurchaseOrderHeader AS poh ON pod.PurchaseOrderID = poh.PurchaseOrderID
JOIN 
    Person.Person AS p ON poh.EmployeeID = p.BusinessEntityID
JOIN 
    Purchasing.Vendor AS v ON poh.VendorID = v.BusinessEntityID
JOIN 
    HumanResources.Employee AS e ON p.BusinessEntityID = e.BusinessEntityID;
```
 **Purpose:** Examines quantities and costs associated with purchase orders.
 
 **Details:** Calculates totals for received, rejected, and stocked quantities with respective unit prices to help track costs per order.

 - **Query 6:** Bill of Materials Analysis

```sql
SELECT 
    BOM.ComponentID,
    P.Name AS ComponentName,
    BOM.ProductAssemblyID,
    PL.Name AS ProductAssemblyName
FROM 
    Production.BillOfMaterials AS BOM
JOIN 
    Production.Product AS P ON BOM.ComponentID = P.ProductID
JOIN 
    Production.Product AS PL ON BOM.ProductAssemblyID = PL.ProductID;
  ```
 **Purpose:** Retrieves details about the bill of materials for each component and its assembly.
 
 **Details:** BillOfMaterials and Product tables to show how each component is part of a larger product assembly.
