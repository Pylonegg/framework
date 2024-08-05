
CREATE PROCEDURE [audit].[activity_end]
    @ActivityID INT,
    @State INT
AS
BEGIN

    UPDATE [audit].[activity]
    SET 
        [pipeline_end]  = getdate()
        ,[pipeline_status] = @State
    WHERE [activity_id] = @ActivityID
END
GO
