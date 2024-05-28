CREATE TABLE [audit].[logs] (
    [LogID]   INT            NOT NULL,
    [ErrorLog] NVARCHAR (MAX) NOT NULL,
    CONSTRAINT [PK_Log_LogID] PRIMARY KEY CLUSTERED ([LogID] ASC)
);

