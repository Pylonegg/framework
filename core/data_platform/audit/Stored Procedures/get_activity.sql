CREATE PROCEDURE [audit].[get_activity]
AS
BEGIN

    SELECT
        *
    FROM [audit].[activity]
END
GO