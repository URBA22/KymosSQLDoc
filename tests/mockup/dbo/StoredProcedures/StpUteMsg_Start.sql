
-- ==========================================================================================
-- Entity Name:   StpUteMsg_Start
-- Author:        Dav
-- Create date:   26.11.17
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	Write custom note here
-- Description:	Stp che può essere richiamata al login per messaggi utente 
--				Va inserita la chiave in TbSettingKeyUte
--				StpStart - Stp da richiamare al login in alternativa a StpUteMsg_Start (default)
--				FormStart - Form da aprire al login
-- History:
-- dav 31.05.18 Aggiunte info versione
-- lisa 07.08.19 Aggiunto controllo fatture elettroniche da inviare
-- lisa 200228 Aggiunto controllo su invio estero con stessa causale
-- dav 200304 Controllo PrmNota
-- dav 200304 Controllo PrmNota con warnings
-- anna 200420 Aggiunta dicitura per info cliente
-- dav 200421 Correzione aggiornamento versione se errore nella codifica
-- dav 200426 Gestione Ci sono fatture clienti da contabilizzare
-- dav 200427 Correzione controllo escludendo PF
-- fab 200427 Aggiunto sintassi per aprire il messaggio in automatico in apertura
-- fab 200609 Totlto la sintassi per mantere i messaggi aperti richiesto da Anna
-- lisa 200707 Aggiunto controllo su presenze
-- lisa 200714 Modificato messaggio controllo presenze
-- dav 200723 controllo presenze con 4 gg per rgitrazioni manuali o sabato e domenica
-- dav 200914 se ci sono fature elettroniche da inviare e aggiornmanti mostra aggiornamenti @FlgGo = 0
-- dav 210113 Gestione dbversion > getdate()
-- lisa 211026 Aggiunto controllo fatture elettroniche reverse charge fornitori da inviare
-- vale 211230 Controllo su dichiarazione senza procotollo di ric.
-- vale 211230 I controlli non scattavano se avevano solo xml ma meglio che ci siano anche se non spediscono con noi 
-- lisa 220103 I controlli scattano se c'è almeno una fattura con stato fatel non nullo e l'utente è amministrazione
-- lisa 220120 Corretto controllo su inserimento protocollo, scatta solo con anno >= 2022
-- dav 220125 Gestione data elaborazione db e srtato ALR
-- lisa 220408 Modificato controllo invio fatture rev charge
-- lisa 220630 Eliminato gestione @FlgCliFatelEstero
-- dav 220630 Gestione AdmPassword
-- lia 220808 Tolta condizione in invio fatture in reverse charge perchè obsoleta (#)
-- dav 230213 Gestione @SizeDb
-- ==========================================================================================
CREATE Procedure [dbo].[StpUteMsg_Start]
(
	@SysUser nvarchar(256),
	@KYStato int = NULL output,
	@KYMsg nvarchar(max) = NULL output,
	@KYRes int = NULL
)
As
Begin
	/*
	return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla	
	Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question	
	*/
	Declare @Msg nvarchar(300)
	Declare @Msg1 nvarchar(300)
	Declare @MsgObj nvarchar(300)
	-- lisa 220630 Commentata questa parte, dal 01.07.22 tutte le fatture andranno inviate
	--Declare @FlgCliFatelEstero as bit

	SET @Msg= 'Login'
	SET @MsgObj='StpUteMsg_Start'
	
	Declare @PrInfo  nvarchar(300)
	Declare @InfoExt nvarchar(max)

	Set @PrInfo  = ''


	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		Declare @MsgType as nvarchar(20)
		Declare @FlgGo as bit

		-- Mette @Msg1 = '' per non far apparire la fascia
		SET @Msg1= ''
		SET @MsgType ='INF'
		SET @FlgGo = 1



		
		/*******************************
		 * Controllo Fatel
		 *******************************/
		-- lisa 220103 i controlli scattano quando c'è almeno una fattura con stato fatel non nullo e l'utente è amministrazione
		If exists (Select TOP 1 IdCliFat from TbCliFatElab where isnull(FatelStato, '') <> '') 
			AND exists(SELECT idutente FROM TbUtenti WHERE IdUtente=@SysUser AND FlgAmministrazione=1) 
		BEGIN
		
			IF EXISTS (SELECT IdPrmNota FROM  TbCntPrmNotaElab WHERE (FlgAllert = 1 or FlgWarnings = 1 ))
				BEGIN
					SET @Msg1= dbo.FncStr (@Msg1,'Ci sono registrazioni di prima nota da controllare.')
					IF @MsgType = 'INF' SET @MsgType ='WRN'
				END

			IF	EXISTS (SELECT IDCLIFAT FROM  VSTCLIFAT WHERE (FlgFatContabilizzata = 0) AND FlgProforma = 0 AND DataCliFat >= DATEADD(MONTH, -2, GETDATE()))
				AND  EXISTS (SELECT IDCLIFAT FROM  VSTCLIFAT WHERE (FlgFatContabilizzata = 1) AND DataCliFat >= DATEADD(MONTH, -2, GETDATE()))
				BEGIN
					SET @Msg1= dbo.FncStr (@Msg1,'Ci sono fatture clienti da contabilizzare.')
					IF @MsgType = 'INF' SET @MsgType ='WRN'
				END

			IF EXISTS (	SELECT TbClienti.IdCliente
						FROM TbClienti INNER JOIN 
						VstCliDicInt ON TbClienti.IdCliente = VstCliDicInt.IdCliente
						WHERE 
						FlgRigaEvasa=0 and FlgChiusuraMan=0
						and isnull(ProtocolloRicezione,'')=''
						and (VstCliDicInt.Anno >= '2022'))
				BEGIN
					SET @Msg1= dbo.FncStr (@Msg1,'Ci sono clienti con dichiarazione d''intento senza protocollo ricezione ')
					IF @MsgType = 'INF' SET @MsgType ='WRN'
				END

			-- lisa 220630 Commentata questa parte, dal 01.07.22 tutte le fatture andranno inviate
			--IF ISNULL(dbo.FncKeyValue('CliFatelEstero' ,null),'ON') ='ON'
			--	BEGIN
			--		SET @FlgCliFatelEstero = 1
			--	END
			--ELSE
			--	BEGIN
			--		SET @FlgCliFatelEstero = 0
			--	END

			IF exists(
				SELECT        IdCliFat
				FROM            VstCliFat
				WHERE  
				year (DataCliFat) >= 2019
				AND VstCliFat.FlgAbilitaFatel=1
				AND (dateadd (day, 8, dbo.FncLastMonthDay (DataCliFat)) < convert(date,getdate()) )  
				AND isnull(VstCliFat.FatelStato, '') IN ('','NS','ERR','XML')
				--AND (VstCliFat.TipoCEE ='IT' OR @FlgCliFatelEstero=1)
				) 
				AND exists (Select IdSetting from TbSetting where isnull(FatelServiceUrl, '') <> '') 
				BEGIN 

					SET @Msg1= dbo.FncStr (@Msg1,'Ci sono fatture elettroniche da inviare.')

					set  @InfoExt =  (

					SELECT DISTINCT LEFT(REPLACE(Substring
					((SELECT        '#' +   DescFat  AS [data()]
					FROM     (
					
					SELECT       'Ft.' + ' ' + IdCliFat + '  ' + 'Stato' + ' ' + isnull(VstCliFat.FatelStato, '---') + '  ' + 'Del' + ' ' + CONVERT(NVARCHAR(20),DataCliFat, 5) +  '  ' + 'Rag. Soc.' + ' ' + RagSoc AS DescFat 
					FROM            VstCliFat
					WHERE  
					year (DataCliFat) >= 2019
					AND VstCliFat.FlgAbilitaFatel=1
					AND (dateadd (day, 8, dbo.FncLastMonthDay (DataCliFat)) < convert(date,getdate()) )  
					AND isnull(VstCliFat.FatelStato, '') IN ('','NS','ERR','XML')
					--AND (VstCliFat.TipoCEE ='IT' OR @FlgCliFatelEstero=1)
					
					) x
					ORDER BY DescFat FOR XML PATH('')), 2, 4000), '#', char(13) + char(10)), 4000) AS DescFat
					)
					
					IF @MsgType = 'INF' SET @MsgType ='WRN'	
					--SET @FlgGo = 0
				END

			--  lisa 211026 controllo fatture elettroniche reverse charge fornitori da inviare
			IF exists(
			SELECT        IdForFat
			FROM            VstForFat INNER JOIN 
			TbForAnagFatCausali ON VstForFat.IdCausaleFat = TbForAnagFatCausali.IdCausaleFat
			WHERE  
			year (ISNULL(FatelDataRicevimento,DataForFat)) >= 2022
			AND VstForFat.FlgAbilitaFatel = 1
			AND (dateadd (day, 8, dbo.FncLastMonthDay (ISNULL(FatelDataRicevimento, DataForFat))) < convert(date,getdate()) )  
			AND isnull(VstForFat.FatelStato, '') IN ('','NS','ERR','XML')
			AND GETDATE() >= CONVERT(DATE,'20220701', 112)
			)
			AND exists (Select IdSetting from TbSetting where isnull(FatelServiceUrl, '') <> '')
			BEGIN
				SET @Msg1= dbo.FncStr (@Msg1,'Ci sono fatture elettroniche reverse charge da inviare.')
					
				set  @InfoExt =  (

				SELECT DISTINCT LEFT(REPLACE(Substring
				((SELECT        '#' +   DescFat  AS [data()]
				FROM     (
					
				SELECT       'Ft.' + ' ' + IdForFat + '  ' + 'Stato' + ' ' + isnull(VstForFat.FatelStato, '---') + '  ' + 'Del' + ' ' + CONVERT(NVARCHAR(20),DataForFat, 5) +  '  ' + 'Rag. Soc.' + ' ' + RagSoc + (CASE WHEN ISNULL(FatelDataRicevimento,'') = '' THEN '' ELSE ' ' + 'Ricevuta il' + ' ' + CONVERT(NVARCHAR(20),FatelDataRicevimento, 5) END) AS DescFat 
				FROM            VstForFat
				WHERE  
				year (ISNULL(FatelDataRicevimento,DataForFat)) >= 2022
				AND VstForFat.FlgAbilitaFatel = 1
				AND (dateadd (day, 8, dbo.FncLastMonthDay (ISNULL(FatelDataRicevimento, DataForFat))) < convert(date,getdate()) )  
				AND isnull(VstForFat.FatelStato, '') IN ('','NS','ERR','XML')
					
				) x
				ORDER BY DescFat FOR XML PATH('')), 2, 4000), '#', char(13) + char(10)), 4000) AS DescFat
				)
					
				IF @MsgType = 'INF' SET @MsgType ='WRN'	
				--SET @FlgGo = 0
			END

		END
        

        /*******************************
		 * Controllo Password di secondo livello
		 *******************************/

		IF  EXISTS (SELECT 1  FROM TbAdmDhRole WHERE AdmPassword IS NOT NULL )
            AND  EXISTS(SELECT idutente FROM TbUtenti WHERE IdUtente=@SysUser AND FlgAmministrazione = 1)
			BEGIN
				OPEN SYMMETRIC KEY MasterPassword_Key  
                DECRYPTION BY CERTIFICATE MasterPassword

                If EXISTS (SELECT 1 FROM TbAdmDhUserRole 
                                WHERE  CONVERT(nvarchar,  
                                        DecryptByKey(AdmPassword, 1 ,   
                                        HASHBYTES('SHA2_256', CONVERT(varbinary, 'dbo')))) IS NOT NULL AND 
                                        AdmPassword IS NOT NULL )
                BEGIN
                    SET @Msg1= dbo.FncStr (@Msg1,'Modulo PASSWORD:')
                    SET @Msg1= dbo.FncStr (@Msg1,'Ci sono utenti che non hanno cambiato la password di secondo livello.') 
                    IF @MsgType = 'INF' SET @MsgType ='WRN'
                END
			END
        ELSE IF  EXISTS (SELECT 1  FROM TbAdmDhRole WHERE AdmPassword IS NOT NULL )
            AND  EXISTS(SELECT idutente FROM TbUtenti WHERE IdUtente=@SysUser AND FlgAmministrazione = 0)
			BEGIN
				OPEN SYMMETRIC KEY MasterPassword_Key  
                DECRYPTION BY CERTIFICATE MasterPassword

                If EXISTS (SELECT 1 FROM TbAdmDhUserRole 
                                WHERE  CONVERT(nvarchar,  
                                        DecryptByKey(AdmPassword, 1 ,   
                                        HASHBYTES('SHA2_256', CONVERT(varbinary, 'dbo')))) IS NOT NULL AND 
                                        AdmPassword IS NOT NULL AND
                                        IdUtente = @SysUser)
                BEGIN
                    SET @Msg1= dbo.FncStr (@Msg1,'Modulo PASSWORD:')
                    SET @Msg1= dbo.FncStr (@Msg1,'Non hai ancora cambiato la password di secondo livello.') 
                    IF @MsgType = 'INF' SET @MsgType ='WRN'
                END
			END
		
		/*******************************
		 * Controllo Presenze
		 *******************************/

		DECLARE @FlgPresenze as bit

		If exists(select IdPresenza from TbRlvPresenze where DataPresenza >= DATEADD(MONTH, -2, GETDATE()))
			AND  exists(SELECT idutente FROM TbUtenti WHERE IdUtente=@SysUser AND FlgAmministrazione=1)
			BEGIN
				SET @FlgPresenze = 1
			END
		ELSE
			BEGIN
				SET @FlgPresenze = 0
			END

		If not exists (
		SELECT IdPresenza 
		FROM TbRlvPresenze 
		WHERE DataPresenza >= DATEADD(DAY, -4, GETDATE())) AND @FlgPresenze = 1

			BEGIN
				SET @Msg1= dbo.FncStr (@Msg1,'Modulo Presenze:')
				SET @Msg1= dbo.FncStr (@Msg1,'Non sono state rilevate presenze degli utenti negli ultimi due giorni.') 
				IF @MsgType = 'INF' SET @MsgType ='WRN'
			END


		/*******************************
		 * Controllo elaborazione db
		 *******************************/

		Declare @NumGGElab as int 
		Declare @DataElabDb as Date
		SET @DataElabDb = dbo.FncKeyValue ( 'DataElabDb', NULL)
		SET @NumGGElab = datediff(day,@DataElabDb,Getdate())

		If @NumGGElab >= 2
			BEGIN
				SET @Msg1= dbo.FncStr (@Msg1,'Ultima elaborazione db di ' + convert(nvarchar(20),@NumGGElab) + ' giorni fa' ) 
				IF @MsgType = 'INF' SET @MsgType ='WRN'
			END

		If @NumGGElab >= 5
			BEGIN
				SET @Msg1= dbo.FncStr (@Msg1,'Ultima elaborazione db di ' + convert(nvarchar(20),@NumGGElab) + ' giorni fa' ) 
				SET @MsgType ='ALR'
			END

        /*******************************
		 * Controllo dimensione database
		 *******************************/

        DECLARE @SizeDb as real
        DECLARE @EditionID as Nvarchar(50)

        SELECT @SizeDb = round(size * 8./1024./1000.,2)
        FROM sys.master_files
        WHERE DB_NAME(database_id) = DB_NAME() and type = 0

        SET @EditionID = CONVERT(Nvarchar(50), serverproperty('EditionID'))
        IF @EditionID IN ('-1592396055') and @SizeDb >  9
        BEGIN
            SET @Msg1= dbo.FncStr (@Msg1,'Dimensione DB: ' + convert(nvarchar(20),@SizeDb) + ' GB' ) 
			SET @MsgType ='ALR'
        END
        ELSE IF @EditionID IN ('-1592396055') and @SizeDb >  8
        BEGIN
            SET @Msg1= dbo.FncStr (@Msg1,'Dimensione DB: ' + convert(nvarchar(20),@SizeDb) + ' GB' ) 
			IF @MsgType = 'INF' SET @MsgType ='WRN'
        END
		
		/*******************************
		 * Controllo Attività Utente
		 *******************************/

		--If Exists (Select IdAttivita from TbAttivita where (IdUtenteDest = @SysUser or IdUtente= @SysUser) and FlgAperta = 1 and DataFineRichiesta <= getdate())
		--	BEGIN
		--		SET @Msg1= 'Ci sono attività aperte'
		--		IF @MsgType = 'INF' SET @MsgType ='WRN'
		--	END
		
		/*******************************
		 * Controllo Versioni
		 *******************************/

		Declare @DbVersion as nvarchar(20)
		Declare @DbVersionUser as nvarchar(20)
		Declare @NumVrs as int
		
		-- Se necessario crea la chiave utente
		If not exists (Select IdKey from TbSettingKeyUte WHERE IdKey = N'DbVersion' and IdUtente = @SysUser)
			BEGIN
			
				INSERT INTO TbSettingKeyUte
				(IdKey, CodFnz, NoteSetting, IdUtente,Value, SysDateCreate, SysUserCreate)
				VALUES        (N'DbVersion', N'KEYE', N'Inserimento automatico - versione db aggiornato',@SysUser,'--', GETDATE(),@SysUser)
			END

		--Set @DbVersion =  IsNull( dbo.FncKeyValue('DbVersion',null),'') 
		Set @DbVersionUser = IsNull( dbo.FncKeyValue('DbVersion',@SysUser),'') 
		Set @DbVersion = IsNull((SELECT max(IdVrs) FROM TbMntObjVrs WHERE IdVrs <> '300000' ),'')
		
		IF @DbVersionUser > convert(nvarchar(20),getdate(), 12) SET @DbVersionUser = '000000'
		
		If @DbVersion <> @DbVersionUser AND @FlgGo = 1
			
			BEGIN

				SELECT @NumVrs = count(IdVrs) 
				FROM TbMntObjVrs 
				WHERE IdVrs > @DbVersionUser
			
				UPDATE  TbSettingKeyUte
				SET  SysDateUpdate = GETDATE(), Value = @DbVersion
				WHERE  
				(IdKey = N'DbVersion') AND 
				-- Controlla in OR la struttura del codice per protezione su Versioni con struttura errata
				(@DbVersionUser < @DbVersion or LEN (Value) < 6  OR ISNUMERIC (Value) = 0)  AND 
				IdUtente = @SysUser
				

				SET @Msg1= dbo.FncStr (@Msg1,'AGGIORNAMENTO DBO ESEGUITO') 
				SET @Msg1= dbo.FncStr (@Msg1,'Ci sono ' + isnull(convert(nvarchar(20),@NumVrs),'') +' nuove funzionalità.')
			
				-- per aprire direttamente iniziare la stringa con {OPEN}
				set  @InfoExt =  (

					SELECT DISTINCT LEFT(REPLACE(Substring
					((SELECT        '#' +   DescVrs  AS [data()]
					FROM     (SELECT top 50 (IsNull(TbMntObjHelp.DescHelp,'') + ' - ' +  IsNull(TbMntObjVrs.DescVrs,'')) as DescVrs
					FROM            TbMntObjVrs INNER JOIN
					TbMntObjHelp ON TbMntObjVrs.IdObject = TbMntObjHelp.IdObject
					WHERE IdVrs > @DbVersionUser
					ORDER BY TbMntObjHelp.DescHelp) x
					ORDER BY DescVrs FOR XML PATH('')), 2, 4000), '#', char(13) + char(10)), 4000) AS DescVrs
				
				)
	
				--Set @PrInfo = 'Verifica le note di aggiornamento nella scheda Versioni.'

				Set @PrInfo ='Verifica i nuovi contenuti in Menu - Manutenzione -  Versioni'
				SET @PrInfo= dbo.FncStr (@PrInfo,'Puoi richiedere l''attivazione delle nuove funzionalità utili alla tua azienda.')

				SET @MsgType ='INF'		
			END
		
		IF ISNULL(@NumVrs,0) = 0 and DB_NAME() = 'dbo'
			BEGIN
				SELECT @NumVrs = count(IdVrs) 
				FROM TbMntObjVrs 
				WHERE IdVrs = '300000'

				SET @Msg1= dbo.FncStr (@Msg1,'Nuove versioni da validare') 
				SET @Msg1= dbo.FncStr (@Msg1,'Ci sono ' + isnull(convert(nvarchar(20),@NumVrs),'') +' nuove funzionalità.')

				IF @MsgType = 'INF' SET @MsgType ='WRN'
			END

		/*******************************
		 * Messaggio
		 *******************************/

		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,@MsgType,@SysUser,
					@KYStato,@KYRes,@InfoExt, '(1):Ok;0:Cancel',@KYMsg out
		
		SET @KYStato = -1
		
		RETURN
	END

	
End

GO

