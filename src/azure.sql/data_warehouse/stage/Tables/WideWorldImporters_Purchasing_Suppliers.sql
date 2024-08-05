
CREATE TABLE [stage].[WideWorldImporters_Purchasing_Suppliers]
    (
    [SupplierID] int,
	[SupplierName] nvarchar(100),
	[SupplierCategoryID] int,
	[PrimaryContactPersonID] int,
	[AlternateContactPersonID] int,
	[DeliveryMethodID] int,
	[DeliveryCityID] int,
	[PostalCityID] int,
	[SupplierReference] nvarchar(20),
	[BankAccountName] nvarchar(50),
	[BankAccountBranch] nvarchar(50),
	[BankAccountCode] nvarchar(20),
	[BankAccountNumber] nvarchar(20),
	[BankInternationalCode] nvarchar(20),
	[PaymentDays] int,
	[InternalComments] nvarchar(max),
	[PhoneNumber] nvarchar(20),
	[FaxNumber] nvarchar(20),
	[WebsiteURL] nvarchar(256),
	[DeliveryAddressLine1] nvarchar(60),
	[DeliveryAddressLine2] nvarchar(60),
	[DeliveryPostalCode] nvarchar(10),
	[DeliveryLocation] geography(max),
	[PostalAddressLine1] nvarchar(60),
	[PostalAddressLine2] nvarchar(60),
	[PostalPostalCode] nvarchar(10),
	[LastEditedBy] int,
	[ValidFrom] datetime2,
	[ValidTo] datetime2
    );