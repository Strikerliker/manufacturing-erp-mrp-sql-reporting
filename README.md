# Manufacturing ERP/MRP SQL Reporting System

A SQL Server portfolio project that simulates the reporting and operational support work of an IT Systems Analyst supporting a manufacturing ERP/MRP environment.

## Business scenario

A small manufacturer needs better visibility into production, inventory, purchasing, suppliers, and customer orders. The ERP contains the transactional data, but operations leaders need reusable SQL-backed reporting that quickly answers practical business questions.

This project models a simplified manufacturing system and adds reporting queries, reusable views, stored procedures, an ERD, a dashboard-ready reporting layer, Crystal Reports design specifications, formal testing, and an ERP root-cause case study.

## Architecture / ERD

![Manufacturing ERP/MRP ERD](docs/erd.svg)

The model covers suppliers and preferred sourcing, customers and sales orders, items and inventory, parent/component BOM relationships, production work orders, and purchase-order delivery exposure.

## What this project demonstrates

- Manufacturing ERP/MRP concepts: items, BOMs, inventory, work orders, purchase orders, sales orders, suppliers, and customers
- SQL Server relational schema design with keys, constraints, and indexes
- BOM-driven material requirement analysis
- Inventory shortage and reorder reporting
- Work-order completion and schedule-risk reporting
- Supplier and open purchase-order visibility
- Customer-order fulfillment reporting
- Reusable SQL views and stored procedures
- Dashboard-ready datasets for Power BI, SSRS, or SSMS demonstrations
- Crystal Reports-style report requirements, parameters, grouping, and validation
- Test planning, regression testing, business acceptance, and change-control evidence
- ERP troubleshooting and root-cause analysis using SQL and operational data

## Files

- `schema.sql` - tables, constraints, relationships, and reporting indexes
- `seed.sql` - realistic sample manufacturing data
- `reports.sql` - eight operational and management reporting queries
- `database_objects.sql` - reusable SQL views and stored procedures
- `dashboard_queries.sql` - dashboard-ready datasets
- `docs/erd.svg` - visual entity-relationship diagram
- `docs/dashboard-preview.svg` - portfolio dashboard preview
- `reports/crystal-report-specifications.md` - Crystal Reports-style designs for inventory, work orders, and supplier delivery
- `docs/test-plan.md` - functional, regression, reconciliation, and user-acceptance test plan
- `docs/root-cause-case-study.md` - ERP/MRP troubleshooting case study from symptom through corrective action

## Quick start

1. Create an empty SQL Server database named `ManufacturingERP`.
2. Run `schema.sql`.
3. Run `seed.sql`.
4. Run `database_objects.sql`.
5. Run `reports.sql` for the detailed reporting pack.
6. Run `dashboard_queries.sql` for dashboard-ready result sets.
7. Review the report specifications, test plan, and root-cause case study as implementation/support artifacts.

The scripts are designed for Microsoft SQL Server / SQL Server Management Studio.

## Reusable database objects

### Views
- `dbo.vw_InventoryStatus` - available inventory, reorder status, and count-date visibility
- `dbo.vw_OpenWorkOrders` - production progress, remaining quantity, percent complete, and schedule risk
- `dbo.vw_MaterialShortages` - aggregated open-production demand versus available component inventory
- `dbo.vw_OpenPurchaseOrders` - supplier, open quantity, expected date, and delivery-risk status

### Stored procedures
- `dbo.usp_GetManufacturingKPIs` - management KPI card dataset
- `dbo.usp_GetWorkOrderRisk @DaysAhead` - configurable work-order schedule-risk report
- `dbo.usp_GetMaterialShortages` - projected shortage report ordered by severity

```sql
EXEC dbo.usp_GetManufacturingKPIs;
EXEC dbo.usp_GetWorkOrderRisk @DaysAhead = 3;
EXEC dbo.usp_GetMaterialShortages;
```

## Dashboard preview

![Manufacturing Operations Dashboard](docs/dashboard-preview.svg)

The preview uses the sample data in `seed.sql` and demonstrates open work orders, reorder exceptions, material shortages, purchase-order exposure, sales-order status, and production completion.

## Enterprise reporting design

The `reports/crystal-report-specifications.md` artifact defines three business-facing reports: Inventory Shortage, Work Order Status & Risk, and Supplier Delivery / Open PO. Each specification documents business ownership, purpose, SQL source, parameters, fields, grouping, exception formatting, validation, and expected user action.

## Testing and change validation

The `docs/test-plan.md` artifact covers database creation, data loading, integrity constraints, report calculations, stored-procedure behavior, dashboard reconciliation, regression testing, empty-result handling, business-user acceptance, and change-control evidence.

## ERP troubleshooting case study

The `docs/root-cause-case-study.md` scenario investigates a work order that appears to have material on hand but is still at risk. The analysis distinguishes on-hand inventory from inventory available after allocations, expands BOM demand, checks incoming supply, identifies the root cause, documents corrective action, and adds a preventive reporting control.

## Reports included

1. Inventory below reorder point
2. Work orders late or at risk
3. Material requirements versus available inventory
4. Open purchase orders and supplier delivery exposure
5. Customer orders still requiring production or shipment
6. Production completion percentage
7. Manufacturing operations KPI summary
8. Projected component shortages across open production

## Example interview walkthrough

1. Start with the ERD and explain how Items connect production, purchasing, inventory, BOMs, and sales.
2. Show `dbo.vw_InventoryStatus` and identify inventory below reorder point.
3. Run `dbo.usp_GetMaterialShortages` and explain how open work-order demand is compared with available inventory.
4. Run `dbo.usp_GetWorkOrderRisk @DaysAhead = 3` to identify orders requiring attention.
5. Show the Crystal Reports specifications and explain how business requirements become report parameters and layouts.
6. Walk through the root-cause case study to demonstrate troubleshooting and cross-functional support.
7. Show the test plan to demonstrate controlled testing, validation, and user acceptance.
8. Finish with `dbo.usp_GetManufacturingKPIs` and the dashboard preview.

## Portfolio talking points

This project demonstrates business-system support rather than only database coding. It shows the ability to understand manufacturing data relationships, translate operational requirements into reusable SQL and report designs, investigate ERP issues, apply data-integrity controls, validate system changes, and communicate actionable information to Operations, Purchasing, Production, Supply Chain, and management.

## Possible next enhancements

Future versions could add requirements/technical specifications, user training and handoff documentation, IATF 16949-oriented data-integrity controls, routing and work-center tables, lot/serial tracking, quality inspections, machine downtime, labor transactions, SQL Agent automation, a live Power BI report, and an AI support layer over ERP procedures and reporting data.
