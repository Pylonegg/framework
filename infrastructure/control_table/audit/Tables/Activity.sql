CREATE TABLE [audit].[activity] 
(
    [ActivityID]        INT              IDENTITY (1, 1) NOT NULL,
    [RunID]             UNIQUEIDENTIFIER NULL,
    [LoadID]            INT              NULL,
    [DataSourceId]      INT              NULL,
    [DataSourceType]    VARCHAR (255)    NULL,
    [PipelineName]      VARCHAR (255)    NULL,
    [PipelineStart]     Datetime,
    [PipelineEnd]       Datetime,
    [PipelineStatus]    VARCHAR (15)     NULL,
    [Additional]        VARCHAR (15)     NULL,
    CONSTRAINT [PK_Activity_ActivityID] PRIMARY KEY CLUSTERED ([ActivityID] ASC)
);