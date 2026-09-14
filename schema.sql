CREATE TABLE Suppliers (
  SupplierID INT IDENTITY PRIMARY KEY,
  SupplierName NVARCHAR(120) NOT NULL,
  LeadTimeDays INT NOT NULL CHECK (LeadTimeDays >= 0),
  Active BIT NOT NULL DEFAULT 1
);

CREATE TABLE Customers (
  CustomerID INT IDENTITY PRIMARY KEY,
  CustomerName NVARCHAR(120) NOT NULL,
  Active BIT NOT NULL DEFAULT 1
);

CREATE TABLE Items (
  ItemID INT IDENTITY PRIMARY KEY,
  ItemNumber NVARCHAR(40) NOT NULL UNIQUE,
  Description NVARCHAR(200) NOT NULL,
  ItemType NVARCHAR(20) NOT NULL CHECK (ItemType IN ('RAW','WIP','FINISHED')),
  UnitOfMeasure NVARCHAR(20) NOT NULL,
  ReorderPoint DECIMAL(18,2) NOT NULL DEFAULT 0,
  StandardCost DECIMAL(18,2) NOT NULL DEFAULT 0,
  PreferredSupplierID INT NULL REFERENCES Suppliers(SupplierID)
);

CREATE TABLE BillOfMaterials (
  ParentItemID INT NOT NULL REFERENCES Items(ItemID),
  ComponentItemID INT NOT NULL REFERENCES Items(ItemID),
  QuantityPer DECIMAL(18,4) NOT NULL CHECK (QuantityPer > 0),
  PRIMARY KEY (ParentItemID, ComponentItemID),
  CHECK (ParentItemID <> ComponentItemID)
);

CREATE TABLE Inventory (
  ItemID INT PRIMARY KEY REFERENCES Items(ItemID),
  QuantityOnHand DECIMAL(18,2) NOT NULL DEFAULT 0,
  QuantityAllocated DECIMAL(18,2) NOT NULL DEFAULT 0,
  LastCountDate DATE NULL,
  CHECK (QuantityOnHand >= 0),
  CHECK (QuantityAllocated >= 0)
);

CREATE TABLE WorkOrders (
  WorkOrderID INT IDENTITY PRIMARY KEY,
  WorkOrderNumber NVARCHAR(30) NOT NULL UNIQUE,
  ItemID INT NOT NULL REFERENCES Items(ItemID),
  PlannedQuantity DECIMAL(18,2) NOT NULL CHECK (PlannedQuantity > 0),
  CompletedQuantity DECIMAL(18,2) NOT NULL DEFAULT 0,
  StartDate DATE NOT NULL,
  DueDate DATE NOT NULL,
  Status NVARCHAR(20) NOT NULL CHECK (Status IN ('PLANNED','RELEASED','IN PROCESS','COMPLETE','HOLD')),
  CHECK (CompletedQuantity >= 0),
  CHECK (CompletedQuantity <= PlannedQuantity),
  CHECK (DueDate >= StartDate)
);

CREATE TABLE PurchaseOrders (
  PurchaseOrderID INT IDENTITY PRIMARY KEY,
  PONumber NVARCHAR(30) NOT NULL UNIQUE,
  SupplierID INT NOT NULL REFERENCES Suppliers(SupplierID),
  ItemID INT NOT NULL REFERENCES Items(ItemID),
  OrderedQuantity DECIMAL(18,2) NOT NULL CHECK (OrderedQuantity > 0),
  ReceivedQuantity DECIMAL(18,2) NOT NULL DEFAULT 0,
  OrderDate DATE NOT NULL,
  ExpectedDate DATE NOT NULL,
  Status NVARCHAR(20) NOT NULL CHECK (Status IN ('OPEN','PARTIAL','CLOSED','CANCELLED')),
  CHECK (ReceivedQuantity >= 0),
  CHECK (ReceivedQuantity <= OrderedQuantity),
  CHECK (ExpectedDate >= OrderDate)
);

CREATE TABLE SalesOrders (
  SalesOrderID INT IDENTITY PRIMARY KEY,
  SONumber NVARCHAR(30) NOT NULL UNIQUE,
  CustomerID INT NOT NULL REFERENCES Customers(CustomerID),
  ItemID INT NOT NULL REFERENCES Items(ItemID),
  OrderQuantity DECIMAL(18,2) NOT NULL CHECK (OrderQuantity > 0),
  ShippedQuantity DECIMAL(18,2) NOT NULL DEFAULT 0,
  OrderDate DATE NOT NULL,
  RequiredDate DATE NOT NULL,
  Status NVARCHAR(20) NOT NULL CHECK (Status IN ('OPEN','PARTIAL','SHIPPED','CANCELLED')),
  CHECK (ShippedQuantity >= 0),
  CHECK (ShippedQuantity <= OrderQuantity),
  CHECK (RequiredDate >= OrderDate)
);

-- Practical indexes for common reporting filters and joins.
CREATE INDEX IX_Items_PreferredSupplier ON Items(PreferredSupplierID);
CREATE INDEX IX_BOM_ComponentItem ON BillOfMaterials(ComponentItemID);
CREATE INDEX IX_WorkOrders_Status_DueDate ON WorkOrders(Status, DueDate) INCLUDE (ItemID, PlannedQuantity, CompletedQuantity);
CREATE INDEX IX_PurchaseOrders_Status_ExpectedDate ON PurchaseOrders(Status, ExpectedDate) INCLUDE (SupplierID, ItemID, OrderedQuantity, ReceivedQuantity);
CREATE INDEX IX_SalesOrders_Status_RequiredDate ON SalesOrders(Status, RequiredDate) INCLUDE (CustomerID, ItemID, OrderQuantity, ShippedQuantity);
