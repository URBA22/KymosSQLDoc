


        
-- ==========================================================================================
-- Entity Name:   StpMntRecompile
-- Author:        dav
-- Create date:   210107
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Richiede la ricompilazione di stp
-- History:
-- dav 210107 Creazione
-- ==========================================================================================

      
CREATE Procedure [dbo].[StpMntRecompile] 
	
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

		Declare @name as nvarchar (256)
        DECLARE db_cursor CURSOR FOR 
        
		--SELECT SPECIFIC_SCHEMA +'.' + SPECIFIC_NAME , *
		--FROM INFORMATION_SCHEMA.ROUTINES
		--WHERE 
		--ROUTINE_TYPE in ('PROCEDURE', 'FUNCTION') and 
		--SPECIFIC_NAME IN( 'STPX%', 'FNCX')

		SELECT  sys.schemas.name + '.' + sys.objects.name AS IdObj
		FROM    sys.objects 
		INNER JOIN sys.schemas ON sys.objects.schema_id = sys.schemas.schema_id
		WHERE type  IN ('FN','IF','TF', 'P' , 'V')
		order by type, sys.objects.name
       
        OPEN db_cursor  
        FETCH NEXT FROM db_cursor INTO @name  

        WHILE @@FETCH_STATUS = 0  
        BEGIN  
			EXEC sp_recompile @name 
            FETCH NEXT FROM db_cursor INTO @name 
        END 

        CLOSE db_cursor  
        DEALLOCATE db_cursor 
END

GO

