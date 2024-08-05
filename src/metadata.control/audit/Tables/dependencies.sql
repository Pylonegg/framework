CREATE TABLE [audit].[dependency] 
(
    [dependency_id]         INT IDENTITY(1,1),
    [dataset_id]            INT not null,
    [dependent_dataset_id]  INT null,
    [dependency_type]       VARCHAR(10) not null
)