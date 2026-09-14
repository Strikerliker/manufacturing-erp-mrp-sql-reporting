# Crystal Reports Design Specifications

These report specifications show how the SQL reporting layer can be presented through Crystal Reports or a comparable enterprise reporting tool. They are portfolio design artifacts rather than exported `.rpt` binaries.

## 1. Inventory Shortage Report

**Business owner:** Operations / Materials

**Purpose:** Identify items whose available quantity is below the configured reorder point so purchasing and production teams can act before a shortage disrupts manufacturing.

**Data source:** `dbo.vw_InventoryStatus`

**Parameters**
- Item type (optional)
- Shortage status (default: below reorder point)
- Last count date range (optional)

**Columns**
- Item Number
- Description
- Item Type
- Quantity On Hand
- Quantity Allocated
- Available Quantity
- Reorder Point
- Reorder Gap
- Last Count Date

**Grouping / sorting:** Group by Item Type; sort largest reorder gap first.

**Conditional formatting:** Highlight negative available quantity or material below reorder point. Flag stale inventory counts for review.

**User action:** Review shortage, validate inventory balance, then determine whether purchasing, allocation correction, or production rescheduling is required.

## 2. Work Order Status and Risk Report

**Business owner:** Production / Operations

**Purpose:** Give production leadership visibility into open work orders, completion percentage, due dates, remaining quantity, and schedule risk.

**Data source:** `dbo.vw_OpenWorkOrders`

**Parameters**
- Due date range
- Work-order status
- Item number (optional)
- Risk status (optional)

**Columns**
- Work Order Number
- Item Number
- Description
- Status
- Planned Quantity
- Completed Quantity
- Remaining Quantity
- Percent Complete
- Start Date
- Due Date
- Schedule Risk

**Grouping / sorting:** Group by Schedule Risk; sort by Due Date ascending.

**Conditional formatting:** LATE = critical exception; AT RISK = warning; ON TRACK = normal.

**User action:** Investigate late/at-risk work orders, validate material availability, and coordinate corrective action with production and purchasing.

## 3. Supplier Delivery / Open PO Report

**Business owner:** Purchasing / Supply Chain

**Purpose:** Show open purchase-order quantities and supplier delivery exposure that could affect production.

**Data source:** `dbo.vw_OpenPurchaseOrders`

**Parameters**
- Supplier (optional)
- Expected date range
- Delivery status

**Columns**
- PO Number
- Supplier Name
- Item Number
- Description
- Ordered Quantity
- Received Quantity
- Open Quantity
- Expected Date
- PO Status
- Delivery Risk

**Grouping / sorting:** Group by Supplier Name; sort Expected Date ascending.

**Conditional formatting:** Flag past-due deliveries and near-due open quantities.

**User action:** Follow up with suppliers, validate expected receipts, and communicate material risk to production.

## Validation expectations

Before a report is released, validate totals against source SQL, verify parameter behavior, test null/empty result handling, confirm sorting and grouping, review access permissions, and obtain business-user acceptance.