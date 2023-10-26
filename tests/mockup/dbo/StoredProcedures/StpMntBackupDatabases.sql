
-- ==========================================================================================
-- Entity Name:	StpMntBackupDatabases
-- Author:	Miki
-- Create date:	23/06/13
-- AutoCreate:	NO
-- Custom:	NO
-- Generator:	01.00.01
-- CustomNote:	Write custom note here
-- Description:	Backup di tutti i db
-- ==========================================================================================


CREATE Procedure [dbo].[StpMntBackupDatabases]  
            @databaseName sysname = null,
            @backupLocation nvarchar(200) ,
            @HasWeekly bit,
            @HasMonthly bit,
            @HasYearly bit,
            @DoFtp bit
AS 
	DECLARE @DataBackup datetime
	SET @DataBackup = GETDATE()
	DECLARE @name VARCHAR(50)

	DECLARE @fileName VARCHAR(256)
	DECLARE @fileDate VARCHAR(20)

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
		END
		-- Backup Mensile, uno per ogni primo giorno del mese, ultimi 12 mesi, con sovrascrittura
		IF(@HasMonthly=1)
		BEGIN
			IF (day ( @DataBackup)=1)
			BEGIN
			   SELECT @fileDate =right ('00' + convert(varchar(10), MONTH ( @DataBackup) ),2)
			   SET @fileName = @backupLocation + '\' + @name + '_mese_' + @fileDate + '.BAK'  
			   BACKUP DATABASE @name TO DISK = @fileName with init 
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
			END       
		END
		FETCH NEXT FROM db_cursor INTO @name   
END   

--finiti i back up, comprimi e carica la cartella sul FTP
if(@DoFtp = 1)
BEGIN
	EXEC StpMntCompressDirectory @backupLocation,'d:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\backup\backup_compressed.gz'
	
	EXEC StpMntFtpUpload 'ftp://ftp.kymos.eu','anonymous','','Public/backup_compressed.gz','d:\Program Files\Microsoft SQL Server\MSSQL10_50.SQLEXPRESS\MSSQL\backup\backup_compressed.gz'
END

CLOSE db_cursor   
DEALLOCATE db_cursor

GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpMntBackupDatabases';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpMntBackupDatabases';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpMntBackupDatabases';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpMntBackupDatabases';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '03/28/2013 17:24:19', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpMntBackupDatabases';


GO

