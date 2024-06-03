CREATE TABLE [audit].[dependency] (
    [DependencyID]          INT              IDENTITY (1, 1) NOT NULL,
    [SourceId]              INT              NOT NULL,
    [DestinationId]         INT              NOT NULL,
    [DependencyType]        VARCHAR (50)     NULL,
    CONSTRAINT [PK_Dependencies_DependencyID] PRIMARY KEY CLUSTERED ([DependencyID])
);

