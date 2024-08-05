CREATE PROCEDURE [audit].[activity_start]
    @ActivityID INT
AS
BEGIN

    UPDATE [audit].[activity]
    SET 
        [pipeline_start]  = getdate()
        ,[pipeline_status] = 'In Progress'
    WHERE [activity_id] = @ActivityID
END
GO