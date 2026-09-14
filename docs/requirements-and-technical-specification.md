# Business Requirements and Technical Specification

## Purpose
This artifact demonstrates how a manufacturing IT Systems Analyst can translate an operational problem into documented business requirements, technical specifications, testable acceptance criteria, and an implementation plan.

## Business problem
Operations, Purchasing, Production, Supply Chain, and management need a consistent way to identify inventory shortages, production schedule risk, supplier delivery exposure, and customer-order fulfillment issues. Transactional ERP/MRP data exists, but users need reliable reports that convert the data into actionable information.

## Stakeholders
- Operations: needs visibility into production constraints and schedule risk.
- Production: needs work-order progress and component availability.
- Purchasing: needs shortage and supplier delivery exposure.
- Supply Chain: needs material demand and incoming-supply visibility.
- Management: needs concise manufacturing KPIs and exception reporting.
- IT: owns technical design, validation, support, documentation, and controlled changes.

## Functional requirements
| ID | Requirement | Priority | Acceptance criterion |
|---|---|---|---|
| FR-01 | Report inventory available after allocations | High | Available quantity equals on-hand minus allocated quantity. |
| FR-02 | Identify items below reorder point | High | Any item with available quantity below its reorder point is flagged. |
| FR-03 | Show open work-order progress | High | Report shows planned, completed, remaining quantity, due date, and status. |
| FR-04 | Identify schedule risk | High | Late and near-due open work orders are classified consistently. |
| FR-05 | Calculate BOM-driven component demand | High | Remaining build quantity is multiplied by BOM quantity-per. |
| FR-06 | Identify projected material shortages | High | Required component demand is compared with available inventory. |
| FR-07 | Show open supplier commitments | Medium | Open PO quantity equals ordered quantity minus received quantity. |
| FR-08 | Identify supplier delivery exposure | Medium | Past-due and near-due open purchase orders are flagged. |
| FR-09 | Show customer fulfillment exposure | Medium | Open sales quantity and available finished-goods inventory are visible. |
| FR-10 | Provide management KPIs | Medium | KPI output reconciles to the detailed reporting datasets. |

## Non-functional requirements
- Data calculations must be repeatable and traceable to ERP source records.
- Database relationships must enforce referential integrity.
- Reports must handle empty result sets without failing.
- Changes must be tested before release and documented for support.
- Users should receive exception-oriented outputs that support an operational action.
- Access to production ERP data should follow least-privilege and approved change-control practices.

## Technical design
### Data layer
The SQL Server model uses `Items` as the common item master connected to inventory, BOMs, work orders, purchase orders, and sales orders. Suppliers and customers provide sourcing and demand context.

### Reporting layer
Reusable views provide standardized calculations for inventory status, open work orders, material shortages, and purchase-order exposure. Stored procedures provide management KPI, work-order risk, and shortage datasets.

### Presentation layer
The reporting layer can feed Crystal Reports, SSRS, Power BI, or controlled SSMS analysis. The repository includes Crystal Reports-style report specifications and a dashboard preview.

## Traceability matrix
| Business need | SQL object / artifact | Validation |
|---|---|---|
| Inventory exceptions | `vw_InventoryStatus` | `docs/test-plan.md` |
| Production risk | `vw_OpenWorkOrders`, `usp_GetWorkOrderRisk` | `docs/test-plan.md` |
| Component shortages | `vw_MaterialShortages`, `usp_GetMaterialShortages` | `docs/test-plan.md` |
| Supplier exposure | `vw_OpenPurchaseOrders` | `docs/test-plan.md` |
| Management summary | `usp_GetManufacturingKPIs`, `dashboard_queries.sql` | Dashboard reconciliation tests |
| Business-facing reports | `reports/crystal-report-specifications.md` | User acceptance criteria |

## Implementation approach
1. Confirm requirements with business stakeholders.
2. Validate ERP/MRP source fields and relationships.
3. Implement schema/reporting changes in a non-production environment.
4. Execute functional, data-integrity, regression, and reconciliation tests.
5. Review output with representative business users.
6. Obtain approval under the applicable change-control process.
7. Deploy the approved change.
8. Provide user guidance and monitor results after implementation.

## Definition of done
A reporting change is complete when its requirement is documented, SQL logic is peer-reviewed or otherwise validated, test cases pass, output reconciles to source data, business acceptance is recorded, documentation is updated, and the change has an identifiable implementation record.