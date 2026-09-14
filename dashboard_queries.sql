-- Dashboard-ready queries for Power BI, SSRS, or SSMS demos
-- Run after database_objects.sql.

-- KPI cards
EXEC dbo.usp_GetManufacturingKPIs;
GO

-- Work-order progress and risk
SELECT
    WorkOrderNumber,
    ItemNumber,
    Description,
    PlannedQuantity,
    CompletedQuantity,
    RemainingQuantity,
    PercentComplete,
    DueDate,
    ScheduleRisk
FROM dbo.vw_OpenWorkOrders
ORDER BY DueDate, WorkOrderNumber;
GO

-- Inventory reorder exceptions
SELECT
    ItemNumber,
    Description,
    AvailableQuantity,
    ReorderPoint,
    ReorderPoint - AvailableQuantity AS ReorderGap,
    LastCountDate
FROM dbo.vw_InventoryStatus
WHERE InventoryStatus = 'REORDER'
ORDER BY ReorderGap DESC, ItemNumber;
GO

-- Material shortages
EXEC dbo.usp_GetMaterialShortages;
GO

-- Supplier and purchase-order exposure
SELECT
    PONumber,
    SupplierName,
    ItemNumber,
    Description,
    OpenQuantity,
    ExpectedDate,
    DeliveryStatus
FROM dbo.vw_OpenPurchaseOrders
ORDER BY ExpectedDate, PONumber;
GO

-- Customer fulfillment status
SELECT
    so.SONumber,
    c.CustomerName,
    i.ItemNumber,
    so.OrderQuantity,
    so.ShippedQuantity,
    so.OrderQuantity - so.ShippedQuantity AS RemainingToShip,
    so.RequiredDate,
    COALESCE(inv.QuantityOnHand - inv.QuantityAllocated, 0) AS AvailableFinishedGoods,
    CASE
        WHEN COALESCE(inv.QuantityOnHand - inv.QuantityAllocated, 0) >= so.OrderQuantity - so.ShippedQuantity
            THEN 'STOCK AVAILABLE'
        ELSE 'PRODUCTION REQUIRED'
    END AS FulfillmentStatus
FROM dbo.SalesOrders AS so
JOIN dbo.Customers AS c ON c.CustomerID = so.CustomerID
JOIN dbo.Items AS i ON i.ItemID = so.ItemID
LEFT JOIN dbo.Inventory AS inv ON inv.ItemID = so.ItemID
WHERE so.Status IN ('OPEN','PARTIAL')
ORDER BY so.RequiredDate, so.SONumber;
GO
