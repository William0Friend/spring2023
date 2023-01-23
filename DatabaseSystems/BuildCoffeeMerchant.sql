-----------------------------------------------------------
--Search and Replace All as follows:
-- 1) Replace <DB> with the name of the database to create.
-- 2) Replace <PATH> with the full path to this file and 
--    others associated with it. Ensure it ends with a 
--    backslash. E.g., C:\MyDatabases\
-----------------------------------------------------------
--
IF NOT EXISTS(SELECT * FROM sys.databases
          WHERE name = N'<DB>')
	CREATE DATABASE <DB>
GO
USE <DB>
--
-- Alter the path so the script can find the CSV files
--
DECLARE
   @data_path nvarchar(256);
SELECT @data_path = '<PATH>';
--
--GO
-- =======================================
-- Delete existing tables
--
IF EXISTS(
  SELECT *
  FROM sys.tables
  WHERE name = N'OrderLines'
         )
  DROP TABLE OrderLines;
--GO
--
IF EXISTS(
  SELECT *
  FROM sys.tables
  WHERE name = N'Orders'
         )
  DROP TABLE Orders;
--GO
--
IF EXISTS(
  SELECT *
  FROM sys.tables
  WHERE name = N'Consumers'
         )
  DROP TABLE Consumers;
--GO
--
IF EXISTS(
  SELECT *
  FROM sys.tables
  WHERE name = N'Inventory'
         )
  DROP TABLE Inventory;
--GO
--
IF EXISTS(
  SELECT *
  FROM sys.tables
  WHERE name = N'Employees'
         )
  DROP TABLE Employees;
--GO
--
IF EXISTS(
  SELECT *
  FROM sys.tables
  WHERE name = N'States'
         )
  DROP TABLE States;
--GO
--
IF EXISTS(
  SELECT *
  FROM sys.tables
  WHERE name = N'Countries'
         )
  DROP TABLE Countries;
--GO
--
-- =======================================
-- Create tables
--
-- Table 1 Countries
CREATE TABLE Countries
     (CountryID   INT          NOT NULL,
      CountryName NVARCHAR(40) NOT NULL,
      CONSTRAINT pk_countries PRIMARY KEY (CountryID)
     );
--GO
--
-- Table 2 States
CREATE TABLE States
     (StateID    NVARCHAR(2)   NOT NULL,
      StateName  NVARCHAR(25)  NOT NULL,
      TaxRate    NUMERIC(7,4),
      Population INT,
      LandArea   INT,
      WebURL     NVARCHAR(50),
      CONSTRAINT pk_States PRIMARY KEY (StateID)
     );
--GO
--
-- Table 3 Employees
CREATE TABLE Employees
     (EmployeeID     INT          NOT NULL,
      FirstName      NVARCHAR(30) NOT NULL,
      LastName       NVARCHAR(30) NOT NULL,
      WorkPhone      NVARCHAR(20),
      CommissionRate NUMERIC(4,4),
      HireDate       DATETIME,
      BirthDate      DATETIME,
      Gender         NVARCHAR(1),
      CONSTRAINT pk_employees PRIMARY KEY (EmployeeID)
     );
--GO
--
-- Table 4 Inventory
CREATE TABLE Inventory
     (InventoryID INT          NOT NULL,
      Name        NVARCHAR(40) NOT NULL,
      Price       NUMERIC(6,2),
      OnHand      INT,
      Description NVARCHAR(500),
      ItemType    NVARCHAR(5),
      CountryID   INT,
      CONSTRAINT  pk_inventory PRIMARY KEY (InventoryID),
      CONSTRAINT fk_Inventory_Countries
      FOREIGN KEY (CountryID) REFERENCES Countries (CountryID)
      ON DELETE CASCADE
     );
--GO
--
-- Table 5 Consumers
CREATE TABLE Consumers
     (ConsumerID  INT          NOT NULL,
      FirstName   NVARCHAR(30) NOT NULL,
      LastName    NVARCHAR(30) NOT NULL,
      Street      NVARCHAR(50),
      City        NVARCHAR(50),
      State       NVARCHAR(2),
      Zipcode     NVARCHAR(11),
      Phone       NVARCHAR(20),
      Fax         NVARCHAR(20),
      CreditLimit INT,
      CONSTRAINT pk_consumers PRIMARY KEY (ConsumerID),
      CONSTRAINT fk_Consumers_States 
      FOREIGN KEY (State) REFERENCES States (StateID)
      ON DELETE CASCADE
     );
