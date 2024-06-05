
CREATE TABLE [stage].[WideWorldImporters_Warehouse_VehicleTemperatures]
    (
    [VehicleTemperatureID] bigint,
	[VehicleRegistration] nvarchar(20),
	[ChillerSensorNumber] int,
	[RecordedWhen] datetime2,
	[Temperature] decimal,
	[FullSensorData] nvarchar(1000),
	[IsCompressed] bit,
	[CompressedSensorData] varbinary(max)
    );
