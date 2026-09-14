# Manufacturing Data Integrity and IATF 16949 Support Controls

## Scope and intent
This portfolio artifact demonstrates IT controls that can support manufacturing quality-system objectives involving data integrity, reporting, system controls, traceability, and controlled change. It does **not** claim that this sample application or repository is IATF 16949 certified or independently demonstrates compliance.

## Control objectives
### 1. Master-data integrity
- Item numbers are unique.
- Supplier, customer, item, BOM, inventory, work-order, purchase-order, and sales-order relationships use primary/foreign keys.
- Quantity and date constraints reject invalid transactional states.
- BOM parent and component cannot be the same item.

### 2. Reporting integrity
- Business calculations are centralized in reusable SQL views and procedures where practical.
- Dashboard/KPI values must reconcile to detailed source queries.
- Report specifications document source, fields, parameters, grouping, validation, and expected user action.
- Changes to report logic require regression testing of affected outputs.

### 3. Change control
For a production implementation, each material change should have:
1. documented business requirement;
2. technical impact assessment;
3. test evidence;
4. business/user acceptance where applicable;
5. approval before production deployment;
6. implementation date and responsible party;
7. rollback or recovery approach;
8. post-implementation validation.

### 4. Traceability and auditability
- Source records use stable business identifiers such as item, work-order, PO, and sales-order numbers.
- Test cases identify the requirement and expected result they validate.
- Git commit history provides development-level version history for this portfolio implementation.
- A production environment should additionally use the organization's authorized ticketing/change-management and database audit mechanisms.

### 5. Access and segregation
A production ERP/reporting environment should use role-based, least-privilege access. Typical separation includes:
- business users: run approved reports;
- report developers/analysts: develop in non-production and submit controlled changes;
- database administrators: manage database/platform permissions and deployment controls;
- approvers/business owners: validate business suitability and authorize release where required.

### 6. Data validation checks
Recommended recurring checks include:
- orphaned or invalid relationships;
- negative or impossible quantities;
- duplicate business identifiers;
- inventory counts that have not been updated within the organization's defined interval;
- open work orders past due;
- purchase orders past expected delivery;
- projected component shortages;
- report totals that fail reconciliation to source transactions.

## Example control evidence matrix
| Control area | Portfolio evidence |
|---|---|
| Referential integrity | `schema.sql` foreign keys and constraints |
| Report consistency | `database_objects.sql`, `reports.sql` |
| Test evidence | `docs/test-plan.md` |
| Requirement traceability | `docs/requirements-and-technical-specification.md` |
| Root-cause investigation | `docs/root-cause-case-study.md` |
| Report design/validation | `reports/crystal-report-specifications.md` |
| User guidance | `docs/user-training-and-handoff.md` |

## Example controlled reporting change
**Request:** Purchasing asks for a new field showing remaining open PO quantity.

**Requirement:** Open quantity must equal ordered quantity minus received quantity.

**Technical change:** Add the calculated field to the approved SQL reporting object and Crystal Reports design.

**Validation:** Test fully open, partially received, and closed orders; reconcile output to source PO quantities.

**Approval:** Purchasing representative confirms the report meets the business requirement before release.

**Post-implementation:** Verify the production report returns expected results and record any follow-up issue through the normal support/change process.

## Interview talking point
The key quality-system principle demonstrated here is controlled, traceable information: understand the business requirement, protect source-data integrity, standardize report logic, validate results, document the change, obtain appropriate approval, and preserve evidence that the result was tested.