
CREATE TABLE [stage].[WideWorldImporters_Warehouse_ColdRoomTemperatures]
    (
    [ColdRoomTemperatureID] bigint,
	[ColdRoomSensorNumber] int,
	[RecordedWhen] datetime2,
	[Temperature] decimal,
	[ValidFrom] datetime2,
	[ValidTo] datetime2
    );
