# ERP/MRP Reporting User Training and Support Handoff

## Audience
Operations, Production, Purchasing, Supply Chain, management, and IT support users who consume the manufacturing reporting outputs.

## Training objectives
After the walkthrough, a user should be able to:
- understand the purpose of each major report;
- interpret available inventory versus on-hand inventory;
- identify late/at-risk work orders;
- identify projected component shortages;
- interpret supplier delivery exposure;
- understand KPI/dashboard values;
- recognize when a result requires business action versus IT investigation;
- provide enough information for IT to troubleshoot a reporting issue.

## Report guide
### Inventory Shortage Report
**Use when:** reviewing material availability or replenishment priorities.

**Key fields:** item number, description, on-hand quantity, allocated quantity, available quantity, reorder point, reorder gap.

**Interpretation:** available quantity is on-hand quantity minus allocated quantity. A positive physical balance does not necessarily mean material is available for a new work order.

**Typical action:** Purchasing or Supply Chain reviews replenishment/incoming supply; Production reviews impact to scheduled work.

### Work Order Status & Risk Report
**Use when:** reviewing production progress and schedule exposure.

**Key fields:** work-order number, item, planned quantity, completed quantity, remaining quantity, percent complete, due date, schedule risk.

**Typical action:** Production reviews late or near-due orders and determines whether material, labor, equipment, priority, or another constraint needs attention.

### Material Shortage Report
**Use when:** determining whether open production demand exceeds available component inventory.

**Key fields:** component, total required quantity, on-hand, allocated, available, projected balance, material status.

**Interpretation:** a negative projected balance indicates that current available inventory does not cover modeled open-production demand.

**Typical action:** validate allocations and requirements, then review incoming supply or production priorities.

### Supplier / Open PO Report
**Use when:** reviewing incoming material and supplier delivery exposure.

**Key fields:** PO number, supplier, item, ordered, received, open quantity, expected date, delivery status.

**Typical action:** Purchasing follows up on past-due or near-due supply that affects production.

### Manufacturing KPI Summary
**Use when:** management needs a concise exception summary.

**Important:** KPI values are indicators for attention; users should drill into the detailed report before making a transactional correction.

## User validation checklist
Before acting on an exception:
1. Confirm the report parameters/date context.
2. Confirm the item/work-order/PO identifier.
3. Compare the report value to the relevant ERP transaction where appropriate.
4. Determine whether the issue is operational, master-data related, or a reporting/system issue.
5. If the report appears incorrect, do not manually alter data simply to make the report match; escalate to IT with supporting details.

## How to report an issue to IT
Provide:
- report name;
- date/time observed;
- user-selected parameters;
- item, work order, PO, or sales order involved;
- expected result;
- actual result;
- screenshot or exported output if permitted;
- business impact and urgency;
- whether the source ERP screen shows the same or different value.

## IT support handoff
### First-line checks
- Reproduce the issue with the same parameters.
- Confirm source ERP records.
- Confirm user permissions and report version.
- Check whether the issue affects one record, one user, or all users.
- Reconcile the displayed calculation to the approved SQL logic.

### Escalation criteria
Escalate when the issue involves:
- suspected source-data corruption;
- security/access anomalies;
- failed database object or deployment;
- broad report failure;
- unexplained discrepancy after source reconciliation;
- quality/compliance impact;
- production-critical business interruption.

## Change communication template
**What changed:** concise description of the approved reporting/system change.

**Why:** business requirement or defect addressed.

**Effective date:** deployment date/time.

**User impact:** changed fields, filters, calculations, or workflow.

**Validation:** testing performed and business acceptance status.

**Support:** where users should report unexpected behavior.

## Post-launch follow-up
After a significant reporting change, IT should confirm that:
- users can access and run the report;
- parameters behave as documented;
- values reconcile to expected source data;
- no known dependent reports were adversely affected;
- user questions or defects are captured and tracked;
- documentation reflects the deployed version.

## Interview walkthrough
A concise demonstration is: explain one business requirement, show the corresponding SQL/report, describe how it was tested, show how a user interprets the result, and finish with the escalation/handoff process if the output does not match the ERP source.