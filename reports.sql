-- Manufacturing ERP/MRP Reporting Pack
-- SQL Server / T-SQL

-- 1. Inventory below reorder point
SELECT i.ItemNumber,
       i.Description,
       i.ItemType,
       inv.QuantityOnHand,
       inv.QuantityAllocated,
       inv.QuantityOnHand - inv.QuantityAllocated AS AvailableQuantity,
       i.ReorderPoint,
       i.ReorderPoint - (inv.QuantityOnHand - inv.QuantityAllocated) AS ReorderGap
FROM Items i
JOIN Inventory inv ON inv.ItemID = i.ItemID
WHERE inv.QuantityOnHand - inv.QuantityAllocated < i.ReorderPoint
ORDER BY ReorderGap DESC;

-- 2. Work orders late or at risk
SELECT wo.WorkOrderNumber,
       i.ItemNumber,
       i.Description,
       wo.Status,
       wo.PlannedQuantity,
       wo.CompletedQuantity,
       wo.PlannedQuantity - wo.CompletedQuantity AS RemainingQuantity,
       wo.DueDate,
       CASE
         WHEN wo.DueDate < CAST(GETDATE() AS date) AND wo.Status <> 'COMPLETE' THEN 'LATE'
         WHEN DATEDIFF(day, CAST(GETDATE() AS date), wo.DueDate) <= 3 AND wo.Status <> 'COMPLETE' THEN 'AT RISK'
         ELSE 'ON TRACK'
       END AS ScheduleRisk
FROM WorkOrders wo
JOIN Items i ON i.ItemID = wo.ItemID
WHERE wo.Status <> 'COMPLETE'
ORDER BY wo.DueDate;

-- 3. Material requirements versus available inventory by open work order
SELECT wo.WorkOrderNumber,
       finished.ItemNumber AS FinishedGood,
       component.ItemNumber AS Component,
       component.Description AS ComponentDescription,
       b.QuantityPer,
       wo.PlannedQuantity - wo.CompletedQuantity AS RemainingBuildQty,
       b.QuantityPer * (wo.PlannedQuantity - wo.CompletedQuantity) AS RequiredComponentQty,
       inv.QuantityOnHand - inv.QuantityAllocated AS AvailableComponentQty,
       (inv.QuantityOnHand - inv.QuantityAllocated)
         - b.QuantityPer * (wo.PlannedQuantity - wo.CompletedQuantity) AS ProjectedBalance
FROM WorkOrders wo
JOIN Items finished ON finished.ItemID = wo.ItemID
JOIN BillOfMaterials b ON b.ParentItemID = wo.ItemID
JOIN Items component ON component.ItemID = b.ComponentItemID
JOIN Inventory inv ON inv.ItemID = component.ItemID
WHERE wo.Status IN ('PLANNED','RELEASED','IN PROCESS')
ORDER BY wo.WorkOrderNumber, component.ItemNumber;

-- 4. Open purchase orders and supplier delivery exposure
SELECT po.PONumber,
       s.SupplierName,
       i.ItemNumber,
       i.Description,
       po.OrderedQuantity,
       po.ReceivedQuantity,
       po.OrderedQuantity - po.ReceivedQuantity AS OpenQuantity,
       po.ExpectedDate,
       po.Status,
       CASE
         WHEN po.ExpectedDate < CAST(GETDATE() AS date) AND po.Status <> 'CLOSED' THEN 'PAST DUE'
         WHEN DATEDIFF(day, CAST(GETDATE() AS date), po.ExpectedDate) <= 2 THEN 'DUE SOON'
         ELSE 'OPEN'
       END AS DeliveryStatus
FROM PurchaseOrders po
JOIN Suppliers s ON s.SupplierID = po.SupplierID
JOIN Items i ON i.ItemID = po.ItemID
WHERE po.Status IN ('OPEN','PARTIAL')
ORDER BY po.ExpectedDate;

-- 5. Customer orders still requiring production or shipment
SELECT so.SONumber,
       c.CustomerName,
       i.ItemNumber,
       i.Description,
       so.OrderQuantity,
       so.ShippedQuantity,
       so.OrderQuantity - so.ShippedQuantity AS RemainingToShip,
       so.RequiredDate,
       so.Status,
       COALESCE(inv.QuantityOnHand - inv.QuantityAllocated, 0) AS AvailableFinishedGoods,
       CASE
         WHEN COALESCE(inv.QuantityOnHand - inv.QuantityAllocated, 0)
              >= so.OrderQuantity - so.ShippedQuantity THEN 'STOCK AVAILABLE'
         ELSE 'PRODUCTION REQUIRED'
       END AS FulfillmentStatus
FROM SalesOrders so
JOIN Customers c ON c.CustomerID = so.CustomerID
JOIN Items i ON i.ItemID = so.ItemID
LEFT JOIN Inventory inv ON inv.ItemID = so.ItemID
WHERE so.Status IN ('OPEN','PARTIAL')
ORDER BY so.RequiredDate;

-- 6. Production completion percentage
SELECT wo.WorkOrderNumber,
       i.ItemNumber,
       i.Description,
       wo.PlannedQuantity,
       wo.CompletedQuantity,
       CAST(100.0 * wo.CompletedQuantity / NULLIF(wo.PlannedQuantity,0) AS DECIMAL(6,2)) AS PercentComplete,
       wo.Status,
       wo.DueDate
FROM WorkOrders wo
JOIN Items i ON i.ItemID = wo.ItemID
ORDER BY wo.DueDate;

-- 7. Manufacturing operations KPI summary
SELECT
  (SELECT COUNT(*) FROM WorkOrders WHERE Status IN ('PLANNED','RELEASED','IN PROCESS','HOLD')) AS OpenWorkOrders,
  (SELECT COUNT(*) FROM WorkOrders WHERE DueDate < CAST(GETDATE() AS date) AND Status <> 'COMPLETE') AS LateWorkOrders,
  (SELECT COUNT(*)
     FROM Items i
     JOIN Inventory inv ON inv.ItemID = i.ItemID
    WHERE inv.QuantityOnHand - inv.QuantityAllocated < i.ReorderPoint) AS ItemsBelowReorderPoint,
  (SELECT COUNT(*) FROM PurchaseOrders WHERE Status IN ('OPEN','PARTIAL')) AS OpenPurchaseOrders,
  (SELECT COUNT(*) FROM PurchaseOrders WHERE ExpectedDate < CAST(GETDATE() AS date) AND Status IN ('OPEN','PARTIAL')) AS PastDuePurchaseOrders,
  (SELECT COUNT(*) FROM SalesOrders WHERE Status IN ('OPEN','PARTIAL')) AS OpenSalesOrders;

-- 8. Projected component shortages across all open production
;WITH OpenRequirements AS (
  SELECT b.ComponentItemID,
         SUM(b.QuantityPer * (wo.PlannedQuantity - wo.CompletedQuantity)) AS TotalRequiredQty
  FROM WorkOrders wo
  JOIN BillOfMaterials b ON b.ParentItemID = wo.ItemID
  WHERE wo.Status IN ('PLANNED','RELEASED','IN PROCESS')
  GROUP BY b.ComponentItemID
)
SELECT i.ItemNumber,
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
FROM OpenRequirements req
JOIN Items i ON i.ItemID = req.ComponentItemID
JOIN Inventory inv ON inv.ItemID = req.ComponentItemID
ORDER BY ProjectedBalance;
