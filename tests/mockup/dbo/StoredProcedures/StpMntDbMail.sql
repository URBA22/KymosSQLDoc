-- =============================================
-- Author:		Mik
-- Create date: 08.09.19
-- Description:	STP per invio di email da Sql Server usando Database Mail 
--				e con SMTP server di MailJet
-- History:
-- MIK 08-09-19: Create
-- MIK 09-09-19: Aggiunto configurazione Database Mail
-- =============================================
CREATE PROCEDURE StpMntDbMail 
	(
	@ServerSMTP AS NVARCHAR(MAX),
	@Porta AS INT,
	@EnableSsl AS BIT,
	@Use_Default_Credentials AS BIT = 0,
	@SrvMailUser AS NVARCHAR(MAX),
	@SrvMailPsw AS NVARCHAR(MAX),
	@Da AS NVARCHAR(MAX),
	@A AS NVARCHAR(MAX),
	@CC AS NVARCHAR(MAX),
	@Soggetto AS NVARCHAR(255),
	@Testo AS NVARCHAR(MAX),
	@IsBodyHtml AS BIT
	)
AS
BEGIN
DECLARE @BdyMail AS NVARCHAR(20)

EXECUTE sp_configure 'show advanced options', 1
--RECONFIGURE
EXECUTE sp_configure 'Database Mail XPs', 1
RECONFIGURE

--CREATE USER [sa] FROM LOGIN [sa];
--exec sp_addrolemember 'db_owner', 'sa'
--EXEC sp_addrolemember N'DatabaseMailUserRole', N'sa' -- Put user name here


	IF(EXISTS(SELECT [name] FROM msdb.dbo.sysmail_account WHERE [Name] = 'mailjet'))
	BEGIN
		--Se account esiste
		--aggiorno solo le impostazioni
		EXECUTE msdb.dbo.sysmail_update_account_sp
		@account_name = 'mailjet'
		,@email_address =  @Da  
		,@display_name =  'Dbo'
		,@description =  'Dbo Invio Email'
		,@mailserver_name =  @ServerSMTP 
		,@mailserver_type =  'SMTP'
		,@port =  @Porta   
		--,@timeout =  'timeout' 
		,@username =  @SrvMailUser
		,@password =  @SrvMailPsw 
		,@use_default_credentials =  @Use_Default_Credentials --use_default_credentials 
		,@enable_ssl =  @EnableSsl   
	END
	ELSE
	BEGIN
		--se account non esiste
		--lo creo
		EXECUTE msdb.dbo.sysmail_add_account_sp
		@account_name = 'mailjet'
		,@email_address =  @Da  
		,@display_name =  'Dbo'
		,@description =  'Dbo Invio Email'
		,@mailserver_name =  @ServerSMTP 
		,@mailserver_type =  'SMTP'
		,@port =  @Porta   
		--,@timeout =  'timeout' 
		,@username =  @SrvMailUser
		,@password =  @SrvMailPsw 
		,@use_default_credentials =  @Use_Default_Credentials --use_default_credentials 
		,@enable_ssl =  @EnableSsl   
	END

	IF(NOT EXISTS(SELECT [name] FROM msdb.dbo.sysmail_profile WHERE [Name] = 'dbomailjet'))
	BEGIN
		--se non esiste il profilo dbomailjet
		--lo creo e l'associo all'account mailjet
		EXECUTE msdb.dbo.sysmail_add_principalprofile_sp  
		@profile_name = 'dbomailjet',  
		@principal_name = 'public',  
		@is_default = 0
    
		EXECUTE msdb.dbo.sysmail_add_profileaccount_sp  
		@profile_name = 'dbomailjet',  
		@account_name = 'mailjet',  
		@sequence_number = 1
	END

	IF(@IsBodyHtml=1)
		SET @BdyMail = 'HTML'
	ELSE
		SET @BdyMail = 'TEXT'

	EXEC msdb.dbo.sp_send_dbmail @profile_name='dbomailjet',
		@from_address = @Da,
		@recipients = @A,
		@copy_recipients = @CC,
		@subject = @Soggetto,
		@body = @Testo,
		@body_format = @BdyMail

END

GO

