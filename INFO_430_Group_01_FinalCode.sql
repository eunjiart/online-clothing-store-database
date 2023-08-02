--------------------------------------------------------------------
--------------- INFO 430 Group 1 Final Project Code ----------------
--- Members: Eunji Ahn, Nathan Limono, Christopher Kim, Ryan Lee --- 
--------------------------------------------------------------------

-- Datasets used include grabbing Customers from PEEPS and 
-- https://www.kaggle.com/datasets/shivamb/fashion-clothing-products-catalog for products
-- and self-created csv file for Reviews.

/*
Table of Contents:

Create Tables - Line 33
Populate Lookup Tables - Line 147
Stored Procedures - Line 205
    Get Procedures - Line 209
    Insert Procedures - Line 352
    Synthetic Transactions/ Wrappers - line 545
    Other - Line 1004
Computed Columns - Line 1048
Business Rules - Line 1239
Complex Queries/Views - Line 1473
*/




USE INFO_430_Proj_01
GO
BACKUP DATABASE INFO_430_Proj_01 TO DISK = 'C:\SQL\INFO_430_Proj_01.BAK'

---------------------
--- Create Tables ---
---------------------

-- EUNJI --
 
CREATE TABLE tblCUSTOMER
(CustID INT IDENTITY(1,1) primary key,
CustFName varchar(60) not null,
CustLName varchar(60) not null,
CustDOB DATE not null,
CustTypeID INT FOREIGN KEY REFERENCES tblCUSTOMER_TYPE(CustTypeID) not null,
CustAddress varchar(200) not null,
CustCity varchar(75) not null,
CustState varchar(75) not null,
CustZip varchar(25) null,
Email varchar(75) null,
PhoneNumber varchar(12) null)
 
CREATE TABLE tblORDER
(OrderID INT IDENTITY(1,1) primary key,
CustomerID INT FOREIGN KEY REFERENCES tblCUSTOMER_TYPE(CustTypeID) not null,
OrderDatePlace DATETIME DEFAULT GetDate() not null)
 
CREATE TABLE tblORDER_STATUS
(OrderStatusID INT IDENTITY(1,1) primary key,
OrderID INT FOREIGN KEY REFERENCES tblORDER(OrderID) not null,
StatusID INT FOREIGN KEY REFERENCES tblSTATUS(StatusID) not null,
BeginDateTime DATETIME DEFAULT GetDate() not null)
 
CREATE TABLE tblSTATUS
(StatusID INT IDENTITY(1,1) primary key,
StatusName varchar(50) not null,
StatusDescr varchar(500) null)
 
CREATE TABLE tblCUSTOMER_TYPE
(CustTypeID INT IDENTITY(1,1) primary key,
CustTypeName varchar(50) not null,
CustTypeDescr varchar(500) null)
 
-- CHRIS –- 


