CREATE TABLE [audit].[datasets] 
(
    [dataset_id] INT IDENTITY(1,1),
    [dataset_name] VARCHAR(50) not null,
    [collection_id] VARCHAR(50) null,
    [is_enabled] VARCHAR(10) not null,
    [dataset_type] VARCHAR(10) not null
)