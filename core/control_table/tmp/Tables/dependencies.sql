CREATE TABLE [tmp].[dependency] 
(
    [dataset_code]            VARCHAR(255) not null,
    [collection_code]            VARCHAR(255) not null,
    [dependent_dataset_code]  VARCHAR(255) not null,
    [dependent_collection_code]  VARCHAR(255) not null,
    [dependency_type]       VARCHAR(10) not null
)