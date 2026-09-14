# ERP/MRP Root-Cause Case Study

## Incident
**Title:** Work order cannot proceed even though ERP shows component inventory on hand

**Scenario:** Production reports that `WO-1002` for `FG-2000` is at risk. The ERP inventory screen shows stock for required components, but the manufacturing team cannot confidently release the remaining build quantity.

## Business impact
A delayed work order can affect the customer required date, production scheduling, purchasing priorities, and management reporting. The incident therefore needs both a technical diagnosis and clear communication to Operations and Supply Chain.

## Investigation

### 1. Confirm the work-order demand
Review the work order and calculate remaining production quantity:

```sql
SELECT WorkOrderNumber, ItemNumber, PlannedQuantity, CompletedQuantity,
       RemainingQuantity, DueDate, ScheduleRisk
FROM dbo.vw_OpenWorkOrders
WHERE WorkOrderNumber = 'WO-1002';
```

### 2. Expand the BOM requirements
Use the BOM to calculate component demand for the remaining build quantity. The key distinction is between **quantity on hand** and **quantity actually available after allocations**.

```sql
SELECT wo.WorkOrderNumber,
       finished.ItemNumber AS FinishedGood,
       component.ItemNumber AS Component,
       b.QuantityPer,
       wo.PlannedQuantity - wo.CompletedQuantity AS RemainingBuildQty,
       b.QuantityPer * (wo.PlannedQuantity - wo.CompletedQuantity) AS RequiredComponentQty,
       inv.QuantityOnHand,
       inv.QuantityAllocated,
       inv.QuantityOnHand - inv.QuantityAllocated AS AvailableComponentQty
FROM WorkOrders wo
JOIN Items finished ON finished.ItemID = wo.ItemID
JOIN BillOfMaterials b ON b.ParentItemID = wo.ItemID
JOIN Items component ON component.ItemID = b.ComponentItemID
JOIN Inventory inv ON inv.ItemID = component.ItemID
WHERE wo.WorkOrderNumber = 'WO-1002';
```

### 3. Check enterprise-wide shortage exposure

```sql
EXEC dbo.usp_GetMaterialShortages;
```

### 4. Check incoming supply
Review `dbo.vw_OpenPurchaseOrders` for affected components and determine whether expected receipts resolve the shortage before the work-order due date.

## Root cause
The operational mistake is treating **QuantityOnHand** as available inventory. Some stock is already allocated to other demand. BOM requirements for open production can therefore exceed the unallocated balance even though the ERP displays a positive on-hand quantity.

## Corrective action
1. Validate physical and system inventory for the affected component.
2. Review allocations and confirm they represent legitimate demand.
3. Review open purchase orders and supplier expected dates.
4. Escalate any material shortage that threatens the work-order due date.
5. Update production/purchasing stakeholders with the affected item, shortage quantity, expected receipt, and next action.
6. Do not directly alter transactional balances outside approved ERP/change-control procedures.

## Preventive improvement
Use the material-shortage view and dashboard as an exception report rather than relying on raw on-hand inventory. Schedule the report for regular review and flag projected negative balances before production is disrupted.

## Validation
After corrective action:
- Re-run the material-shortage report.
- Confirm available inventory and allocations reconcile to source transactions.
- Confirm expected receipts are represented correctly.
- Verify production can meet the work-order requirement or document the revised plan.
- Record actions, owner, status, and follow-up date in the approved ticket/project system.

## Interview talking point
This scenario demonstrates a practical systems-analysis approach: clarify the business symptom, trace the ERP relationships, distinguish raw data from operationally meaningful data, identify root cause with SQL, coordinate a business response, validate the correction, and create a reporting control to reduce recurrence.