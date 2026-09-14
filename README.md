# Manufacturing ERP/MRP SQL Reporting System

A compact SQL Server portfolio project that simulates the reporting work of an IT Systems Analyst supporting a manufacturing ERP/MRP environment.

## Business scenario

A small manufacturer needs better visibility into production, inventory, purchasing, and customer orders. The ERP contains the data, but operations leaders need clear SQL-backed reports that answer practical questions quickly.

This project models a simplified manufacturing system and provides reusable SQL reports for those day-to-day decisions.

## What this project demonstrates

- Manufacturing ERP/MRP concepts: items, BOMs, inventory, work orders, purchase orders, sales orders, suppliers, and customers
- SQL Server relational schema design with keys, constraints, and indexes
- BOM-driven material requirement analysis
- Inventory shortage and reorder reporting
- Work-order schedule risk reporting
- Supplier and open purchase-order visibility
- Customer-order fulfillment reporting
- Production completion and management KPI reporting

## Files

- `schema.sql` - creates the SQL Server tables, constraints, and indexes
- `seed.sql` - loads realistic sample manufacturing data
- `reports.sql` - contains operational and management reporting queries

## Quick start

1. Create an empty SQL Server database named `ManufacturingERP`.
2. Run `schema.sql`.
3. Run `seed.sql`.
4. Run `reports.sql` one section at a time.

The scripts are designed for Microsoft SQL Server / SQL Server Management Studio.

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

1. Show the `Items`, `BillOfMaterials`, `Inventory`, and `WorkOrders` relationships.
2. Open the material-requirements report and explain how BOM quantity is multiplied by remaining work-order quantity.
3. Show which components have a negative projected balance.
4. Open the work-order risk report and identify late or near-due production orders.
5. Finish with the KPI summary to show how the same transactional data can support management reporting.

## Business questions answered

- Which inventory items are below their reorder point?
- Which work orders are late or at risk?
- Which components could stop production?
- What quantities are still open on supplier purchase orders?
- Which customer orders still require production or shipment?
- How far along is each manufacturing work order?
- What are the current high-level production and supply-chain KPIs?

## Portfolio talking points

This project focuses on business-system support rather than a purely cloud-native use case. It demonstrates the ability to understand manufacturing data relationships, translate operational questions into SQL, validate data through constraints, and produce reports that operations, purchasing, production, and management teams can use.

## Possible next enhancements

A larger version could add SQL views, stored procedures, lot/serial tracking, routing/operations, quality records, machine downtime, labor transactions, SSRS/Power BI dashboards, and an AI support layer over the ERP knowledge base.
