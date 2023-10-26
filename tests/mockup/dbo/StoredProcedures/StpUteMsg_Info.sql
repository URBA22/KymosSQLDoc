-- ==========================================================================================
-- Entity Name:	StpUteMsg_Info
-- Author:	Dav
-- Create date:	27/12/2012 18:50:40
-- AutoCreate:	NO
-- Custom:	NO
-- Generator:	01.00.00
-- CustomNote:	Write custom note here
-- Description:	Controlla integrità dei dati
-- History
-- dav 27.11.16 controllo su lotti e magevrt
-- dav 28.02.17 controllo ddt e messaggi a fascia 
-- dav 22.06.18 Controllo sequenza con dbo.FncCliFor_Ddt()
-- dav 22.06.18 Controllo fatture
-- sim 221123 Aggiunto parametro a FncMageVrt
-- ==========================================================================================
CREATE Procedure [dbo].[StpUteMsg_Info]
	(
		@SysUser nvarchar(256),
		@KYStato int = NULL output,
		@KYMsg nvarchar(max) = NULL output,
		@KYRes int = NULL
	)

AS
BEGIN

	/*
	return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera;	
	Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question	
	*/
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Declare @Msg nvarchar(300)
	Declare @Msg1 nvarchar(300)
	Declare @MsgObj nvarchar(300)
	Declare @MsgExt nvarchar(max)
	Declare @TipoMsg as nvarchar(5)

	Set @TipoMsg = 'INF'

	SET @Msg= 'Controllo coerenza dati'
	SET @MsgObj='StpUteMsg_Info'

	Declare @PrInfo  nvarchar(300)
	Set @PrInfo  = ''
	
	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato,999) = 0
	BEGIN
		SET @Msg1= 'Eseguo il controllo di coerenza dei dati ?'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,'QST',@SysUser,
				@KYStato,@KYRes,'', '(1):Ok;0:Cancel',@KYMsg out
		SET @KYStato = 1
		RETURN
	END
	
	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF (@KYStato = 1 and @KYRes = 1)
	BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		Declare @Param as nvarchar
		Declare @NumInfo as int
	
		Set @NumInfo=0
	
		-- Da gestire a seconda del gruppo di appartenenza
	
	
		/*****************************************************
		 * Verifica autoupdate
		 *****************************************************/
	 
		 -- DocElabNRiga
		 --Se ON abilita il ricalcolo NRiga nei documenti (CliOrd, CliOff, ArtConfig) su eliminazione o modifica righe

		If dbo.FncKeyValue ('DocElabNRiga',Null)='ON'
			BEGIN
			
				set @Param= (select count (IdAutoUpd) from TbSettingAutoUpd where Tabella = 'VstCliOrdDet' and Campo = 'NRiga' and CodFncAct ='Upd' )
				if @Param >0 
					BEGIN
						Set @Msg= 'Parametri autoupdate errati'
						Execute StpUteMsg_Ins 'Clienti Ordini' , 'DocElabNRiga=ON e AutoUpdate NRiga abilitato', '', 'WRN',@SysUser
						Set @NumInfo= @NumInfo+1
						Set @MsgExt = dbo.FncStr (@MsgExt,@Msg)
					END

					set @Param= (select count (IdAutoUpd) from TbSettingAutoUpd where Tabella = 'VstCliOffDet' and Campo = 'NRiga' and CodFncAct ='Upd' )
				if @Param >0 
					BEGIN
						Set @Msg= 'Parametri autoupdate errati'
						Execute StpUteMsg_Ins 'Clienti Offerte' , 'DocElabNRiga=ON e AutoUpdate NRiga abilitato', '', 'WRN',@SysUser
						Set @NumInfo= @NumInfo+1
						Set @MsgExt = dbo.FncStr (@MsgExt,@Msg)
					END

			END
	

		/*****************************************************
		 * Verifica correttezza listini personalizzati
		 *****************************************************/
	 
		set @Param= (select count (IdArticolo) from VstCliArt where FlgErrore=1)
		if @Param >0 
			BEGIN
				Set @Msg= 'Listini Errati'
				Execute StpUteMsg_Ins 'Clienti Listini' , 'Listini Errati', '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
				Set @MsgExt = dbo.FncStr (@MsgExt,@Msg)
			END
		
		/*****************************************************
		 * Verifica chiavi di setting
		 *****************************************************/
	 
		if dbo.FncKeyValue  ('IdLingua1',null) is not null and  not exists  (SELECT IdLingua FROM  TbLingue where IdLingua=dbo.FncKeyValue  ('IdLingua1',null))
			BEGIN
				Set @Msg= 'Lingua 1 non definita'
				Execute StpUteMsg_Ins 'Setting' , 'IdLingua1 non definita', '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
				Set @MsgExt = dbo.FncStr (@MsgExt,@Msg)
			END
		
		if dbo.FncKeyValue  ('IdLingua2',null) is not null and  not exists  (SELECT IdLingua FROM  TbLingue where IdLingua=dbo.FncKeyValue  ('IdLingua2',null) )
			BEGIN
				Set @Msg= 'Lingua 2 non definita'
				Execute StpUteMsg_Ins 'Setting' , 'IdLingua2 non definita', '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
				Set @MsgExt = dbo.FncStr (@MsgExt,@Msg)
			END
		
	
		/*********************************************************
		 * Controlla configurazione iva
		 *********************************************************/

		If not exists (SELECT  IdIva FROM TbCntIva WHERE (Predefinita = 1) AND (NOT (Aliquota IS NULL)))
			BEGIN
				Set @Msg= 'Non è stata definita aliquota iva predefinita'
				Execute StpUteMsg_Ins 'Iva' , @Msg, '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
				Set @MsgExt = dbo.FncStr (@MsgExt,@Msg)
			END
	
		/*********************************************************
		 * Controlla listini generici
		 *********************************************************/

		If  exists (SELECT IdListino FROM TbArtListini WHERE(FlgListinoStd = 1) AND (DataInizioValidita > GETDATE()) or (DataFineValidita < GETDATE()))
			BEGIN
				Set @Msg= 'Il listino standard non è temporalmente valido'
				Execute StpUteMsg_Ins 'Listini Generali' , @Msg, '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
				Set @MsgExt = dbo.FncStr (@MsgExt,@Msg)
			END
	
	
		/*********************************************************
		 * Controlla tabella cambi
		 *********************************************************/

		If  exists (SELECT     NumRecord FROM  VstCntValuteCambiAttuali WHERE     (NumRecord > 1))
			BEGIN
				Set @Msg= 'Tabella cambi con valori ambigui'
				Execute StpUteMsg_Ins 'Cambi Valute' , @Msg, '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
			END
	
		/*********************************************************
		 * Controlla tabella cambi
		 *********************************************************/

		If  exists (SELECT     VstCntValuteCambiAttuali.IdValuta, TbSetting.IdSetting
					FROM         TbSetting RIGHT OUTER JOIN
					TbCntValute ON TbSetting.IdValuta = TbCntValute.IdValuta LEFT OUTER JOIN
					VstCntValuteCambiAttuali ON TbCntValute.IdValuta = VstCntValuteCambiAttuali.IdValuta
					WHERE     (VstCntValuteCambiAttuali.IdValuta IS NULL) AND (TbSetting.IdSetting IS NULL))
			BEGIN
				Set @Msg= 'Tabella cambi non definiti'
				Execute StpUteMsg_Ins 'Cambi Valute' , @Msg, '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
				Set @MsgExt = dbo.FncStr (@MsgExt,@Msg)
			END	
		
	
		/*********************************************************
		 * Controlla deriva vrt
		 *********************************************************/
	 	
		If Exists (
					SELECT        TbMageVrtElab.IdArticolo, TbMageVrtElab.KeyMage, TbMageVrtElab.IdLotto, TbMageVrtElab.DimLunghezza, TbMageVrtElab.DimLarghezza, TbMageVrtElab.DimAltezza, TbMageVrtElab.Qta, 
					FncMageVrt_1.Qta AS Expr1, FncMageVrt_1.Qta + TbMageVrtElab.Qta AS Expr2
					FROM            dbo.FncMageVrt(GETDATE(), 1,1,0,0, 'dav') AS FncMageVrt_1 FULL OUTER JOIN
					TbMageVrtElab ON ISNULL(FncMageVrt_1.DimLarghezza, 0) = ISNULL(TbMageVrtElab.DimLarghezza, 0) AND ISNULL(FncMageVrt_1.DimLunghezza, 0) = ISNULL(TbMageVrtElab.DimLunghezza, 0) AND 
					ISNULL(FncMageVrt_1.DimAltezza, 0) = ISNULL(TbMageVrtElab.DimAltezza, 0) AND ISNULL(FncMageVrt_1.MagePosiz, N'') = ISNULL(TbMageVrtElab.MagePosiz, N'') AND 
					FncMageVrt_1.IdArticolo = TbMageVrtElab.IdArticolo AND FncMageVrt_1.KeyMage = TbMageVrtElab.KeyMage AND ISNULL(FncMageVrt_1.IdLotto, N'') = ISNULL(TbMageVrtElab.IdLotto, N'') AND 
					FncMageVrt_1.MagePosiz = TbMageVrtElab.MagePosiz
					WHERE ABS (round( round(ISNULL(FncMageVrt_1.Qta, 0),2) - ISNULL(TbMageVrtElab.Qta, 0),2)) > 0.01
				)
			BEGIN

				Set @Msg= 'Disallineamneto Mage VRT'
				Execute StpUteMsg_Ins 'Magazzino' , @Msg, '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
				Set @MsgExt = dbo.FncStr (@MsgExt,@Msg)

			END

		/*********************************************************
		 * Controlla Lotti Prod
		 *********************************************************/
	 	
		If Exists (
					SELECT        IdUtente, COUNT(IdProdLotto) AS Expr1
					FROM            TbProdLotti
					WHERE        (FlgPausa = 0) AND (FlgLottoChiuso = 0)
					GROUP BY IdUtente
					HAVING        (COUNT(IdProdLotto) > 1)
				)
			BEGIN

				Set @Msg= 'Lotti di produzione incongruenti (operatori attivi su più lotti)'
				Execute StpUteMsg_Ins 'Produzione' , @Msg, '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
				Set @MsgExt = dbo.FncStr (@MsgExt,@Msg)

			END

		/*********************************************************
		 * Controlla Lotti Prod Macchine
		 *********************************************************/
	 	
		If Exists (
					SELECT        IdCdlUnita, COUNT(IdCdlUnita) AS Expr1
					FROM            TbProdLotti
					WHERE        (FlgPausa = 0) AND (FlgLottoChiuso = 0)
					GROUP BY IdCdlUnita
					HAVING        (COUNT(IdProdLotto) > 1)
				)
			BEGIN

				Set @Msg= 'Lotti di produzione incongruenti (unità attive su più lotti)'
				Execute StpUteMsg_Ins 'Produzione' , @Msg, '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
				Set @MsgExt = dbo.FncStr (@MsgExt,@Msg)

			END
	
		/*********************************************************
		 * Controlla Numerazione ddt anno corrente
		 *********************************************************/

		Declare @IdDdt as nvarchar(20)
		Declare @IdDdtElab as nvarchar(20)
		Declare @DataDdt  as date  
		Declare @DataDdtElab  as date  
		Declare @NumDdt as int
		Declare @Prefisso as nvarchar(4)
		Declare @TipoDoc as nvarchar(20)
		Declare @GruppoDoc as nvarchar(20)
		Declare @GruppoDocElab as nvarchar(20)
		Declare @Info as nvarchar(max)

		SET @Prefisso = ''
		SET @NumDdt = 0
		Set @Prefisso = ''

		CREATE TABLE #ControlloDoc(
			IdDoc nvarchar(20) NOT NULL,
			DataDoc date NULL,
			TipoDoc varchar(20) NOT NULL,
			GruppoDoc varchar(20) NOT NULL
		) 

		
		INSERT INTO #ControlloDoc
		(IdDoc, DataDoc, TipoDoc, GruppoDoc)
		SELECT  IdDoc AS IdDdt, DataDoc AS DataDdt, TipoDoc, GruppoDoc
		FROM  dbo.FncCliFor_Ddt(NULL) drvDdt

		Declare @AnnoContabile AS NVARCHAR(4)
		Set @AnnoContabile = dbo.FncKeyValue( 'YearDoc', @SysUser)
		Set @AnnoContabile = isnull(@AnnoContabile, year(getdate()))
		Set @AnnoContabile = Right (@AnnoContabile,2)

		DECLARE db_cursor CURSOR FOR 
		
		--Controllo con left per eventuali / bis
		SELECT IdDoc as IdDoc,DataDoc,TipoDoc,GruppoDoc
		FROM #ControlloDoc
		Where substring (IdDoc,3,2) =  @AnnoContabile
		ORDER BY GruppoDoc,IdDoc

		OPEN db_cursor   
		FETCH NEXT FROM db_cursor INTO @IdDdt, @DataDdt, @TipoDoc, @GruppoDoc  

		WHILE @@FETCH_STATUS = 0   
		BEGIN   
		
				If @Prefisso <>left (@IdDdt,4) or @GruppoDocElab <> @GruppoDoc
					BEGIN
						Set @Prefisso = left (@IdDdt,4)
						SET @NumDdt = 0
						SET @DataDdtElab = @DataDdt
						SET @GruppoDocElab = @GruppoDoc
						If IsNumeric (Substring(@IdDdt,5,20)) = 1 Set @NumDdt = Convert(Int, Substring(@IdDdt,5,20))-1
					END
		
				Set @NumDdt = @NumDdt + 1
				set @IdDdtElab = @Prefisso + right('00000'+convert(nvarchar(20),@NumDdt),5)

				If @DataDdtElab >  @DataDdt
					BEGIN
						set @Info =dbo.FncStr ( @Info,'Errore data ' + @TipoDoc + ' ' + @IdDdt + ' ' + convert (nvarchar(20),@DataDdt,104) +  ' attesa ' + convert (nvarchar(20),@DataDdtElab,104))
					END
				If @IdDdtElab <> @IdDdt
					BEGIN
						set @Info =dbo.FncStr ( @Info, 'Errore numerazione ' + @TipoDoc + ' ' + @IdDdt + ' atteso ' + @IdDdtElab)
						If IsNumeric (right(@IdDdt,5)) = 1 Set @NumDdt = right(@IdDdt,5)
					END

				Set @DataDdtElab = @DataDdt
		
			   FETCH NEXT FROM db_cursor INTO @IdDdt, @DataDdt, @TipoDoc, @GruppoDoc   
		END   

		CLOSE db_cursor   
		DEALLOCATE db_cursor

		If @Info is not null
			BEGIN

				Set @Msg= left(@Info,300)
				Execute StpUteMsg_Ins 'Verifica DDT' , @Msg, '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
				Set @MsgExt = dbo.FncStr (@MsgExt,@Info)

			END

		/*********************************************************
		 * Controlla Numerazione fatture anno corrente
		 *********************************************************/

		Declare @NumCliFat as int
		Declare @IdCliFat as Nvarchar(20)
		Declare @IdCliFatElab as Nvarchar(20)
		Declare @DataCliFat as Date
		Declare @DataCliFatElab as Date

		SET @Prefisso = ''
		SET @NumCliFat = 0


		DECLARE db_cursor CURSOR FOR 
 
		SELECT IdCliFat as IdCliFat,DataCliFat 
		FROM TbCliFat
		WHERE   (YEAR(DataCliFat) = YEAR(GETDATE()))
		ORDER BY IdCliFat

		OPEN db_cursor   
		FETCH NEXT FROM db_cursor INTO @IdCliFat, @DataCliFat

		WHILE @@FETCH_STATUS = 0   
		BEGIN   
		
				If @Prefisso <>left (@IdCliFat,4)
					BEGIN
						Set @Prefisso = left (@IdCliFat,4)
						SET @NumCliFat = 0
						SET @DataCliFatElab = @DataCliFat
						SET @GruppoDocElab = @GruppoDoc
						If IsNumeric (Substring(@IdCliFat,5,20)) = 1 Set @NumCliFat = Convert(Int, Substring(@IdCliFat,5,20))-1
					END
		
				Set @NumCliFat = @NumCliFat + 1
				set @IdCliFatElab = @Prefisso + right('00000'+convert(nvarchar(20),@NumCliFat),5)

				If @DataCliFatElab >  @DataCliFat
					BEGIN
						set @Info =dbo.FncStr ( @Info,'Errore data ' + @TipoDoc + ' ' + @IdCliFat + ' ' + convert (nvarchar(20),@DataCliFat,104) +  ' attesa ' + convert (nvarchar(20),@DataCliFatElab,104))
					END
				If @IdCliFatElab <> @IdCliFat
					BEGIN
						set @Info =dbo.FncStr ( @Info, 'Errore numerazione ' + @TipoDoc + ' ' + @IdCliFat + ' atteso ' + @IdCliFatElab)
						If IsNumeric (right(@IdCliFat,5)) = 1 Set @NumCliFat = right(@IdCliFat,5)
					END

				Set @DataCliFatElab = @DataCliFat
		
			   FETCH NEXT FROM db_cursor INTO @IdCliFat, @DataCliFat   
		END   

		CLOSE db_cursor   
		DEALLOCATE db_cursor

		If @Info is not null
			BEGIN

				Set @Msg= left(@Info,300)
				Execute StpUteMsg_Ins 'Verifica CliFat' , @Msg, '', 'WRN',@SysUser
				Set @NumInfo= @NumInfo+1
				Set @MsgExt = dbo.FncStr (@MsgExt,@Info)

			END

		/*****************************************************
		 * Uscita
		 *****************************************************/
	
		if @NumInfo =0 
			BEGIN
				Execute StpUteMsg_Ins 'System Info' , 'OK', '', 'INF',@SysUser
				SET @TipoMsg='INF'
				SET @Msg1= 'Operazione completata'
			END
		ELSE
			BEGIN
				SET @TipoMsg='WRN'
				SET @Msg1= 'Operazione completata con errori'
			END
		
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, @PrInfo ,@TipoMsg,@SysUser,
				@KYStato,@KYRes,@MsgExt,Null,@KYMsg out
		SET @KYStato = -2
		
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
	
END

GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_Info';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '12/28/2012 16:15:13', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_Info';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Messaggi sullo stato dei dati', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_Info';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_Info';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Dav', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'PROCEDURE', @level1name = N'StpUteMsg_Info';


GO

