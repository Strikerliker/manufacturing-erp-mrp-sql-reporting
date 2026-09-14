-- Manufacturing ERP/MRP reusable database objects
-- SQL Server / T-SQL
-- Run after schema.sql and seed.sql.

CREATE OR ALTER VIEW dbo.vw_InventoryStatus
AS
SELECT
    i.ItemID,
    i.ItemNumber,
    i.Description,
    i.ItemType,
    i.UnitOfMeasure,
    inv.QuantityOnHand,
    inv.QuantityAllocated,
    inv.QuantityOnHand - inv.QuantityAllocated AS AvailableQuantity,
    i.ReorderPoint,
    CASE
        WHEN inv.QuantityOnHand - inv.QuantityAllocated < i.ReorderPoint THEN 'REORDER'
        ELSE 'OK'
    END AS InventoryStatus,
    inv.LastCountDate
FROM dbo.Items AS i
JOIN dbo.Inventory AS inv ON inv.ItemID = i.ItemID;
GO

CREATE OR ALTER VIEW dbo.vw_OpenWorkOrders
AS
SELECT
    wo.WorkOrderID,
    wo.WorkOrderNumber,
    i.ItemNumber,
    i.Description,
    wo.PlannedQuantity,
    wo.CompletedQuantity,
    wo.PlannedQuantity - wo.CompletedQuantity AS RemainingQuantity,
    CAST(100.0 * wo.CompletedQuantity / NULLIF(wo.PlannedQuantity, 0) AS DECIMAL(6,2)) AS PercentComplete,
    wo.StartDate,
    wo.DueDate,
    wo.Status,
    CASE
        WHEN wo.DueDate < CAST(GETDATE() AS date) THEN 'LATE'
        WHEN DATEDIFF(day, CAST(GETDATE() AS date), wo.DueDate) <= 3 THEN 'AT RISK'
        ELSE 'ON TRACK'
    END AS ScheduleRisk
FROM dbo.WorkOrders AS wo
JOIN dbo.Items AS i ON i.ItemID = wo.ItemID
WHERE wo.Status <> 'COMPLETE';
GO

CREATE OR ALTER VIEW dbo.vw_MaterialShortages
AS
WITH OpenRequirements AS (
    SELECT
        b.ComponentItemID,
        SUM(b.QuantityPer * (wo.PlannedQuantity - wo.CompletedQuantity)) AS TotalRequiredQty
    FROM dbo.WorkOrders AS wo
    JOIN dbo.BillOfMaterials AS b ON b.ParentItemID = wo.ItemID
    WHERE wo.Status IN ('PLANNED','RELEASED','IN PROCESS')
    GROUP BY b.ComponentItemID
)
SELECT
    i.ItemNumber,
    i.Description,
    req.TotalRequiredQty,
    inv.QuantityOnHand,
    inv.QuantityAllocated,
    inv.QuantityOnHand - inv.QuantityAllocated AS AvailableQuantity,
    (inv.QuantityOnHand - inv.QuantityAllocated) - req.TotalRequiredQty AS ProjectedBalance,
    CASE
        WHEN (inv.QuantityOnHand - inv.QuantityAllocated) - req.TotalRequiredQty < 0 THEN 'SHORTAGE'
        ELSE 'AVAILABLE'
    END AS MaterialStatus
FROM OpenRequirements AS req
JOIN dbo.Items AS i ON i.ItemID = req.ComponentItemID
JOIN dbo.Inventory AS inv ON inv.ItemID = req.ComponentItemID;
GO

CREATE OR ALTER VIEW dbo.vw_OpenPurchaseOrders
AS
SELECT
    po.PurchaseOrderID,
    po.PONumber,
    s.SupplierName,
    i.ItemNumber,
    i.Description,
    po.OrderedQuantity,
    po.ReceivedQuantity,
    po.OrderedQuantity - po.ReceivedQuantity AS OpenQuantity,
    po.OrderDate,
    po.ExpectedDate,
    po.Status,
    CASE
        WHEN po.ExpectedDate < CAST(GETDATE() AS date) THEN 'PAST DUE'
        WHEN DATEDIFF(day, CAST(GETDATE() AS date), po.ExpectedDate) <= 2 THEN 'DUE SOON'
        ELSE 'OPEN'
    END AS DeliveryStatus
FROM dbo.PurchaseOrders AS po
JOIN dbo.Suppliers AS s ON s.SupplierID = po.SupplierID
JOIN dbo.Items AS i ON i.ItemID = po.ItemID
WHERE po.Status IN ('OPEN','PARTIAL');
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetManufacturingKPIs
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        (SELECT COUNT(*) FROM dbo.WorkOrders WHERE Status IN ('PLANNED','RELEASED','IN PROCESS','HOLD')) AS OpenWorkOrders,
        (SELECT COUNT(*) FROM dbo.WorkOrders WHERE DueDate < CAST(GETDATE() AS date) AND Status <> 'COMPLETE') AS LateWorkOrders,
        (SELECT COUNT(*) FROM dbo.vw_InventoryStatus WHERE InventoryStatus = 'REORDER') AS ItemsBelowReorderPoint,
        (SELECT COUNT(*) FROM dbo.PurchaseOrders WHERE Status IN ('OPEN','PARTIAL')) AS OpenPurchaseOrders,
        (SELECT COUNT(*) FROM dbo.PurchaseOrders WHERE ExpectedDate < CAST(GETDATE() AS date) AND Status IN ('OPEN','PARTIAL')) AS PastDuePurchaseOrders,
        (SELECT COUNT(*) FROM dbo.SalesOrders WHERE Status IN ('OPEN','PARTIAL')) AS OpenSalesOrders,
        (SELECT COUNT(*) FROM dbo.vw_MaterialShortages WHERE MaterialStatus = 'SHORTAGE') AS ComponentShortages;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetWorkOrderRisk
    @DaysAhead INT = 3
AS
BEGIN
    SET NOCOUNT ON;

    IF @DaysAhead < 0
        THROW 50001, 'DaysAhead must be zero or greater.', 1;

    SELECT
        wo.WorkOrderNumber,
        i.ItemNumber,
        i.Description,
        wo.PlannedQuantity,
        wo.CompletedQuantity,
        wo.PlannedQuantity - wo.CompletedQuantity AS RemainingQuantity,
        wo.DueDate,
        wo.Status,
        CASE
            WHEN wo.DueDate < CAST(GETDATE() AS date) THEN 'LATE'
            WHEN DATEDIFF(day, CAST(GETDATE() AS date), wo.DueDate) <= @DaysAhead THEN 'AT RISK'
            ELSE 'ON TRACK'
        END AS ScheduleRisk
    FROM dbo.WorkOrders AS wo
    JOIN dbo.Items AS i ON i.ItemID = wo.ItemID
    WHERE wo.Status <> 'COMPLETE'
    ORDER BY wo.DueDate, wo.WorkOrderNumber;
END;
GO

CREATE OR ALTER PROCEDURE dbo.usp_GetMaterialShortages
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ItemNumber,
        Description,
        TotalRequiredQty,
        AvailableQuantity,
        ProjectedBalance,
        MaterialStatus
    FROM dbo.vw_MaterialShortages
    WHERE MaterialStatus = 'SHORTAGE'
    ORDER BY ProjectedBalance ASC, ItemNumber;
END;
GO