--GO
--
-- Table 6 Orders
CREATE TABLE Orders
     (OrderID    INT           NOT NULL,
      OrderDate  DATETIME      NOT NULL,
      CustomerPO NVARCHAR(15),
      ConsumerID INT           NOT NULL,
      EmployeeID INT,
      CONSTRAINT pk_orders PRIMARY KEY (OrderID),
      CONSTRAINT fk_Orders_Consumers
      FOREIGN KEY (ConsumerID) REFERENCES Consumers (ConsumerID)
      ON DELETE CASCADE,
      CONSTRAINT fk_Orders_Employees
      FOREIGN KEY (EmployeeID) REFERENCES Employees (EmployeeID)
      ON DELETE CASCADE
     );
--GO
--
-- Table 7 OrderLines
CREATE TABLE OrderLines
     (OrderID     INT NOT NULL,
      LineItem    INT NOT NULL,
      InventoryID INT NOT NULL,
      Quantity    INT NOT NULL,
      Price       NUMERIC(6,2),
      Discount    NUMERIC(4,4),
      CONSTRAINT pk_orderlines PRIMARY KEY (OrderID, LineItem),
      CONSTRAINT fk_Orderlines_Orders
      FOREIGN KEY (OrderID) REFERENCES Orders (OrderID)
      ON DELETE CASCADE,
      CONSTRAINT fk_Orderlines_Inventory
      FOREIGN KEY (InventoryID) REFERENCES Inventory (InventoryID)
      ON DELETE CASCADE
     );
--GO
--
-- =======================================
-- Load table data
--
-- Table 1 Countries
--
EXECUTE (N'BULK INSERT Countries FROM ''' + @data_path + N'Countries.csv''
WITH (
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    KEEPIDENTITY,
    TABLOCK
);');
--
-- Table 2 States
--
EXECUTE (N'BULK INSERT States FROM ''' + @data_path + N'States.csv''
WITH (
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    KEEPIDENTITY,
    TABLOCK
);');
--
-- Table 3 Employees
--
EXECUTE (N'BULK INSERT Employees FROM ''' + @data_path + N'Employees.csv''
WITH (
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    KEEPIDENTITY,
    TABLOCK
);');
--
-- Table 4 Inventory
--
EXECUTE (N'BULK INSERT Inventory FROM ''' + @data_path + N'Inventory.csv''
WITH (
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    FIELDTERMINATOR= ''\t'',
    ROWTERMINATOR = ''\n'',
    KEEPIDENTITY,
    TABLOCK
);');
--
-- Table 5 Consumers
--
EXECUTE (N'BULK INSERT Consumers FROM ''' + @data_path + N'Consumers.csv''
WITH (
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    KEEPIDENTITY,
    TABLOCK
);');
--
-- Table 6 Orders
--
EXECUTE (N'BULK INSERT Orders FROM ''' + @data_path + N'Orders.csv''
WITH (
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    KEEPIDENTITY,
    TABLOCK
);');
--
-- Table OrderLines
--
EXECUTE (N'BULK INSERT OrderLines FROM ''' + @data_path + N'OrderLines.csv''
WITH (
    CHECK_CONSTRAINTS,
    CODEPAGE=''ACP'',
    DATAFILETYPE = ''char'',
    FIELDTERMINATOR= '','',
    ROWTERMINATOR = ''\n'',
    KEEPIDENTITY,
    TABLOCK
);');
--
-- =====================================================
-- Display confirming information about table row counts
--
GO
SET NOCOUNT ON
SELECT 'Consumers' AS "Table", COUNT(*) AS "Rows"
FROM   Consumers
     UNION
SELECT 'Countries', COUNT(*)
FROM   Countries
     UNION
SELECT 'Employees', COUNT(*)
FROM   Employees
     UNION
SELECT 'Inventory', COUNT(*)
FROM   Inventory
     UNION
SELECT 'Orderlines', COUNT(*)
FROM   Orderlines
     UNION
SELECT 'Orders', COUNT(*)
FROM   Orders
     UNION
SELECT 'States', COUNT(*)
FROM   States
ORDER BY 1;
SET NOCOUNT OFF