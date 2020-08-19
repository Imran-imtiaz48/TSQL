-- TASK 1 
/* 
1. Create a stored procedure called ‘MULTIPLY’ that takes 2 numbers as parameters
and outputs to screen the answer in the following format:
e.g. The product of 2 and 3 is 6; */
drop procedure if EXISTS MULTIPLY
go

Create procedure MULTIPLY @Param1 INT, @Param2 INT
As 
Begin 
    declare @product INTEGER;
    set @product = @Param1 * @Param2;
    SELECT CONCAT('The sum of ', @Param1, ' and ', @Param2, ' is ', @product);

End 

Go

exec MULTIPLY @Param1 = 2, @Param2 = 3;

GO

-- TASK 2 
/* 2. Create a stored function called ‘ADD’ that takes 2 numbers as parameters and returns the
sum of the numbers ( as a suitable numeric datatype )
 */
drop FUNCTION if EXISTS [add]
go


CREATE FUNCTION [add] (@Param1 INTEGER, @Param2 INTEGER) RETURNS INTEGER AS
BEGIN
    declare @product INTEGER;
    set @product = @Param1 + @Param2;
    RETURN @product;
END

GO

BEGIN
DECLARE @result INTEGER;
DECLARE @Num1 INTEGER = 3;
DECLARE @Num2 INTEGER = 4;

EXEC @result = [add] @Param1 = @Num1, @Param2 = @Num2;
SELECT CONCAT('The sum of ', @Num1, ' and ', @Num2, ' is ', @result);

END

-- task 3 
DROP TABLE IF EXISTS LOG;
DROP TABLE IF EXISTS Account;


CREATE TABLE Account(
AcctNo INT, 
Fname NVARCHAR(10), 
Lname NVARCHAR(10), 
CreditLimit int , 
Balance INT
PRIMARY KEY (AcctNo)
);

CREATE TABLE LOG(
ORGAcct INT, 
LOGDateTime DATETIME2, 
RecAccnt INT, 
Amount int,
PRIMARY KEY (ORGAcct, LOGDateTime),
Foreign Key (ORGAcct) References Account (AcctNo),
Foreign Key (RecAccnt) References Account (AcctNo)
);

insert into Account VALUES
('1', 'Ben', 'Gardiner', '5000', '1000'),
('2', 'Tony', 'Beroni', '55500', '105500');

GO

drop procedure if EXISTS creditTransfer

GO

Create procedure creditTransfer @ORGAcct INT, @RecAccnt INT, @Amount INT, @dateTime DATETIME2

As 

Begin 
    
    UPDATE Account SET Balance = Balance - @Amount
    WHERE AcctNo = @ORGAcct

    UPDATE Account SET Balance = Balance + @Amount 
    WHERE AcctNo = @RecAccnt

    INSERT INTO LOG (ORGAcct, LOGDateTime, RecAccnt, Amount)
    VALUES (@ORGAcct, SYSDATETIME(), @RecAccnt, @Amount);

End 

exec creditTransfer @ORGAcct = 1, @RecAccnt = 2, @Amount = 300, @dateTime = sysdatetime;

GO 

SELECT *
fROM Account;

SELECT *
fROM [LOG];