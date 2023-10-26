
-- ==========================================================================================
-- Entity Name:	tpMntBackupDatabases_SB
-- Author:	Miki
-- Create date:	23/06/13
-- AutoCreate:	NO
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	Backup di tutti i db e ftp
-- ==========================================================================================


CREATE Procedure [dbo].[StpMntBackupDatabases_SB]  
            @databaseName sysname = null,
            @backupLocation nvarchar(200) ,
            @HasWeekly bit,
            @HasMonthly bit,
            @HasYearly bit,
            @DoFtp bit
AS 
	--questa procedura di backup comprime e sposta su FTP i singoli file invece di tutti così da evitare la limirazione di 4GB di dimensione per file

	--CREATE TYPE file_list_tbtype AS TABLE (filepath nvarchar(255) NOT NULL PRIMARY KEY)
	--DECLARE @file_list file_list_tbtype
	DECLARE @file_list TABLE 
	(
	filepath nvarchar(255),
	filename_noext nvarchar(255)
	)


	DECLARE @DataBackup datetime
	SET @DataBackup = GETDATE()
	DECLARE @name VARCHAR(50)

	DECLARE @fileName VARCHAR(256)
	DECLARE @fileDate VARCHAR(20)

	DECLARE @filepath NVARCHAR(255)
	DECLARE @filename_noext NVARCHAR(255)
	DECLARE @tmpPath NVARCHAR(255)
	DECLARE @tmpFtpPath NVARCHAR(255)
	DECLARE @tmp nvarchar(255)
	SET NOCOUNT ON; 
           
	DECLARE db_cursor CURSOR FOR  
	SELECT name 
	FROM master.dbo.sysdatabases 
	WHERE name NOT IN ('master','model','msdb','tempdb','ReportServer$SQLEXPRESS','ReportServer$SQLEXPRESSTempDB')
	AND  (@databaseName IS NULL OR @databaseName = name)


	OPEN db_cursor   
	FETCH NEXT FROM db_cursor INTO @name   

	WHILE @@FETCH_STATUS = 0   
	BEGIN   

		-- Backup Settimanale , uno per ogni giorno delle settimana, con sovrascrittura
		IF(@HasWeekly=1)
			BEGIN
				SELECT @fileDate =right ('00' + convert(varchar(10), datepart (dw , @DataBackup) ),2)
				SET @fileName = @backupLocation + '\' + @name + '_set_' + @fileDate + '.BAK'  
				BACKUP DATABASE @name TO DISK = @fileName with init 

				--Mik130527
				--mi segno tutti i file di backup che ho creato ma senza estensione che poi aggiungerò io a seconda stia facendo un backup o un	
				SET @tmp = @name + '_set_' + @fileDate
				--print @tmp	   
				INSERT INTO @file_list(filepath,filename_noext) VALUES (@backupLocation, @name + '_set_' + @fileDate)
			END
		
 	   -- Backup Mensile, uno per ogni primo giorno del mese, ultimi 12 mesi, con sovrascrittura
       IF(@HasMonthly=1)
		   BEGIN
				IF (day ( @DataBackup)=1)
				BEGIN
					SELECT @fileDate =right ('00' + convert(varchar(10), MONTH ( @DataBackup) ),2)
					SET @fileName = @backupLocation + '\' + @name + '_mese_' + @fileDate + '.BAK'  
					BACKUP DATABASE @name TO DISK = @fileName with init 
				   
					--Mik130527
					--mi segno tutti i file di backup che ho creato ma senza estensione che poi aggiungerò io a seconda stia facendo un backup o un		   
					INSERT INTO @file_list(filepath,filename_noext) VALUES (@backupLocation, @name + '_mese_' + @fileDate)
				END
			END
		
		-- Backup Annuale, uno per ogni primo giorno del mese, ultimi 12 mesi, con sovrascrittura
		IF(@HasYearly=1)
			BEGIN
				if (day ( @DataBackup)=1 and MONTH ( @DataBackup)=1 )
				BEGIN
					SELECT @fileDate =  convert(varchar(10), year ( @DataBackup) )
					SET @fileName = @backupLocation + '\' + @name + '_anno_' + @fileDate + '.BAK'  
					BACKUP DATABASE @name TO DISK = @fileName  

					--Mik130527
					--mi segno tutti i file di backup che ho creato ma senza estensione che poi aggiungerò io a seconda stia facendo un backup o un		   
					INSERT INTO @file_list(filepath,filename_noext) VALUES (@backupLocation, @name + '_anno_' + @fileDate)
				END       
			END
		FETCH NEXT FROM db_cursor INTO @name   
	END   
	CLOSE db_cursor   
	DEALLOCATE db_cursor

	--finiti i back up, comprimi e carica la cartella sul FTP
	if(@DoFtp = 1)
	BEGIN
		DECLARE db_cursor_file1 CURSOR FOR  
		SELECT filepath, filename_noext
		FROM @file_list 
		--Scorro i backup creati (e solo loro) e li comprimo
		OPEN db_cursor_file1   
		FETCH NEXT FROM db_cursor_file1 INTO @filepath, @filename_noext
		WHILE @@FETCH_STATUS = 0   
			BEGIN  
				BEGIN TRY 
					--EXEC StpMntCompressDirectory @backupLocation,'d:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\backup\backup_compressed.gz'
					SET @tmpPath = @filepath+'\'+@filename_noext+'.bak'
					--print @tmpPath
					EXEC StpMntCompressFile @tmpPath
				END TRY
				BEGIN CATCH

				END CATCH
				FETCH NEXT FROM db_cursor_file1 INTO @filepath,@filename_noext
			END
		CLOSE db_cursor_file1  
		DEALLOCATE db_cursor_file1


		DECLARE db_cursor_file2 CURSOR FOR  
		SELECT filepath, filename_noext
		FROM @file_list 
		--Scorro i backup creati (e solo loro) e li comprimo
		OPEN db_cursor_file2   
		FETCH NEXT FROM db_cursor_file2 INTO @filepath,@filename_noext
		WHILE @@FETCH_STATUS = 0   
		BEGIN  
			BEGIN TRY 
				SET @tmpPath = @filepath+'\'+@filename_noext+'.bak.gz'
				SET @tmpFtpPath = 'Upload/'+@filename_noext+'.bak.gz'
				--print @tmpFtpPath
				--print @tmpPath
				EXEC StpMntFtpUpload 'ftp://ftp.kymos.eu','anonymous','',@tmpFtpPath,@tmpPath
			END TRY
			BEGIN CATCH

			END CATCH
		FETCH NEXT FROM db_cursor_file2 INTO @filepath,@filename_noext
	END

	CLOSE db_cursor_file2
	DEALLOCATE db_cursor_file2

END

GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpMntBackupDatabases_SB';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpMntBackupDatabases_SB';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpMntBackupDatabases_SB';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '06/03/2013 10:54:44', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpMntBackupDatabases_SB';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpMntBackupDatabases_SB';


GO

