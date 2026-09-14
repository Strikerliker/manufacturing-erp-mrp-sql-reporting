INSERT INTO Suppliers (SupplierName, LeadTimeDays) VALUES
('Midwest Metals', 10),
('Precision Plastics', 7),
('Industrial Fasteners', 5),
('Great Lakes Electronics', 12);

INSERT INTO Customers (CustomerName) VALUES
('Northstar Equipment'),
('Summit Components'),
('Atlas Automation');

INSERT INTO Items (ItemNumber, Description, ItemType, UnitOfMeasure, ReorderPoint, StandardCost, PreferredSupplierID) VALUES
('RM-STEEL-01','Cold Rolled Steel Sheet','RAW','EA',120,18.50,1),
('RM-PLASTIC-01','ABS Housing Resin','RAW','LB',300,2.10,2),
('RM-BOLT-08','M8 Fastener','RAW','EA',500,0.15,3),
('RM-SENSOR-01','Industrial Proximity Sensor','RAW','EA',80,24.00,4),
('WIP-BRACKET-01','Formed Mounting Bracket','WIP','EA',40,11.50,NULL),
('FG-1000','Control Enclosure','FINISHED','EA',40,62.00,NULL),
('FG-2000','Sensor Mount Assembly','FINISHED','EA',60,38.00,NULL);

INSERT INTO BillOfMaterials (ParentItemID, ComponentItemID, QuantityPer)
SELECT p.ItemID,c.ItemID,v.Qty
FROM (VALUES
('FG-1000','RM-STEEL-01',1.0),
('FG-1000','RM-BOLT-08',8.0),
('FG-2000','RM-PLASTIC-01',2.5),
('FG-2000','RM-BOLT-08',4.0),
('FG-2000','RM-SENSOR-01',1.0),
('FG-2000','WIP-BRACKET-01',1.0),
('WIP-BRACKET-01','RM-STEEL-01',0.5),
('WIP-BRACKET-01','RM-BOLT-08',2.0)
) v(ParentNo,ComponentNo,Qty)
JOIN Items p ON p.ItemNumber=v.ParentNo
JOIN Items c ON c.ItemNumber=v.ComponentNo;

INSERT INTO Inventory (ItemID, QuantityOnHand, QuantityAllocated, LastCountDate)
SELECT ItemID,
CASE ItemNumber
  WHEN 'RM-STEEL-01' THEN 95
  WHEN 'RM-PLASTIC-01' THEN 420
  WHEN 'RM-BOLT-08' THEN 460
  WHEN 'RM-SENSOR-01' THEN 55
  WHEN 'WIP-BRACKET-01' THEN 30
  WHEN 'FG-1000' THEN 18
  WHEN 'FG-2000' THEN 72
END,
CASE ItemNumber
  WHEN 'RM-STEEL-01' THEN 40
  WHEN 'RM-PLASTIC-01' THEN 120
  WHEN 'RM-BOLT-08' THEN 210
  WHEN 'RM-SENSOR-01' THEN 35
  WHEN 'WIP-BRACKET-01' THEN 18
  WHEN 'FG-1000' THEN 12
  WHEN 'FG-2000' THEN 10
END,
'2026-09-10'
FROM Items;

INSERT INTO WorkOrders (WorkOrderNumber,ItemID,PlannedQuantity,CompletedQuantity,StartDate,DueDate,Status)
SELECT 'WO-1001',ItemID,80,45,'2026-09-08','2026-09-18','IN PROCESS' FROM Items WHERE ItemNumber='FG-1000'
UNION ALL SELECT 'WO-1002',ItemID,120,20,'2026-09-09','2026-09-17','IN PROCESS' FROM Items WHERE ItemNumber='FG-2000'
UNION ALL SELECT 'WO-1003',ItemID,60,0,'2026-09-15','2026-09-22','PLANNED' FROM Items WHERE ItemNumber='FG-1000'
UNION ALL SELECT 'WO-1004',ItemID,100,25,'2026-09-10','2026-09-16','IN PROCESS' FROM Items WHERE ItemNumber='WIP-BRACKET-01'
UNION ALL SELECT 'WO-1005',ItemID,50,50,'2026-09-01','2026-09-08','COMPLETE' FROM Items WHERE ItemNumber='FG-2000';

INSERT INTO PurchaseOrders (PONumber,SupplierID,ItemID,OrderedQuantity,ReceivedQuantity,OrderDate,ExpectedDate,Status)
SELECT 'PO-501',s.SupplierID,i.ItemID,200,0,'2026-09-05','2026-09-15','OPEN' FROM Suppliers s JOIN Items i ON i.ItemNumber='RM-STEEL-01' WHERE s.SupplierName='Midwest Metals'
UNION ALL SELECT 'PO-502',s.SupplierID,i.ItemID,1000,400,'2026-09-06','2026-09-14','PARTIAL' FROM Suppliers s JOIN Items i ON i.ItemNumber='RM-BOLT-08' WHERE s.SupplierName='Industrial Fasteners'
UNION ALL SELECT 'PO-503',s.SupplierID,i.ItemID,100,20,'2026-09-02','2026-09-13','PARTIAL' FROM Suppliers s JOIN Items i ON i.ItemNumber='RM-SENSOR-01' WHERE s.SupplierName='Great Lakes Electronics'
UNION ALL SELECT 'PO-504',s.SupplierID,i.ItemID,500,500,'2026-08-28','2026-09-08','CLOSED' FROM Suppliers s JOIN Items i ON i.ItemNumber='RM-PLASTIC-01' WHERE s.SupplierName='Precision Plastics';

INSERT INTO SalesOrders (SONumber,CustomerID,ItemID,OrderQuantity,ShippedQuantity,OrderDate,RequiredDate,Status)
SELECT 'SO-9001',c.CustomerID,i.ItemID,75,20,'2026-09-04','2026-09-19','PARTIAL' FROM Customers c JOIN Items i ON i.ItemNumber='FG-1000' WHERE c.CustomerName='Northstar Equipment'
UNION ALL SELECT 'SO-9002',c.CustomerID,i.ItemID,100,0,'2026-09-07','2026-09-20','OPEN' FROM Customers c JOIN Items i ON i.ItemNumber='FG-2000' WHERE c.CustomerName='Summit Components'
UNION ALL SELECT 'SO-9003',c.CustomerID,i.ItemID,40,40,'2026-08-29','2026-09-09','SHIPPED' FROM Customers c JOIN Items i ON i.ItemNumber='FG-1000' WHERE c.CustomerName='Atlas Automation'
UNION ALL SELECT 'SO-9004',c.CustomerID,i.ItemID,45,0,'2026-09-10','2026-09-23','OPEN' FROM Customers c JOIN Items i ON i.ItemNumber='FG-2000' WHERE c.CustomerName='Atlas Automation';
