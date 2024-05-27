
CREATE OR ALTER PROC [audit].[setup]
AS
BEGIN
    IF OBJECT_ID(N'[tmp].[datasets]', 'U') IS NULL
    BEGIN 
        CREATE TABLE [tmp].[datasets] 
        (
            [code] VARCHAR(50) not null,
            [source_system_code] VARCHAR(50) null,
            [is_enabled] VARCHAR(10) not null,
            [type] VARCHAR(10) not null
        )
    END

    BEGIN
        -- Populate dataset from temp 
        Truncate Table [audit].[dataset]
        INSERT INTO [audit].[dataset]
        (
            DatasetName, 
            DatasetGroupID,
            IsEnabled,
            DatasetType
        )
        SELECT 
            [code],
            1,
            [is_enabled],
            [type]
        FROM [tmp].[datasets]


        -- LOAD ACTIVITY
        Truncate Table [audit].[activity]
        INSERT INTO [audit].[activity]
        (
            RunID, 
            LoadID,
            DataSourceID,
            DataSourceType

        )
        SELECT 
            NEWID(),
            -1,
            [DatasetId],
            [DatasetType]
        FROM [audit].[dataset]
        WHERE [IsEnabled] = 'true'
    END

END;
GO