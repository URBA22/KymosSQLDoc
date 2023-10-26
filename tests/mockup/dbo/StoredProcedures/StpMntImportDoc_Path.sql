-- ==========================================================================================
-- Entity Name:	StpMntImportDoc_Path
-- Author:		Dav
-- Create date:	11.07.18
-- AutoCreate:	YES
-- Custom:		NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	Importa più file nella tabella   documenti
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpMntImportDoc_Path]
	(
		@BasePath varchar(1000),	-- Path dei file accessibile da utente sql, esempio 'F:\Test\'
		@Estensione nvarchar(20),	-- Esetnsione di filtro da caricare, ad esempio csv, se nullo importa tutto
		@PathLog nvarchar(100),		-- Sottocaretlla per spostamento dei file,se nulla non sposta, es: log
		@TipoDoc nvarchar(300),		-- Tipo di documento da caricare, ad esempio TbArticoli
		@SysUser as nvarchar(256)
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- ref:			http://www.sqlservercentral.com/blogs/everyday-sql/2012/12/31/how-to-use-xp_dirtree-to-list-all-files-in-a-folder-part-2/
	
	SET NOCOUNT ON;

   
	DECLARE @Path varchar(1000)
	DECLARE @fullpath varchar(2000)
	DECLARE @Id int

	declare   @TbImptFilePath Table (
		id int IDENTITY(1,1)
		,fullpath varchar(2000)
		,FileName nvarchar(512)
		,depth int
		,isfile bit);

	--Populate the table using the initial base path.
	INSERT @TbImptFilePath (FileName,depth,isfile)
	EXEC master.sys.xp_dirtree @BasePath,1,1;

	UPDATE @TbImptFilePath SET fullpath = @BasePath;

	Declare @FilePath as nvarchar(max)
	Declare @FileName as nvarchar(max)
	Declare @Sql as varchar(4000)
	Declare @I as int

	DECLARE db_cursor CURSOR FOR  

	SELECT fullpath + '\' + FileName AS Path, FileName as FILENAME
	FROM @TbImptFilePath
	where right (FileName,3)=@Estensione  or @Estensione is null
	ORDER BY fullpath,FileName;


	OPEN db_cursor   
	FETCH NEXT FROM db_cursor INTO @FilePath   , @FileName

	WHILE @@FETCH_STATUS = 0   
	BEGIN   
      
		SET @I = @I +1
		PRINT @I
		print @FilePath

		Declare @IdDocumento int
		Declare @IdDoc as nvarchar(50)
		Declare @Descrizione as nvarchar(200)
		Declare @ExtDoc nvarchar(8)

		-- calcola il nome del documento dal nome del file
		Set @IdDoc = left (@FileName, len(@FileName)-4)

		-- descrizione mette il nome del file
		Set @Descrizione = @FileName

		-- estensione
		Set @ExtDoc = Right (@FileName, 4)

		execute [dbo].[StpMntImportDoc]
			@IdDocumento OUTPUT,
			@TipoDoc,					-- Tipo di documento da caricare, ad esempio TbArticoli
			@IdDoc,
			@Descrizione,
			@ExtDoc,
			@FilePath,
			@SysUser

		If @PathLog is not null
			BEGIN
				SELECT @sql =     ' MOVE "' + @FilePath +  '"' + ' ' +   '"' + @BasePath + '\Log\' + @filename +  '"'
				Execute master..xp_cmdshell  @sql
			END


		FETCH NEXT FROM db_cursor INTO @FilePath  , @FileName 
	END   

	CLOSE db_cursor   
	DEALLOCATE db_cursor


	

	
END

GO

