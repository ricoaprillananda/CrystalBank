# CrystalBank 💎🏦🍃
CrystalBank is a PL/SQL system for managing accounts and transactions with clarity and precision. It enables atomic transfers with exception handling for insufficient funds, while audit triggers log every operation for transparency and trust.

---

## Features

> Relational schema with three entities: Accounts, Transactions, and AuditLog.

> Transfer procedure (Transfer_Funds) to debit and credit accounts atomically.

> Exception handling to block overdrafts and preserve consistency.

> Audit trigger that records every transaction for traceability.

> Sample dataset to simulate accounts and balances.

> Comprehensive test script validating transfers, overdraft cases, and audit logging.

---

### Project Structure

```
CrystalBank/
├── sql/
│   ├── tables.sql        # Schema definitions
│   ├── procedures.sql    # Atomic transfer procedure
│   ├── triggers.sql      # Audit trigger
│   ├── seed.sql          # Sample data
│   └── test.sql          # End-to-end validation
├── LICENSE               # MIT License
└── README.md             # Project documentation
```
---

## Quick Start

### 1. Create Schema

Run the schema definition script in Oracle Live SQL or an Oracle XE instance:

```
@sql/tables.sql
```

### 2. Load Procedures and Triggers

```
@sql/procedures.sql
@sql/triggers.sql
```

### 3. Insert Sample Data

```
@sql/seed.sql
```

### 4. Execute Tests

Run the validation workflow:

```
@sql/test.sql
```

### Example Output

```
Transfer 200 from 101 to 102 completed.
Expected error: ORA-20011: Insufficient funds
```

Audit queries show each transaction logged with account, action type, and timestamp for full transparency.

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---

## Author
Created by Rico Aprilla Nanda

