/**********************************************************************************************
 *                                                                                            
 *   ███████╗███████╗██╗     ██╗     ██╗   ██╗                                                 
 *   ██╔════╝██╔════╝██║     ██║     ██║   ██║                                                 
 *   ███████╗███████╗██║     ██║     ██║   ██║                                                 
 *   ╚════██║██╔═══╝ ██║     ██║     ██║   ██║                                                 
 *   ███████║███████╗███████╗███████╗╚██████╔╝                                                 
 *   ╚══════╝╚══════╝╚══════╝╚══════╝ ╚═════╝                                                  
 *                                                                                            
 *     S E L L V    -    El mejor sistema de ventas                                            
 *                                                                                            
 *     Autor     : [Carlos E. Nuñez, Tanisha Maria]                                                      
 *     Versión   : 1.0                                                                         
 *     Fecha     : [2025-07-15]                                                               
 *     Descripción: Script SQL para definición de tablas del sistema POS (ventas y caja)       
 *                                                                                            
 **********************************************************************************************/

CREATE TABLE Roles (
  Id INT PRIMARY KEY IDENTITY(1,1),
  [Name] NVARCHAR(50) UNIQUE
);

CREATE TABLE UserRoles (
  UserId INT,
  RoleId INT,
  PRIMARY KEY (UserId, RoleId),
  FOREIGN KEY (UserId) REFERENCES [User](Id),
  FOREIGN KEY (RoleId) REFERENCES Roles(Id),
  CreatedBy INT,
  UpdatedBy INT,
  UpdatedAt DATETIME,
  CreatedAt DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
  FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
);

CREATE TABLE Permissions
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(100),
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
)

CREATE TABLE RolePermission (
  RoleId INT,
  PermissionId INT,
  PRIMARY KEY (RoleId, PermissionId),
  FOREIGN KEY (RoleId) REFERENCES Roles(Id),
  FOREIGN KEY (PermissionId) REFERENCES Permissions(Id),
  CreatedBy INT,
  UpdatedBy INT,
  UpdatedAt DATETIME,
  CreatedAt DATETIME DEFAULT GETDATE(),
  FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
  FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
);

-- ESQUEMA DE LOS PRODUCTOS (Borrador).
CREATE TABLE WareHouses
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR (100) NOT NULL,
	[Location] NVARCHAR(255),
	IsActive BIT,
	MinStock DECIMAL (18,4),
	MaxStock DECIMAL (18,4),
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
)

CREATE TABLE ProductsCategories
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(255),
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
)

CREATE TABLE ProductsSubCategories
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(255),
	ProductCategoryId INT NOT NULL,
	FOREIGN KEY (ProductCategoryId) REFERENCES ProductCategory(Id),
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
)

CREATE TABLE Measurements
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(100) UNIQUE NOT NULL,
	Symbol NVARCHAR(100) UNIQUE NOT NULL,
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
)

CREATE TABLE [Products]
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(150) NOT NULL,
	[Status] NVARCHAR(50),
	Code NVARCHAR(150) UNIQUE NOT NULL,
	Price DECIMAL(10,2) NOT NULL ,
	BarCode NVARCHAR(120) UNIQUE,
	CategoryId INT NOT NULL,
	MeasurementId INT NOT NULL,
	IsActive BIT,
	FOREIGN KEY (CategoryId) REFERENCES ProductsCategories(Id),
	FOREIGN KEY (MeasurementId) REFERENCES Measurements(Id),
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
)

CREATE TABLE [Stocks]
(
	PRIMARY KEY (ProductId, WareHouseId),
	ProductId INT NOT NULL,
	WareHouseId INT NOT NULL,
	Qty DECIMAL (18,4) NOT NULL ,
	FOREIGN KEY (ProductId) REFERENCES [Products](Id),
	FOREIGN KEY (WareHouseId) REFERENCES WareHouses(Id),
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
)


CREATE TABLE PaymentMethods
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	[Name] NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(255),
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
)

CREATE TABLE Itbis
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	[Name] NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(255),
	[Percentage] DECIMAL NOT NULL,
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
)

CREATE TABLE Customers
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	[Name] NVARCHAR(100),
	Phone NVARCHAR(100),
	[Address] NVARCHAR(255),
	EmailAddress NVARCHAR(100),
	IsActive BIT,
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
) 


