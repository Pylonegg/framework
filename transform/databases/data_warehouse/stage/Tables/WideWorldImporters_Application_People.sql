
CREATE TABLE [stage].[WideWorldImporters_Application_People]
    (
    [PersonID] int,
	[FullName] nvarchar(50),
	[PreferredName] nvarchar(50),
	[SearchName] nvarchar(101),
	[IsPermittedToLogon] bit,
	[LogonName] nvarchar(50),
	[IsExternalLogonProvider] bit,
	[HashedPassword] varbinary(max),
	[IsSystemUser] bit,
	[IsEmployee] bit,
	[IsSalesperson] bit,
	[UserPreferences] nvarchar(max),
	[PhoneNumber] nvarchar(20),
	[FaxNumber] nvarchar(20),
	[EmailAddress] nvarchar(256),
	[Photo] varbinary(max),
	[CustomFields] nvarchar(max),
	[OtherLanguages] nvarchar(max),
	[LastEditedBy] int,
	[ValidFrom] datetime2,
	[ValidTo] datetime2
    );
