--1.Create database named AZBank.
CREATE DATABASE AZBank
GO

USE AZBank
GO

--2.In the AZBank database, create tables with constraints as design above.
CREATE TABLE Customer(
  CustomerID int NOT NULL CONSTRAINT PK_CustomerID PRIMARY KEY,
  Name nvarchar(50),
  City nvarchar(50),
  Country nvarchar(50),
  Phone nvarchar(15),
  Email nvarchar(50)
)
GO

CREATE TABLE CustomerAccount(
  AccountNumber char(9) NOT NULL CONSTRAINT PK_AccountNumber PRIMARY KEY,
  CustomerID int NOT NULL,
  CONSTRAINT FK_CustomerID FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
  Balance money NOT NULL,
  MinAccount money
)
GO

CREATE TABLE CustomerTransaction(
  TransactionID int NOT NULL CONSTRAINT PK_TransactionID PRIMARY KEY,
  AccountNumber char(9),
  CONSTRAINT CK_AccountNumber FOREIGN KEY (AccountNumber) REFERENCES CustomerAccount(AccountNumber),
  TransactionDate smalldatetime,
  Amount money,
  DepositorWithdraw bit
)
GO

--3.Insert into each table at least 3 records.
INSERT INTO Customer (CustomerID,Name,City,Country,Phone,Email) 
  VALUES (1,N'TRẦN NGỌC ANH',N'HÀ NỘI',N'VIỆT NAM','081-234-5678',N'Ngocanh1@gmail.com'),
         (2,N'ĐÀO DUY ANH',N'THANH HÓA',N'VIỆT NAM','091-123-4567',N'Duyanhhh@gmail.com'),
		 (3,N'KIỀU HOÀNG VŨ',N'HÀ NỘI',N'VIỆT NAM','098-654-3211',N'VuKieu@gmail.com')
GO

INSERT INTO CustomerAccount (AccountNumber,CustomerID,Balance,MinAccount)
  VALUES (123456,1,'2500000','100000'),
         (234567,2,'3000000','200000'),
		 (345678,3,'1200000','300000')
GO

INSERT INTO CustomerTransaction (TransactionID,AccountNumber,TransactionDate,Amount,DepositorWithdraw)
  VALUES (100,123456,'2021/12/09 3:20:15','200000',1),
         (101,234567,'2022/1/02 12:10:09','500000',NULL),
		 (102,345678,'2021/9/12 20:30:00','500000',1)
GO

--4.Write a query to get all customers from Customer table who live in ‘Hanoi’.
SELECT Name,City FROM Customer WHERE City = 'HÀ NỘI'
GO

--5.Write a query to get account information of the customers (Name, Phone, Email, AccountNumber, Balance).
SELECT c.Name, c.Phone, c.Email, ca.AccountNumber, ca.Balance
FROM Customer c, CustomerAccount ca
WHERE c.CustomerID = ca.CustomerID
GO

/*6.A-Z bank has a business rule that each transaction (withdrawal or deposit) won’t be
over $1000000 (One million USDs). Create a CHECK constraint on Amount column
of CustomerTransaction table to check that each transaction amount is greater than
0 and less than or equal $1000000.*/
ALTER TABLE CustomerTransaction
ADD CONSTRAINT CHK_Amount CHECK(Amount<= 1000000)
GO
/*7.Create a view named vCustomerTransactions that display Name,
AccountNumber, TransactionDate, Amount, and DepositorWithdraw from Customer,
CustomerAccount and CustomerTransaction tables.*/
CREATE VIEW vCustomerAccount AS
SELECT c.Name, ca.AccountNumber
FROM Customer c
INNER JOIN CustomerAccount ca ON c.CustomerID = ca.CustomerID
GO

CREATE VIEW vCustomerTransactions AS
SELECT vc.Name,ct.AccountNumber,ct.TransactionDate,ct.Amount,ct.DepositorWithdraw
FROM vCustomerAccount vc
INNER JOIN CustomerTransaction ct ON vc.AccountNumber = ct.AccountNumber
GO

