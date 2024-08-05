CREATE TABLE [audit].[activity](
	[activity_id] [int] IDENTITY(1,1) NOT NULL,
	[run_id] [uniqueidentifier] NULL,
	[load_id] [int] NULL,
	[dataset_id] [int] NULL,
	[collection_id] [int] NULL,
    [dependencies] INT,
	[dataset_type] [varchar](255) NULL,
	[pipeline_name] [varchar](255) NULL,
	[pipeline_start] [datetime] NULL,
	[pipeline_end] [datetime] NULL,
	[pipeline_status] [varchar](15) NULL
) ON [PRIMARY]