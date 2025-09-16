-- ============================================
-- CrystalBank • Schema Definition
-- ============================================

-- Drop in dependency order for clean re-runs
BEGIN EXECUTE IMMEDIATE 'DROP TABLE AuditLog PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Transactions PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP TABLE Accounts PURGE'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF; END;
/

-- Accounts: each customer account with balance
CREATE TABLE Accounts (
  account_id   NUMBER        PRIMARY KEY,
  holder_name  VARCHAR2(120) NOT NULL,
  balance      NUMBER(14,2)  DEFAULT 0 CHECK (balance >= 0)
);

-- Transactions: debit/credit records
CREATE TABLE Transactions (
  txn_id       NUMBER        PRIMARY KEY,
  account_id   NUMBER        NOT NULL REFERENCES Accounts(account_id),
  txn_type     VARCHAR2(10)  CHECK (txn_type IN ('DEBIT','CREDIT')),
  amount       NUMBER(14,2)  NOT NULL CHECK (amount > 0),
  txn_date     DATE          DEFAULT SYSDATE
);

-- AuditLog: every transaction action recorded by triggers
CREATE TABLE AuditLog (
  audit_id     NUMBER        PRIMARY KEY,
  txn_id       NUMBER,
  account_id   NUMBER,
  action_type  VARCHAR2(20),
  amount       NUMBER(14,2),
  created_at   DATE          DEFAULT SYSDATE,
  created_by   VARCHAR2(100) DEFAULT USER
);
