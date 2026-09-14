# ERP/MRP Reporting Test & Validation Plan

## Objective
Validate that the Manufacturing ERP/MRP reporting solution produces accurate, repeatable results and that changes can be safely promoted after technical and business-user review.

## Test approach
Testing covers schema integrity, seeded data, reporting logic, views, stored procedures, parameters, exception handling, and business acceptance.

| ID | Test case | Expected result |
|---|---|---|
| T01 | Load `schema.sql` into an empty database | All tables, constraints, relationships, and indexes are created without errors |
| T02 | Run `seed.sql` | Suppliers, customers, items, BOMs, inventory, work orders, POs, and sales orders load successfully |
| T03 | Attempt duplicate ItemNumber | Unique constraint prevents duplicate master-data key |
| T04 | Attempt BOM row with same parent/component | Check constraint prevents invalid self-reference |
| T05 | Query `vw_InventoryStatus` | Available quantity equals on-hand minus allocated quantity |
| T06 | Compare shortage report to reorder points | Only qualifying inventory exceptions are flagged |
| T07 | Query `vw_OpenWorkOrders` | Complete work orders are excluded and remaining quantity is correct |
| T08 | Execute `usp_GetWorkOrderRisk @DaysAhead = 3` | Work orders are classified consistently by due date and completion status |
| T09 | Execute `usp_GetMaterialShortages` | Aggregated BOM demand is compared with available component inventory |
| T10 | Query `vw_OpenPurchaseOrders` | Closed/cancelled POs are excluded and open quantity is ordered minus received |
| T11 | Execute `usp_GetManufacturingKPIs` | KPI counts reconcile to detailed report rows |
| T12 | Run dashboard queries | KPI and detail datasets return without SQL errors |
| T13 | Run report with no matching parameter values | Report returns a valid empty result rather than misleading data |
| T14 | Compare report output with source transactions | Totals and exception status reconcile to source tables |
| T15 | Business-user acceptance walkthrough | Operations/purchasing user confirms labels, filters, results, and actions are understandable |

## Regression checklist
After a SQL or reporting change:
1. Rebuild a clean test database.
2. Load the standard seed dataset.
3. Execute all views and stored procedures.
4. Reconcile KPI totals to detailed rows.
5. Verify report parameters, sorting, grouping, and empty-result behavior.
6. Confirm no existing report output changed unexpectedly.
7. Record test evidence and obtain user acceptance before production promotion.

## Change-control evidence
For each change retain: requirement/request, change description, SQL object affected, developer/tester, test date, test result, known limitations, business approval, implementation date, and rollback instructions.

## Acceptance criteria
The reporting package is acceptable when SQL executes without error, calculations reconcile to source data, exception logic matches documented rules, users can interpret the output, and the change has documented testing and approval.