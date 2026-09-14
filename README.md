# Manufacturing ERP/MRP SQL Reporting System

A SQL Server portfolio project that simulates the reporting and operational support work of an IT Systems Analyst supporting a manufacturing ERP/MRP environment.

## Business scenario

A small manufacturer needs better visibility into production, inventory, purchasing, suppliers, and customer orders. The ERP contains the transactional data, but operations leaders need reusable SQL-backed reporting that quickly answers practical business questions.

This project models a simplified manufacturing system and adds reporting queries, reusable views, stored procedures, an ERD, and a dashboard-ready reporting layer.

## Architecture / ERD

![Manufacturing ERP/MRP ERD](docs/erd.svg)

The model covers:

- Suppliers and preferred item sourcing
- Customers and sales orders
- Items and inventory balances
- Parent/component bill-of-material relationships
- Production work orders
- Purchase orders and supplier delivery exposure

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

## Files

- `schema.sql` - creates tables, constraints, relationships, and reporting indexes
- `seed.sql` - loads realistic sample manufacturing data
- `reports.sql` - contains eight operational and management reporting queries
- `database_objects.sql` - creates reusable SQL views and stored procedures
- `dashboard_queries.sql` - returns dashboard-ready KPI, production, inventory, shortage, purchasing, and fulfillment datasets
- `docs/erd.svg` - visual entity-relationship diagram
- `docs/dashboard-preview.svg` - portfolio dashboard preview built from the seeded dataset

## Quick start

1. Create an empty SQL Server database named `ManufacturingERP`.
2. Run `schema.sql`.
3. Run `seed.sql`.
4. Run `database_objects.sql`.
5. Run `reports.sql` for the detailed reporting pack.
6. Run `dashboard_queries.sql` for dashboard-ready result sets.

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

Example:

```sql
EXEC dbo.usp_GetManufacturingKPIs;
EXEC dbo.usp_GetWorkOrderRisk @DaysAhead = 3;
EXEC dbo.usp_GetMaterialShortages;
```

## Dashboard preview

![Manufacturing Operations Dashboard](docs/dashboard-preview.svg)

The preview uses the sample data in `seed.sql` and demonstrates the types of visuals that can be produced from the reporting layer: open work orders, reorder exceptions, material shortages, purchase-order exposure, sales-order status, and production completion.

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

A useful demo path is:

1. Start with the ERD and explain how Items connect production, purchasing, inventory, BOMs, and sales.
2. Show `dbo.vw_InventoryStatus` and identify inventory below reorder point.
3. Run `dbo.usp_GetMaterialShortages` and explain how open work-order demand is compared with available component inventory.
4. Run `dbo.usp_GetWorkOrderRisk @DaysAhead = 3` to identify production orders that need attention.
5. Run `dbo.usp_GetManufacturingKPIs` and finish with the dashboard preview to show how transactional SQL supports management reporting.

## Business questions answered

- Which inventory items are below their reorder point?
- Which work orders are late or approaching their due date?
- Which components could stop production?
- What quantities remain open on supplier purchase orders?
- Which suppliers have past-due or near-due deliveries?
- Which customer orders still require production or shipment?
- How far along is each manufacturing work order?
- What are the current high-level manufacturing and supply-chain KPIs?

## Portfolio talking points

This project focuses on business-system support rather than a purely cloud-native use case. It demonstrates the ability to understand manufacturing data relationships, translate operational questions into reusable SQL, apply data-integrity controls, create reporting abstractions, and present technical data in a format useful to operations, purchasing, production, and management teams.

## Possible next enhancements

Future versions could add routing and work-center tables, lot/serial tracking, quality inspections, machine downtime, labor transactions, SQL Agent automation, a live Power BI report, and an AI support layer over ERP procedures and reporting data.
