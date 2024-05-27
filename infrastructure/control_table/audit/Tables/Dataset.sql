CREATE TABLE [audit].[Dataset] (
    [DatasetID]             INT              IDENTITY (1, 1) NOT NULL,
    [IsEnabled]             VARCHAR(10) NOT NULL,
    [SourceSystemId]        INT              NOT NULL,
    [DatasetName]     VARCHAR (255)    NULL,
    CONSTRAINT [PK_Datasets_LoadID] PRIMARY KEY CLUSTERED ([DatasetID])
);

