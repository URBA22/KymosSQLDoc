
-- ==========================================================================================
-- Entity Name:   StpMntDataLog 
-- Author:        dav
-- Create date:   21.10.15
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	  Write custom note here
-- Description:	  Esegue il log degli oggetti  o il controllo
-- History:
-- dav 22.07.19 Modifica parametri StpAdmElab_001_Costi
-- dav 19.08.19 Aggiunto controllo su ValoreMage
-- dav 24.08.19 Aggiunta mail
-- dav 190903	Aggiunto controllo come parametro
-- dav 190908 Inversione flag di elaborazione nei costi (StpAdmElab_001_Costi)
-- dav 200218 Aggiunto parametro tipo elbaoraizone su StpAdmElab_001_Costi
-- dav 200818 Aggiunti print per powershell
-- dav 200821 IsNull per non avere warnings, @OutMsg 
-- dav 200921 Gestione @ValoreMageVrt
-- dav 201112 Filtro per variazione mage di 10 € per non avere interferenze con i decimali dell'arrotondamento qta mage per il calcolo del costo
-- DAV 210915 Gestione tesoreria
-- lisa 211104 Correzione @NumTesoreriaMov_1
-- dav 220205 Aggiunto 000 e tolleranza
-- dav 220520 Gestione @FlgElabMedioMese in StpAdmElab_001_Costi
-- dav 220829 Gestione @CliFatDetPrezzoTotSgn
-- dav 221011 Controllo tesoreria solo se elaborata per otimizzazione
-- DAV 221117 Correzione messaggio IMPORTO TESORERIA NON CONTROLLATO
-- sim 221123 Aggiunto parametro a FncMage e FncMageVrt
-- dav 221217 Spostato tesoreria, gestito mrp
-- dav 221220 Formattazione e gestione output anche se esito positivo
-- dav 221227 Correzione chiamata StpUteMsg
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpMntDataLog] (
	@SysUser NVARCHAR(256),
	@FlgElabMage BIT,
	@KYStato INT = NULL OUTPUT,
	@KYMsg NVARCHAR(max) = NULL OUTPUT,
	@KYRes INT = NULL,
	@OutMsg NVARCHAR(max) = NULL OUTPUT -- Parametro per powershell
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

	DECLARE @Msg NVARCHAR(300)
	DECLARE @Msg1 NVARCHAR(300)
	DECLARE @MsgObj NVARCHAR(300)
	DECLARE @MsgExt NVARCHAR(300)
	DECLARE @CliFatImponibileVlt AS MONEY
	DECLARE @CliFatImponibileDetVlt AS MONEY
	DECLARE @CliFatImportoVlt AS MONEY
	DECLARE @CliFatImpostaVlt AS MONEY
	DECLARE @CliFatDetPrezzoTotSgn AS MONEY
	DECLARE @CliDdtImponibileVlt AS MONEY
	DECLARE @CliDdtImponibileDetVlt AS MONEY
	DECLARE @CliDdtImportoVlt AS MONEY
	DECLARE @CliDdtImpostaVlt AS MONEY
	DECLARE @CliOrdImponibileVlt AS MONEY
	DECLARE @CliOrdImponibileDetVlt AS MONEY
	DECLARE @CliOrdImportoVlt AS MONEY
	DECLARE @CliOrdImpostaVlt AS MONEY
	DECLARE @CliOffImponibileVlt AS MONEY
	DECLARE @CliOffImponibileDetVlt AS MONEY
	DECLARE @CliOffImportoVlt AS MONEY
	DECLARE @CliOffImpostaVlt AS MONEY
	DECLARE @ForFatImponibileVlt AS MONEY
	DECLARE @ForFatImponibileDetVlt AS MONEY
	DECLARE @ForFatImportoVlt AS MONEY
	DECLARE @ForFatImpostaVlt AS MONEY
	DECLARE @ForOrdImponibileVlt AS MONEY
	DECLARE @ForOrdImponibileDetVlt AS MONEY
	DECLARE @ForOrdImportoVlt AS MONEY
	DECLARE @ForOrdImpostaVlt AS MONEY
	DECLARE @CliFatImponibileVlt_1 AS MONEY
	DECLARE @CliFatImponibileDetVlt_1 AS MONEY
	DECLARE @CliFatImportoVlt_1 AS MONEY
	DECLARE @CliFatImpostaVlt_1 AS MONEY
	DECLARE @CliFatDetPrezzoTotSgn_1 AS MONEY
	DECLARE @CliDdtImponibileVlt_1 AS MONEY
	DECLARE @CliDdtImponibileDetVlt_1 AS MONEY
	DECLARE @CliDdtImportoVlt_1 AS MONEY
	DECLARE @CliDdtImpostaVlt_1 AS MONEY
	DECLARE @CliOrdImponibileVlt_1 AS MONEY
	DECLARE @CliOrdImponibileDetVlt_1 AS MONEY
	DECLARE @CliOrdImportoVlt_1 AS MONEY
	DECLARE @CliOrdImpostaVlt_1 AS MONEY
	DECLARE @CliOffImponibileVlt_1 AS MONEY
	DECLARE @CliOffImponibileDetVlt_1 AS MONEY
	DECLARE @CliOffImportoVlt_1 AS MONEY
	DECLARE @CliOffImpostaVlt_1 AS MONEY
	DECLARE @ForFatImponibileVlt_1 AS MONEY
	DECLARE @ForFatImponibileDetVlt_1 AS MONEY
	DECLARE @ForFatImportoVlt_1 AS MONEY
	DECLARE @ForFatImpostaVlt_1 AS MONEY
	DECLARE @ForOrdImponibileVlt_1 AS MONEY
	DECLARE @ForOrdImponibileDetVlt_1 AS MONEY
	DECLARE @ForOrdImportoVlt_1 AS MONEY
	DECLARE @ForOrdImpostaVlt_1 AS MONEY
	DECLARE @ValoreMage AS MONEY
	DECLARE @ValoreMageVrt AS MONEY
	DECLARE @CostoStd AS MONEY
	DECLARE @CostoMedioListini AS MONEY
	DECLARE @CostoMedioPond AS MONEY
	DECLARE @CostoUltimo AS MONEY
	DECLARE @CostoCiclo AS MONEY
	DECLARE @NoCostoStd AS INT
	DECLARE @NoCostoMedioListini AS INT
	DECLARE @NoCostoMedioPond AS INT
	DECLARE @NoCostoUltimo AS INT
	DECLARE @NoCostoCiclo AS INT
	DECLARE @QtaMageMov AS REAL
	DECLARE @QtaMageMov_000 AS REAL
	DECLARE @CostoStdMageMov AS MONEY
	DECLARE @QtaVrt AS REAL
	DECLARE @QtaVrtMageMov AS REAL
	DECLARE @ValoreMage_1 AS MONEY
	DECLARE @ValoreMageVrt_1 AS MONEY
	DECLARE @CostoStd_1 AS MONEY
	DECLARE @CostoMedioListini_1 AS MONEY
	DECLARE @CostoMedioPond_1 AS MONEY
	DECLARE @CostoUltimo_1 AS MONEY
	DECLARE @CostoCiclo_1 AS MONEY
	DECLARE @NoCostoStd_1 AS INT
	DECLARE @NoCostoMedioListini_1 AS INT
	DECLARE @NoCostoMedioPond_1 AS INT
	DECLARE @NoCostoUltimo_1 AS INT
	DECLARE @NoCostoCiclo_1 AS INT
	DECLARE @QtaMageMov_1 AS REAL
	DECLARE @QtaMageMov_000_1 AS REAL
	DECLARE @CostoStdMageMov_1 AS MONEY
	DECLARE @QtaVrt_1 AS REAL
	DECLARE @QtaVrtMageMov_1 AS REAL
	DECLARE @NumTesoreriaMov AS INT
	DECLARE @ImportoTesoreria AS MONEY
	DECLARE @NumTesoreriaMov_1 AS INT
	DECLARE @ImportoTesoreria_1 AS MONEY
	DECLARE @NumMrpMov AS INT
	DECLARE @QtaMrp AS DECIMAL(18, 8)
	DECLARE @NumMrpMov_1 AS INT
	DECLARE @QtaMrp_1 AS DECIMAL(18, 8)

	SET @Msg = 'DataLog'
	SET @MsgObj = 'StpMntDataLog'

	DECLARE @Version AS NVARCHAR(20)
	DECLARE @PrInfo NVARCHAR(300)

	SET @PrInfo = ''

	-- Gestione parametri
	DECLARE @C_EabMage AS NVARCHAR(max)
	DECLARE @ParamCtrl NVARCHAR(max)

	SET @ParamCtrl = '<ParamCtrl>' + REPLACE(REPLACE(@KYMsg, '-|', '<'), '|-', '>') + '</ParamCtrl>'

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 0
	BEGIN
		SET @KYStato = 1
		SET @C_EabMage = dbo.FncKyMsgCheckBox('EabMage', @KYStato, 'Verifica mage:', 0)
		SET @ParamCtrl = dbo.FncKyMsgAddControl(@ParamCtrl, @KYStato - 1, @C_EabMage)
		SET @Msg1 = 'Controllo dati DB per aggiornamento'

		EXECUTE [dbo].[StpUteMsg] @Msg = @Msg,
			@Msg1 = @Msg1,
			@MsgObj = @MsgObj,
			@Param = @PrInfo,
			@CodFnzTipoMsg = 'QST',
			@SysUser = @SysUser,
			@KYStato = @KYStato,
			@KYRes = @KYRes,
			@KyParam = '(1):Verifica;2:Storicizza;0:Cancel',
			@KyMsg = @KYMsg OUTPUT

		SET @KYMsg = @KYMsg + '<ParamCtrl>' + @ParamCtrl + '</ParamCtrl>'

		RETURN
	END

	/****************************************************************
	* Stato 1 - storicizza
	****************************************************************/
	IF (
			@KYStato = 1
			AND @KYRes = 2
			)
	BEGIN
		SET @Version = CONVERT(NVARCHAR(50), GETDATE(), 120)
		-- Elabora Flag per ricalcolo valori di magazzino
		-- La sezione  può essere disabilitata per ottimizzare le prestazioni se magazzino non gestito
		SET @FlgElabMage = IsNull(@FlgElabMage, dbo.FncKyMsgCtrlValue(@ParamCtrl, 'EabMage', 1))

		IF @FlgElabMage = 1
		BEGIN
			-- Elabora contatori
			EXECUTE dbo.StpAdmElab_000_Gen @SysUser

			-- Ricalcola costi e aggiorna il costo standard  negli articoli
			EXECUTE dbo.StpAdmElab_001_Costi @SysUser = @SysUser

			SELECT @CostoStd = x.CostoStd,
				@CostoMedioListini = x.CostoMedioListini,
				@CostoMedioPond = x.CostoMedioPond,
				@CostoUltimo = x.CostoUltimo,
				@CostoCiclo = x.CostoCiclo,
				@NoCostoStd = x.NoCostoStd,
				@NoCostoMedioListini = x.NoCostoMedioListini,
				@NoCostoMedioPond = x.NoCostoMedioPond,
				@NoCostoUltimo = x.NoCostoUltimo,
				@NoCostoCiclo = x.NoCostoCiclo,
				@QtaMageMov = y.QtaMageMov,
				@CostoStdMageMov = y.CostoStdMageMov,
				@QtaVrt = z.QtaVrt,
				@QtaVrtMageMov = z.QtaVrtMageMov,
				@QtaMageMov_000 = k.QtaMageMov_000
			FROM (
				SELECT COUNT(IdArticolo) AS NumArt,
					SUM(CostoStd) AS CostoStd,
					SUM(CostoStdCommerciale) AS CostoStdCommerciale,
					SUM(NoCostoStd) AS NoCostoStd,
					SUM(NoCostoStdCommerciale) AS NoCostoStdCommerciale,
					SUM(CostoMedioListini) AS CostoMedioListini,
					SUM(CostoMedioPond) AS CostoMedioPond,
					SUM(CostoUltimo) AS CostoUltimo,
					SUM(NoCostoMedioListini) AS NoCostoMedioListini,
					SUM(NoCostoMedioPond) AS NoCostoMedioPond,
					SUM(NoCostoUltimo) AS NoCostoUltimo,
					SUM(NoCostoCiclo) AS NoCostoCiclo,
					SUM(CostoCiclo) AS CostoCiclo,
					SUM(ISNULL(QtaMage, 0)) AS QtaMage,
					SUM(ISNULL(QtaMageCV, 0)) AS QtaMageCV,
					SUM(ISNULL(QtaMageCLavFor, 0)) AS QtaMageCLavFor,
					SUM(ISNULL(QtaMageCLavCli, 0)) AS QtaMageCLavCli,
					SUM(ISNULL(QtaMageFiscale, 0)) AS QtaMageFiscale
				FROM TbArtElab
				) AS x
			CROSS JOIN (
				SELECT SUM(ISNULL(QtaMageMov, 0)) AS QtaMageMov,
					SUM(ISNULL(CostoStd, 0)) AS CostoStdMageMov
				FROM VstMageMov
				) AS y
			CROSS JOIN (
				SELECT SUM(ISNULL(QtaMageMov, 0)) AS QtaMageMov_000
				FROM VstMageMov_000
				) AS k
			CROSS JOIN (
				SELECT SUM(ISNULL(QtaMov, 0)) AS QtaVrt,
					SUM(ISNULL(QtaMageMov, 0)) AS QtaVrtMageMov
				FROM VstMageVrtMov
				) AS z

			SELECT @ValoreMage = sum(costo)
			FROM dbo.FncMage(getdate(), 0, 1, 0, NULL)

			SELECT @ValoreMageVrt = sum(costo)
			FROM dbo.FncMageVrt(getdate(), 0, 0, 1, 0, NULL)

			SELECT @NumMrpMov = count(1),
				@QtaMrp = SUM(Qta)
			FROM VstArtMrpDocAperti

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'MrpMov',
				@NumMrpMov,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'QtaMrp',
				@QtaMrp,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'ValoreMage',
				@ValoreMage,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'ValoreMageVrt',
				@ValoreMageVrt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CostoStd',
				@CostoStd,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CostoMedioListini',
				@CostoMedioListini,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CostoMedioPond',
				@CostoMedioPond,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CostoUltimo',
				@CostoUltimo,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CostoCiclo',
				@CostoCiclo,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'NoCostoStd',
				@NoCostoStd,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'NoCostoMedioListini',
				@NoCostoMedioListini,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'NoCostoMedioPond',
				@NoCostoMedioPond,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'NoCostoUltimo',
				@NoCostoUltimo,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'NoCostoCiclo',
				@NoCostoCiclo,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'QtaMageMov',
				@QtaMageMov,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CostoStdMageMov',
				@CostoStdMageMov,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'QtaVrt',
				@QtaVrt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'QtaVrtMageMov',
				@QtaVrtMageMov,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'QtaMageMov_000',
				@QtaMageMov_000,
				GETDATE(),
				@SysUser
				)
		END

		-- Rielabora Tesoreria
		IF EXISTS (
				SELECT 1
				FROM TbCntTesoreriaMovScad
				)
		BEGIN
			SELECT @NumTesoreriaMov = count(1),
				@ImportoTesoreria = SUM(IMPORTO)
			FROM VstCntTesoreriaMov

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'TesoreriaMov',
				@NumTesoreriaMov,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'TesoreriaImporto',
				@ImportoTesoreria,
				GETDATE(),
				@SysUser
				)
		END

		-- Rielabora documentale sempre
		BEGIN
			SELECT @CliFatImponibileVlt = SUM(ISNULL(ImponibileVlt, 0)),
				@CliFatImponibileDetVlt = SUM(ISNULL(ImponibileDetVlt, 0)),
				@CliFatImportoVlt = SUM(ISNULL(ImportoVlt, 0)),
				@CliFatImpostaVlt = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstCliFatImpt

			SELECT @CliFatDetPrezzoTotSgn = SUM(ISNULL(PrezzoTotSgn, 0))
			FROM VstCliFatDet

			SELECT @CliDdtImponibileVlt = SUM(ISNULL(ImponibileVlt, 0)),
				@CliDdtImponibileDetVlt = SUM(ISNULL(ImponibileDetVlt, 0)),
				@CliDdtImportoVlt = SUM(ISNULL(ImportoVlt, 0)),
				@CliDdtImpostaVlt = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstCliDdtImpt

			SELECT @CliOrdImponibileVlt = SUM(ISNULL(ImponibileVlt, 0)),
				@CliOrdImponibileDetVlt = SUM(ISNULL(ImponibileDetVlt, 0)),
				@CliOrdImportoVlt = SUM(ISNULL(ImportoVlt, 0)),
				@CliOrdImpostaVlt = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstCliOrdImpt

			SELECT @CliOffImponibileVlt = SUM(ISNULL(ImponibileVlt, 0)),
				@CliOffImponibileDetVlt = SUM(ISNULL(ImponibileDetVlt, 0)),
				@CliOffImportoVlt = SUM(ISNULL(ImportoVlt, 0)),
				@CliOffImpostaVlt = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstCliOffImpt

			SELECT @ForFatImponibileVlt = SUM(ISNULL(ImponibileVlt, 0)),
				@ForFatImponibileDetVlt = SUM(ISNULL(ImponibileDetVlt, 0)),
				@ForFatImportoVlt = SUM(ISNULL(ImportoVlt, 0)),
				@ForFatImpostaVlt = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstForFatImpt

			SELECT @ForOrdImponibileVlt = SUM(ISNULL(ImponibileVlt, 0)),
				@ForOrdImponibileDetVlt = SUM(ISNULL(ImponibileDetVlt, 0)),
				@ForOrdImportoVlt = SUM(ISNULL(ImportoVlt, 0)),
				@ForOrdImpostaVlt = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstForOrdImpt

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliFatImponibileVlt',
				@CliFatImponibileVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliFatImponibileDetVlt',
				@CliFatImponibileDetVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliFatImportoVlt',
				@CliFatImportoVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliFatImpostaVlt',
				@CliFatImpostaVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliFatDetPrezzoTotSgn',
				@CliFatDetPrezzoTotSgn,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliDdtImponibileVlt',
				@CliDdtImponibileVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliDdtImponibileDetVlt',
				@CliDdtImponibileDetVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliDdtImportoVlt',
				@CliDdtImportoVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliDdtImpostaVlt',
				@CliDdtImpostaVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliOrdImponibileVlt',
				@CliOrdImponibileVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliOrdImponibileDetVlt',
				@CliOrdImponibileDetVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliOrdImportoVlt',
				@CliOrdImportoVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliOrdImpostaVlt',
				@CliOrdImpostaVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliOffImponibileVlt',
				@CliOffImponibileVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliOffImponibileDetVlt',
				@CliOffImponibileDetVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliOffImportoVlt',
				@CliOffImportoVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'CliOffImpostaVlt',
				@CliOffImpostaVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'ForFatImponibileVlt',
				@ForFatImponibileVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'ForFatImponibileDetVlt',
				@ForFatImponibileDetVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'ForFatImportoVlt',
				@ForFatImportoVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'ForFatImpostaVlt',
				@ForFatImpostaVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'ForOrdImponibileVlt',
				@ForOrdImponibileVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'ForOrdImponibileDetVlt',
				@ForOrdImponibileDetVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'ForOrdImportoVlt',
				@ForOrdImportoVlt,
				GETDATE(),
				@SysUser
				)

			INSERT INTO TbMntDataLog (
				Version,
				IdKey,
				Value,
				SysDateCreate,
				SysUserCreate
				)
			VALUES (
				@Version,
				N'ForOrdImpostaVlt',
				@ForOrdImpostaVlt,
				GETDATE(),
				@SysUser
				)
		END

		-- tiene solo le ultime 4 versioni
		DELETE
		FROM TbMntObjLog
		FROM (
			SELECT TOP (4) Version
			FROM TbMntObjLog AS TbMntObjLog_1
			GROUP BY Version
			ORDER BY Version DESC
			) AS drvVrs
		RIGHT OUTER JOIN TbMntObjLog
			ON drvVrs.Version = TbMntObjLog.Version
		WHERE (drvVrs.Version IS NULL)

		/****************************************************************
			* Uscita
			****************************************************************/
		SET @Msg1 = 'Operazione completata versione ' + @Version

		EXECUTE [dbo].[StpUteMsg] @Msg = @Msg,
			@Msg1 = @Msg1,
			@MsgObj = @MsgObj,
			@Param = @PrInfo,
			@CodFnzTipoMsg = 'INF',
			@SysUser = @SysUser,
			@KYStato = @KYStato,
			@KYRes = 0,
			@KyParam = NULL,
			@KyMsg = @KYMsg OUTPUT

		SET @KYStato = - 1

		RETURN
	END

	/****************************************************************
	* Stato 1 - risposta verifica
	****************************************************************/
	IF (
			@KYStato = 1
			AND @KYRes = 1
			)
	BEGIN
		SET @Version = (
				SELECT max(Version)
				FROM TbMntDataLog
				)

		DECLARE @InfoExt AS NVARCHAR(max)
		DECLARE @InfoExt1 AS NVARCHAR(max)

		SET @InfoExt = ''
		SET @InfoExt1 = ''

		/* 
			 * Controllo 
			 *
			
			SELECT        TbMntObjLog.IdLog, TbMntObjLog.Version, TbMntObjLog.IdObj, 
			CASE WHEN drvObj.IdObj IS NOT NULL THEN 'X' ELSE '' END AS Stato, Definition,
			TbMntObjLog.SysDateCreate, TbMntObjLog.SysDateUpdate, 
			drvObj.create_date, drvObj.modify_date

			FROM            TbMntObjLog FULL OUTER JOIN
			(SELECT [name] as IdObj ,create_date,modify_date FROM sys.objects
			) AS drvObj ON TbMntObjLog.IdObj = drvObj.IdObj

			WHERE        (LEFT(TbMntObjLog.IdObj, 3) = 'tbx') OR
			(LEFT(TbMntObjLog.IdObj, 4) = 'vstx') OR
			(LEFT(TbMntObjLog.IdObj, 4) = 'stpx')
			and
			TbMntObjLog.Version= @Version
			
			*/
		DECLARE @Congruenti AS INT
		DECLARE @CongruentiMage AS INT
		DECLARE @CongruentiTesoreria AS INT
		DECLARE @NonCongruenti AS INT
		DECLARE @NonCongruentiTesoreria AS INT
		DECLARE @NonCongruentiMage AS INT
		DECLARE @Oggetti AS INT

		SET @NonCongruenti = 0
		SET @NonCongruentiMage = 0
		SET @NonCongruentiTesoreria = 0
		-- Elabora Flag per ricalcolo valori di magazzino
		-- La sezione  può essere disabilitata per ottimizzare le prestazioni se magazzino non gestito
		SET @FlgElabMage = IsNUll(@FlgElabMage, dbo.FncKyMsgCtrlValue(@ParamCtrl, 'EabMage', 1))

		IF @FlgElabMage = 1
		BEGIN
			-- Elabora contatori
			EXECUTE dbo.StpAdmElab_000_Gen @SysUser

			-- Ricalcola costi e aggiorna il costo standard  negli articoli
			EXECUTE dbo.StpAdmElab_001_Costi @SysUser = @SysUser

			SELECT @CostoStd_1 = x.CostoStd,
				@CostoMedioListini_1 = x.CostoMedioListini,
				@CostoMedioPond_1 = x.CostoMedioPond,
				@CostoUltimo_1 = x.CostoUltimo,
				@CostoCiclo_1 = x.CostoCiclo,
				@NoCostoStd_1 = x.NoCostoStd,
				@NoCostoMedioListini_1 = x.NoCostoMedioListini,
				@NoCostoMedioPond_1 = x.NoCostoMedioPond,
				@NoCostoUltimo_1 = x.NoCostoUltimo,
				@NoCostoCiclo_1 = x.NoCostoCiclo,
				@QtaMageMov_1 = y.QtaMageMov,
				@CostoStdMageMov_1 = CostoStdMageMov,
				@QtaVrt_1 = z.QtaVrt,
				@QtaVrtMageMov_1 = z.QtaVrtMageMov,
				@QtaMageMov_000_1 = k.QtaMageMov_000
			FROM (
				SELECT COUNT(IdArticolo) AS NumArt,
					SUM(CostoStd) AS CostoStd,
					SUM(CostoStdCommerciale) AS CostoStdCommerciale,
					SUM(NoCostoStd) AS NoCostoStd,
					SUM(NoCostoStdCommerciale) AS NoCostoStdCommerciale,
					SUM(CostoMedioListini) AS CostoMedioListini,
					SUM(CostoMedioPond) AS CostoMedioPond,
					SUM(CostoUltimo) AS CostoUltimo,
					SUM(NoCostoMedioListini) AS NoCostoMedioListini,
					SUM(NoCostoMedioPond) AS NoCostoMedioPond,
					SUM(NoCostoUltimo) AS NoCostoUltimo,
					SUM(NoCostoCiclo) AS NoCostoCiclo,
					SUM(CostoCiclo) AS CostoCiclo,
					SUM(ISNULL(QtaMage, 0)) AS QtaMage,
					SUM(ISNULL(QtaMageCV, 0)) AS QtaMageCV,
					SUM(ISNULL(QtaMageCLavFor, 0)) AS QtaMageCLavFor,
					SUM(ISNULL(QtaMageCLavCli, 0)) AS QtaMageCLavCli,
					SUM(ISNULL(QtaMageFiscale, 0)) AS QtaMageFiscale
				FROM TbArtElab
				) AS x
			CROSS JOIN (
				SELECT SUM(ISNULL(QtaMageMov, 0)) AS QtaMageMov,
					SUM(ISNULL(CostoStd, 0)) AS CostoStdMageMov
				FROM VstMageMov
				) AS y
			CROSS JOIN (
				SELECT SUM(ISNULL(QtaMageMov, 0)) AS QtaMageMov_000
				FROM VstMageMov_000
				) AS k
			CROSS JOIN (
				SELECT SUM(ISNULL(QtaMov, 0)) AS QtaVrt,
					SUM(ISNULL(QtaMageMov, 0)) AS QtaVrtMageMov
				FROM VstMageVrtMov
				) AS z

			SELECT @ValoreMage_1 = sum(IsNull(Costo, 0))
			FROM dbo.FncMage(getdate(), 0, 1, 0, NULL)

			SELECT @ValoreMageVrt_1 = sum(IsNull(Costo, 0))
			FROM dbo.FncMageVrt(getdate(), 0, 0, 1, 0, NULL)

			SELECT @NumMrpMov_1 = count(1),
				@QtaMrp_1 = SUM(Qta)
			FROM VstArtMrpDocAperti

			SELECT @NumMrpMov = Value
			FROM TbMntDataLog
			WHERE IdKey = 'MrpMov'
				AND Version = @Version

			SELECT @QtaMrp = Value
			FROM TbMntDataLog
			WHERE IdKey = 'QtaMrp'
				AND Version = @Version

			SELECT @ValoreMage = Value
			FROM TbMntDataLog
			WHERE IdKey = 'ValoreMage'
				AND Version = @Version

			SELECT @ValoreMageVrt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'ValoreMageVrt'
				AND Version = @Version

			SELECT @CostoStd = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CostoStd'
				AND Version = @Version

			SELECT @CostoMedioListini = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CostoMedioListini'
				AND Version = @Version

			SELECT @CostoMedioPond = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CostoMedioPond'
				AND Version = @Version

			SELECT @CostoUltimo = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CostoUltimo'
				AND Version = @Version

			SELECT @CostoCiclo = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CostoCiclo'
				AND Version = @Version

			SELECT @NoCostoStd = Value
			FROM TbMntDataLog
			WHERE IdKey = 'NoCostoStd'
				AND Version = @Version

			SELECT @NoCostoMedioListini = Value
			FROM TbMntDataLog
			WHERE IdKey = 'NoCostoMedioListini'
				AND Version = @Version

			SELECT @NoCostoMedioPond = Value
			FROM TbMntDataLog
			WHERE IdKey = 'NoCostoMedioPond'
				AND Version = @Version

			SELECT @NoCostoUltimo = Value
			FROM TbMntDataLog
			WHERE IdKey = 'NoCostoUltimo'
				AND Version = @Version

			SELECT @NoCostoCiclo = Value
			FROM TbMntDataLog
			WHERE IdKey = 'NoCostoCiclo'
				AND Version = @Version

			SELECT @QtaMageMov = Value
			FROM TbMntDataLog
			WHERE IdKey = 'QtaMageMov'
				AND Version = @Version

			SELECT @QtaMageMov_000 = Value
			FROM TbMntDataLog
			WHERE IdKey = 'QtaMageMov_000'
				AND Version = @Version

			SELECT @CostoStdMageMov = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CostoStdMageMov'
				AND Version = @Version

			SELECT @QtaVrt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'QtaVrt'
				AND Version = @Version

			SELECT @QtaVrtMageMov = Value
			FROM TbMntDataLog
			WHERE IdKey = 'QtaVrtMageMov'
				AND Version = @Version

			IF ABS(Round(@QtaMrp, 2) - Round(@QtaMrp_1, 2)) > 10
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'QtaMrp: ' + convert(NVARCHAR(20), Round(@QtaMrp, 2) - Round(@QtaMrp_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'QtaMrp: OK')
			END

			IF ABS(Round(@NumMrpMov, 2) - Round(@NumMrpMov_1, 2)) > 10
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'MovimentiMRP: ' + convert(NVARCHAR(20), Round(@NumMrpMov, 2) - Round(@NumMrpMov_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'MovimentiMRP: OK')
			END

			IF ABS(Round(@ValoreMage, 2) - Round(@ValoreMage_1, 2)) > 10
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'ValoreMage: ' + convert(NVARCHAR(20), Round(@ValoreMage, 2) - Round(@ValoreMage_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'ValoreMage: OK')
			END

			IF ABS(Round(@ValoreMageVrt, 2) - Round(@ValoreMageVrt_1, 2)) > 10
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'ValoreMageVrt: ' + convert(NVARCHAR(20), Round(@ValoreMageVrt, 2) - Round(@ValoreMageVrt_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'ValoreMageVrt: OK')
			END

			IF ABS(Round(@CostoStd, 2) - Round(@CostoStd_1, 2)) > 10
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'CostoStd: ' + convert(NVARCHAR(20), Round(@CostoStd, 2) - Round(@CostoStd_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'CostoStd: OK')
			END

			IF ABS(Round(@CostoMedioListini, 2) - Round(@CostoMedioListini_1, 2)) > 10
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'CostoMedioListini: ' + convert(NVARCHAR(20), Round(@CostoMedioListini, 2) - Round(@CostoMedioListini_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'CostoMedioListini: OK')
			END

			IF ABS(Round(@CostoMedioPond, 2) - Round(@CostoMedioPond_1, 2)) > 10
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'CostoMedioPond: ' + convert(NVARCHAR(20), Round(@CostoMedioPond, 2) - Round(@CostoMedioPond_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'CostoMedioPond: OK')
			END

			IF ABS(Round(@CostoUltimo, 2) - Round(@CostoUltimo_1, 2)) > 10
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'CostoUltimo: ' + convert(NVARCHAR(20), Round(@CostoUltimo, 2) - Round(@CostoUltimo_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'CostoUltimo: OK')
			END

			IF ABS(Round(@CostoCiclo, 2) - Round(@CostoCiclo_1, 2)) > 10
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'CostoCiclo: ' + convert(NVARCHAR(20), Round(@CostoCiclo, 2) - Round(@CostoCiclo_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'CostoCiclo: OK')
			END

			IF ABS(Round(@NoCostoStd, 2) - Round(@NoCostoStd_1, 2)) > 10
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'NoCostoStd: ' + convert(NVARCHAR(20), Round(@NoCostoStd, 2) - Round(@NoCostoStd_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'NoCostoStd: OK')
			END

			IF Round(@NoCostoMedioListini, 2) <> Round(@NoCostoMedioListini_1, 2)
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'NoCostoMedioListini: ' + convert(NVARCHAR(20), Round(@NoCostoMedioListini, 2) - Round(@NoCostoMedioListini_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'NoCostoMedioListini: OK')
			END

			IF Round(@NoCostoMedioPond, 2) <> Round(@NoCostoMedioPond_1, 2)
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'NoCostoMedioPond: ' + convert(NVARCHAR(20), Round(@NoCostoMedioPond, 2) - Round(@NoCostoMedioPond_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'NoCostoMedioPond: OK')
			END

			IF Round(@NoCostoUltimo, 2) <> Round(@NoCostoUltimo_1, 2)
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'NoCostoUltimo: ' + convert(NVARCHAR(20), Round(@NoCostoUltimo, 2) - Round(@NoCostoUltimo_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'NoCostoUltimo: OK')
			END

			IF Round(@NoCostoCiclo, 2) <> Round(@NoCostoCiclo_1, 2)
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'NoCostoCiclo: ' + convert(NVARCHAR(20), Round(@NoCostoCiclo, 2) - Round(@NoCostoCiclo_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'NoCostoCiclo: OK')
			END

			IF ABS(Round(@QtaMageMov, 2) - Round(@QtaMageMov_1, 2)) > 1
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'QtaMageMov: ' + convert(NVARCHAR(20), Round(@QtaMageMov, 2) - Round(@QtaMageMov_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'QtaMageMov: OK')
			END

			IF ABS(Round(@QtaMageMov_000, 2) - Round(@QtaMageMov_000_1, 2)) > 1
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'QtaMageMov_000: ' + convert(NVARCHAR(20), Round(@QtaMageMov_000, 2) - Round(@QtaMageMov_000_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'QtaMageMov_000: OK')
			END

			IF ABS(Round(@CostoStdMageMov, 2) - Round(@CostoStdMageMov_1, 2)) > 1
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'CostoStdMageMov: ' + convert(NVARCHAR(20), Round(@CostoStdMageMov, 2) - Round(@CostoStdMageMov_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'CostoStdMageMov: OK')
			END

			IF ABS(Round(@QtaVrt, 2) - Round(@QtaVrt_1, 2)) > 1
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'QtaVrt: ' + convert(NVARCHAR(20), Round(@QtaVrt, 2) - Round(@QtaVrt_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'QtaVrt: OK')
			END

			IF ABS(Round(@QtaVrtMageMov, 2) - Round(@QtaVrtMageMov_1, 2)) > 1
			BEGIN
				SET @NonCongruentiMage = @NonCongruentiMage + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'QtaVrtMageMov: ' + convert(NVARCHAR(20), Round(@QtaVrtMageMov, 2) - Round(@QtaVrtMageMov_1, 2)))
			END
			ELSE
			BEGIN
				SET @CongruentiMage = @CongruentiMage + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'QtaVrtMageMov: OK')
			END
		END
		ELSE
		BEGIN
			SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'Controllo Mage: ## DISABILITATO ##')
		END

		-- Rielabora tesoreria
		IF EXISTS (
				SELECT 1
				FROM TbCntTesoreriaMovScad
				)
		BEGIN
			SELECT @NumTesoreriaMov_1 = count(1),
				@ImportoTesoreria_1 = SUM(IMPORTO)
			FROM VstCntTesoreriaMov

			SELECT @NumTesoreriaMov = Value
			FROM TbMntDataLog
			WHERE IdKey = 'TesoreriaMov'
				AND Version = @Version

			SELECT @ImportoTesoreria = Value
			FROM TbMntDataLog
			WHERE IdKey = 'TesoreriaImporto'
				AND Version = @Version

			IF ABS(Round(@NumTesoreriaMov, 2) - Round(@NumTesoreriaMov_1, 2)) > 0
			BEGIN
				SET @NonCongruentiTesoreria = @NonCongruentiTesoreria + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'MovTesoreria: ' + convert(NVARCHAR(20), @NumTesoreriaMov - @NumTesoreriaMov_1))
			END
			ELSE
			BEGIN
				SET @CongruentiTesoreria = @CongruentiTesoreria + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'MovTesoreria: OK')
			END

			IF @ImportoTesoreria - @ImportoTesoreria_1 <> 0
			BEGIN
				SET @NonCongruentiTesoreria = @NonCongruentiTesoreria + 1
				SET @InfoExt = dbo.FncStr(@InfoExt, 'ImportoTesoreria: ' + convert(NVARCHAR(20), @ImportoTesoreria - @ImportoTesoreria_1))
			END
			ELSE
			BEGIN
				SET @CongruentiTesoreria = @CongruentiTesoreria + 1
				SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'ImportoTesoreria: OK')
			END
		END
		ELSE
		BEGIN
			SET @InfoExt1 = dbo.FncStr(@InfoExt1, 'Controllo Tesoreria: ## DISABILITATO ##')
		END

		-- Rielabora documenti (sempre)
		BEGIN
			SELECT @CliFatImponibileVlt_1 = SUM(ISNULL(ImponibileVlt, 0)),
				@CliFatImponibileDetVlt_1 = SUM(ISNULL(ImponibileDetVlt, 0)),
				@CliFatImportoVlt_1 = SUM(ISNULL(ImportoVlt, 0)),
				@CliFatImpostaVlt_1 = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstCliFatImpt

			SELECT @CliFatDetPrezzoTotSgn_1 = SUM(ISNULL(PrezzoTotSgn, 0))
			FROM VstCliFatDet

			SELECT @CliDdtImponibileVlt_1 = SUM(ISNULL(ImponibileVlt, 0)),
				@CliDdtImponibileDetVlt_1 = SUM(ISNULL(ImponibileDetVlt, 0)),
				@CliDdtImportoVlt_1 = SUM(ISNULL(ImportoVlt, 0)),
				@CliDdtImpostaVlt_1 = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstCliDdtImpt

			SELECT @CliOrdImponibileVlt_1 = SUM(ISNULL(ImponibileVlt, 0)),
				@CliOrdImponibileDetVlt_1 = SUM(ISNULL(ImponibileDetVlt, 0)),
				@CliOrdImportoVlt_1 = SUM(ISNULL(ImportoVlt, 0)),
				@CliOrdImpostaVlt_1 = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstCliOrdImpt

			SELECT @CliOffImponibileVlt_1 = SUM(ISNULL(ImponibileVlt, 0)),
				@CliOffImponibileDetVlt_1 = SUM(ISNULL(ImponibileDetVlt, 0)),
				@CliOffImportoVlt_1 = SUM(ISNULL(ImportoVlt, 0)),
				@CliOffImpostaVlt_1 = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstCliOffImpt

			SELECT @ForFatImponibileVlt_1 = SUM(ISNULL(ImponibileVlt, 0)),
				@ForFatImponibileDetVlt_1 = SUM(ISNULL(ImponibileDetVlt, 0)),
				@ForFatImportoVlt_1 = SUM(ISNULL(ImportoVlt, 0)),
				@ForFatImpostaVlt_1 = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstForFatImpt

			SELECT @ForOrdImponibileVlt_1 = SUM(ISNULL(ImponibileVlt, 0)),
				@ForOrdImponibileDetVlt_1 = SUM(ISNULL(ImponibileDetVlt, 0)),
				@ForOrdImportoVlt_1 = SUM(ISNULL(ImportoVlt, 0)),
				@ForOrdImpostaVlt_1 = SUM(ISNULL(ImpostaVlt, 0))
			FROM VstForOrdImpt

			SELECT @CliFatImponibileVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliFatImponibileVlt'
				AND Version = @Version

			SELECT @CliFatImponibileDetVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliFatImponibileDetVlt'
				AND Version = @Version

			SELECT @CliFatImportoVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliFatImportoVlt'
				AND Version = @Version

			SELECT @CliFatImpostaVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliFatImpostaVlt'
				AND Version = @Version

			SELECT @CliFatDetPrezzoTotSgn = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliFatDetPrezzoTotSgn'
				AND Version = @Version

			SELECT @CliDdtImponibileVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliDdtImponibileVlt'
				AND Version = @Version

			SELECT @CliDdtImponibileDetVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliDdtImponibileDetVlt'
				AND Version = @Version

			SELECT @CliDdtImportoVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliDdtImportoVlt'
				AND Version = @Version

			SELECT @CliDdtImpostaVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliDdtImpostaVlt'
				AND Version = @Version

			SELECT @CliOrdImponibileVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliOrdImponibileVlt'
				AND Version = @Version

			SELECT @CliOrdImponibileDetVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliOrdImponibileDetVlt'
				AND Version = @Version

			SELECT @CliOrdImportoVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliOrdImportoVlt'
				AND Version = @Version

			SELECT @CliOrdImpostaVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliOrdImpostaVlt'
				AND Version = @Version

			SELECT @CliOffImponibileVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliOffImponibileVlt'
				AND Version = @Version

			SELECT @CliOffImponibileDetVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliOffImponibileDetVlt'
				AND Version = @Version

			SELECT @CliOffImportoVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliOffImportoVlt'
				AND Version = @Version

			SELECT @CliOffImpostaVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'CliOffImpostaVlt'
				AND Version = @Version

			SELECT @ForFatImponibileVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'ForFatImponibileVlt'
				AND Version = @Version

			SELECT @ForFatImponibileDetVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'ForFatImponibileDetVlt'
				AND Version = @Version

			SELECT @ForFatImportoVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'ForFatImportoVlt'
				AND Version = @Version

			SELECT @ForFatImpostaVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'ForFatImpostaVlt'
				AND Version = @Version

			SELECT @ForOrdImponibileVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'ForOrdImponibileVlt'
				AND Version = @Version

			SELECT @ForOrdImponibileDetVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'ForOrdImponibileDetVlt'
				AND Version = @Version

			SELECT @ForOrdImportoVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'ForOrdImportoVlt'
				AND Version = @Version

			SELECT @ForOrdImpostaVlt = Value
			FROM TbMntDataLog
			WHERE IdKey = 'ForOrdImpostaVlt'
				AND Version = @Version
		END

		IF @CliFatImponibileVlt <> @CliFatImponibileVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliFatImponibileVlt: ' + convert(NVARCHAR(20), @CliFatImponibileVlt - @CliFatImponibileVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliFatImponibileVlt: OK')
		END

		IF @CliFatImponibileDetVlt <> @CliFatImponibileDetVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliFatImponibileDetVlt: ' + convert(NVARCHAR(20), @CliFatImponibileDetVlt - @CliFatImponibileDetVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliFatImponibileVlt: OK')
		END

		IF @CliFatImportoVlt <> @CliFatImportoVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliFatImportoVlt: ' + convert(NVARCHAR(20), @CliFatImportoVlt - @CliFatImportoVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliFatImportoVlt: OK')
		END

		IF @CliFatImpostaVlt <> @CliFatImpostaVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliFatImpostaVlt: ' + convert(NVARCHAR(20), @CliFatImpostaVlt - @CliFatImpostaVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliFatImpostaVlt: OK')
		END

		IF @CliFatDetPrezzoTotSgn <> @CliFatDetPrezzoTotSgn_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliFatDetPrezzoTotSgn: ' + convert(NVARCHAR(20), @CliFatDetPrezzoTotSgn - @CliFatDetPrezzoTotSgn_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliFatDetPrezzoTotSgn: OK')
		END

		IF @CliDdtImponibileVlt <> @CliDdtImponibileVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliDdtImponibileVlt: ' + convert(NVARCHAR(20), @CliDdtImponibileVlt - @CliDdtImponibileVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliDdtImponibileVlt: OK')
		END

		IF @CliDdtImponibileDetVlt <> @CliDdtImponibileDetVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliDdtImponibileDetVlt: ' + convert(NVARCHAR(20), @CliDdtImponibileDetVlt - @CliDdtImponibileDetVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliDdtImponibileDetVlt: OK')
		END

		IF @CliDdtImportoVlt <> @CliDdtImportoVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliDdtImportoVlt: ' + convert(NVARCHAR(20), @CliDdtImportoVlt - @CliDdtImportoVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliDdtImportoVlt: OK')
		END

		IF @CliDdtImpostaVlt <> @CliDdtImpostaVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliDdtImpostaVlt: ' + convert(NVARCHAR(20), @CliDdtImpostaVlt - @CliDdtImpostaVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliDdtImpostaVlt: OK')
		END

		IF @CliOrdImponibileVlt <> @CliOrdImponibileVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOrdImponibileVlt: ' + convert(NVARCHAR(20), @CliOrdImponibileVlt - @CliOrdImponibileVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOrdImponibileVlt: OK')
		END

		IF @CliOrdImponibileDetVlt <> @CliOrdImponibileDetVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOrdImponibileDetVlt: ' + convert(NVARCHAR(20), @CliOrdImponibileDetVlt - @CliOrdImponibileDetVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOrdImponibileDetVlt: OK')
		END

		IF @CliOrdImportoVlt <> @CliOrdImportoVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOrdImportoVlt: ' + convert(NVARCHAR(20), @CliOrdImportoVlt - @CliOrdImportoVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOrdImportoVlt: OK')
		END

		IF @CliOrdImpostaVlt <> @CliOrdImpostaVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOrdImpostaVlt: ' + convert(NVARCHAR(20), @CliOrdImpostaVlt - @CliOrdImpostaVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOrdImpostaVlt: OK')
		END

		IF @CliOffImponibileVlt <> @CliOffImponibileVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOffImponibileVlt: ' + convert(NVARCHAR(20), @CliOffImponibileVlt - @CliOffImponibileVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOffImponibileVlt: OK')
		END

		IF @CliOffImponibileDetVlt <> @CliOffImponibileDetVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOffImponibileDetVlt: ' + convert(NVARCHAR(20), @CliOffImponibileDetVlt - @CliOffImponibileDetVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOffImponibileDetVlt: OK')
		END

		IF @CliOffImportoVlt <> @CliOffImportoVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOffImportoVlt: ' + convert(NVARCHAR(20), @CliOffImportoVlt - @CliOffImportoVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOffImportoVlt: OK')
		END

		IF @CliOffImpostaVlt <> @CliOffImpostaVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOffImpostaVlt: ' + convert(NVARCHAR(20), @CliOffImpostaVlt - @CliOffImpostaVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'CliOffImpostaVlt: OK')
		END

		IF @ForFatImponibileVlt <> @ForFatImponibileVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForFatImponibileVlt: ' + convert(NVARCHAR(20), @ForFatImponibileVlt - @ForFatImponibileVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForFatImponibileVlt: OK')
		END

		IF @ForFatImponibileDetVlt <> @ForFatImponibileDetVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForFatImponibileDetVlt: ' + convert(NVARCHAR(20), @ForFatImponibileDetVlt - @ForFatImponibileDetVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForFatImponibileDetVlt: OK')
		END

		IF @ForFatImportoVlt <> @ForFatImportoVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForFatImportoVlt: ' + convert(NVARCHAR(20), @ForFatImportoVlt - @ForFatImportoVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForFatImportoVlt: OK')
		END

		IF @ForFatImpostaVlt <> @ForFatImpostaVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForFatImpostaVlt: ' + convert(NVARCHAR(20), @ForFatImpostaVlt - @ForFatImpostaVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForFatImpostaVlt: OK')
		END

		IF @ForOrdImponibileVlt <> @ForOrdImponibileVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForOrdImponibileVlt: ' + convert(NVARCHAR(20), @ForOrdImponibileVlt - @ForOrdImponibileVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForOrdImponibileVlt: OK')
		END

		IF @ForOrdImponibileDetVlt <> @ForOrdImponibileDetVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForOrdImponibileDetVlt: ' + convert(NVARCHAR(20), @ForOrdImponibileDetVlt - @ForOrdImponibileDetVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForOrdImponibileDetVlt: OK')
		END

		IF @ForOrdImportoVlt <> @ForOrdImportoVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForOrdImportoVlt: ' + convert(NVARCHAR(20), @ForOrdImportoVlt - @ForOrdImportoVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForOrdImportoVlt: OK')
		END

		IF @ForOrdImpostaVlt <> @ForOrdImpostaVlt_1
		BEGIN
			SET @NonCongruenti = @NonCongruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForOrdImpostaVlt: ' + convert(NVARCHAR(20), @ForOrdImpostaVlt - @ForOrdImpostaVlt_1))
		END
		ELSE
		BEGIN
			SET @Congruenti = @Congruenti + 1
			SET @InfoExt = dbo.FncStr(@InfoExt, 'ForOrdImpostaVlt: OK')
		END

		------------------------------------------------
		-- Uscita
		------------------------------------------------
		DECLARE @Ret AS INT
		DECLARE @TypeMsg AS NVARCHAR(20)

		IF @NonCongruenti <> 0
			OR @NonCongruentiMage <> 0
			OR @NonCongruentiTesoreria <> 0
		BEGIN
			SET @TypeMsg = 'WRN'

			PRINT '### Verifica congruenze: NOK ###'

			SET @Ret = 1
		END
		ELSE
		BEGIN
			SET @TypeMsg = 'INF'

			PRINT 'Verifca congruenze documentali: OK'

			IF @FlgElabMage = 1
			BEGIN
				PRINT 'Verifca congruenze mage: OK'
			END
			ELSE
			BEGIN
				PRINT 'Verifca congruenze mage: DISABILITATA'
			END

			IF EXISTS (
					SELECT 1
					FROM TbCntTesoreriaMovScad
					)
			BEGIN
				PRINT 'Verifca congruenze tesoreria: OK'
			END
			ELSE
			BEGIN
				PRINT 'Verifca congruenze tesoreria: DISABILITATA'
			END

			SET @Ret = 0
		END

		SET @Msg1 = 'Operazione completata versione ' + @Version
		SET @Msg1 = dbo.FncStr(@Msg1, '-----------------------------------')
		SET @Msg1 = dbo.FncStr(@Msg1, 'Congruenti Doc: ' + convert(NVARCHAR(20), @Congruenti))
		SET @Msg1 = dbo.FncStr(@Msg1, 'Non Congruenti Doc: ' + convert(NVARCHAR(20), @NonCongruenti))

		IF EXISTS (
				SELECT 1
				FROM TbCntTesoreriaMovScad
				)
		BEGIN
			SET @Msg1 = dbo.FncStr(@Msg1, 'Congruenti Tesoreria: ' + isnull(convert(NVARCHAR(20), @CongruentiTesoreria), '--'))
			SET @Msg1 = dbo.FncStr(@Msg1, 'Non Congruenti Tesoreria: ' + IsNull(convert(NVARCHAR(20), @NonCongruentiTesoreria), '--'))
		END
		ELSE
		BEGIN
			SET @Msg1 = dbo.FncStr(@Msg1, 'Tesoreria non controllata')
		END

		IF @FlgElabMage = 1
		BEGIN
			SET @Msg1 = dbo.FncStr(@Msg1, 'Congruenti Mage: ' + isnull(convert(NVARCHAR(20), @CongruentiMage), '--'))
			SET @Msg1 = dbo.FncStr(@Msg1, 'Non Congruenti Mage: ' + IsNull(convert(NVARCHAR(20), @NonCongruentiMage), '--'))
		END
		ELSE
		BEGIN
			SET @Msg1 = dbo.FncStr(@Msg1, 'Mage non controllato')
		END

		SET @Msg1 = dbo.FncStr(@Msg1, '-----------------------------------')

		PRINT @Msg1
		PRINT @InfoExt
		PRINT @InfoExt1

		SET @OutMsg = dbo.FncStr(@OutMsg, @Msg1)
		SET @Msg1 = dbo.FncStr(@Msg1, '-----------------------------------')
		SET @OutMsg = dbo.FncStr(@OutMsg, @InfoExt)
		SET @Msg1 = dbo.FncStr(@Msg1, '-----------------------------------')
		SET @OutMsg = dbo.FncStr(@OutMsg, @InfoExt1)

		-- IF @TypeMsg <> 'INF'
		-- BEGIN
		-- 	SET @OutMsg = @InfoExt -- Setta parametro di out per powershell
		-- END
		EXECUTE [dbo].[StpUteMsg] @Msg = @Msg,
			@Msg1 = @Msg1,
			@MsgObj = @MsgObj,
			@Param = @PrInfo,
			@CodFnzTipoMsg = @TypeMsg,
			@SysUser = @SysUser,
			@KYStato = @KYStato,
			@KYRes = 0,
			@KyParam = NULL,
			@KyMsg = @KYMsg OUTPUT

		SET @KYStato = - 1

		--If right(DB_NAME(),2) Not in ('T1','T2','T3')
		--	BEGIN
		--		Declare @Obj as NVARCHAR(300)
		--		Set @Obj = 'Verifica aggiornamento ' + DB_NAME() + ' Versione ' + @Version
		--		Set @InfoExt = dbo.fncstr( @Msg1 ,@InfoExt)
		--		Execute StpAdmSendMail NULL, 'bug@studiotoniolo.eu', 'support@studiotoniolo.eu', NULL, @Obj , @InfoExt 
		--	END
		RETURN (@Ret)
	END

	/****************************************************************
	* Stato 1 - risposta negativa
	****************************************************************/
	IF ISNULL(@KYStato, 999) = 1
		AND @KYRes = 0
	BEGIN
		/****************************************************************
		* Uscita
		****************************************************************/
		SET @Msg1 = 'Operazione annullata'

		EXECUTE [dbo].[StpUteMsg] @Msg = @Msg,
			@Msg1 = @Msg1,
			@MsgObj = @MsgObj,
			@Param = @PrInfo,
			@CodFnzTipoMsg = 'WRN',
			@SysUser = @SysUser,
			@KYStato = @KYStato,
			@KYRes = @KYRes,
			@KyParam = NULL,
			@KyMsg = @KYMsg OUTPUT

		SET @KYStato = - 4

		RETURN
	END
END

GO

