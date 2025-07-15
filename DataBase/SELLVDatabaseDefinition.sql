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

CREATE TABLE PaymentMethod
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	[Name] NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(255),
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME
)

CREATE TABLE PaymentMethodInvoiceHeader
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	PaymentMethodId INT NOT NULL,
	InvoiceHeaderId INT NOT NULL,
	Amount DECIMAL NOT NULL,
	FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethod(Id),
	FOREIGN KEY (InvoiceHeaderId) REFERENCES InvoiceHeader(Id),
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME
)

CREATE TABLE Itbis
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	[Name] NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(255),
	[Percentage] DECIMAL NOT NULL,
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME
)

CREATE TABLE CashBox
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	[Name] NVARCHAR(100) NOT NULL,
	[Description] NVARCHAR(255),
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME
)

CREATE TABLE WareHouseMovement
(
	Id INT PRIMARY KEY IDENTITY (1,1),
	WareHouseId INT NOT NULL,
	ToWareHouseId INT,
	MovementDate DATETIME NOT NULL,
	MovementType NVARCHAR(50) NOT NULL,
	Description NVARCHAR(255),
	Qty DECIMAL NOT NULL,
	ProductId INT NOT NULL,
	CreatedBy NVARCHAR(100),
	UpdatedBy NVARCHAR(100),
	UpdatedAt DATETIME,
	CreatedAt DATETIME,
	FOREIGN KEY (WareHouseId) REFERENCES WareHouse(Id),
	FOREIGN KEY (ProductId) REFERENCES [Product](Id)
)

CREATE TABLE CashRegister
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(100) NOT NULL,
    [Location] NVARCHAR(255),
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE CashRegisterSession
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    CashRegisterId INT NOT NULL,
    OpenedBy INT NOT NULL,
    ClosedBy INT NOT NULL,
    OpeningAmount DECIMAL(10,2) NOT NULL,
    ClosingAmount DECIMAL(10,2),
    OpeningTime DATETIME NOT NULL DEFAULT GETDATE(),
    ClosingTime DATETIME,
    [Status] NVARCHAR(20) NOT NULL DEFAULT 'OPEN',
    Observations NVARCHAR(MAX),
    FOREIGN KEY (CashRegisterId) REFERENCES CashRegister(Id),
	FOREIGN KEY (OpenedBy) REFERENCES Users(Id),
	FOREIGN KEY (ClosedBy) REFERENCES Users(Id)
);

CREATE TABLE CashMovement
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    CashRegisterSessionId INT NOT NULL,
    MovementType NVARCHAR(20) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    [Description] NVARCHAR(255),
    RelatedInvoiceId INT, -- Nullable, si viene de una venta
    CreatedBy NVARCHAR(100),
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CashRegisterSessionId) REFERENCES CashRegisterSession(Id),
    FOREIGN KEY (RelatedInvoiceId) REFERENCES InvoiceHeader(Id)
);
