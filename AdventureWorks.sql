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

--------------------------------------------------------------------------------------------------------------------
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
---------------------------------------------------------------------------------------------------------------------------
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
----------------------------------------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------------------------------------------------
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
--------------------------------------------------------------------------------------------------------------------
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
------------------------------------------------------------------------------------------------------------------
