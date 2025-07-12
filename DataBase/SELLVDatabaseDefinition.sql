/*
	Tablas necesarias para el POS:
	Metodos de pago
	Tabla de ITBIS
	Tabla de movimientos
	Tabla de cajas
	Tabla de Roles
	Tabla mucho a muchos para los metodos de pago
*/


-- ESQUEMA DE LOS PRODUCTOS (Borrador).
CREATE TABLE WareHouse
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR (100) NOT NULL,
	[Location] NVARCHAR(255),
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME
)

CREATE TABLE ProductCategory
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(255),
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME
)

CREATE TABLE ProductSubCategory
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(255),
	ParentCategoryId INT NOT NULL,
	FOREIGN KEY (ParentCategoryId) REFERENCES ProductCategory(Id),
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME
)

CREATE TABLE Measurement
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(100) UNIQUE NOT NULL,
	Symbol NVARCHAR(100) UNIQUE NOT NULL,
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME
)

CREATE TABLE [Product]
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(150) NOT NULL,
	[Status] NVARCHAR(50),
	Code NVARCHAR(150) UNIQUE NOT NULL,
	Price DECIMAL NOT NULL,
	BarCode NVARCHAR(120) UNIQUE,
	CategoryId INT NOT NULL,
	MeasurementId INT NOT NULL
	FOREIGN KEY (CategoryId) REFERENCES ProductCategory(Id),
	FOREIGN KEY (MeasurementId) REFERENCES Measurement(Id),
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME
)

CREATE TABLE [Stock]
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	ProductId INT UNIQUE NOT NULL,
	WareHouseId INT UNIQUE NOT NULL,
	Qty DECIMAL NOT NULL,
	FOREIGN KEY (ProductId) REFERENCES [Product](Id),
	FOREIGN KEY (WareHouseId) REFERENCES WareHouse(Id),
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME
)


-- SALES:

CREATE TABLE InvoiceHeader
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	[Date] DATETIME,
	PaymentMethodId INT,
	Total DECIMAL,
	SubTotal DECIMAL,
	GeneralAmount DECIMAL,
	UserId INT,
	[Status] NVARCHAR(50),
	ClientId INT,
	ClientRnc NVARCHAR(50),
	ClientName NVARCHAR(100),
	CajaId INT,
	SucursalId INT,
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME
)

CREATE TABLE InvoiceDetails
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	ProductId INT,
	InvoiceHeaderId INT,
	Qty DECIMAL, 
	Price DECIMAL,
	ItbisId INT,
	ProductDescription NVARCHAR(150),
	ProductCode NVARCHAR(150),
	Discount DECIMAL,
	TotalDiscount DECIMAL,
	ItbisTotal DECIMAL,
)