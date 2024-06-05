
CREATE TABLE [stage].[WideWorldImporters_Application_SystemParameters]
    (
    [SystemParameterID] int,
	[DeliveryAddressLine1] nvarchar(60),
	[DeliveryAddressLine2] nvarchar(60),
	[DeliveryCityID] int,
	[DeliveryPostalCode] nvarchar(10),
	[DeliveryLocation] geography(max),
	[PostalAddressLine1] nvarchar(60),
	[PostalAddressLine2] nvarchar(60),
	[PostalCityID] int,
	[PostalPostalCode] nvarchar(10),
	[ApplicationSettings] nvarchar(max),
	[LastEditedBy] int,
	[LastEditedWhen] datetime2
    );
