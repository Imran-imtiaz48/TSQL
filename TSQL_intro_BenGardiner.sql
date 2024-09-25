-- TASK 1
/*
1. Create a stored procedure called 'MULTIPLY' that takes 2 numbers as parameters
   and outputs to the screen the answer in the following format:
   e.g. The product of 2 and 3 is 6;
*/

DROP PROCEDURE IF EXISTS MULTIPLY;
GO

CREATE PROCEDURE MULTIPLY
    @Param1 INT,
    @Param2 INT
AS
BEGIN
    DECLARE @Product INT;
    SET @Product = @Param1 * @Param2;
    SELECT CONCAT('The product of ', @Param1, ' and ', @Param2, ' is ', @Product) AS Result;
END
GO

-- Example Execution
EXEC MULTIPLY @Param1 = 2, @Param2 = 3;
GO


-- TASK 2
/*
2. Create a stored function called 'ADD' that takes 2 numbers as parameters
   and returns the sum of the numbers (as a suitable numeric datatype)
*/

DROP FUNCTION IF EXISTS ADD_NUMBERS;
GO

CREATE FUNCTION ADD_NUMBERS
    (@Param1 INT, @Param2 INT)
RETURNS INT
AS
BEGIN
    RETURN @Param1 + @Param2;
END
GO

-- Example Execution
BEGIN
    DECLARE @Result INT;
    DECLARE @Num1 INT = 3;
    DECLARE @Num2 INT = 4;

    SET @Result = dbo.ADD_NUMBERS(@Num1, @Num2);
    SELECT CONCAT('The sum of ', @Num1, ' and ', @Num2, ' is ', @Result) AS Result;
END
GO


-- TASK 3
/*
3. Create Account and Log tables, and a procedure to transfer credit from one account to another.
*/

DROP TABLE IF EXISTS LOG;
DROP TABLE IF EXISTS Account;

CREATE TABLE Account (
    AcctNo INT PRIMARY KEY, 
    FName NVARCHAR(10), 
    LName NVARCHAR(10), 
    CreditLimit INT, 
    Balance INT
);

CREATE TABLE LOG (
    ORGAcct INT, 
    LOGDateTime DATETIME, 
    RecAccnt INT, 
    Amount INT,
    PRIMARY KEY (ORGAcct, LOGDateTime),
    FOREIGN KEY (ORGAcct) REFERENCES Account (AcctNo),
    FOREIGN KEY (RecAccnt) REFERENCES Account (AcctNo)
);

-- Insert sample data
INSERT INTO Account (AcctNo, FName, LName, CreditLimit, Balance)
VALUES 
(1, 'Ben', 'Gardiner', 5000, 1000),
(2, 'Tony', 'Beroni', 55500, 105500);
GO

-- Create Procedure for Credit Transfer
DROP PROCEDURE IF EXISTS creditTransfer;
GO

CREATE PROCEDURE creditTransfer
    @ORGAcct INT,
    @RecAccnt INT,
    @Amount INT
AS
BEGIN
    -- Deduct amount from the originating account
    UPDATE Account
    SET Balance = Balance - @Amount
    WHERE AcctNo = @ORGAcct;

    -- Add amount to the receiving account
    UPDATE Account
    SET Balance = Balance + @Amount
    WHERE AcctNo = @RecAccnt;

    -- Log the transaction
    INSERT INTO LOG (ORGAcct, LOGDateTime, RecAccnt, Amount)
    VALUES (@ORGAcct, SYSDATETIME(), @RecAccnt, @Amount);
END
GO

-- Example Execution of the Credit Transfer
EXEC creditTransfer @ORGAcct = 1, @RecAccnt = 2, @Amount = 300;
GO

-- Query the updated data
SELECT * FROM Account;
SELECT * FROM LOG;
GO
