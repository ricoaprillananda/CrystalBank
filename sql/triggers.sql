-- ============================================
-- CrystalBank • Triggers
-- ============================================

-- Drop if present
BEGIN EXECUTE IMMEDIATE 'DROP TRIGGER trg_txn_audit'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4080 THEN RAISE; END IF; END;
/

-- Audit every transaction insert
CREATE OR REPLACE TRIGGER trg_txn_audit
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
  INSERT INTO AuditLog (audit_id, txn_id, account_id, action_type, amount, created_at, created_by)
  VALUES (
    NVL((SELECT MAX(audit_id) FROM AuditLog),0)+1,
    :NEW.txn_id,
    :NEW.account_id,
    :NEW.txn_type,
    :NEW.amount,
    SYSDATE,
    USER
  );
END;
/
SHOW ERRORS;
