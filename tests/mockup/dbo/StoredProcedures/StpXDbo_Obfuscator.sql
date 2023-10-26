-- ==========================================================================================
-- Entity Name:   StpXDbo_Obfuscator
-- Author:        dav
-- Create date:   200503
-- Custom_Dbo:	  NO
-- Standard_dbo:  NO
-- CustomNote:    
-- Description:   Offusca i dati di un database
-- History:
-- dav 200502 Creazione
-- mik 200917 aggiunta parte per offuscamento dell'IdUtente ad opera di Simone
-- simone 210127 Aggiunto offuscamento SysUserCreate/Update
-- sim 210913 Aggiunto offuscamento per le presenze, aggiunto più campi offuscati a tbutenti
-- ==========================================================================================
CREATE Procedure [dbo].[StpXDbo_Obfuscator]
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


	SET @Msg= 'Obfsucator'
	SET @MsgObj='StpXDbo_Obfuscator'
	
	Declare @PrInfo  nvarchar(300)
	Set @PrInfo  = ''

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0 
	BEGIN
		SET @KYStato = 1

		SET @Msg1= 'Attenzione, con questo comando cripti tutti i dati del database di test !'
		SET @Msg1= dbo.fncstr (@Msg1, 'Database: ' + db_name())
		SET @Msg1= dbo.fncstr (@Msg1, 'Ok per procedere')
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUser,
				@KYStato,@KYRes,'', '(1):Ok;0:Cancel',@KYMsg out

		RETURN
	END


	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato IS NULL OR (@KYStato = 1 and @KYRes = 1)
	BEGIN

	
		/****************************************************************
		* Controllo esistenza
		****************************************************************/

		If  right (db_name(),2) <> 'T1'
		BEGIN	
			SET @KYStato = 0
			
			SET @Msg1= 'Operazione annullata, puoi operare solo database di test T1'
			EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUser,
					@KYStato,@KYRes,'','(1):Ok',@KYMsg out
			RETURN
		END

		
	
		/****************************************************************
		* Offusca
		****************************************************************/
		
		--BEGIN TRY
				
			UPDATE TbClienti
			SET  email=null, 
			Acronimo = null,
			contatto1 = case when  contatto1 is not null then 'Sig. Andrea' else null end,
			contatto2 = case when  contatto2 is not null then 'Sig. Paolo' else null end,
			Contatto1Note = case when  Contatto1Note is not null then 'Tel 32901234455' else null end,
			Contatto2Note = case when  Contatto2Note is not null then 'Tel 45566777889' else null end,
			PIva = IdCliente, CodFiscale = IdCliente, RagSoc = N'Cliente ' + CONVERT(nvarchar(20), IdCliente), Indirizzo = N'Via Novegno ' + CONVERT(nvarchar(20), IdCliente), Tel = IdCliente, Fax = IdCliente

			Update tbclidest
			set RagSoc = N'Cliente ' + CONVERT(nvarchar(20), IdCliente)

			Update tbcontatti set Cognome ='Rossi', ragsoc = Null, tel = Null, email = 'test@kymso.eu'


			UPDATE TbFornitori
			SET  email=null, 
			Acronimo = null,
			contatto1 = case when  contatto1 is not null then 'Sig. Andrea' else null end,
			contatto2 = case when  contatto2 is not null then 'Sig. Paolo' else null end,
			Contatto1Note = case when  Contatto1Note is not null then 'Tel 32901234455' else null end,
			Contatto2Note = case when  Contatto2Note is not null then 'Tel 45566777889' else null end,
			PIva = IdFornitore, CodFiscale = IdFornitore, RagSoc = N'Fornitore ' + CONVERT(nvarchar(20), IdFornitore), Indirizzo = N'Via Cornetto ' + CONVERT(nvarchar(20), IdFornitore), 
			Tel = IdFornitore, Fax = IdFornitore

			Update TbArticoli set
			DescArticolo ='Articolo ' + idarticolo

			UPDATE TbCliOff
			SET      CodFiscale = TbCliOff.IdCliente, Destinatario = TbClienti.RagSocCompleta, Destinazione = TbClienti.RagSocCompleta, PIva = TbCliOff.IdCliente
			, idutente = 'dav', email = 'test@kymos.eu', tel =null, fax = null
			FROM   TbCliOff INNER JOIN
			TbClienti ON TbCliOff.IdCliente = TbClienti.IdCliente

			update tbattivita set idutente ='dav', descattivita ='Impianto automatico'

			update TbDocumenti  set sysusercreate ='dav', descrizione ='Impianto automatico'

			UPDATE TbCliOrd
			SET      CodFiscale = TbCliOrd.IdCliente, Destinatario = TbClienti.RagSocCompleta, Destinazione = TbClienti.RagSocCompleta, PIva = TbCliOrd.IdCliente
			, idutente = 'dav', email = 'test@kymos.eu', tel =null, fax = null, contatto = 'Mario Rossi'
			FROM   TbCliOrd INNER JOIN
			TbClienti ON TbCliOrd.IdCliente = TbClienti.IdCliente

			UPDATE Tbcliddt
			SET      CodFiscale = Tbcliddt.IdCliente, Destinatario = TbClienti.RagSocCompleta, Destinazione = TbClienti.RagSocCompleta, PIva = Tbcliddt.IdCliente
			, idutente = 'dav', email = 'test@kymos.eu', tel =null, fax = null, contatto = 'Mario Rossi'
			FROM   Tbcliddt INNER JOIN
			TbClienti ON Tbcliddt.IdCliente = TbClienti.IdCliente

			UPDATE TbCliFat
			SET      CodFiscale = TbCliFat.IdCliente, Destinatario = TbClienti.RagSocCompleta, Destinazione = TbClienti.RagSocCompleta, PIva = TbCliFat.IdCliente
			, idutente = 'dav', email = 'test@kymos.eu', tel =null, fax = null, contatto = 'Mario Rossi'
			FROM   TbCliFat INNER JOIN
			TbClienti ON TbCliFat.IdCliente = TbClienti.IdCliente

			UPDATE TbCliPrpList
			SET      Destinatario = TbClienti.RagSocCompleta, Destinazione = TbClienti.RagSocCompleta
			FROM   TbCliPrpList INNER JOIN
			TbClienti ON TbCliPrpList.IdCliente = TbClienti.IdCliente

			UPDATE TbCliPkList
			SET       Destinazione = TbClienti.RagSocCompleta
			FROM   TbCliPkList INNER JOIN
			TbClienti ON TbCliPkList.IdCliente = TbClienti.IdCliente

			update tbcliartlistini set PrezzoVlt = qta * 2

			--update tbclioffdet set prezzounitvlt =  2
			--update tbcliorddet set prezzounitvlt =  2
			--update tbcliddtdet set prezzounitvlt =  2
			--update tbclifatdet set prezzounitvlt =  2

			--UPDATE TbSetting
			--SET      RagSoc = 'Novegno impianti', Indirizzo = N'Via della scola 21', RegImp = N'1234', CodFiscale = N'12343', REA = N'AER4', PIVA = N'123456789', EMail = N'test@kymos.eu', Tel = N'1234567', MailUserName = N'test', MailPassword = N'test', MailReturnTo = N'test@kymos.eu', MailFrom = N'test@kymos.eu', FatelMail = N'test@kymos.eu', FatelTel = N'123456', CapitaleSociale = 100000, FatelCitta = N'Vicenza', FatelCAP = N'3456', 
			--FatelCodFiscaleTrasm = N'123456', FatelUser = NULL, FatelPsw = NULL, DatiTestaDoc = N'Novegno Novegno Impianti', DatiPiePDoc = N'Novegno Impianti'

			UPDATE TbSetting
			SET     RagSoc = 'Novegno impianti', Indirizzo = N'Via della scola 21', RegImp = N'1234', CodFiscale = N'12343', REA = N'AER4', PIVA = N'123456789', EMail = N'test@kymos.eu', Tel = N'1234567', MailUserName = N'test', MailPassword = N'test', MailReturnTo = N'test@kymos.eu', MailFrom = N'test@kymos.eu', FatelMail = N'test@kymos.eu', FatelTel = N'123456', CapitaleSociale = 100000, FatelCitta = N'Vicenza', FatelCAP = N'3456', 
			FatelCodFiscaleTrasm = N'123456', FatelUser = NULL, FatelPsw = NULL, DatiTestaDoc = N'Novegno Novegno Impianti', DatiPiePDoc = N'Novegno Impianti'

			,DataBloccoCnt = NULL, Fax = '1234567', MailFattureTesto = 'Buongiorno, inviamo in allegato copia della ft. in oggetto formato PDF', MailObj = 'Fattura', 
			RptSrvrUserName = 'Report' + DB_NAME(), 
			RptSrvrPassword = 'DboDemo!123', RptSrvrDomain = NULL, WebEmailInfo = NULL, ImgWatermark = NULL, WebEmailOrder = NULL, AdmURLDbo = NULL, AdmURLCrm = NULL, 
			AdmURLConnect = NULL, FatelAuthUrl = NULL, FatelServiceUrl = NULL, FatelHUB = NULL, AdmServerIP = '10.0.0.4', DicPIvaIncr = NULL, DicCognomeIncr = NULL, DicNomeIncr = NULL, DicCognomeDich = NULL, DicNomeDich = NULL, DicImpgPresentazioneIncrData = NULL, FlgMonitorMailSrv = NULL, DataBloccoMage = NULL, FatelImpgPresentazioneIncr = NULL, 
			FatelCodFiscaleDich = NULL, FatelCodFiscaleIncr = NULL, FatelCaricaDich = NULL, FatelCognomeEmit = NULL, FatelCompany = NULL, FatelNomeEmit = NULL, FatelDenominazioneEmit = NULL, FatelCodFiscaleEmit = NULL, FatelPIvaEmit = NULL, FatelIdPaeseEmit = NULL, FatelTelTrasm = NULL, FatelEmailTrasm = NULL, RptSrvrPath = N'Report_DboDemo'



			UPDATE TbForFat
			SET      CodFiscale = TbForFat.IdFornitore,  PIva = TbForFat.IdFornitore
			FROM   TbForFat INNER JOIN
			TbFornitori ON TbForFat.IdFornitore = TbFornitori.IdFornitore


			UPDATE TbForOrd
			SET      CodFiscale = TbForOrd.IdFornitore,  PIva = TbForOrd.IdFornitore,
			Destinatario = IndirizzoCompleto, Destinazione ='Novegno Impianti', idutente ='dav', tel=TbFornitori.IdFornitore, fax = TbFornitori.IdFornitore,
			DestinatarioProd = IndirizzoCompleto, email = 'test@kymos.eu'
			FROM   TbForOrd INNER JOIN
			TbFornitori ON TbForOrd.IdFornitore = TbFornitori.IdFornitore

			UPDATE TbForDdt
			SET      CodFiscale = TbForDdt.IdFornitore,  PIva = TbForDdt.IdFornitore,
			Destinatario = IndirizzoCompleto, Destinazione ='Novegno Impianti', idutente ='dav', tel=TbFornitori.IdFornitore, fax = TbFornitori.IdFornitore,
			email = 'test@kymos.eu'
			FROM   TbForDdt INNER JOIN
			TbFornitori ON TbForDdt.IdFornitore = TbFornitori.IdFornitore


			UPDATE TbForArtListini SET costounitvlt = Qta*10
			--UPDATE TbForOffDet SET costounitvlt = 2
			--UPDATE TbForOrdDet SET costounitvlt = 2
			--UPDATE TbForfatDet SET costounitvlt = 2

			update TbForoffDet set descrizione  ='Articolo ' + idarticolo where idarticolo is not null
			update TbForOrdDet set descrizione  ='Articolo ' + idarticolo where idarticolo is not null
			update TbForrcvddtDet set descrizione  ='Articolo ' + idarticolo where idarticolo is not null
			update TbForfatDet set descrizione  ='Articolo ' + idarticolo where idarticolo is not null

			update TbclioffDet set descrizione  ='Articolo ' + idarticolo where idarticolo is not null
			update TbcliOrdDet set descrizione  ='Articolo ' + idarticolo where idarticolo is not null
			update TbclircvddtDet set descrizione  ='Articolo ' + idarticolo where idarticolo is not null
			update TbclifatDet set descrizione  ='Articolo ' + idarticolo where idarticolo is not null

			update tbschedodl set 
			descschedodlsnt = 'Articolo ' + idarticolo,
			ragsoc ='Pasubio SPA'

			update TbOdlDet set descrizione  ='Articolo ' + idarticolo where idarticolo is not null

			update TbOdlDetfasi set costounit = 10 where flgfaseext = 0
			update TbOdlDetdist set costounit = costounit * rand(2)
			update TbOdlDetdistvrsm set costounit = costounit * rand(2)
			update TbMageInvDet set costounit = costounit * rand(2)

			update tbodldetregtmp set costounit = 10

			update tbodldetelab set costomaterialiunit=10 where costomaterialiunit is not null
			update tbodldetelab set prezzomaterialiunit=10 where prezzomaterialiunit is not null

			update tbodldetelab set costolavintunit=10 where costolavintunit is not null
			update tbodldetelab set PrezzoLavIntUnit=10 where PrezzoLavIntUnit is not null

			update tbodldetelab set costolavestunit=10 where costolavestunit is not null
			update tbodldetelab set PrezzoLavestUnit=10 where PrezzoLavestUnit is not null

			update tbodldetelab set costototunit=30 where costototunit is not null
			update tbodldetelab set Prezzoproposto=30 where Prezzoproposto is not null

			update tbodldetelab set costomateriali=10 where costomateriali is not null
			update tbodldetelab set costolavint=10 where costolavint is not null
			update tbodldetelab set costolavest=10 where costolavest is not null

			update tbodldetelab set costotot=30 where costolavest is not null

			update tbodldet set MargineMateriali= 5
			update tbodldet set MargineLavorazioni= 5
			update tbodldet set MargineLavorazioniExt= 5
			update tbodldet set MargineCostiAgnt= 5

			update TbProdCdl set CostoCdl = 10
			update TbProdCdl set CostoCdlatrz = 10
			update TbProdCdl set CostoCdl1 = 11
			update TbProdCdl set CostoCdlatrz1 = 11
			update TbProdCdl set CostoCdl2 = 12
			update TbProdCdl set CostoCdlatrz2 = 12

			update TbProdCdlCausali set CostoCausaleCdl = 10


			UPDATE TbProdLottiRegQta
			SET    Descrizione = N'Articolo ' + IdArticolo


			update tbutenti set cognome = 'Rossi' , nome = Idutente, email = 'test@kymos.eu', 
			indirizzo ='Via delle prese, 21',
			codfiscale = null, emailfirma = Null, descutente ='Mario Rossi',
			GAFlgTwoAuthentication = 0,
			PowerBIToken = null,
			PswdSmtp = null,
			UserNameSmtp = null,
            Citta = N'Città', Provincia = 'VI',
            LuogoNascita = null, Cap = null, Tel = '424/2424242', Tel1 = null,
			DataNascita = null


			delete tbmail

			delete tbdocumenti

			update   tbforrda set idutente = null
			update   TbOdlDetRegQta set idutente = null
			delete from TbSettingKeyUte
			update   TbAttivitaUte set idutentedest = null
			update   TbAttivita set idutentedest = null
			update   TbForOff set idutente = null
			update   TbQaReclami set idutente = null
			update   TbUteMsg set idutente = null

			--UPDATE TbUtenti
			--SET      IdUtente = right('000' + convert(nvarchar(20), x.nute),3)
			--FROM   TbUtenti INNER JOIN
			--(SELECT IdUtente, ROW_NUMBER() OVER(ORDER BY idutente ASC) AS nute
			--FROM   TbUtenti AS TbUtenti_1) AS x ON x.IdUtente = TbUtenti.IdUtente
			--where TbUtenti.idutente <>'dav'

			UPDATE TbSchedOdl
			SET      DescSchedOdlSnt = N'Zambon Spa'


			--UPDATE tbprodcdl
			--SET      IdCdl = right('000' + convert(nvarchar(20), x.nute),3)
			--FROM   tbprodcdl INNER JOIN
			--(SELECT idcdl, ROW_NUMBER() OVER(ORDER BY idcdl ASC) AS nute
			--FROM   tbprodcdl AS TbUtenti_1) AS x ON x.idcdl = tbprodcdl.idcdl

			--UPDATE tbprodcdlunita
			--SET      Idcdlunita = right('000' + convert(nvarchar(20), x.nute),3)
			--FROM   tbprodcdlunita INNER JOIN
			--(SELECT idcdlunita, ROW_NUMBER() OVER(ORDER BY idcdlunita ASC) AS nute
			--FROM   tbprodcdlunita AS TbUtenti_1) AS x ON x.idcdlunita = tbprodcdlunita.idcdlunita


			Update tbprodcdl set DescCdl = 'Macchina ' + idcdl
			Update tbprodcdlunita set DescUnita = 'Macchina ' + idcdlunita



			UPDATE TbCntLiqIvaDet
			SET      RagSoc = N'Cliente ' + CONVERT(nvarchar(20),IdCliente )
			from TbCntLiqIvaDet  inner join 
			TbCntPrmNotaIva ON TbCntPrmNotaIva.idprmnotaiva = TbCntLiqIvaDet.idprmnotaiva
			inner join
			TbCntPrmNota ON TbCntPrmNota.IdPrmNota = TbCntPrmNotaIva.IdPrmNota
			where IdCliente is not null

			UPDATE TbCntLiqIvaDet
			SET      RagSoc = N'Fornitore ' + CONVERT(nvarchar(20),IdFornitore )
			from TbCntLiqIvaDet  inner join 
			TbCntPrmNotaIva ON TbCntPrmNotaIva.idprmnotaiva = TbCntLiqIvaDet.idprmnotaiva
			inner join
			TbCntPrmNota ON TbCntPrmNota.IdPrmNota = TbCntPrmNotaIva.IdPrmNota
			where IdFornitore is not null



			UPDATE TbCntPartite
			SET  RagSoc = N'Cliente ' + CONVERT(nvarchar(20), IdCntrPartita),
			DescPartita =  N'Cliente ' + CONVERT(nvarchar(20), IdCntrPartita )
			where TipoCntrPartita  ='C'

			UPDATE TbCntPartite
			SET  RagSoc = N'Fornitore ' + CONVERT(nvarchar(20), IdCntrPartita),
			DescPartita = N'Fornitore ' + CONVERT(nvarchar(20), IdCntrPartita)
			where TipoCntrPartita ='F'


			update tbcntprmnota set   RagSoc = N'Cliente ' + CONVERT(nvarchar(20), IdCliente) 
			where IdCliente is not null

			update tbcntprmnota set   RagSoc = N'Fornitore ' + CONVERT(nvarchar(20), IdFornitore) 
			where IdFornitore is not null

			update tbcntprmnotadet set   descprmnotadet = NULL
			update tbcntprmnota set   DescPrmNota = null

			Update  tbcntdistinteribadet
			set ragsoc ='Novegno SPA', abi ='000000', cab ='000000', Piva ='00000000000', Indirizzo ='Via Padova 1', Cap ='000000', Citta ='Vicenza', Provincia ='VI', CodFiscale ='0000000'

			UPDATE TbSettingKey SET Value ='Novegno' where idkey in ('ExportBonificoAzienda','ExportBonificoRagSocCompleto','ExportRibaAzienda','ExportRibaRagSocCompleto')

			UPDATE  TbCntLiqIvaDet set ragsoc ='Novegno SPA'

			UPDATE TbCntDistinteBonificodet set RagSoc = 'Novegno'

			update TbCntEsterometrodet set RagSoc = 'Novegno'

			update tbcntpartite set ragsoc = 'Novegno', notepartita ='Novegno'

			update tbclienti 
			set notecliente = null, notedoc =null, noteclioff=null, notecliord=null, 
			notecliddt = null, noteclifat = null, noteodl = null, noteodlprod = null,
			EMailFattura = null, EMailFatturaPec = null

			update tbcntcespitimov set ragsoc ='Novegno'
			
			update TbCntBilanciRtfCmp set ragsoc ='Novegno'
			update TbCntBilanciRtfCmpDoc set ragsoc ='Novegno'

			-- Presenze
			UPDATE TbRlvPresenze SET NomeUtente = CONCAT('Cognome Nome ', drvNomiUtenti.Riga)
			FROM TbRlvPresenze
			LEFT OUTER JOIN (
			    SELECT TbRlvPresenze.NomeUtente, ROW_NUMBER() OVER(ORDER BY NomeUtente) AS Riga
			    FROM TbRlvPresenze
			    GROUP BY NomeUtente ) AS drvNomiUtenti ON TbRlvPresenze.NomeUtente = drvNomiUtenti.NomeUtente

			-- Società
			UPDATE TbRlvSocieta SET RagSoc = CONCAT(N'Società ', drvSocieta.Riga)
			FROM TbRlvSocieta
			LEFT OUTER JOIN (
			    SELECT TbRlvSocieta.RagSoc, ROW_NUMBER() OVER(ORDER BY RagSoc) AS Riga
			    FROM TbRlvSocieta
			    GROUP BY RagSoc ) AS drvSocieta ON TbRlvSocieta.RagSoc = drvSocieta.RagSoc

			-- Reparti
			UPDATE drvProdReparti
			SET DescReparto = DescRepartoNew
			FROM (
			     SELECT DescReparto, CONCAT('Reparto numero ', ROW_NUMBER() OVER (ORDER BY IdReparto)) AS DescRepartoNew
			     FROM TbProdReparti
			) drvProdReparti

			-- Dispositivi
			DECLARE @NewIdDispstivo TABLE
            (
                IdDispositivo    NVARCHAR(20) COLLATE DATABASE_DEFAULT,
                IdDispositivoNew NVARCHAR(20) COLLATE DATABASE_DEFAULT
            )

            INSERT INTO @NewIdDispstivo (IdDispositivo, IdDispositivoNew)
			SELECT IdDispositivo, CONCAT('Dispositivo numero ', ROW_NUMBER() OVER (ORDER BY IdDispositivo)) AS IdDispositivoNew
		    FROM TbRlvAnagDispositivi

			INSERT INTO TbRlvAnagDispositivi (IdDispositivo, IPDispositivo, NoteDispositivo, IdSocieta, Disabilita)
			SELECT [@NewIdDispstivo].IdDispositivoNew, IPDispositivo, NoteDispositivo, IdSocieta, Disabilita
			FROM TbRlvAnagDispositivi
			INNER JOIN @NewIdDispstivo
		        ON TbRlvAnagDispositivi.IdDispositivo = [@NewIdDispstivo].IdDispositivo

			UPDATE TbRlvTransiti
			SET TbRlvTransiti.IdDispositivo = [@NewIdDispstivo].IdDispositivoNew
			FROM TbRlvTransiti
			INNER JOIN @NewIdDispstivo
		        ON TbRlvTransiti.IdDispositivo = [@NewIdDispstivo].IdDispositivo

			DELETE TbRlvAnagDispositivi
			WHERE IdDispositivo IN (SELECT IdDispositivo FROM @NewIdDispstivo)
			

			/****************************************************************
			* Offuscamento IdUtete
			*****************************************************************/
			--vedere StpXDbo_ObfuscatorUtenti come riferimento

			DECLARE @nome_relazione AS nvarchar(300)
			DECLARE @nome_tabella AS nvarchar(300)
			DECLARE @nome_colonna AS nvarchar(300)
			DECLARE @sql AS nvarchar (300)
			DECLARE @vecchio_id AS nvarchar (256)
			DECLARE @row_number AS float

			-- Dichiarazione cursore static (fa una copia temporanea dei dati) e scroll (può tornare all'inizio)
			-- che punta ad una vista delle relazioni della tabella TbUtenti
			DECLARE relationship_cursor CURSOR STATIC SCROLL FOR
				SELECT 
					f.name AS relazione
				   ,OBJECT_NAME (f.parent_object_id) AS tabella
				   ,COL_NAME(fc.parent_object_id, fc.parent_column_id) AS colonna
				FROM sys.foreign_keys AS f  
				INNER JOIN sys.foreign_key_columns AS fc ON f.object_id = fc.constraint_object_id
				WHERE f.referenced_object_id = OBJECT_ID('dbo.TbUtenti');  

			-- Eliminazione vincoli di chiave esterna che puntano a IdUtenti
			OPEN relationship_cursor;  
			FETCH NEXT FROM relationship_cursor INTO @nome_relazione, @nome_tabella, @nome_colonna;  
			WHILE @@FETCH_STATUS = 0  
				BEGIN  
					SET @sql = 'ALTER TABLE ' + @nome_tabella + ' ' +
							   'DROP CONSTRAINT ' + @nome_relazione + ';'
					--PRINT @sql
					EXEC(@sql)
					FETCH NEXT FROM relationship_cursor INTO @nome_relazione, @nome_tabella, @nome_colonna;  
				END;  

			-- Creazione di una tabella temporanea che contine il vecchio id e quello nuovo (generato in modo casuale)
			-- Non è possibile usare una variabile tabella in quanto essendo locale ha uno scope diverso di quello di EXEC 
			CREATE TABLE #TbOldNewId (
				idOld nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS, 
				idNew nvarchar(256) COLLATE SQL_Latin1_General_CP1_CI_AS PRIMARY KEY)

			DECLARE insert_cursor CURSOR SCROLL FOR
				SELECT TbUtenti.IdUtente
				FROM TbUtenti

			SET @row_number = (SELECT COUNT(*) FROM TbUtenti)

			OPEN insert_cursor;  
			FETCH NEXT FROM insert_cursor INTO @vecchio_id;  
			WHILE @@FETCH_STATUS = 0
				BEGIN  
					BEGIN TRY
						-- Se un nuovo id esiste già, solleva un'eccezione, quindi ripete senza eseguire un nuovo fetch
						-- Da notare che il numero di possibili numeri generati da RAND() è sempre > del numero di righe di TbUtenti
						-- perchè RAND() * @row_number genera un numero > 0 < @row_number, decimali compresi
						
						INSERT INTO #TbOldNewId 
						VALUES(@vecchio_id, 
						CASE WHEN @vecchio_id = 'DAV' then 'dav' else
						CONVERT(nvarchar(256), RAND() * @row_number) end)
						


						FETCH NEXT FROM insert_cursor INTO @vecchio_id; 

					END TRY
					BEGIN CATCH 
						-- Do nothing
					END CATCH  
				END;
			CLOSE insert_cursor
			DEALLOCATE insert_cursor

			-- Update delle tabelle che puntavano a TbUtenti utilizzando la tabella temporanea
			FETCH FIRST FROM relationship_cursor INTO @nome_relazione, @nome_tabella, @nome_colonna;
			WHILE @@FETCH_STATUS = 0 
				BEGIN
					SET @sql = 'UPDATE ' + @nome_tabella + ' 
								SET ' + @nome_colonna + ' = idNew
								FROM ' + @nome_tabella + '
								INNER JOIN #TbOldNewId ON idOld = ' + @nome_colonna + ';'
					--PRINT @sql
					EXEC(@sql)
					FETCH NEXT FROM relationship_cursor INTO @nome_relazione, @nome_tabella, @nome_colonna;  
				END;

			-- Update di TbUtenti con il nuovo id
			UPDATE TbUtenti
			SET IdUtente = idNew
			FROM TbUtenti
			INNER JOIN #TbOldNewId ON idOld = IdUtente;	

			-- Per verifica dati
			--SELECT * FROM #TbOldNewId

			-- Elimnazione tabella temporanea
			DROP TABLE #TbOldNewId
		
			-- ATTENZIONE: esiste un IdUtente in TbUtentiElab che non esiste in TbUtenti 
			-- Eliminazione di tutti gli utenti in TbUtentiElab che non sono presenti in TbUtenti
			DELETE FROM TbUtentiElab
			WHERE TbUtentiElab.IdUtente NOT IN ( SELECT TbUtenti.IdUtente
											 FROM TbUtenti )


			-- Ripristino vincoli di chiave esterna
			FETCH FIRST FROM relationship_cursor INTO @nome_relazione, @nome_tabella, @nome_colonna;  
			WHILE @@FETCH_STATUS = 0  
				BEGIN
					SET @sql = 'ALTER TABLE ' + @nome_tabella + ' ' +
							   'ADD CONSTRAINT ' + @nome_relazione + ' FOREIGN KEY (' + @nome_colonna + ') ' +
							   'REFERENCES dbo.TbUtenti(IdUtente);'
					--PRINT @sql
					EXEC(@sql)
					FETCH NEXT FROM relationship_cursor INTO @nome_relazione, @nome_tabella, @nome_colonna;  
				END;  
			CLOSE relationship_cursor; 

			DEALLOCATE relationship_cursor;


			/****************************************************************
			* ---------------------------------------------------------------
			*****************************************************************/


			/****************************************************************
			* Offuscamento SysUserCreate e Update
			*****************************************************************/

			DECLARE @tableName NVARCHAR(300)


			DECLARE crs_offSysUserCreate CURSOR FOR
			SELECT TABLE_NAME 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_TYPE = 'BASE TABLE' 
			AND TABLE_NAME IN (
				SELECT DISTINCT TABLE_NAME
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE 'SysUserCreate' = COLUMN_NAME
			)
			
			OPEN crs_offSysUserCreate
			
			FETCH NEXT FROM crs_offSysUserCreate INTO @tableName
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @sql = 'UPDATE ' + @tableName + ' SET SysUserCreate = ''Lorem'' WHERE ISNULL(SysUserCreate, '''') <> '''''
					EXEC(@Sql)
					
					FETCH NEXT FROM crs_offSysUserCreate INTO @tableName
				END
			
			CLOSE crs_offSysUserCreate
			
			DEALLOCATE crs_offSysUserCreate


			DECLARE crs_offSysUserUpdate CURSOR FOR
			SELECT TABLE_NAME 
			FROM INFORMATION_SCHEMA.TABLES 
			WHERE TABLE_TYPE = 'BASE TABLE' 
			AND TABLE_NAME IN (
				SELECT DISTINCT TABLE_NAME
				FROM INFORMATION_SCHEMA.COLUMNS
				WHERE 'SysUserUpdate' = COLUMN_NAME
			)
			
			OPEN crs_offSysUserUpdate
			
			FETCH NEXT FROM crs_offSysUserUpdate INTO @tableName
			
			WHILE @@FETCH_STATUS = 0
				BEGIN
					SET @sql = 'UPDATE ' + @tableName + ' SET SysUserUpdate = ''Ispum'' WHERE ISNULL(SysUserUpdate, '''') <> '''''
					EXEC(@Sql)
					
					FETCH NEXT FROM crs_offSysUserUpdate INTO @tableName
				END
			
			CLOSE crs_offSysUserUpdate
			
			DEALLOCATE crs_offSysUserUpdate


			/****************************************************************
			* Uscita
			****************************************************************/

			SET @Msg1= 'Operazione completata'
			EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'INF',@SysUser,
					@KYStato,-1,'', NULL,@KYMsg out

			SET @KYStato = -1
			
		--END TRY
		--BEGIN CATCH
		--	-- Execute error retrieval routine.
		--	--rollback transaction
		--	Declare @MsgExt as nvarchar(max)
		--	SET @MsgExt= ERROR_MESSAGE()
		--	SET @Msg1= 'Errore Stp'
			
		--	EXECUTE StpUteMsg	@Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUser,
		--			@KYStato,@KYRes,@MsgExt,null,@KYMsg out
		--	SET @KYStato = -4
		--END CATCH

		RETURN
	END

	/****************************************************************
	* Stato 1 - risposta negativa
	****************************************************************/
	IF ISNULL(@KYStato,999) = 1 and @KYRes = 0
	BEGIN

		/****************************************************************
		* Uscita
		****************************************************************/

		SET @Msg1= 'Operazione annullata'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'WRN',@SysUser,
				@KYStato,@KYRes,'',null,@KYMsg out
		SET @KYStato = -4
		RETURN
	END

	
	
	
End

GO

