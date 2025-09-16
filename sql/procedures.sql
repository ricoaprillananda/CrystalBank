-- ============================================
-- CrystalBank • Procedures
-- ============================================

-- Drop if present
BEGIN EXECUTE IMMEDIATE 'DROP PROCEDURE Transfer_Funds'; EXCEPTION WHEN OTHERS THEN IF SQLCODE != -4043 THEN RAISE; END IF; END;
/

-- Transfer_Funds: atomic debit-credit with balance validation
CREATE OR REPLACE PROCEDURE Transfer_Funds (
  p_from_account IN NUMBER,
  p_to_account   IN NUMBER,
  p_amount       IN NUMBER
) AS
  v_balance NUMBER(14,2);
  v_txn_id  NUMBER;
BEGIN
  IF p_amount <= 0 THEN
    RAISE_APPLICATION_ERROR(-20010, 'Transfer amount must be positive');
  END IF;

  -- Lock source account for update
  SELECT balance INTO v_balance
    FROM Accounts
   WHERE account_id = p_from_account
   FOR UPDATE;

  IF v_balance < p_amount THEN
    RAISE_APPLICATION_ERROR(-20011, 'Insufficient funds');
  END IF;

  -- Debit source
  UPDATE Accounts
     SET balance = balance - p_amount
   WHERE account_id = p_from_account;

  v_txn_id := NVL((SELECT MAX(txn_id) FROM Transactions),0)+1;
  INSERT INTO Transactions (txn_id, account_id, txn_type, amount, txn_date)
  VALUES (v_txn_id, p_from_account, 'DEBIT', p_amount, SYSDATE);

  -- Credit destination
  UPDATE Accounts
     SET balance = balance + p_amount
   WHERE account_id = p_to_account;

  v_txn_id := NVL((SELECT MAX(txn_id) FROM Transactions),0)+1;
  INSERT INTO Transactions (txn_id, account_id, txn_type, amount, txn_date)
  VALUES (v_txn_id, p_to_account, 'CREDIT', p_amount, SYSDATE);

  COMMIT;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20012, 'Account not found');
  WHEN OTHERS THEN
    ROLLBACK;
    RAISE;
END Transfer_Funds;
/
SHOW ERRORS;
