CREATE PROCEDURE [audit].[activity_start]
    @ActivityID INT
AS
BEGIN

    UPDATE [audit].[activity]
    SET 
        [PipelineStart]  = getdate()
        ,[PipelineStatus] = 'In Progress'
    WHERE [ActivityID] = @ActivityID
END
GO