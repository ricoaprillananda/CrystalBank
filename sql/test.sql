-- ============================================
-- CrystalBank • End-to-End Test
-- ============================================

SET SERVEROUTPUT ON;

-- 1) Check balances before
SELECT * FROM Accounts ORDER BY account_id;

-- 2) Transfer 200 from Alice(101) to Brian(102)
BEGIN
  Transfer_Funds(101, 102, 200);
  DBMS_OUTPUT.PUT_LINE('Transfer 200 from 101 to 102 completed.');
END;
/

-- 3) Attempt overdraft (should raise error)
BEGIN
  Transfer_Funds(201, 102, 999);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Expected error: ' || SQLERRM);
END;
/

-- 4) Balances after
SELECT * FROM Accounts ORDER BY account_id;

-- 5) Transaction records
SELECT * FROM Transactions ORDER BY txn_id;

-- 6) Audit log
SELECT * FROM AuditLog ORDER BY audit_id;