CREATE TABLE tblMATERIAL (
   [MaterialID][int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
   [MaterialName][varchar](50) NOT NULL,
   [MaterialDescr][varchar](500) NOT NULL)
 
CREATE TABLE tblBRAND (
   [BrandID][int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
   [BrandName][varchar](50) NOT NULL,
   [BrandDescr][varchar](500) NOT NULL,
   [YearFounded][datetime] DEFAULT GetDate() NULL)
 
 
-- Transactional Tables –
CREATE TABLE tblPRODUCT_TYPE (
   [ProductTypeID][int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
   [ProductTypeName][varchar](50) NOT NULL,
   [ProductTypeDesc][varchar](50) NOT NULL)
 
CREATE TABLE tblPROD_MATERIAL (
   [ProductMaterialID][int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
   [ProductID] INT FOREIGN KEY REFERENCES tblPRODUCT(ProductID) NOT NULL,
   [MaterialID] INT FOREIGN KEY REFERENCES tblMATERIAL(MaterialID) NOT NULL,
   [Percentage][numeric](5,2) NOT NULL)
 
--  Nathan --
 
CREATE TABLE tblSIZE
(SizeID INT IDENTITY(1,1) PRIMARY KEY,
SizeName VARCHAR(50) not null,
SizeDescr VARCHAR(500))
 
CREATE TABLE tblSTYLE
(StyleID INT IDENTITY(1,1) PRIMARY KEY,
StyleName VARCHAR(50) not null,
StyleDescr VARCHAR(500))
 
 
-- Ryan --
CREATE TABLE tblPRODUCT
(ProductID INT IDENTITY(1,1) primary key,
ProdName varchar(50) not null,
Price Numeric(9,2) not null,
ProductTypeID INT FOREIGN KEY REFERENCES tblPRODUCT_TYPE (ProductTypeID) not null,
BrandID INT FOREIGN KEY REFERENCES tblBRAND (BrandID) not null,
GenderID INT FOREIGN KEY REFERENCES tblGENDER (GenderID) not null,
SizeID INT FOREIGN KEY REFERENCES tblSIZE (SizeID) not null,
ProdDescr varchar(500) null)
 
CREATE TABLE tblGENDER
(GenderID INT IDENTITY(1,1) primary key,
GenderName varchar(30) not null,
GenderDesc varchar(50) null)
 
CREATE TABLE tblRATING
(RatingID INT IDENTITY(1,1) primary key,
RatingName varchar(50) not null,
RatingValue INT not null)
 
CREATE TABLE tblREVIEW
(ReviewID INT IDENTITY(1,1) primary key,
OrderProductID INT FOREIGN KEY REFERENCES tblORDER_PRODUCT (OrderProductID) not null,
RatingID INT FOREIGN KEY REFERENCES tblRATING (RatingID) not null,
ReviewText varchar(5000) not null)
 
-- Transactional Table
CREATE TABLE tblORDER_PRODUCT
(OrderProductID INT IDENTITY(1,1) primary key,
OrderID INT FOREIGN KEY REFERENCES tblORDER (OrderID) not null,
ProductID INT FOREIGN KEY REFERENCES tblPRODUCT (PRoductID) not null,
Qty INT not null)
 
-------------------------------
--- Populate Look-up Tables ---
-------------------------------

-- EUNJI --

INSERT tblCUSTOMER_TYPE(CustTypeName, CustTypeDescr)
VALUES('Member', 'Spend Per Calendar Year: $1-$1,999'),
('Bronze', 'Spend Per Calendar Year: $2,000-$4,999'),
('Silver', 'Spend Per Calendar Year: $5,000-$9,999'),
('Gold', 'Spend Per Calendar Year: $10,000+')
 
INSERT tblSTATUS(StatusName, StatusDescr)
VALUES('Processing', 'Order is being processed and will be shipped soon'),
('Shipped', ' The package has been loaded on a truck and departed for the final distribution center. This means the package could be anywhere between the origin location and the destination terminal.'),
('In-Transit', 'The package is on its way to its final destination'),
('Delivered', 'The delivery driver has dropped off the package at the final destination'),
('Return', 'The package was returned back to the seller')

-- Nathan –-

INSERT INTO tblSTYLE(StyleName, StyleDescr)
VALUES('Winter', 'Clothing for Winter'), ('Spring', 'Clothing for Spring'), ('Summer', 'Clothing for Summer'), ('Fall', 'Clothing for Fall')
 
SELECT size INTO WORKING_COPY_SIZE
FROM dbo.sizes_raw
WHERE size is not null
 
INSERT INTO tblSIZE(SizeName)
SELECT DISTINCT size FROM WORKING_COPY_SIZE
WHERE size is not null
 
SELECT DISTINCT * FROM WORKING_COPY_SIZE
 
INSERT INTO tblSIZE(SizeName)
VALUES('XXXS'), ('XXS'), ('XS'), ('S'), ('M'), ('L'), ('XL'), ('XXL'), ('XXXL')


-- Chris –-
INSERT tblMATERIAL (MaterialName, MaterialDescr)
VALUES ('Cotton', 'Soft, breathable material usually used in most clothing, natural. Tends to shrink.'),
('Polyester', 'Heavy, less breathable material, man-made. Shrinks less'),
('Nylon', 'Tough, durable, man-made'),
('Leather', 'Tough, thick material usually derived from animal skin. Water-resistant'),
('Canvas', 'Plain-weave fabric typically made out of heavy cotton yarn'),
('Cashmere', 'A type of wool fabric that is made from cashmere goats and pashmina goats'),
('Chenille', 'Chenille is a woven fabric that can be made from cotton, silk, wool, and rayon'),
('Damask', 'A reversible, jacquard-patterned fabric, meaning that the pattern is woven into the fabric'),
('Jersey', 'Jersey is a soft stretchy, knit fabric that was originally made from wool'),
('Linen','Linen is an extremely strong, lightweight fabric made from the flax plant'),
('Merino Wool', 'Merino wool is a type of wool gathered from the coats of Merino sheep')

-- Ryan --

INSERT INTO tblRATING(RatingName, RatingValue)
VALUES ('Extremely Bad','1'), ('Poor','2'), ('Average','3'), ('Good','4'), ('Excellent','5')
GO

-------------------------
--- Stored Procedures ---
-------------------------

----------------------
--- Get Procedures ---
----------------------

-- GetCustID -- 
CREATE PROCEDURE GetCustID
@GetCustFname VARCHAR(60),
@GetCustLName VARCHAR(60),
@GetCustDOB DATE,
@ResultCustID INT OUTPUT
AS
SET @ResultCustID = (SELECT CustID
   FROM tblCUSTOMER
   WHERE CustFname = @GetCustFname
   AND CustLname = @GetCustLName
   AND CustDOB = @GetCustDOB)
GO
 
 
-- GetCustTypeID
CREATE PROCEDURE GetCustTypeID
@CT_CustTypeName varchar(50),
@GetCustTypeID INT OUTPUT
AS
SET @GetCustTypeID = (SELECT CustTypeID FROM tblCUSTOMER_TYPE WHERE CustTypeName = @GetCustTypeName)
GO
 
-- GetMeterialID
CREATE PROCEDURE GetMaterialID
@GetMaterialName varchar(50),
@ResultMaterialID INT OUTPUT
AS
SET @ResultMaterialID = (SELECT MaterialID
   FROM tblMATERIAL
   WHERE MaterialName = @GetMaterialName)
GO
 
-- GetStatusID
CREATE PROCEDURE GetStatusID
@GetStatusName varchar(50),
@GetStatusID INT OUTPUT
AS
SET @GetStatusID = (SELECT StatusID FROM tblSTATUS WHERE StatusName = @GetStatusName)
GO
 
-- Get ProductTypeID
CREATE PROCEDURE GetProdTypeID
@PTN varchar(50),
@PT_ID INT OUTPUT
AS
 
SET @PT_ID = (SELECT ProductTypeID FROM tblPRODUCT_TYPE WHERE ProductTypeName = @PTN)
GO
 
-- Get GenderID
CREATE PROCEDURE GetGenderID
@Gen varchar(50),
@G_ID INT OUTPUT
AS
 
SET @G_ID = (SELECT GenderID FROM tblGENDER WHERE GenderName = @Gen)
GO
 
-- Get SizeID
CREATE PROCEDURE GetSizeID
@Sizy varchar(50),
@Siz_ID INT OUTPUT
AS
 
SET @Siz_ID = (SELECT SizeID FROM tblSIZE WHERE SizeName = @Sizy)
GO
 
-- Get StyleID
CREATE PROCEDURE GetStyleID
@StyN varchar(50),
@Sty_ID INT OUTPUT
AS
 
SET @Sty_ID = (SELECT StyleID FROM tblSTYLE WHERE StyleName = @StyN)
GO
 
-- GetOrderID --
CREATE PROCEDURE GetOrderID
@CustF varchar(60),
@CustL varchar(60),
@CustDOB DATE,
@ODate DATETIME,
@O_ID INT OUTPUT
AS
DECLARE @CustID INT
 
EXEC GetCustID
@GetCustFname = @CustF,
@GetCustLname = @CustL,
@GetCustDOB = @CustDOB,
@ResultCustID = @CustID OUTPUT
IF @CustID IS NULL
   BEGIN
       PRINT'@CustID is null... check spelling';
       THROW 55678, '@CustID cannot be null', 1;
   END
 
SET @O_ID = (SELECT OrderID FROM tblORDER WHERE CustomerID = @CustID AND OrderDatePlace = @ODate)
GO
 
-- GetProductID 
CREATE PROCEDURE GetProductID
@ProN varchar(50),
@PSize varchar(50),
@ProdID INT OUTPUT
AS
DECLARE @SizeID INT
 
EXEC GetSizeID
@Sizy = @PSize,
@Siz_ID = @SizeID OUTPUT
IF @SizeID IS NULL
   BEGIN
       PRINT'@SizeID is null... check spelling';
       THROW 55678,'@SizeID cannot be null', 1;
   END
 
SET @ProdID = (SELECT ProductID FROM tblPRODUCT WHERE ProdName = @ProN AND SizeID = @SizeID)
GO
 
-- Rating ID
CREATE PROCEDURE GetRatingID
@RN varchar(50),
@R_ID INT OUTPUT
AS
 
SET @R_ID = (SELECT RatingID FROM tblRATING WHERE RatingName = @RN)
GO
 
-- Get BrandID
CREATE PROCEDURE GetBrandID
@BN  varchar(50),
@B_ID INT OUTPUT
AS
 
SET @B_ID = (SELECT BrandID FROM tblBRAND WHERE BrandName = @BN)
GO

-------------------------
--- Insert Procedures ---
-------------------------


-- EUNJI --
-- Insert Customer
CREATE PROCEDURE Insert_Customer
@CustFname varchar(50),
@CustLname varchar(50),
@CustDOB DATE,
@CustTypeName INT,
@CustAddress varchar(200),
@CustCity varchar(50),
@CustState varchar(50),
@CustZip varchar(10),
@CustCounty varchar(50),
@Email varchar(50),
@PhoneNumber varchar(12)
AS
DECLARE @CT_ID INT
 
EXEC GetCustTypeID
@CT_CustTypeName = @CustTypeName,
@GetCustTypeID = @CT_ID OUTPUT
 
IF @CT_ID IS NULL
   BEGIN
       PRINT '@CT_ID IS NULL. Check the Spelling' ;
       THROW 55654, '@CT_ID cannot be found.', 1;
   END
 
BEGIN TRANSACTION T1
INSERT INTO tblCUSTOMER(CustFName, CustLName, CustDOB, CustTypeID, CustAddress, CustCity, CustState, CustZip, CustCountry, Email, PhoneNumber)
VALUES(@CustFname, @CustLname, @CustDOB, @CT_ID, @CustAddress, @CustCity, @CustState, @CustZip, @CustCounty, @Email, @PhoneNumber)
COMMIT TRANSACTION T1
GO
 
 -- Insert Order and OrderStatus
CREATE PROCEDURE Insert_Order_OrderStatus
@O_CustLName varchar(50),
@O_CustFName varchar(50),
@O_CustDOB DATE,
@OrderDatePlaced DATETIME,
@StatusName varchar(50),
@Status_BeginDateTime DATETIME
AS
DECLARE @C_ID INT, @O_ID INT, @S_ID INT
 
EXEC GetCustID
@GetCustFname = @O_CustLName,
@GetCustLName = @O_CustFName,
@GetCustDOB = @O_CustDOB,
@ResultCustID = @C_ID OUTPUT
 
IF @C_ID IS NULL
   BEGIN
       PRINT '@C_ID IS NULL. Customer information may be incorrect'
       RAISERROR ('@C_ID cannot be null.', 11, 1)
       RETURN
   END
 
EXEC GetStatusID
@GetStatusName = @StatusName,
@GetStatusID = @S_ID OUTPUT
 
IF @S_ID IS NULL
   BEGIN
       PRINT '@S_ID IS NULL. Check the spelling';
       THROW 55674, '@S_ID cannot be found.', 1;
   END
 
BEGIN TRANSACTION O1
INSERT INTO tblORDER(CustomerID, OrderDatePlace)
VALUES(@C_ID, @OrderDatePlaced)
 
SET @O_ID = (SELECT SCOPE_IDENTITY())
 
INSERT INTO tblORDER_STATUS(OrderID, StatusID, BeginDateTime)
VALUES(@StatusName, @S_ID, @Status_BeginDateTime)
COMMIT TRANSACTION O1
GO

-- Chris -- 
CREATE PROCEDURE insertProdMaterial
@ProductName VARCHAR (255),
@MaterialName VARCHAR (255),
@ProductSize VARCHAR (50),
@Percentage numeric(5,2)
AS
DECLARE @PROD_ID INT, @MAT_ID INT, @PERCENT INT

SET @PERCENT = (RAND() * 100 + 1)

EXEC GetProductID
@ProN = @ProductName,
@PSize = @ProductSize,
@ProdID = @PROD_ID OUTPUT

IF @PROD_ID IS NULL
	BEGIN
		PRINT '@PROD_ID is null, product might be misspelled';
		THROW 569998, '@PROD_ID Error, Process is terminated', 1;
	END


EXEC GetMaterialID
@GetMaterialName = @MaterialName,
@ResultMaterialID = @MAT_ID OUTPUT

IF @MAT_ID IS NULL
	BEGIN
		PRINT '@MAT_ID is null, material might be misspelled';
		THROW 569798, '@MAT_ID Error, Process is terminated', 1;
	END

BEGIN TRANSACTION L1
INSERT INTO tblPROD_MATERIAL(ProductID, MaterialID, Percentage)
VALUES (@PROD_ID, @MAT_ID, @PERCENT)
COMMIT TRANSACTION L1
GO


-- Ryan -- 
CREATE PROCEDURE ProductInsert
@Proddy varchar(50),
@Pricy Numeric(9,2),
@PTypey varchar(50),
@Brandy varchar(50),
@Gendy varchar(50),
@SizeName varchar(50),
@Styley varchar(50)
AS

DECLARE @ProdTypeID INT, @BrandID INT, @GenID INT, @SizeID INT, @StyleID INT

EXEC GetBrandID
@BN = @Brandy,
@B_ID = @BrandID OUTPUT 

IF @BrandID IS NULL
    BEGIN
        PRINT'@BrandID is null.. check spelling';
        THROW 55656, '@BrandID cannot be null', 1;
    END

EXEC GetGenderID
@Gen = @Gendy,
@G_ID = @GenID OUTPUT

IF @BrandID IS NULL
    BEGIN
        PRINT'@GenID is null.. check spelling';
        THROW 55656, '@GenID cannot be null', 1;
    END

EXEC GetProdTypeID
@PTN = @PTypey,
@PT_ID = @ProdTypeID OUTPUT

IF @ProdTypeID IS NULL
    BEGIN
        PRINT'@ProdTypeID is null.. check spelling';
        THROW 55656, '@ProdTypeID cannot be null', 1;
    END

EXEC GetSizeID
@Sizy = @SizeName,
@Siz_ID = @SizeID OUTPUT

IF @SizeID IS NULL
    BEGIN
        PRINT'@SizeID is null.. check spelling';
        THROW 55656, '@SizeID cannot be null', 1;
    END

EXEC GetStyleID
@StyN = @Styley,
@Sty_ID = @StyleID OUTPUT 

IF @StyleID IS NULL
    BEGIN
        PRINT'@StyleID is null.. check spelling';
        THROW 55656, '@StyleID cannot be null', 1;
    END

BEGIN TRANSACTION T1
    INSERT INTO tblPRODUCT(ProdName, Price, ProductTypeID, BrandID, GenderID, SizeID, StyleID)
    VALUES(@Proddy, @Pricy, @ProdTypeID, @BrandID, @GenID, @SizeID, @StyleID)
COMMIT TRANSACTION T1
GO


----------------------------------------
--- Synthetic Transactions / Wrappers ---
----------------------------------------

-- Eunji --

-- Insert into tblCUSTOMER
DROP TABLE Customer_Data

CREATE TABLE Customer_Data
([CustID] [int] IDENTITY(1,1) NOT NULL,
[CustFName] [varchar](60) NOT NULL,
[CustLName] [varchar](60) NOT NULL,
[CustDOB] [date] NOT NULL,
[CustTypeID] [int] NULL,
[CustAddress] [varchar](200) NOT NULL,
[CustCity] [varchar](75) NOT NULL,
[CustState] [varchar](75) NOT NULL,
[CustZip] [varchar](25) NOT NULL,
[Email] [varchar](75) NULL,
[PhoneNumber] [varchar](12) NULL)


INSERT INTO Customer_Data (CustFname, CustLname, CustDOB, CustAddress, CustCity, CustState, CustZip, Email, PhoneNumber)
SELECT TOP 10000 CustomerFname, CustomerLname, DateOfBirth, CustomerAddress, CustomerCity, CustomerState, CustomerZip, Email, AreaCode + '-' + PhoneNum
FROM PEEPS.dbo.tblCUSTOMER


-- WHILE LOOP for Random CustomerType
DECLARE @RUN INT
DECLARE @RANDO INT

SET @RUN = 10000
WHILE @RUN > 0
    BEGIN
        SET @RANDO = (SELECT RAND() * 4 + 1)
        BEGIN TRANSACTION
            UPDATE Customer_Data
            SET CustTypeID = @RANDO
            WHERE CustID = @RUN
        COMMIT TRANSACTION

        SET @RUN = @RUN - 1
    END
-- END OF THE WHILE LOOP

SELECT * 
FROM Customer_Data

-- INSERTING INTO tblCUSTOMER
INSERT INTO tblCUSTOMER (CustFname, CustLname, CustDOB, CustTypeID, CustAddress, CustCity, CustState, CustZip, Email, PhoneNumber)
SELECT CustFname, CustLname, CustDOB, CustTypeID, CustAddress, CustCity, CustState, CustZip, Email, PhoneNumber
FROM Customer_Data
GO

-- Populate Order and Order Status
CREATE PROCEDURE SYN_POP_ORDER_ORDERSTATUS
@RUN INT
AS
 
DECLARE @CustRowCount INT = (SELECT COUNT(*) FROM tblCUSTOMER)
DECLARE @StatusRowCount INT = (SELECT COUNT(*) FROM tblSTATUS)
DECLARE @C_PK INT, @S_PK INT, @SynDate DATETIME
DECLARE @SynFname varchar(60), @SynLname varchar(60), @SynDOB DATE, @SynStatus varchar(50)
 
WHILE @RUN > 0
   BEGIN
       SET @C_PK = (SELECT RAND() * @CustRowCount + 1)
       SET @S_PK = 1
       SET @SynDate = (SELECT GetDate() - (SELECT RAND() * 10000))
 
 
       SET @SynFname = (SELECT CustFname FROM tblCUSTOMER WHERE CustID = @C_PK)
       SET @SynLname = (SELECT CustLname FROM tblCUSTOMER WHERE CustID = @C_PK)
       SET @SynDOB = (SELECT CustDOB FROM tblCUSTOMER WHERE CustID = @C_PK)
 
       SET @SynStatus = (SELECT StatusName FROM tblSTATUS WHERE StatusID = 1)
 
       EXEC Insert_Order_OrderStatus
       @O_CustLName = @SynLname,
       @O_CustFName = @SynFname,
       @O_CustDOB = @SynDOB,
       @OrderDatePlaced = @SynDate,
       @StatusName = @SynStatus,
       @Status_BeginDateTime = @SynDate
 
       SET @RUN = @RUN - 1
   END
GO
 
EXEC SYN_POP_ORDER_ORDERSTATUS
@RUN = 100000
GO

-- Nathan --
CREATE PROCEDURE WRAPPER_SYNTHETIC_ORDER_STATUS @RUN INT
AS
DECLARE @PStatusName VARCHAR(50), @PBeginDateTime DATETIME, @PCustFname VARCHAR(50), @PCustLname VARCHAR(50), @PCustDOB DATE, @POrderDatePlaced DATETIME
DECLARE @StatusRow INT = (SELECT COUNT(*) FROM tblSTATUS)
DECLARE @OrderRow INT = (SELECT COUNT(*) FROM tblORDER)
DECLARE @S_PK INT
DECLARE @O_PK INT
DECLARE @RUN_STATUS INT = 2
 
WHILE @RUN > 0
BEGIN
 
SET @S_PK = (SELECT RAND() * @StatusRow + 1)
WHILE @S_PK = 1
    BEGIN
        SET @S_PK = (SELECT RAND() * @StatusRow + 1)
    END
 
SET @O_PK = (SELECT RAND() * @OrderRow + 1)
 
SET @PCustFname = (SELECT CustFName FROM tblCUSTOMER C 
    JOIN tblORDER O ON C.CustID = O.CustomerID
    WHERE O.OrderID = @O_PK)
 
SET @PCustLname = (SELECT CustLName FROM tblCUSTOMER C 
    JOIN tblORDER O ON C.CustID = O.CustomerID
    WHERE O.OrderID = @O_PK)
 
SET @PCustDOB = (SELECT CustDOB FROM tblCUSTOMER C 
    JOIN tblORDER O ON C.CustID = O.CustomerID
    WHERE O.OrderID = @O_PK)
 
SET @POrderDatePlaced = (SELECT OrderDatePlace FROM tblORDER WHERE OrderID = @O_PK)
 
SET @PBeginDateTime = @POrderDatePlaced
 
WHILE @RUN_STATUS <= @S_PK
    BEGIN
        SET @PBeginDateTime = (@PBeginDateTime + RAND() * 10)
        SET @PStatusName = (SELECT StatusName FROM tblSTATUS WHERE StatusID = @RUN_STATUS)
 
        EXEC Insert_OrderStatus
        @BeginDateTime = @PBeginDateTime,
        @StatusName = @PStatusName,
        @OrderDatePlace = @POrderDatePlaced,
        @CustFName = @PCustFname,
        @CustLName = @PCustLname,
        @CustDOB = @PCustDOB
 
 
    SET @RUN_STATUS = @RUN_STATUS + 1
    END
 
SET @RUN = @RUN - 1
END
GO

EXEC WRAPPER_SYNTHETIC_ORDER_STATUS 
@RUN = 100000
GO

-- Chris --
ALTER PROCEDURE WRAPPER_SYNTHETIC_PROD_MATERIAL @RUN INT
AS
DECLARE @SMaterialName VARCHAR(50), @SProdName VARCHAR(50), @SProdSize VARCHAR(50), @SPercentage numeric(5,2)
DECLARE @ProductRow INT = (SELECT COUNT(*) FROM tblPRODUCT)
DECLARE @MaterialRow INT = (SELECT COUNT(*) FROM tblMATERIAL)
DECLARE @SizeRow INT = (SELECT COUNT(*) FROM tblSIZE)
DECLARE @P_PK INT
DECLARE @M_PK INT
DECLARE @S_PK INT

WHILE @RUN > 0
BEGIN
SET @P_PK = (SELECT RAND() * @ProductRow + 162934)
SET @M_PK = (SELECT RAND() * @MaterialRow + 1)
SET @S_PK = (SELECT TOP 1 SizeID FROM tblPRODUCT WHERE ProductID = @P_PK)

SET @SMaterialName = (SELECT MaterialName FROM tblMATERIAL WHERE MaterialID = @M_PK)
SET @SProdName = (SELECT ProdName FROM tblPRODUCT WHERE ProductID = @P_PK)
SET @SProdSize = (SELECT SizeName FROM tblSIZE WHERE SizeID = @S_PK)

SET @SPercentage = (RAND() * 100 + 1)

EXEC insertProdMaterial
@ProductName = @SProdName,
@MaterialName = @SMaterialName,
@ProductSize = @SProdSize,
@Percentage = @SPercentage

SET @RUN = @RUN -1
END
GO

EXEC WRAPPER_SYNTHETIC_PROD_MATERIAL
@RUN = 100000
GO

-- Ryan --

--- Populate Product/ProductType using Dataset ---

-- Transfer raw data into duplicate table
CREATE TABLE [dbo].[CLEANED_PK_PRODUCTS](
    ProductID INT IDENTITY(1,1) primary key,
    ProductName nvarchar(500) null,
    ProductBrand nvarchar(50) null,
    Gender nvarchar(50) not null,
    Price_Rupees Numeric(18,2) null,
    Descript nvarchar(4000) null,
    PrimaryColor nvarchar(50) null
) ON [PRIMARY]
GO

-- INSERT INTO CLEANED_PK_PRODUCTS
INSERT INTO CLEANED_PK_PRODUCTS ([ProductName], [ProductBrand], [Gender], [Price_Rupees], [Descript], [PrimaryColor])
SELECT ProductName, ProductBrand, Gender, Price_INR, [Description], [PrimaryColor]
FROM product_catalog_raw_data
WHERE ProductName IS NOT NULL
AND ProductBrand IS NOT null
AND Gender IS NOT NULL 
AND Price_INR IS NOT NULL
AND [Description] IS NOT NULL
AND PrimaryColor IS NOT NULL
GO

-- INSERT DISTINCT INTO tblBRAND
INSERT INTO tblBRAND(BrandName)
SELECT DISTINCT ProductBrand
FROM CLEANED_PK_PRODUCTS

-- INSERT DISTINCT INTO tblGENDER
INSERT INTO tblGENDER(GenderName)
SELECT DISTINCT Gender
FROM CLEANED_PK_PRODUCTS

-- Case Statement to assign ProductType for each ProductID in CLEANED_PK_PRODUCTS
SELECT A.ProductID, A.Product_Type
INTO #product_type
FROM (SELECT(CASE
    WHEN P.ProductName LIKE '%Shirt%'
        THEN 'Shirt'
    WHEN P.ProductName LIKE '%T-shirt%'
        THEN 'T-shirt'
    WHEN P.ProductName LIKE '%Trousers%'
        THEN 'Trousers'
    WHEN P.ProductName LIKE '%Bag%'
        THEN 'Bag'
    WHEN P.ProductName LIKE '%Jeans%'
        THEN 'Jeans'
    WHEN P.ProductName LIKE '%Jacket%'
        THEN 'Jacket'
    WHEN P.ProductName LIKE '%Sneakers%'
        THEN 'Sneakers'
    WHEN P.ProductName LIKE '%Sweater%'
        THEN 'Sweater'
    WHEN P.ProductName LIKE '%Top%'
        THEN 'Top'
    WHEN P.ProductName LIKE '%Dress%'
        THEN 'Dress'
    WHEN P.ProductName LIKE '%Blazer%'
        THEN 'Blazer'
    WHEN P.ProductName LIKE '%Tuxedo%'
        THEN 'Tuxedo'
    WHEN P.ProductName LIKE '%Kurta%'
        THEN 'Kurta'
    WHEN P.ProductName LIKE '%Shorts%'
        THEN 'Shorts'
    WHEN P.ProductName LIKE '%Wallet%'
        THEN 'Wallet'
    WHEN P.ProductName LIKE '%Shoes%'
        THEN 'Shoes'
    WHEN P.ProductName LIKE '%Flats%'
        THEN 'Flats'
    WHEN P.ProductName LIKE '%Sandals%'
        THEN 'Sandals'
    WHEN P.ProductName LIKE '%Heels%'
        THEN 'Heels'
    WHEN P.ProductName LIKE '%Suit%'
        THEN 'Suit'
    WHEN P.ProductName LIKE '%Backpack%'
        THEN 'Backpack'
    WHEN P.ProductName LIKE '%Chinos%'
        THEN 'Chinos'
    WHEN P.ProductName LIKE '%Sweatshirt%'
        THEN 'Sweatshirt'
    WHEN P.ProductName LIKE '%Boots%'
        THEN 'Boots'
    WHEN P.ProductName LIKE '%Bracelet%'
        THEN 'Bracelet'
    WHEN P.ProductName LIKE '%Earrings%'
        THEN 'Earrings'
    WHEN P.ProductName LIKE '%Scarf%'
        THEN 'Scarf'
    WHEN P.ProductName LIKE '%Flip-Flops%'
        THEN 'Flip-Flops'
    WHEN P.ProductName LIKE '%Watch%'
        THEN 'Watch'
    WHEN P.ProductName LIKE '%Joggers%'
        THEN 'Joggers'
    ELSE
        'Other'
    END) AS Product_Type, P.ProductID
    FROM CLEANED_PK_PRODUCTS P) A
DROP TABLE #Product_Type

-- Populate tblPRODUCT_TYPE
INSERT INTO tblPRODUCT_TYPE(ProductTypeName)
SELECT DISTINCT Product_Type
FROM #Product_Type

-- Declare variables 
DECLARE @TempProducts TABLE (
    ProductID INT IDENTITY(1,1) primary key,
    ProductName nvarchar(500) null,
    ProductBrand nvarchar(50) null,
    Gender nvarchar(50) not null,
    Price_Rupees Numeric(18,2) null,
    Descript nvarchar(4000) null,
    PrimaryColor nvarchar(50) null
)

DECLARE @ProductName varchar(50), @SizeName varchar(50), @BrandName varchar(50), @GenderName varchar(50), 
@ProductTypeName varchar(50), @StyleName varchar(50), @Price Numeric(18,2)

DECLARE @MIN_PK INT -- Tracks current row
DECLARE @RUN INT -- tracks number of values

-- Create temp table copy of products to insert
INSERT INTO @TempProducts
SELECT ProductName, ProductBrand, Gender, Price_Rupees, Descript, PrimaryColor
FROM CLEANED_PK_PRODUCTS


DECLARE @Style_PK INT -- Will hold random style to assign to clothing
DECLARE @SizeCount INT -- Will keep track of how many sizes are in table
DECLARE @StyleCount INT = (SELECT COUNT(*) FROM tblSTYLE)

SET @RUN = (SELECT COUNT(*) FROM @TempProducts)

WHILE @RUN > 0
BEGIN
    SET @SizeCount = (SELECT COUNT(*) FROM tblSIZE)
    SET @Style_PK = (SELECT RAND() * @StyleCount + 1)
    
    -- SET variables for what we have so far
    SET @MIN_PK = (SELECT TOP 1 ProductID FROM @TempProducts ORDER BY ProductID ASC)
    SET @ProductName = (SELECT TOP 1 ProductName FROM @TempProducts WHERE ProductID = @MIN_PK)
    SET @BrandName = (SELECT TOP 1 ProductBrand FROM @TempProducts WHERE ProductID = @MIN_PK)
    SET @GenderName  = (SELECT TOP 1 Gender FROM @TempProducts WHERE ProductID = @MIN_PK)
    SET @Price = (SELECT TOP 1 Price_Rupees FROM @TempProducts WHERE ProductID = @MIN_PK)
    SET @ProductTypeName = (SELECT TOP 1 Product_Type FROM #Product_Type WHERE ProductID = @MIN_PK)

    -- SET Style to randomly chosen style name
    SET @StyleName = (SELECT TOP 1 StyleName FROM tblSTYLE WHERE StyleID = @Style_PK)

    -- Insert into product for every single size in size table
    WHILE @SizeCount > 0
    BEGIN
        SET @SizeName = (SELECT SizeName FROM tblSIZE WHERE SizeID = @SizeCount)
        EXEC ProductInsert
        @Proddy = @ProductName,
        @Pricy = @Price,
        @PTypey = @ProductTypeName,
        @Brandy = @BrandName,
        @Gendy = @GenderName,
        @SizeName = @SizeName,
        @Styley  = @StyleName

        SET @SizeCount = @SizeCount - 1
    END

DELETE FROM @TempProducts WHERE ProductID = @MIN_PK
SET @RUN = @RUN - 1
END

-- Populate Review --
-- Create table with PK for RandomReviewRawData
CREATE TABLE [dbo].[CLEANED_PK_RandRev] (
    RandRevID INT IDENTITY (1,1) primary key,
    RevText varchar(5000),
    RatingVal INT
) ON [PRIMARY]
GO

-- INSERT INTO this table
INSERT INTO CLEANED_PK_RandRev (RevText, RatingVal)
SELECT [ReviewText], [RatingNum]
FROM RandomReviewsRawData
WHERE [ReviewText] IS NOT NULL
AND [RatingNum] IS NOT NULL
GO


IF EXISTS (SELECT * FROM sys.sysobjects WHERE NAME = 'WORKING_COPY_Reviews')
    BEGIN
        DROP table WORKING_COPY_Reviews
        SELECT *
        INTO WORKING_COPY_Reviews
        FROM CLEANED_PK_RandRev
        ORDER BY RandRevID
    END
GO

-- INSERT INTO Reviews
CREATE PROCEDURE PopReviews
@OrdProID INT,
@RatID INT,
@ReviewT varchar(5000)
AS 

BEGIN TRANSACTION T1
INSERT INTO tblREVIEW (OrderProductID, RatingID, ReviewText)
VALUES (@OrdProID, @RatID, @ReviewT)
COMMIT TRANSACTION T1
GO

-- Wrapper to randomize population of reviews table for decided amount
CREATE PROCEDURE Wrapper_PopReviews
@RUN INT
AS

DECLARE @OrderProductRowCount INT = (SELECT COUNT(*) FROM tblORDER_PRODUCT)
DECLARE @RandReviewRowCount INT = (SELECT COUNT(*) FROM WORKING_COPY_Reviews)
DECLARE @RandReviewPK INT 
DECLARE @OrderProductPK INT
DECLARE @RatingPK INT

DECLARE @RatingVal INT 
DECLARE @RateName varchar(50)
DECLARE @RevText varchar(5000)

WHILE @RUN > 0
BEGIN

SET @OrderProductPK = (SELECT RAND() * @OrderProductRowCount + 4)
SET @RandReviewPK = (SELECT RAND() * @RandReviewRowCount + 1)

SET @RatingVal = (SELECT RatingVal FROM WORKING_COPY_Reviews WHERE RandRevID = @RandReviewPK)
SET @RateName = (SELECT RatingName FROM tblRATING WHERE RatingValue = @RatingVal)
SET @RevText = (SELECT RevText FROM WORKING_COPY_Reviews WHERE RandRevID = @RandReviewPK)

EXEC GetRatingID
@RN = @RateName,
@R_ID = @RatingPK OUTPUT
IF @RatingPK IS NULL
    BEGIN
        PRINT'@RatingPK IS NULL... something is wrong';
        THROW 55678, '@RatingPK cannot be null', 1;
    END 

EXEC PopReviews
@OrdProID = @OrderProductPK,
@RatID = @RatingPK,
@ReviewT = @RevText

SET @RUN = @RUN - 1
END
GO

EXEC Wrapper_PopReviews
@RUN = 10000
GO

------------------------
--- Other Procedures ---
------------------------

-- Nathan --
-- Update Customer Type
 
CREATE PROCEDURE Update_CustomerType
@CustFname VARCHAR(50),
@CustLname VARCHAR(50),
@CUSTDOB Date,
@CustTypeName VARCHAR(50)
AS
DECLARE @C_ID INT, @CT_ID INT
 
EXEC GetCustID
@GetCustFname = @CustFname,
@GetCustLname = @CustLname,
@GetCustDOB = @CustDOB,
@ResultCustID = @C_ID OUTPUT
 
IF @C_ID IS NULL
    BEGIN
        PRINT '@C_ID is null, Customer information may be incorrect';
        THROW 568595, '@C_ID Error, Process is terminated', 1;
    END
 
EXEC GetCustTypeID
@CT_CustTypeName = @CustTypeName,
@GetCustTypeID = @CT_ID OUTPUT
 
IF @CT_ID IS NULL
    BEGIN
        PRINT '@CT_ID is null, Customer Type information may be incorrect';
        THROW 568595, '@CT_ID Error, Process is terminated', 1;
    END
 
BEGIN TRANSACTION N1
UPDATE tblCUSTOMER
SET CustomerTypeID = @CT_ID
WHERE CustID = @C_ID
COMMIT TRANSACTION N1
GO

------------------------
--- Computed Columns ---
------------------------

-- Eunji --
-- Order (Total Cost)
CREATE FUNCTION TotalCost(@PK INT)
RETURNS NUMERIC(12,2)
AS
BEGIN
DECLARE @RET NUMERIC(12,2) = (
   SELECT SUM(OP.Qty * P.Price)
   FROM tblORDER O
       JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
       JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
   WHERE OP.OrderID = @PK)
RETURN @RET
END
GO
 
ALTER TABLE tblORDER
ADD TotalCost AS (dbo.TotalCost(OrderID))
GO
 
-- Average Rating for Each Product
CREATE FUNCTION AverageRating(@PK INT)
RETURNS DECIMAL(3,2)
AS
BEGIN
DECLARE @RET DECIMAL(3,2) = (
   SELECT AVG(Ra.RatingValue)
   FROM tblPRODUCT P
       JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
       JOIN tblREVIEW R ON OP.OrderProductID = R.OrderProductID
       JOIN tblRATING RA ON R.RatingID = RA.RatingID
   WHERE P.ProductID = @PK
)
RETURN @RET
END
GO
 
ALTER TABLE tblPRODUCT
ADD AverageRating AS (dbo.AverageRating(ProductID))
GO

-- Nathan --
-- Customer(FavBrand)
CREATE FUNCTION fn_calc_fav_brand(@PK INT)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @RET VARCHAR(50) = (SELECT TOP 1 A.BrandName
        FROM (SELECT COUNT(BrandName) AS Brand_Count, BrandName
            FROM tblCUSTOMER C
                JOIN tblORDER O ON C.CustID = O.CustomerID
                JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
                JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
                JOIN tblBRAND B ON P.BrandID = B.BrandID
            WHERE C.CustID = @PK
            GROUP BY B.BrandName
            ORDER BY Brand_Count DESC)A)
    RETURN @RET
END
GO
 
ALTER TABLE tblCUSTOMER
ADD fav_brand AS (dbo.fn_calc_fav_brand(CustomerID))
GO
 
-- Cust(TotalOrders)
CREATE FUNCTION fn_calc_total_orders(@PK INT)
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = (SELECT COUNT(O.OrderID)
        FROM tblCUSTOMER C
            JOIN tblORDER O ON C.CustomerID = O.CustomerID
        WHERE C.CustomerID = @PK)
    RETURN @RET
END
GO
 
ALTER TABLE tblCUSTOMER
ADD Total_Orders AS (dbo.fn_calc_total_orders(CustomerID))
GO

-- Chris --
-- Total products sold/available by Brand
CREATE FUNCTION Total_Products (@PK INT)
RETURNS NUMERIC(10,0)
AS
BEGIN
DECLARE @RET NUMERIC(10,0) = (
   SELECT SUM(P.BrandID)
   FROM tblBRAND B
       JOIN tblPRODUCT P ON B.BrandID = P.BrandID
   WHERE P.BrandID = @PK)
RETURN @RET
END
GO
 
ALTER TABLE tblBRAND
ADD Total_Products AS (dbo.Total_Products(BrandID))
GO

-- Total revenue for Brand
CREATE FUNCTION Total_Revenue (@PK INT)
RETURNS NUMERIC(12,2)
AS
BEGIN
DECLARE @RET NUMERIC(12,2) = (
   SELECT SUM(P.Price * OP.Qty)
   FROM tblBRAND B
       JOIN tblPRODUCT P ON B.BrandID = P.BrandID
	   JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
   WHERE P.BrandID = @PK)
RETURN @RET
END
GO
 
ALTER TABLE tblBRAND
ADD Total_Revenue AS (dbo.Total_Revenue(BrandID))
GO

-- Ryan --
-- Product(NumReviews)
CREATE FUNCTION fn_ProductNumReviews (@PK INT)
RETURNS INT
AS
BEGIN

DECLARE @RET INT = (
    SELECT COUNT(ReviewID)
    FROM tblREVIEW R
        JOIN tblORDER_PRODUCT OP ON R.OrderProductID = OP.OrderProductID
        JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
    WHERE P.ProductID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblPRODUCT
ADD NumReviews AS
(dbo.fn_ProductNumReviews(ProductID))
GO

-- Cumulative quantity sold over past 5 years
CREATE FUNCTION fn_CumQuantSold5Years (@PK INT)
RETURNS INT 
AS 
BEGIN 

DECLARE @RET INT = (
    SELECT SUM(Qty)
    FROM tblORDER_PRODUCT OP
        JOIN tblPRODUCT P ON OP.ProductID = P.ProductID 
        JOIN tblORDER O ON OP.OrderID = O.OrderID 
    WHERE O.OrderDatePlace > DATEADD(year, -5, GetDate())
    AND P.ProductID = @PK)
IF @RET IS NULL
    BEGIN
    SET @RET = 0
    END
RETURN @RET
END
GO

ALTER TABLE tblPRODUCT
ADD TotalSold_Past5years AS
(dbo.fn_CumQuantSold5Years(ProductID))
GO

-- Computed column for rupees to dollars
CREATE FUNCTION fn_RupeesToDollars (@PK INT)
RETURNS NUMERIC (9,2)
AS
BEGIN

DECLARE @RET NUMERIC (9,2) = (
    SELECT (SUM(P.Price) * 0.013) AS PriceUSD
    FROM tblPRODUCT P
    WHERE P.ProductID = @PK)
RETURN @RET
END
GO

ALTER TABLE tblPRODUCT
ADD PriceUSD AS
(dbo.fn_RupeesToDollars(ProductID))
GO

----------------------
--- Business Rules ---
----------------------

 -- Eunji --
-- EcoFriendly: No Product with ProductType “Shirt” can have more than 70% made up of “polyester”
CREATE FUNCTION eco_friendly_shirt()
RETURNS INT
AS
BEGIN
   DECLARE @RET INT = 0
   IF EXISTS (
       SELECT *
       FROM tblPRODUCT P
           JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
           JOIN tblPROD_MATERIAL PM ON P.ProductID = PM.ProductID
           JOIN tblMATERIAL M ON PM.MaterialID = M.MaterialID
       WHERE M.MaterialName = 'Polyester'
       AND PM.[Percentage] > 70
       AND PT.ProductTypeName = 'Shirt')
       BEGIN
           SET @RET = 1
       END
   RETURN @RET
END
GO
 
ALTER TABLE tblPRODUCT
ADD CONSTRAINT CK_EcofriendlyShirt
CHECK (dbo.eco_friendly_shirt() = 0)
GO

-- InStyleSeason : No customer 25 or younger can make an order during winter months for summer clothing; stay warm
CREATE FUNCTION InStyleSeason()
RETURNS INT
AS
BEGIN
   DECLARE @RET INT = 0
   IF EXISTS (
       SELECT *
       FROM tblCUSTOMER C
           JOIN tblORDER O ON C.CustID = O.CustomerID
           JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
           JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
           JOIN tblSTYLE S ON P.StyleID = S.StyleID
       WHERE C.CustDOB >= DATEADD(YEAR, -25, GETDATE())
       AND S.StyleName = 'Summer'
       AND MONTH(O.OrderDatePlace) IN (12, 1, 2))
   BEGIN
       SET @RET = 1
   END
RETURN @RET
END
GO
 
ALTER TABLE tblORDER
ADD CONSTRAINT CK_InStyleSeason
CHECK (dbo.InStyleSeason() = 0)
GO
 
-- Nathan Limono--
-- No customer with ‘membership’ customer_type can have less than 5 reviews total and they cannot be under 18
CREATE FUNCTION no_child_membership()
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = 0
    IF EXISTS(SELECT COUNT(R.ReviewID) AS total_reviews
        FROM tblCUSTOMER_TYPE CT
            JOIN tblCUSTOMER C ON CT.CustTypeID = C.CustTypeID
            JOIN tblORDER O ON C.CustID = O.CustomerID
            JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
            JOIN tblREVIEW R ON OP.OrderProductID = R.OrderProductID
        WHERE CT.CustTypeName = 'membership'
        AND C.CustDOB < DATEADD(YEAR, -18, GETDATE())
        GROUP BY C.CustID
        HAVING COUNT(R.ReviewID) < 5)
        BEGIN
            SET @RET = 1
        END
    RETURN @RET
END
GO
 
ALTER TABLE tblCUSTOMER_TYPE
ADD CONSTRAINT ck_no_child_membership
CHECK(dbo.no_child_membership() = 0)
GO
 
-- No customer under the age of 18 can make an order of more than $50
CREATE FUNCTION no_child_big_purchase()
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = 0
    IF EXISTS(SELECT SUM(OP.Qty * P.Price) AS totalCost
        FROM tblCUSTOMER C
            JOIN tblORDER O ON C.CustID = O.CustomerID
            JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
            JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
        WHERE C.CustDOB < DATEADD(YEAR, -18, GETDATE())
        GROUP BY O.OrderID
        HAVING SUM(OP.Qty * P.PriceUSD) > 50)
        BEGIN
            SET @RET = 1
        END
    RETURN @RET
END
GO
 
ALTER TABLE tblORDER
ADD CONSTRAINT ck_no_child_big_purchase
CHECK(dbo.no_child_big_purchase = 0)
GO
 
 -- Chris --
-- A customer cannot review a product until the order status is ‘Delivered’

CREATE FUNCTION Cannot_Review_Until_Delivery ()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (
	SELECT *
	FROM tblCUSTOMER C
		JOIN tblORDER O ON C.CustID = O.CustomerID
		JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
		JOIN tblREVIEW R ON OP.OrderID = R.OrderProductID
		JOIN tblORDER_STATUS OS ON O.OrderID = OS.OrderID
		JOIN tblSTATUS S ON OS.StatusID = S.StatusID
	WHERE S.StatusName != 'Delivered'
	AND R.ReviewID IS NOT NULL)
	BEGIN
	SET @RET = 1
	END
RETURN @RET
END
GO
 
ALTER TABLE tblCUSTOMER
ADD CONSTRAINT CK_CannotReviewUntilDelivery
CHECK (dbo.Cannot_Review_Until_Delivery() = 0)
GO

-- No customer 50 or older may order products with polyester or nylon, bad for the skin

CREATE FUNCTION no_bad_skin_products()
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = 0
    IF EXISTS(SELECT *
        FROM tblCUSTOMER C
            JOIN tblORDER O ON C.CustID = O.CustomerID
            JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
            JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
			JOIN tblPROD_MATERIAL PM ON P.ProductID = PM.ProductID
			JOIN tblMATERIAL M ON PM.MaterialID = M.MaterialID
        WHERE M.MaterialName = 'Polyester' OR M.MaterialName = 'Nylon'
		AND C.CustDOB <= DATEADD(YEAR, -50, GETDATE())
		)
        BEGIN
            SET @RET = 1
        END
    RETURN @RET
END
GO
 
ALTER TABLE tblCUSTOMER
ADD CONSTRAINT ck_no_bad_skin_products
CHECK(dbo.no_bad_skin_products = 0)
GO

-- Ryan --
-- A Single customer cannot have more than 10 return statuses
CREATE FUNCTION fn_NoMoreTenReturns()
RETURNS INT
AS
BEGIN

DECLARE @RET INT = 0
IF EXISTS (SELECT C.CustID
    FROM tblCUSTOMER C
        JOIN tblORDER O ON C.CustID = O.CustomerID
        JOIN tblORDER_STATUS OS ON O.OrderID = OS.OrderID
        JOIN tblSTATUS S ON OS.StatusID = S.StatusID
    WHERE S.StatusName = 'Return'
    GROUP BY C.CustID
    HAVING COUNT(O.OrderID) > 10)
    BEGIN
    SET @RET = 1
    END
RETURN @RET
END
GO

ALTER TABLE tblCUSTOMER
ADD CONSTRAINT CK_noCustomerTenReturns
CHECK(dbo.fn_NoMoreTenReturns() = 0)
GO

-- No product denoted with the season Winter can have a product type of flip-flops made up of more than 80% cotton
SELECT * FROM tblPRODUCT_TYPE
GO

ALTER FUNCTION fn_NoFlopsWinter()
RETURNS INT
AS
BEGIN
DECLARE @RET INT = 0
IF EXISTS (SELECT P.ProductID
    FROM tblPRODUCT P
        JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
        JOIN tblSTYLE S ON P.StyleID = S.StyleID
        JOIN tblPROD_MATERIAL PM ON P.ProductID = PM.ProductID
        JOIn tblMATERIAL M ON PM.MaterialID = M.MaterialID
    WHERE S.StyleName = 'Winter'
    AND PT.ProductTypeName = 'Flip-Flops'
    AND M.MaterialName = 'Cotton'
    AND PM.[Percentage] > 80)
BEGIN
    SET @RET = 1
END

RETURN @RET
END
GO

ALTER TABLE tblPRODUCT
ADD CONSTRAINT CK_NoFlopsWinter
CHECK(dbo.fn_NoFlopsWinter() = 0)
GO

------------------------------
---  Complex Queries/Views ---
------------------------------

-- Eunji --
-- What are the top 10 most popular brands from 2010 to 2019?

CREATE VIEW Top10_MostPopularBrand AS
SELECT TOP 10 B.BrandID, B.BrandName, SUM(OP.Qty) AS TotalNumberOfItemSold
FROM tblORDER O
  JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
  JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
  JOIN tblBRAND B ON P.BrandID = B.BrandID
WHERE YEAR(O.OrderDatePlace) LIKE '201%'
GROUP BY B.BrandID, B.BrandName
ORDER BY SUM(OP.Qty) DESC
 GO
 
-- List of the clothing types from most polyesters as their materials to the
-- least polyesters as their materials on average that were sold during winter?

CREATE VIEW PloyesterItemType_Winter AS 
SELECT PT.ProductTypeID, PT.ProductTypeName, AVG(PM.[Percentage]) AS Avg_Percentage
FROM tblPRODUCT P
   JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
   JOIN tblPROD_MATERIAL PM ON P.ProductID = PM.ProductID
   JOIN tblMATERIAL M ON PM.MaterialID = M.MaterialID
   JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
   JOIN tblORDER O ON OP.OrderID = O.OrderID
WHERE MONTH(O.OrderDatePlace) IN (12, 1, 2)
AND M.MaterialName = 'Polyester'
GROUP BY PT.ProductTypeID, PT.ProductTypeName
ORDER BY Avg_Percentage DESC
GO

-- Puma Brand yearly sales
CREATE VIEW [Puma_Yearly_Sales] AS
SELECT B.BrandID, B.BrandName, SUM(OP.Qty * P.PriceUsd) AS Total_Money_First_Quarter_USD, YEAR(O.OrderDatePlace) AS [YEAR]
FROM tblBRAND B
    JOIN tblPRODUCT P ON B.BrandID = P.BrandID
    JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
    JOIN tblORDER O ON OP.OrderID = O.OrderID
WHERE B.BrandName = 'Puma'
GROUP BY B.BrandID, B.BrandName, YEAR(O.OrderDatePlace)
GO

-- Nathan --
-- What are the top 10 brands that made the most money
CREATE VIEW [Top10_Brands_Most_Money] AS
SELECT TOP 10 B.BrandID, B.BrandName, SUM(OP.Qty * P.PriceUsd) AS Total_Money_From_Sales_USD
FROM tblBRAND B
    JOIN tblPRODUCT P ON B.BrandID = P.BrandID
    JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
    JOIN tblORDER O ON OP.OrderID = O.OrderID
WHERE YEAR(O.OrderDatePlace) like '201%'
GROUP BY B.BrandID, B.BrandName
ORDER BY Total_Money_From_Sales_USD DESC
GO
 
-- Nike first quarter (1,2,3) in 2010 sales for gold membership customers
CREATE VIEW [Nike_First_Quarter_2010_sales] AS
SELECT B.BrandID, B.BrandName, SUM(OP.Qty * P.PriceUsd) AS Total_Money_First_Quarter_USD
FROM tblBRAND B
    JOIN tblPRODUCT P ON B.BrandID = P.BrandID
    JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
    JOIN tblORDER O ON OP.OrderID = O.OrderID
WHERE B.BrandName = 'Nike'
AND YEAR(O.OrderDatePlace) = '2010'
AND MONTH(O.OrderDatePlace) BETWEEN '1' AND '3'
GROUP BY B.BrandID, B.BrandName
GO
 
 
-- Indian Terrain Brand yearly sales
CREATE VIEW [Indian_Terrain_Yearly_Sales] AS
SELECT B.BrandID, B.BrandName, SUM(OP.Qty * P.PriceUsd) AS Total_Money_First_Quarter_USD, YEAR(O.OrderDatePlace) AS [YEAR]
FROM tblBRAND B
    JOIN tblPRODUCT P ON B.BrandID = P.BrandID
    JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
    JOIN tblORDER O ON OP.OrderID = O.OrderID
WHERE B.BrandName = 'Indian Terrain'
GROUP BY B.BrandID, B.BrandName, YEAR(O.OrderDatePlace)
GO

-- Chris --
-- What is the most popular clothing type
-- VIEW
CREATE VIEW Top10_MostPopularClothingType AS
SELECT Top 10 PT.ProductTypeID, PT.ProductTypeName, SUM(OP.Qty) AS TotalNumberOfClothingTypeSold
FROM tblORDER O
   JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
   JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
   JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
GROUP BY PT.ProductTypeID, PT.ProductTypeName
ORDER BY SUM(OP.Qty) DESC
GO

-- Which season has the highest number of orders
-- VIEW

CREATE VIEW MostPopularStyleType AS
SELECT Top 4 S.StyleName, S.StyleID, SUM(OP.Qty) AS TotalNumberOfStylesSold
FROM tblORDER O
   JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
   JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
   JOIN tblSTYLE S ON P.StyleID = S.StyleID
GROUP BY S.StyleID, S.StyleName
ORDER BY SUM(OP.Qty) DESC
GO

-- Ryan --
-- For each Year, show total orders that contain products of size Small containing Material Cotton over 20% and
-- the customer ordering is older than 18
CREATE VIEW TotalMedCottonOrders AS
SELECT YEAR(O.OrderDatePlace) AS OrderYear, COUNT(O.OrderID) AS TotalOrders
FROM tblCUSTOMER C
    JOIN tblORDER O ON C.CustID = O.CustomerID
    JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
    JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
    JOIN tblSIZE S ON P.SizeID = S.SizeID
    JOIN tblPROD_MATERIAL PM ON P.ProductID = PM.ProductID
    JOIN tblMATERIAL M ON PM.MaterialID = M.MaterialID
WHERE S.SizeName = 'M'
AND M.MaterialName = 'Cotton'
AND PM.[Percentage] > 50
AND C.CustDOB < DATEADD(YEAR, -18, GETDATE())
GROUP BY YEAR(O.OrderDatePlace)
GO

-- Titan Brand yearly sales
CREATE VIEW [Puma_Yearly_Sales] AS
SELECT B.BrandID, B.BrandName, SUM(OP.Qty * P.PriceUsd) AS Total_Money_First_Quarter_USD, YEAR(O.OrderDatePlace) AS [YEAR]
FROM tblBRAND B
    JOIN tblPRODUCT P ON B.BrandID = P.BrandID
    JOIN tblORDER_PRODUCT OP ON P.ProductID = OP.ProductID
    JOIN tblORDER O ON OP.OrderID = O.OrderID
WHERE B.BrandName = 'Titan'
GROUP BY B.BrandID, B.BrandName, YEAR(O.OrderDatePlace)
GO

-- Find the top 10 customers that have spend the most for products of type 'Bag' over the past 5 years
-- that have also purchased a total more than 3 orders with product type 'Shoes' from the style 'Spring'
CREATE VIEW MostSpentBags_ShoeOrdersSpring AS
WITH CTE_TotalSpentBlazers (CustID, CustF, CustL, TotalSpent)
AS
(SELECT C.CustID, C.CustFName, C.CustLName, SUM(OP.Qty * P.PriceUSD) AS TotalSpent
FROM tblCUSTOMER C
    JOIN tblORDER O ON C.CustID = O.CustomerID
    JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
    JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
    JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
WHERE PT.ProductTypeName = 'Bag'
 AND O.OrderDatePlace > DATEADD(YEAR, -5, GETDATE())
GROUP BY C.CustID, C.CustFName, C.CustLName)
,
OrdersShoesSpring(CustID, CustF, CustL, TotalOrders)
AS
(SELECT C.CustID, C.CustFName, C.CustLName, COUNT(O.OrderID) AS TotalOrders
FROM tblCUSTOMER C
    JOIN tblORDER O ON C.CustID = O.CustomerID
    JOIN tblORDER_PRODUCT OP ON O.OrderID = OP.OrderID
    JOIN tblPRODUCT P ON OP.ProductID = P.ProductID
    JOIN tblPRODUCT_TYPE PT ON P.ProductTypeID = PT.ProductTypeID
    JOIN tblSTYLE S ON P.StyleID = S.StyleID
WHERE PT.ProductTypeName = 'Shirt'
AND S.StyleName = 'Spring'
GROUP BY C.CustID, C.CustFName, C.CustLName
HAVING COUNT(O.OrderID) > 3)
SELECT TOP 10 A.CustID, A.CustF, A.CustL, TotalSpent, TotalOrders
FROM CTE_TotalSpentBlazers A
    JOIN OrdersShoesSpring B ON A.CustID = B.CustID
ORDER BY TotalSpent DESC