CREATE TABLE InvoicesHeaders
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	[Date] DATETIME,
	PaymentMethodId INT,
	Total DECIMAL (10,2),
	SubTotal DECIMAL (10,2),
	GeneralAmount DECIMAL (10,2),
	UserId INT,
	[Status] NVARCHAR(50),
	CustomerId INT,
	ClientRnc NVARCHAR(50),
	ClientName NVARCHAR(100),
	CashRegisterSessionId INT,
	SucursalId INT,
	FOREIGN KEY (PaymentMethodId) REFERENCES PaymentsMethods(Id),
	FOREIGN KEY (CashRegisterSessionId) REFERENCES CashRegisterSessions(Id),
	FOREIGN KEY (UserId) REFERENCES [User](Id),
	FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id)
)


CREATE TABLE InvoicesDetails
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	ProductId INT,
	InvoiceHeaderId INT,
	Qty DECIMAL (18,4), 
	Price DECIMAL (10,2),
	ItbisId INT,
	ProductDescription NVARCHAR(150),
	ProductCode NVARCHAR(150),
	Discount DECIMAL,
	TotalDiscount DECIMAL (10,2),
	ItbisTotal DECIMAL (10,2),
	FOREIGN KEY (ProductId) REFERENCES Products(Id),
	FOREIGN KEY (InvoiceHeaderId) REFERENCES InvoicesHeaders(Id),
	FOREIGN KEY (ItbisId) REFERENCES Itbis(Id)
)

CREATE TABLE WareHousesMovements
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	WareHouseId INT NOT NULL,
	ToWareHouseId INT,
	MovementDate DATETIME NOT NULL,
	MovementType NVARCHAR(50) NOT NULL,
	[Description] NVARCHAR(255),
	Qty DECIMAL(18,4) NOT NULL,
	ProductId INT NOT NULL,
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id),
	FOREIGN KEY (WareHouseId) REFERENCES WareHouses(Id),
	FOREIGN KEY (ToWarehouseId) REFERENCES Warehouses(Id),
	FOREIGN KEY (ProductId) REFERENCES Products(Id)
)

CREATE TABLE CashRegisters
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(100) NOT NULL,
    [Location] NVARCHAR(255),
    IsActive BIT
);

CREATE TABLE CashRegisterSessions
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    CashRegisterId INT NOT NULL,
    OpenedBy INT,
    ClosedBy INT,
    OpeningAmount DECIMAL(10,2) NOT NULL,
    ClosingAmount DECIMAL(10,2),
    OpeningTime DATETIME NOT NULL DEFAULT GETDATE(),
    ClosingTime DATETIME,
    [Open] BIT,
    Observations NVARCHAR(MAX),
    FOREIGN KEY (OpenedBy) REFERENCES [User](Id),
    FOREIGN KEY (ClosedBy) REFERENCES [User](Id),
    FOREIGN KEY (CashRegisterId) REFERENCES CashRegisters(Id)
);


CREATE TABLE Payments
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	PaymentMethodId INT NOT NULL,
	InvoiceHeaderId INT NOT NULL,
	CashRegisterSessionId INT,
	Amount DECIMAL(10,2) NOT NULL,
	CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id),
	FOREIGN KEY (PaymentMethodId) REFERENCES PaymentsMethods(Id),
	FOREIGN KEY (InvoiceHeaderId) REFERENCES InvoicesHeaders(Id),
	FOREIGN KEY (CashRegisterSessionId) REFERENCES CashRegisterSessions(Id)

)

CREATE TABLE CashMovements
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    CashRegisterSessionId INT NOT NULL,
    MovementType NVARCHAR(20) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    [Description] NVARCHAR(255),
    RelatedInvoiceId INT, -- Nullable, si viene de una venta
    CreatedBy INT,
	UpdatedBy INT,
	UpdatedAt DATETIME,
	CreatedAt DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (CreatedBy) REFERENCES [User](Id),
	FOREIGN KEY (UpdatedBy) REFERENCES [User](Id),
    FOREIGN KEY (CashRegisterSessionId) REFERENCES CashRegisterSessions(Id),
    FOREIGN KEY (RelatedInvoiceId) REFERENCES InvoicesHeaders(Id)
);
