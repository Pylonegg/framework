CREATE PROC [audit].[setup]
AS
BEGIN
    -- Create audit.dataset if it does not exist---------------------------
    IF OBJECT_ID(N'[audit].[collections]', 'U') IS NULL
    BEGIN 
        CREATE TABLE [audit].[collections] 
        (
            [collection_id] INT IDENTITY(1,1),
            [collection_name] VARCHAR(50) not null,
        )
    END

    -- Create audit.dataset if it does not exist---------------------------
    IF OBJECT_ID(N'[audit].[datasets]', 'U') IS NULL
    BEGIN 
        CREATE TABLE [audit].[datasets] 
        (
            [dataset_id] INT IDENTITY(1,1),
            [dataset_name] VARCHAR(50) not null,
            [collection_id] VARCHAR(50) null,
            [is_enabled] VARCHAR(10) not null,
            [dataset_type] VARCHAR(10) not null
        )
    END
    IF OBJECT_ID(N'[audit].[dependency]', 'U') IS NULL
    BEGIN 
        CREATE TABLE [audit].[dependency] 
        (
            [dependency_id]         INT IDENTITY(1,1),
            [dataset_id]            INT not null,
            [dependent_dataset_id]  INT null,
            [dependency_type]       VARCHAR(10) not null
        )
    END



    BEGIN

        TRUNCATE TABLE [audit].[datasets]
        TRUNCATE TABLE [audit].[collections]
        TRUNCATE TABLE [audit].[dependency]

        -- Populate COLLECTIONS from temp ---------------------------
        INSERT INTO [audit].[collections] (
            [collection_name]
        )
        SELECT DISTINCT 
            [collection_code]
        FROM [tmp].[datasets]

        -- Populate dataset from temp ---------------------------
        INSERT INTO [audit].[datasets] (
            [dataset_name], 
            [collection_id],
            [is_enabled],
            [dataset_type]
        )
        SELECT DISTINCT
            D.[code],
            C.[collection_id],
            D.[is_enabled],
            D.[type]
        FROM [tmp].[datasets] D
        LEFT JOIN [audit].[collections] C
        ON D.[collection_code] = C.[collection_name]


        -- Populate dependency from  ---------------------------
        INSERT INTO [audit].[dependency] (
            [dataset_id],
            [dependent_dataset_id],
            [dependency_type]
        )
        SELECT DISTINCT
            D.[dataset_id],
            DD.[dataset_id],
            'Unknown'
        FROM [tmp].[dependency] TD
        --  dataset
        LEFT JOIN [audit].[collections] C
        ON TD.[collection_code] = C.[collection_name]      
        LEFT JOIN [audit].[datasets] D
        ON  TD.[dataset_code]   = D.[dataset_name]
        AND D.[collection_id]  = C.[collection_id]
        -- dependent dataset
        LEFT JOIN [audit].[collections] DC
        ON TD.[dependent_collection_code] = DC.[collection_name]      
        LEFT JOIN [audit].[datasets] DD
        ON  TD.[dependent_dataset_code]   = DD.[dataset_name]
        AND DD.[collection_id]  = DC.[collection_id]






        -- LOAD ACTIVITY ---------------------------------------
        TRUNCATE TABLE [audit].[activity]
        INSERT INTO [audit].[activity] (
            run_id, 
            load_id,
            dataset_id,
            collection_id,
            dataset_type,
            dependencies

        )
        SELECT 
            NEWID()
            ,-1
            ,D.[dataset_id]
            ,D.[collection_id]
            ,D.[dataset_type]
            ,0
        FROM [audit].[datasets] D
        WHERE [is_enabled] = 'true'


        -- UPDATE ACTIVITY ---------------------------------------
        UPDATE A
        SET A.[dependencies] = COALESCE(G.[dependencies],0)
        FROM [audit].[activity] A
        LEFT JOIN (
            SELECT
                D.[dataset_id]
                ,count(*) AS [dependencies]
            FROM [audit].[dependency] D
            JOIN [audit].[activity] A
            ON A.[dataset_id] = D.[dependent_dataset_id]
            GROUP BY D.[dataset_id]
        ) G
        ON  G.[dataset_id] = A.[dataset_id]
    END

END;
GO
