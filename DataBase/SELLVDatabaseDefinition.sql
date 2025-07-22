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

CREATE TABLE Companies
(
	Id INT PRIMARY KEY IDENTITY(1,1),
	CorporateGroupId INT NULL,
	[Name] NVARCHAR(255) NOT NULL,
	ObjectType NVARCHAR(50) NULL,
	Phone1 NVARCHAR(20) NULL,
	Phone2 NVARCHAR(20) NULL,
	CountryCode NVARCHAR(10) NULL,
	Email NVARCHAR(255) NULL,
	[Address] NVARCHAR(MAX) NULL,
	IsActive BIT NOT NULL,
	CreatedAt DATETIME NOT NULL DEFAULT SYSUTCDATETIME(),
	UpdatedAt DATETIME NULL,
	CreatedBy INT NULL,
	UpdatedBy INT NULL,
	FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
	FOREIGN KEY (UpdatedBy) REFERENCES Users(Id),
	FOREIGN KEY (CorporateGroupId) REFERENCES CorporateGroups(Id)
);


CREATE TABLE Roles
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(50) UNIQUE,
    CompanyId INT NOT NULL,
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id)
);

CREATE TABLE UserRoles
(
    UserId INT,
    RoleId INT,
    CompanyId INT NOT NULL,
    PRIMARY KEY (UserId, RoleId),
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (RoleId) REFERENCES Roles(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE Permissions
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(100),
    CompanyId INT NOT NULL,
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE RolePermission
(
    RoleId INT,
    PermissionId INT,
    CompanyId INT NOT NULL,
    PRIMARY KEY (RoleId, PermissionId),
    FOREIGN KEY (RoleId) REFERENCES Roles(Id),
    FOREIGN KEY (PermissionId) REFERENCES Permissions(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

-- ESQUEMA DE LOS PRODUCTOS (Borrador).
CREATE TABLE WareHouses
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(100) NOT NULL,
    [Location] NVARCHAR(255),
    IsActive BIT,
    MinStock DECIMAL(18,4),
    MaxStock DECIMAL(18,4),
    CompanyId INT NOT NULL,
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE ProductsCategories
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(255),
    CompanyId INT NOT NULL,
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE ProductsSubCategories
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(255),
    ProductCategoryId INT NOT NULL,
    CompanyId INT NOT NULL,
    FOREIGN KEY (ProductCategoryId) REFERENCES ProductsCategories(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE Measurements
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(100) UNIQUE NOT NULL,
    Symbol NVARCHAR(100) UNIQUE NOT NULL,
    CompanyId INT NOT NULL,
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE Products
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(150) NOT NULL,
    Code NVARCHAR(150) UNIQUE NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    BarCode NVARCHAR(120) UNIQUE,
    CategoryId INT NOT NULL,
    MeasurementId INT NOT NULL,
    IsActive BIT,
    CompanyId INT NOT NULL,
    FOREIGN KEY (CategoryId) REFERENCES ProductsCategories(Id),
    FOREIGN KEY (MeasurementId) REFERENCES Measurements(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE Barcodes
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    Code NVARCHAR(200),
    ProductId INT,
    CompanyId INT NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id)
);

CREATE TABLE Stocks
(
    PRIMARY KEY (ProductId, WareHouseId),
    ProductId INT NOT NULL,
    WareHouseId INT NOT NULL,
    Qty DECIMAL(18,4) NOT NULL,
    CompanyId INT NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    FOREIGN KEY (WareHouseId) REFERENCES WareHouses(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE PaymentMethods
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(255),
    CompanyId INT NOT NULL,
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE Taxes
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(100) NOT NULL,
    [Description] NVARCHAR(255),
    [Percentage] DECIMAL NOT NULL,
    CompanyId INT NOT NULL,
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE Customers
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(100),
    Phone NVARCHAR(100),
    [Address] NVARCHAR(255),
    EmailAddress NVARCHAR(100),
    IsActive BIT,
    CompanyId INT NOT NULL,
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE InvoicesHeaders
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Date] DATETIME NOT NULL,
    Total DECIMAL(10,2),
    SubTotal DECIMAL(10,2),
    GeneralAmount DECIMAL(10,2),
    UserId INT,
    [Status] NVARCHAR(50) NOT NULL,
    CustomerId INT,
    ClientRnc NVARCHAR(50),
    ClientName NVARCHAR(100),
    CashRegisterSessionId INT,
    SucursalId INT,
    CompanyId INT NOT NULL,
    FOREIGN KEY (UserId) REFERENCES Users(Id),
    FOREIGN KEY (CustomerId) REFERENCES Customers(Id),
    FOREIGN KEY (CashRegisterSessionId) REFERENCES CashRegisterSessions(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE InvoicesDetails
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    ProductId INT,
    InvoiceHeaderId INT,
    Qty DECIMAL(18,4),
    Price DECIMAL(10,2),
    TaxId INT,
    ProductDescription NVARCHAR(150),
    ProductCode NVARCHAR(150),
    Discount DECIMAL(10,2) NOT NULL DEFAULT 0,
    TotalDiscount DECIMAL(10,2),
    ItbisTotal DECIMAL(10,2),
    CompanyId INT NOT NULL,
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    FOREIGN KEY (InvoiceHeaderId) REFERENCES InvoicesHeaders(Id),
    FOREIGN KEY (TaxId) REFERENCES Taxes(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id)
);

CREATE TABLE WareHousesEntrances
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    WareHouseId INT NOT NULL,
    [Date] DATETIME,
    [Description] NVARCHAR(255),
    ProductId INT NOT NULL,
    Qty DECIMAL(18,4) NOT NULL,
    CompanyId INT NOT NULL,
    FOREIGN KEY (WareHouseId) REFERENCES WareHouses(Id),
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE WareHousesExits
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    WareHouseId INT NOT NULL,
    [Date] DATETIME NOT NULL,
    [Description] NVARCHAR(255),
    Qty DECIMAL(18,4) NOT NULL,
    ProductId INT NOT NULL,
    CompanyId INT NOT NULL,
    FOREIGN KEY (WareHouseId) REFERENCES WareHouses(Id),
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE WareHousesTransfers
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    WareHouseId INT NOT NULL,
    ToWareHouseId INT NOT NULL,
    [Date] DATETIME NOT NULL,
    [Description] NVARCHAR(255),
    Qty DECIMAL(18,4) NOT NULL,
    ProductId INT NOT NULL,
    CompanyId INT NOT NULL,
    FOREIGN KEY (WareHouseId) REFERENCES WareHouses(Id),
    FOREIGN KEY (ToWareHouseId) REFERENCES WareHouses(Id),
    FOREIGN KEY (ProductId) REFERENCES Products(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE CashRegisters
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    [Name] NVARCHAR(100) NOT NULL,
    [Location] NVARCHAR(255),
    IsActive BIT,
    CompanyId INT NOT NULL,
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id)
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
    CompanyId INT NOT NULL,
    FOREIGN KEY (OpenedBy) REFERENCES Users(Id),
    FOREIGN KEY (ClosedBy) REFERENCES Users(Id),
    FOREIGN KEY (CashRegisterId) REFERENCES CashRegisters(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id)
);

CREATE TABLE Payments
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    PaymentMethodId INT NOT NULL,
    InvoiceHeaderId INT NOT NULL,
    CashRegisterSessionId INT,
    Amount DECIMAL(10,2) NOT NULL,
    CompanyId INT NOT NULL,
    FOREIGN KEY (PaymentMethodId) REFERENCES PaymentMethods(Id),
    FOREIGN KEY (InvoiceHeaderId) REFERENCES InvoicesHeaders(Id),
    FOREIGN KEY (CashRegisterSessionId) REFERENCES CashRegisterSessions(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);

CREATE TABLE CashMovements
(
    Id INT PRIMARY KEY IDENTITY(1,1),
    CashRegisterSessionId INT NOT NULL,
    MovementType NVARCHAR(20) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    [Description] NVARCHAR(255),
    RelatedInvoiceId INT,
    CompanyId INT NOT NULL,
    FOREIGN KEY (CashRegisterSessionId) REFERENCES CashRegisterSessions(Id),
    FOREIGN KEY (RelatedInvoiceId) REFERENCES InvoicesHeaders(Id),
    FOREIGN KEY (CompanyId) REFERENCES Companies(Id),
    CreatedBy INT,
    UpdatedBy INT,
    UpdatedAt DATETIME,
    CreatedAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CreatedBy) REFERENCES Users(Id),
    FOREIGN KEY (UpdatedBy) REFERENCES Users(Id)
);


CREATE TABLE [dbo].[User]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](150) NULL,
	[Username] [nvarchar](50) NULL,
	[Password] [nvarchar](200) NULL,
	[CreatedBy] [nvarchar](50) NULL,
	[UpdatedBy] [nvarchar](50) NULL,
	[CreatedAt] [datetime] NULL,
	[UpdatedAt] [datetime] NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [User]
ADD CompanyId INT;

ALTER TABLE [User]
ADD FOREIGN KEY (CompanyId)
REFERENCES Companies(Id)

CREATE TABLE [dbo].[UserToken]
(
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[UserId] [int] NULL,
	[Token] [nvarchar](500) NULL,
	[CreatedAt] [datetime] NULL,
	[ExpDate] [datetime] NULL,
	PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]