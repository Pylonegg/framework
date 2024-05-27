CREATE TABLE [audit].[watermarkTable] (
    [TableName]         VARCHAR (255) NOT NULL,
    [WatermarkValue]    DATETIME      NULL,
    [NewWatermarkValue] DATETIME      NULL,
    CONSTRAINT [PK_watermarkTable] PRIMARY KEY CLUSTERED ([TableName] ASC)
);



