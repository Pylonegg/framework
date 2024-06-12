
CREATE PROCEDURE [audit].[activity_end]
    @ActivityID INT,
    @State INT
AS
BEGIN

    UPDATE [audit].[activity]
    SET 
        [PipelineEnd]  = getdate()
        ,[PipelineStatus] = @State
    WHERE [ActivityID] = @ActivityID
END
GO
