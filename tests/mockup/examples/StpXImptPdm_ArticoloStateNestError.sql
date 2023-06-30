SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/**
 * @summary Importa macchina o articolo da tabelle di interscambio di Dbo ad articoli e distinte
 * @author simone
 * @custom YES
 * @standard NO
 * @version sim 230417 Creazione
 * @version dav 230517 Aggiornamento
 **/
CREATE OR ALTER PROCEDURE [dbo].[StpXImptPdm_Articolo] (
	@IdArticolo NVARCHAR(50) = NULL OUT,
	@SysUser NVARCHAR(256),
	@KYStato INT = NULL OUTPUT,
	@KYMsg NVARCHAR(MAX) = NULL OUTPUT,
	@KYRes INT = NULL,
	@KYRequest UNIQUEIDENTIFIER = NULL OUTPUT,
    @Debug BIT = 0
)
AS
BEGIN
	-- Return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla
	-- Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question
	SET NOCOUNT ON


	DECLARE @StartExecutionTime DATETIME2
	SET @StartExecutionTime = SYSUTCDATETIME()

	DECLARE @PartialExecutionTime DATETIME2
	SET @PartialExecutionTime = SYSUTCDATETIME()

    DECLARE @ExecutionTime INT

	-------------------------------------
	-- Parametri generali
	-------------------------------------
	DECLARE @Msg NVARCHAR(MAX)
	DECLARE @Msg1 NVARCHAR(300)
	DECLARE @MsgObj NVARCHAR(300)
	DECLARE @MsgInfo NVARCHAR(300)
	DECLARE @PrInfo NVARCHAR(300)
	DECLARE @MsgExt NVARCHAR(MAX)
	-- Parametro di log

	-------------------------------------
	-- Parametri per struttura XML
	-------------------------------------
	DECLARE @ParamCtrl NVARCHAR(MAX)
	DECLARE @C_IdArticolo AS NVARCHAR(MAX)


    DECLARE @InfoArtLog NVARCHAR(MAX)
    DECLARE @InfoArtLogTemp NVARCHAR(MAX)
    DECLARE @InfoArtLogErr NVARCHAR(MAX)
    DECLARE @CrLf CHAR(2) = CHAR(13) + CHAR(10)
    DECLARE @DistVer NVARCHAR(20)
    DECLARE @IdArtDist INT
    DECLARE @DescArticolo NVARCHAR(MAX)
    DECLARE @IdArticoloElab NVARCHAR(50)
    DECLARE @IdElab INT
    DECLARE @LivelloStr NVARCHAR(50)

    DECLARE @UrlDboH NVARCHAR(200)
    SELECT @UrlDboH = AdmURLDboH
    FROM TbSetting
    WHERE IdSetting = 1

	-------------------------------------
	-- Parametri di risposta
	-------------------------------------
	SET @ParamCtrl = '<ParamCtrl>' + REPLACE(REPLACE(@KYMsg, '-|', '<'), '|-', '>') + '</ParamCtrl>'

    -- @IF
	-------------------------------------
	-- @State 0 Domanda Iniziale
	-------------------------------------
	IF @KYStato = 0
        BEGIN
            SET @KYStato = 1
            SET @Msg1 = 'Confermi l''importazione?'

            -- @Step Creo controlli per fascia
            SET @C_IdArticolo = dbo.FncKyMsgComboBoxSQL(
                'IdArticolo', 
                @KYStato, 
                'Matricola:', 
                @IdArticolo, 
                'IdArticolo', 
                'IdArticolo', 
                'IdArticolo',
                'SELECT IdArticolo, Ord FROM (SELECT DISTINCT CONVERT(NVARCHAR(50), MACCHINA) AS IdArticolo, CONVERT(NVARCHAR(50), CONCAT(''0#'', MACCHINA)) AS Ord FROM TbXImptPdmArt WHERE ISNULL(MACCHINA, '''') <> '''' UNION ALL SELECT IdArticolo, CONCAT(''1#'', IdArticolo) FROM TbXImptPdmArt) drv ORDER BY Ord'
            )

            -- @Step Crea XML per fascia
            SET @ParamCtrl = dbo.FncKyMsgAddControl(@ParamCtrl, @KYStato - 1, @C_IdArticolo)

            EXECUTE dbo.StpUteMsg @Msg = @Msg,
                @Msg1 = @Msg1,
                @MsgObj = @MsgObj,
                @Param = @PrInfo,
                @CodFnzTipoMsg = 'QST',
                @SysUser = @SysUser,
                @KYStato = @KYStato,
                @KYRes = @KYRes,
                @KyParam = '(1):Ok;0:Cancel',
                @KyMsg = @KyMsg OUTPUT

            SET @KYMsg = @KYMsg + '<ParamCtrl>' + @ParamCtrl + '</ParamCtrl>'

            RETURN
        END
        	
    -------------------------------------
    -- @EndState 
	-------------------------------------
    -- @ENDIF

	-------------------------------------
	-- @State 1 @Res 1 Esecuzione procedura
	-------------------------------------
	IF @KYStato IS NULL
		OR (
			@KYStato = 1
			AND @KYRes = 1
			)
        BEGIN
            SET @IdArticolo = ISNULL(dbo.FncKyMsgCtrlValue(@ParamCtrl, 'IdArticolo', 1), @IdArticolo)

            SET @PartialExecutionTime = SYSUTCDATETIME()

            -- @Step Esplode articolo PDM
            EXECUTE StpXImptPdm_Esplodi
                @IdArticolo = @IdArticolo,
                @SysUser = @SysUser

            SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
            SET @PartialExecutionTime = SYSUTCDATETIME()

            BEGIN TRY
                BEGIN TRANSACTION
            
                    CREATE TABLE #TmpStats (
                        ID INT NOT NULL,
                        TipoStatistica VARCHAR(10), -- "AC, GR, Numero Elaborazioni, tempomedio, ecc..."
                        DettaglioStatistica VARCHAR(200), -- "Anagrafiche, Distinte"
                        DescTipo VARCHAR(200),
                        Valore INT DEFAULT 0
                    )

                    INSERT INTO #TmpStats (ID, TipoStatistica, DescTipo, DettaglioStatistica)
                    SELECT (drvTipi.id * 10) + drvStat.Id, drvTipi.Tipo, drvTipi.DescTipo, drvStat.Tipo
                    FROM (
                        SELECT 'Anagrafiche inserite' AS Tipo, 1 AS Id UNION ALL
                        SELECT 'Anagrafiche modificate' AS Tipo, 2 AS Id UNION ALL
                        SELECT 'Distinte revisionate' AS Tipo, 3 AS Id UNION ALL
                        SELECT 'Distinte non revisionate' AS Tipo, 4 AS Id UNION ALL
                        SELECT 'Totale in macchina' AS Tipo, 5 AS Id
                    ) drvStat
                    CROSS JOIN (
                        SELECT 'GR' AS Tipo, 'GRUPPI (GR)' AS DescTipo, 1 AS Id UNION ALL
                        SELECT 'AC' AS Tipo, 'ASSIEMI (AC)' AS DescTipo, 2 AS Id UNION ALL
                        SELECT 'CO' AS Tipo, 'COSTRUTTIVI (CO)' AS DescTipo, 3 AS Id UNION ALL
                        SELECT 'GZ' AS Tipo, 'COSTRUTTIVI GREZZI (CO...-GZ)' AS DescTipo, 4 AS Id UNION ALL
                        SELECT 'TL' AS Tipo, 'OSSITAGLI (TL)' AS DescTipo, 5 AS Id UNION ALL
                        SELECT 'C' AS Tipo, 'COMMERCIALI (C)' AS DescTipo, 6 AS Id UNION ALL
                        SELECT 'B' AS Tipo, 'COMMERCIALI (B)' AS DescTipo, 7 AS Id UNION ALL
                        SELECT 'R' AS Tipo, 'MOTORI (R)' AS DescTipo, 8 AS Id UNION ALL
                        SELECT 'CD' AS Tipo, 'COMMERCIALI A DISEGNO (CD)' AS DescTipo, 9 AS Id
                    ) drvTipi

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()

                    -- @Step inserimento finiture
                    DECLARE @IdFinitura INT

                    SELECT @IdFinitura = MAX(CONVERT(INT, IdFinitura))
                    FROM TbArtAnagFiniture
                    WHERE ISNUMERIC(IdFinitura) = 1

                    INSERT INTO TbArtAnagFiniture (IdFinitura, DescFinitura, SysDateCreate, SysUserCreate)
                    SELECT IIF(LEN(IdFinitura) = 1, CONCAT('0', IdFinitura), IdFinitura), DescFinitura, GETDATE(), @SysUser
                    FROM (
                        SELECT LEFT(TXIPA.TRATT_SUP, 200) AS DescFinitura, ROW_NUMBER() OVER (ORDER BY LEFT(TXIPA.TRATT_SUP, 200)) + @IdFinitura AS IdFinitura
                        FROM TbArtDistEsplosaPdm TADEP
                        INNER JOIN TbXImptPdmArt TXIPA
                            ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                        LEFT OUTER JOIN TbArtAnagFiniture TAAF
                            ON TAAF.DescFinitura = LEFT(TXIPA.TRATT_SUP, 200)
                        WHERE TAAF.IdFinitura IS NULL
                            AND ISNULL(TRATT_SUP, '') <> ''
                            AND TXIPA.IdArticolo = @IdArticolo
                        GROUP BY LEFT(TXIPA.TRATT_SUP, 200)
                    ) drv



                    -- @Step Prendo Id di Dbo da descrizioni
                    SELECT * 
                    INTO #tmpXImptPdmArt
                    FROM (
                        SELECT 
                            TXIPA.*, 
                            TAAT.IdTrattamento, TAAF.IdFinitura, TAACM.IdCategoriaMrc, TF.IdFornitore, TAAMA.IdMateriale, TADEP.Livello,
                            ISNULL(TAAC.IdCategoria, '000') AS IdCategoria, TXIPA.TIPOLOGIA_1 AS DescCategoria, 0 AS IsGZ, 
                            IIF(CHARINDEX('.', TXIPA.IdArticolo) > 1, LEFT(TXIPA.IdArticolo, CHARINDEX('.', TXIPA.IdArticolo) - 1), LEFT(TXIPA.IdArticolo, PATINDEX('%[0-9]%', TXIPA.IdArticolo) - 1)) AS TipoExpert
                        FROM TbArtDistEsplosaPdm TADEP
                        INNER JOIN TbXImptPdmArt TXIPA
                            ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                        LEFT OUTER JOIN TbArtAnagTrattamenti TAAT
                            ON TXIPA.TRATT_TERM = TAAT.DescTrattamento
                        LEFT OUTER JOIN TbArtAnagFiniture TAAF
                            ON TXIPA.TRATT_SUP = TAAF.DescFinitura
                        LEFT OUTER JOIN TbArtAnagCatgrMrc TAACM
                            ON TXIPA.CATEGORIA_MERCEOLOGICA = TAACM.DescCategoriaMrc
                        LEFT OUTER JOIN TbArtAnagCatgr TAAC
                            ON TXIPA.TIPOLOGIA_1 = TAAC.DescCategoria
                        LEFT OUTER JOIN TbFornitori TF
                            ON TXIPA.FORNITORE = TF.RagSoc
                        LEFT OUTER JOIN TbArtAnagMateriali TAAMA
                            ON TXIPA.CODICE_MATERIALE = TAAMA.IdMateriale
                        WHERE TADEP.IdArticolo = @IdArticolo
                            AND FlgRilasciato = 1

                        UNION
                    
                        SELECT 
                            TXIPA.*, 
                            TAAT.IdTrattamento, TAAF.IdFinitura, TAACM.IdCategoriaMrc, TF.IdFornitore, TAAMA.IdMateriale, TADEP.Livello,
                            COALESCE(TAAC_CO.IdCategoria, TAAC.IdCategoria, '000') AS IdCAtegoria, ISNULL(TXIPA.TIPOLOGIA_2, TXIPA.TIPOLOGIA_1) AS DescCategoria, 1 AS IsGZ,
                            'GZ' As TipoExpert
                        FROM TbArtDistEsplosaPdm TADEP
                        INNER JOIN TbXImptPdmArt TXIPA
                            ON TADEP.IdArticoloFgl = CONCAT(TXIPA.IdArticolo, '-GZ')
                        LEFT OUTER JOIN TbArtAnagTrattamenti TAAT
                            ON TXIPA.TRATT_TERM = TAAT.DescTrattamento
                        LEFT OUTER JOIN TbArtAnagFiniture TAAF
                            ON TXIPA.TRATT_SUP = TAAF.DescFinitura
                        LEFT OUTER JOIN TbArtAnagCatgrMrc TAACM
                            ON TXIPA.CATEGORIA_MERCEOLOGICA = TAACM.DescCategoriaMrc
                        LEFT OUTER JOIN TbArtAnagCatgr TAAC
                            ON TXIPA.TIPOLOGIA_1 = TAAC.DescCategoria
                        LEFT OUTER JOIN TbArtAnagCatgr TAAC_CO
                            ON TXIPA.TIPOLOGIA_2 = TAAC_CO.DescCategoria
                        LEFT OUTER JOIN TbFornitori TF
                            ON TXIPA.FORNITORE = TF.RagSoc
                        LEFT OUTER JOIN TbArtAnagMateriali TAAMA
                            ON TXIPA.CODICE_MATERIALE = TAAMA.IdMateriale
                        WHERE TADEP.IdArticolo = @IdArticolo
                            AND FlgRilasciato = 1
                    ) drv

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()


                    UPDATE #tmpXImptPdmArt
                    SET PESO = REPLACE(PESO, ',', '.')

                    UPDATE tmp
                    SET NOME_FILE = spec.NOME_FILE,
                        [PATH] = [spec].[PATH],
                        DISEGNO = COALESCE(spec.DISEGNO, tmp.CODICE_SPECULARE, tmp.DISEGNO)
                    FROM #tmpXImptPdmArt tmp
                    LEFT OUTER JOIN TbXImptPdmArt spec
                        ON tmp.CODICE_SPECULARE = spec.IdArticolo
                    WHERE tmp.CODICE_SPECULARE IS NOT NULL

                    UPDATE #tmpXImptPdmArt
                    SET IdArticolo = CONCAT(IdArticolo, '-GZ'),
                        DESCRIZIONE = CONCAT(DESCRIZIONE, ' GZ')
                    WHERE IsGZ = 1

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()
            


                    -- @Section Creazione articoli

                    -- @step Log nuovo articolo
                    SELECT @InfoArtLogTemp = STRING_AGG(CONVERT(NVARCHAR(MAX), CONCAT('<li>Inserimento articolo <b>', TXIPA.IdArticolo, '</b></li>')), @CrLf)
                    FROM #tmpXImptPdmArt TXIPA
                    LEFT OUTER JOIN TbArticoli TA
                        ON TXIPA.IdArticolo = TA.IdArticolo
                    WHERE TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND TA.IdArticolo IS NULL
                    
                    SET @InfoArtLog = CONCAT('<h4>INSERIMENTO ANAGRAFICHE</h4><ul>', @CrLf, ISNULL(@InfoArtLogTemp, 'Nessuna anagrafica da inserire'), '</ul>')

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()

                    -- @step Aggiorno statistiche
                    UPDATE #TmpStats
                    SET Valore = Num
                    FROM #TmpStats
                    INNER JOIN (
                        SELECT TipoExpert, COUNT(1) AS Num
                        FROM #tmpXImptPdmArt TXIPA
                        LEFT OUTER JOIN TbArticoli TA
                            ON TXIPA.IdArticolo = TA.IdArticolo
                        WHERE TXIPA.FlgRilasciato = 1
                            AND TXIPA.FlgModificaPdm = 1
                            AND TA.IdArticolo IS NULL
                        GROUP BY TipoExpert
                    ) drv
                    ON #TmpStats.TipoStatistica = drv.TipoExpert 
                        AND #TmpStats.DettaglioStatistica = 'Anagrafiche inserite'

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()

                    -- @step Inserimento articoli
                    INSERT INTO TbArticoli (IdArticolo, IdArticoloBase, RevisioneId, RevisioneData, DescArticolo, DimPeso, UnitMPeso, 
                        IdTrattamento, IdFinitura, IdCategoria, IdCategoriaMrc, IdFornitoreAbituale, Disegno, IdMateriale, CodFnzStato, 
                        NoteOrigine, FlgGestioneCommessa, FlgLavoratoInt, FlgGrpVirtuale, SysDateCreate, SysUserCreate, FlgPdm, FlgDisabilitaMrp,
                        PercorsoFile, FiltroFile
					)
                    SELECT TXIPA.IdArticolo, IIF(LEFT(RIGHT(TXIPA.IdArticolo, 2), 1) = '-', LEFT(TXIPA.IdArticolo, LEN(TXIPA.IdArticolo) - 2), TXIPA.IdArticolo),
                        LEFT(REV, 10), DATA_CREAZIONE, DESCRIZIONE, IIF(ISNUMERIC(REPLACE(PESO, ',', '.')) = 1, REPLACE(PESO, ',', '.'), NULL), 'KG',
                        TXIPA.IdTrattamento, TXIPa.IdFinitura, TXIPA.IdCategoria, TXIPa.IdCategoriaMrc, TXIPa.IdFornitore, TXIPA.DISEGNO, TXIPA.IdMateriale,
                        'T', CONCAT('Stato PDM:', TXIPA.STATO), IIF(LEFT(TXIPA.IdArticolo, 3) = 'GR.', 1, 0), IIF(LEFT(TXIPA.IdArticolo, 3) = 'GR.', 1, 0),
                        IIF(LEFT(TXIPA.IdArticolo, 3) = 'AC.' AND TXIPA.DescCategoria NOT LIKE '%B - Buy%', 1, 0), GETDATE(), @SysUser, 1, 0,
                        REPLACE(TXIPA.[PATH], 'G:', '\\Srvexpert\Uff.tecnico1'), TXIPA.NOME_FILE
                    FROM #tmpXImptPdmArt TXIPA
                    LEFT OUTER JOIN TbArticoli TA
                        ON TXIPA.IdArticolo = TA.IdArticolo
                    WHERE TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND TA.IdArticolo IS NULL

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()

                    -- @step Inserimento unità di misura
                    INSERT INTO TbArtUnitM (IdArticolo, UnitM, UnitMCoeff, Std, Acq, Ven, Prod)
                    SELECT TXIPA.IdArticolo, ISNULL(TXIPA.UM, 'PZ'), 1, 1, 1, 1, 1
                    FROM #tmpXImptPdmArt TXIPA
                    LEFT OUTER JOIN TbArtUnitM TAUM
                        ON TXIPA.IdArticolo = TAUM.IdArticolo
                    WHERE TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND TAUM.IdArticolo IS NULL

                    UPDATE TAE
                    SET UnitM = ISNULL(TXIPA.UM, 'PZ')
                    FROM TbArtElab TAE
                    INNER JOIN  #tmpXImptPdmArt TXIPA
                        ON TAE.IdArticolo = TXIPA.IdArticolo

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()


                    -- @EndSection


                    -- @Section UPDATE anagrafiche articolo
                    
                    -- @Step Log cambio descrizione
                    INSERT INTO TbDataLog(TipoDoc, IdDoc, DescLog, SysUserCreate)
                    SELECT 'TbArticoli', TXIPA.IdArticolo, CONCAT('PDM Agg. Desc.: ', TA.DescArticolo, ' -> ', TXIPA.DESCRIZIONE), @SysUser
                    FROM TbArtDistEsplosaPdm TADEP
                    INNER JOIN #tmpXImptPdmArt TXIPA
                        ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                    INNER JOIN TbArticoli TA
                        ON TADEP.IdArticoloFgl = TA.IdArticolo
                    WHERE TADEP.IdArticolo = @IdArticolo
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND ISNULL(TA.DescArticolo, '') <> ISNULL(TXIPA.DESCRIZIONE, '')

                    -- @Step Log cambio peso
                    INSERT INTO TbDataLog(TipoDoc, IdDoc, DescLog, SysUserCreate)
                    SELECT 'TbArticoli', TXIPA.IdArticolo, CONCAT('PDM Agg. Peso: ', CONVERT(REAL, TA.DimPeso), ' -> ', ROUND(CONVERT(REAL, TXIPA.PESO), 2)), @SysUser
                    FROM TbArtDistEsplosaPdm TADEP
                    INNER JOIN #tmpXImptPdmArt TXIPA
                        ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                    INNER JOIN TbArticoli TA
                        ON TADEP.IdArticoloFgl = TA.IdArticolo
                    WHERE TADEP.IdArticolo = @IdArticolo
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND ABS(ISNULL(TA.DimPeso, 0) - ISNULL(TXIPA.PESO, 0)) > 0.0001

                    -- @Step Log cambio trattamento
                    INSERT INTO TbDataLog(TipoDoc, IdDoc, DescLog, SysUserCreate)
                    SELECT 'TbArticoli', TXIPA.IdArticolo, CONCAT('PDM Agg. Tratt.: ', TA.IdTrattamento, ' -> ', TXIPA.IdTrattamento), @SysUser
                    FROM TbArtDistEsplosaPdm TADEP
                    INNER JOIN #tmpXImptPdmArt TXIPA
                        ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                    INNER JOIN TbArticoli TA
                        ON TADEP.IdArticoloFgl = TA.IdArticolo
                    WHERE TADEP.IdArticolo = @IdArticolo
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND ISNULL(TA.IdTrattamento, '') <> ISNULL(TXIPA.IdTrattamento, '')
                    
                    -- @Step Log cambio finitura
                    INSERT INTO TbDataLog(TipoDoc, IdDoc, DescLog, SysUserCreate)
                    SELECT 'TbArticoli', TXIPA.IdArticolo, CONCAT('PDM Agg. Fin.: ', TA.IdFinitura, ' -> ', TXIPA.IdFinitura), @SysUser
                    FROM TbArtDistEsplosaPdm TADEP
                    INNER JOIN #tmpXImptPdmArt TXIPA
                        ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                    INNER JOIN TbArticoli TA
                        ON TADEP.IdArticoloFgl = TA.IdArticolo
                    WHERE TADEP.IdArticolo = @IdArticolo
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND ISNULL(TA.IdFinitura, '') <> ISNULL(TXIPA.IdFinitura, '')

                    -- @Step Log cambio categoria merceologica
                    INSERT INTO TbDataLog(TipoDoc, IdDoc, DescLog, SysUserCreate)
                    SELECT 'TbArticoli', TXIPA.IdArticolo, CONCAT('PDM Agg. Cat. Mrc.: ', TA.IdCategoriaMrc, ' -> ', TXIPA.IdCategoriaMrc), @SysUser
                    FROM TbArtDistEsplosaPdm TADEP
                    INNER JOIN #tmpXImptPdmArt TXIPA
                        ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                    INNER JOIN TbArticoli TA
                        ON TADEP.IdArticoloFgl = TA.IdArticolo
                    WHERE TADEP.IdArticolo = @IdArticolo
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND ISNULL(TA.IdCategoriaMrc, '') <> ISNULL(TXIPA.IdCategoriaMrc, '')
                    
                    -- @Step Log cambio categoria
                    INSERT INTO TbDataLog(TipoDoc, IdDoc, DescLog, SysUserCreate)
                    SELECT 'TbArticoli', TXIPA.IdArticolo, CONCAT('PDM Agg. Cat. : ', TA.IdCategoria, ' -> ', TXIPA.IdCategoria), @SysUser
                    FROM TbArtDistEsplosaPdm TADEP
                    INNER JOIN #tmpXImptPdmArt TXIPA
                        ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                    INNER JOIN TbArticoli TA
                        ON TADEP.IdArticoloFgl = TA.IdArticolo
                    WHERE TADEP.IdArticolo = @IdArticolo
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND ISNULL(TA.IdCategoria, '') <> ISNULL(TXIPA.IdCategoria, '')

                    -- @Step Log cambio fonritore
                    INSERT INTO TbDataLog(TipoDoc, IdDoc, DescLog, SysUserCreate)
                    SELECT 'TbArticoli', TXIPA.IdArticolo, CONCAT('PDM Agg. For.: ', TA.IdFornitoreAbituale, ' -> ', TXIPA.IdFornitore), @SysUser
                    FROM TbArtDistEsplosaPdm TADEP
                    INNER JOIN #tmpXImptPdmArt TXIPA
                        ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                    INNER JOIN TbArticoli TA
                        ON TADEP.IdArticoloFgl = TA.IdArticolo
                    WHERE TADEP.IdArticolo = @IdArticolo
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND ISNULL(TA.IdFornitoreAbituale, '') <> ISNULL(TXIPA.IdFornitore, '')

                    -- @Step Log cambio disegno
                    INSERT INTO TbDataLog(TipoDoc, IdDoc, DescLog, SysUserCreate)
                    SELECT 'TbArticoli', TXIPA.IdArticolo, CONCAT('PDM Agg. Disgn.: ', TA.Disegno, ' -> ', TXIPA.DISEGNO), @SysUser
                    FROM TbArtDistEsplosaPdm TADEP
                    INNER JOIN #tmpXImptPdmArt TXIPA
                        ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                    INNER JOIN TbArticoli TA
                        ON TADEP.IdArticoloFgl = TA.IdArticolo
                    WHERE TADEP.IdArticolo = @IdArticolo
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND ISNULL(TA.Disegno, '') <> ISNULL(TXIPA.DISEGNO, '')

                    -- @Step Log cambio materiale
                    INSERT INTO TbDataLog(TipoDoc, IdDoc, DescLog, SysUserCreate)
                    SELECT 'TbArticoli', TXIPA.IdArticolo, CONCAT('PDM Agg. Mat.: ', TA.IdMateriale, ' -> ', TXIPA.IdMateriale), @SysUser
                    FROM TbArtDistEsplosaPdm TADEP
                    INNER JOIN #tmpXImptPdmArt TXIPA
                        ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                    INNER JOIN TbArticoli TA
                        ON TADEP.IdArticoloFgl = TA.IdArticolo
                    WHERE TADEP.IdArticolo = @IdArticolo
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND ISNULL(TA.IdMateriale, '') <> ISNULL(TXIPA.IdMateriale, '')

                    -- @Step Log cambio percorso file
                    INSERT INTO TbDataLog(TipoDoc, IdDoc, DescLog, SysUserCreate)
                    SELECT 'TbArticoli', TXIPA.IdArticolo, CONCAT('PDM Agg. Perc.: ', TA.PercorsoFile, TA.FiltroFile, ' -> ', TXIPA.[PATH], TXIPA.NOME_FILE), @SysUser
                    FROM TbArtDistEsplosaPdm TADEP
                    INNER JOIN #tmpXImptPdmArt TXIPA
                        ON TADEP.IdArticoloFgl = TXIPA.IdArticolo
                    INNER JOIN TbArticoli TA
                        ON TADEP.IdArticoloFgl = TA.IdArticolo
                    WHERE TADEP.IdArticolo = @IdArticolo
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1
                        AND (ISNULL(TA.PercorsoFile, '') <> ISNULL(REPLACE(TXIPA.[PATH], 'G:', '\\Srvexpert\Uff.tecnico1'), '') OR  ISNULL(TA.FiltroFile, '') <> ISNULL(TXIPA.[NOME_FILE], ''))

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()


                    -- @Step log modifica intera
                    SELECT @InfoArtLogTemp = STRING_AGG(CONVERT(NVARCHAR(MAX), 
                        CONCAT('<tr><td style="text-align:left; width:25%; border: 1px solid; padding: 5px"><b>', TXIPA.IdArticolo, '</b></td><td style="text-align:left; border: 1px solid; padding: 5px">Aggiornamento: ',
                            IIF(ISNULL(TA.DescArticolo, '') <> ISNULL(TXIPA.DESCRIZIONE, ''), 'descrizione, ', ''),
                            IIF(ABS(ISNULL(TA.DimPeso, 0) - ISNULL(TXIPA.PESO, 0)) > 0.0001, 'peso, ', ''),
                            IIF(ISNULL(TA.IdTrattamento, '') <> ISNULL(TXIPA.IdTrattamento, ''), 'tratt. termico, ', ''),
                            IIF(ISNULL(TA.IdFinitura, '') <> ISNULL(TXIPA.IdFinitura, ''), 'finitura, ', ''),
                            IIF(ISNULL(TA.IdCategoriaMrc, '') <> ISNULL(TXIPA.IdCategoriaMrc, ''), 'cat. merceologica, ', ''),
                            IIF(ISNULL(TA.IdCategoria, '') <> ISNULL(TXIPA.IdCategoria, ''), 'categoria, ', ''),
                            IIF(ISNULL(TA.IdFornitoreAbituale, '') <> ISNULL(TXIPA.IdFornitore, ''), 'fornitore, ', ''),
                            IIF(ISNULL(TA.Disegno, '') <> ISNULL(TXIPA.DISEGNO, ''), 'disegno, ', ''),
                            IIF(ISNULL(TA.IdMateriale, '') <> ISNULL(TXIPA.IdMateriale, ''), 'materiale, ', ''),
                            IIF((ISNULL(TA.PercorsoFile, '') <> ISNULL(REPLACE(TXIPA.[PATH], 'G:', '\\Srvexpert\Uff.tecnico1'), '') OR  ISNULL(TA.FiltroFile, '') <> ISNULL(TXIPA.[NOME_FILE], '')) , 'percorso file', ''),
                            '</td></tr>'
                        )), @CrLf)
                    FROM #tmpXImptPdmArt TXIPA
                    INNER JOIN TbArticoli TA
                        ON TXIPA.IdArticolo = TA.IdArticolo
                    WHERE (
                            ISNULL(TA.DescArticolo, '') <> ISNULL(TXIPA.DESCRIZIONE, '')
                            OR ABS(ISNULL(TA.DimPeso, 0) - ISNULL(TXIPA.PESO, 0)) > 0.0001
                            OR ISNULL(TA.IdTrattamento, '') <> ISNULL(TXIPA.IdTrattamento, '')
                            OR ISNULL(TA.IdFinitura, '') <> ISNULL(TXIPA.IdFinitura, '')
                            OR ISNULL(TA.IdCategoriaMrc, '') <> ISNULL(TXIPA.IdCategoriaMrc, '')
                            OR ISNULL(TA.IdCategoria, '') <> ISNULL(TXIPA.IdCategoria, '')
                            OR ISNULL(TA.IdFornitoreAbituale, '') <> ISNULL(TXIPA.IdFornitore, '')
                            OR ISNULL(TA.Disegno, '') <> ISNULL(TXIPA.DISEGNO, '')
                            OR ISNULL(TA.IdMateriale, '') <> ISNULL(TXIPA.IdMateriale, '')
                            OR (ISNULL(TA.PercorsoFile, '') <> ISNULL(REPLACE(TXIPA.[PATH], 'G:', '\\Srvexpert\Uff.tecnico1'), '') OR  ISNULL(TA.FiltroFile, '') <> ISNULL(TXIPA.[NOME_FILE], ''))
                        )
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1

                    SET @InfoArtLog = CONCAT(@InfoArtLog, '<h4>AGGIORNAMENTO ANAGRAFICHE</h4>')

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()

                    IF @InfoArtLogTemp IS NULL
                        SET @InfoArtLog = CONCAT(@InfoArtLog, 'Nessuna anagrafica da aggiornare</br>')
                    ELSE
                        SET @InfoArtLog = CONCAT(@InfoArtLog, '<table style="border-collapse: collapse; text-align:center"><thead><tr><th style="padding: 10px; border: 1px solid">Articolo</th><th style="padding: 10px; border: 1px solid">Info</th></tr></thead><tbody>', @CrLf, @InfoArtLogTemp, '</tbody></table></br>')   

                    -- @Step Aggiorno statistiche
                    UPDATE #TmpStats
                    SET Valore = Num
                    FROM #TmpStats
                    INNER JOIN (
                        SELECT TipoExpert, COUNT(1) AS Num
                        FROM #tmpXImptPdmArt TXIPA
                        INNER JOIN TbArticoli TA
                            ON TXIPA.IdArticolo = TA.IdArticolo
                        WHERE (
                                ISNULL(TA.DescArticolo, '') <> ISNULL(TXIPA.DESCRIZIONE, '')
                                OR ABS(ISNULL(TA.DimPeso, 0) - ISNULL(TXIPA.PESO, 0)) > 0.0001
                                OR ISNULL(TA.IdTrattamento, '') <> ISNULL(TXIPA.IdTrattamento, '')
                                OR ISNULL(TA.IdFinitura, '') <> ISNULL(TXIPA.IdFinitura, '')
                                OR ISNULL(TA.IdCategoriaMrc, '') <> ISNULL(TXIPA.IdCategoriaMrc, '')
                                OR ISNULL(TA.IdCategoria, '') <> ISNULL(TXIPA.IdCategoria, '')
                                OR ISNULL(TA.IdFornitoreAbituale, '') <> ISNULL(TXIPA.IdFornitore, '')
                                OR ISNULL(TA.Disegno, '') <> ISNULL(TXIPA.DISEGNO, '')
                                OR ISNULL(TA.IdMateriale, '') <> ISNULL(TXIPA.IdMateriale, '')
                                OR (ISNULL(TA.PercorsoFile, '') <> ISNULL(REPLACE(TXIPA.[PATH], 'G:', '\\Srvexpert\Uff.tecnico1'), '') OR  ISNULL(TA.FiltroFile, '') <> ISNULL(TXIPA.[NOME_FILE], ''))
                            )
                            AND TXIPA.FlgRilasciato = 1
                            AND TXIPA.FlgModificaPdm = 1
                        GROUP BY TipoExpert
                    ) drv
                    ON #TmpStats.TipoStatistica = drv.TipoExpert 
                        AND #TmpStats.DettaglioStatistica = 'Anagrafiche modificate'        

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()


                    -- @Step Update anagrafiche articoli
                    -- Se campo TXIPA è NULLO prendo quello articolo, se non è nullo è uguale o diverso quindi lo cambio a prescindere
                    UPDATE TbArticoli
                    SET DescArticolo = ISNULL(TXIPA.DESCRIZIONE, TA.DescArticolo), 
                        DimPeso = ISNULL(ROUND(CONVERT(real, TXIPA.PESO), 2), TA.DimPeso),
                        IdTrattamento = ISNULL(TXIPA.IdTrattamento, TA.IdTrattamento),
                        IdFinitura = ISNULL(TXIPA.IdFinitura, TA.IdFinitura),
                        IdCategoriaMrc = ISNULL(TXIPA.IdCategoriaMrc, TA.IdCategoriaMrc),
                        IdCategoria = ISNULL(TXIPA.IdCategoria, TA.IdCategoria),
                        IdFornitoreAbituale = ISNULL(TXIPA.IdFornitore, TA.IdFornitoreAbituale),
                        Disegno = ISNULL(TXIPA.DISEGNO, TA.Disegno),
                        IdMateriale = ISNULL(TXIPA.IdMateriale, TA.IdMateriale),
                        FlgGestioneCommessa = IIF(LEFT(TXIPA.IdArticolo, 3) = 'GR.', 1, 0),
                        FlgLavoratoInt = IIF(LEFT(TXIPA.IdArticolo, 3) = 'GR.', 1, 0),
                        FlgGrpVirtuale = IIF(LEFT(TXIPA.IdArticolo, 3) = 'AC.' AND TXIPA.DescCategoria NOT LIKE '%B - Buy%', 1, 0),
                        IdArticoloBase = CASE 
                            WHEN LEFT(RIGHT(TXIPA.IdArticolo, 2), 1) = '-'
                                THEN LEFT(TXIPA.IdArticolo, LEN(TXIPA.IdArticolo) - 2)
                            ELSE TXIPA.IdArticolo
                            END,
                        NoteOrigine = CONCAT('Stato PDM:', STATO),
                        PercorsoFile = REPLACE(TXIPA.[PATH], 'G:', '\\Srvexpert\Uff.tecnico1'),
                        FiltroFile = TXIPA.NOME_FILE
                    FROM #tmpXImptPdmArt TXIPA
                    INNER JOIN TbArticoli TA
                        ON TXIPA.IdArticolo = TA.IdArticolo
                    WHERE (
                            ISNULL(TA.DescArticolo, '') <> ISNULL(TXIPA.DESCRIZIONE, '')
                            OR ABS(ISNULL(TA.DimPeso, 0) - ISNULL(TXIPA.PESO, 0)) > 0.0001
                            OR ISNULL(TA.IdTrattamento, '') <> ISNULL(TXIPA.IdTrattamento, '')
                            OR ISNULL(TA.IdFinitura, '') <> ISNULL(TXIPA.IdFinitura, '')
                            OR ISNULL(TA.IdCategoriaMrc, '') <> ISNULL(TXIPA.IdCategoriaMrc, '')
                            OR ISNULL(TA.IdCategoria, '') <> ISNULL(TXIPA.IdCategoria, '')
                            OR ISNULL(TA.IdFornitoreAbituale, '') <> ISNULL(TXIPA.IdFornitore, '')
                            OR ISNULL(TA.Disegno, '') <> ISNULL(TXIPA.DISEGNO, '')
                            OR ISNULL(TA.IdMateriale, '') <> ISNULL(TXIPA.IdMateriale, '')
                            OR (ISNULL(TA.PercorsoFile, '') <> ISNULL(REPLACE(TXIPA.[PATH], 'G:', '\\Srvexpert\Uff.tecnico1'), '') OR  ISNULL(TA.FiltroFile, '') <> ISNULL(TXIPA.[NOME_FILE], ''))
                        )
                        AND TXIPA.FlgRilasciato = 1
                        AND TXIPA.FlgModificaPdm = 1


                    UPDATE anag
                    SET FlgModificaPdm = 0
                    FROM TbXImptPdmArt anag
                    INNER JOIN #tmpXImptPdmArt tmp
                        ON tmp.IdArticolo = anag.IdArticolo


                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()

                    -- @EndSection



                    -- @Section UPDATE anagrafiche articolo


                    CREATE TABLE #tmpDistinta (
                        IdArticolo NVARCHAR(50), -- Articolo
                        IdArticoloBase NVARCHAR(50), -- Articolo base, è l'articolo senza revisione, la revisione è identificata da ultimi due caratteri con penultimo = -
                        Qta DECIMAL(18, 8), -- Qta
                        NumVrs INT, -- Controllo se articoli con diversa revisione in distinta, prende comunque il massimo 
                        NumQta INT, -- Controllo presenza articoli doppi, ragruppa ma segnala
                        FlgModificaVrs BIT,
                        QtaPrec DECIMAL(18, 8) NULL DEFAULT 0,
                        FlgPdm BIT DEFAULT 0
                    )


                    SET @InfoArtLog = CONCAT(@InfoArtLog, @CrLf, @CrLf, 
                        '<h4>AGGIORNAMENTO DISTINTE</h4><table style="border-collapse: collapse; text-align:center"><thead><tr><th style="padding: 10px; border: 1px solid">Articolo</th><th style="padding: 10px; border: 1px solid">Descrizione</th><th style="padding: 10px; border: 1px solid">InfoElab</th></tr></thead><tbody>')
                    
                    -- @Loop Ciclo su tutti gli articoli in distita esplosa del PDM con riferimento all'ID

                    DECLARE db_cursor CURSOR FAST_FORWARD FOR
                    SELECT IdArticoloFgl, IdElab, LivelloStr, Descrizione
                    FROM TbArtDistEsplosaPdm
                    WHERE IdArticolo = @IdArticolo
                        AND Sem1 <> 3 -- Sem1 = 3 quando articolo è bloccato
                    ORDER BY Ordinamento
                    
                    OPEN db_cursor
                    FETCH NEXT FROM db_cursor INTO @IdArticoloElab, @IdElab, @LivelloStr, @DescArticolo
                    
                    WHILE @@FETCH_STATUS = 0
                        BEGIN
                            TRUNCATE TABLE #tmpDistinta

                            -- @Step Carico la sitinta dell'articolo

                            SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                            SET @PartialExecutionTime = SYSUTCDATETIME()

                            ;WITH cte_dist AS (
                                SELECT
                                -- ELABORA DISTINTA 
                                -- Se nella tabella di import c'è un codice articolo con il medesimo articolo base che c'era in distinta 
                                -- allora prendi l'articolo di import (ha una nuova revisione)
                                -- altrimenti prende l'articolo precedente e lascia il numero VRS a NULL
                                -- la Qta è semrpe 1 (distinta fittizia da angarfaica articoli)
                                -- Elabora comunque tutto anche codici eliminati, successivamente se VRS a NULL forza la qta a 0
                                -- non filtra per impianti elettrici gestiti manualmente (gruppo 'GREL')
                                COALESCE(drvImpt.IdArticolo, TbArticoli.IdArticolo) AS IdArticolo,
                                TbArticoli.IdArticoloBase,
                                COALESCE(drvImptQta.Qta, VstArtDistDetStd.QtaPz) AS Qta,
                                -- dav 230321 Corretto calcolo drvImpt.numVrs, nullo se articolo non presente in import
                                drvImpt.numVrs AS numVrs,
                                COALESCE(drvImptQta.NumQta, 1) AS NumQta,
                                CASE 
                                    WHEN TbArticoli.IdArticolo <> drvImpt.IdArticolo
                                        -- dav 230321 Correzione comparazione VstArtDistDetStd.Qta -> VstArtDistDetStd.QtaPz, non compara  drvImptQta.Import = 0
                                        -- OR drvImptQta.Qta <> VstArtDistDetStd.Qta
                                        OR drvImptQta.Qta <> VstArtDistDetStd.QtaPz
                                        OR ISNULL(drvImpt.numVrs, 0) = 0
                                        --OR drvImptQta.Import = 0
                                        THEN 1
                                    ELSE 0
                                    END AS FlgModificaVrs,
                                ISNULL(VstArtDistDetStd.QtaPz, 0) AS QtaPrec,
                                COALESCE(drvImpt.FlgPdm, VstArtDistDetStd.FlgPdm) AS FlgPdm
                            FROM (
                                SELECT IdArticoloFgl,
                                    SUM(Qta) AS Qta,
                                    SUM(QtaPz) AS QtaPz,
                                    MAX(CONVERT(INT, VstArtDistDetStd.FlgPdm)) AS FlgPdm
                                FROM VstArtDistDetStd
                                WHERE VstArtDistDetStd.IdArticolo = @IdArticoloElab
                                GROUP BY IdArticoloFgl
                                ) VstArtDistDetStd
                            LEFT OUTER JOIN TbArticoli
                                ON TbArticoli.IdArticolo = VstArtDistDetStd.IdArticoloFgl
                            LEFT OUTER JOIN (
                                SELECT IdArticoloBase AS IdArticoloBase,
                                    COUNT(1) AS NumVrs,
                                    MAX(espl.IdArticoloFgl) AS IdArticolo,
                                    1 as FlgPdm
                                FROM TbArtDistEsplosaPdm espl
                                INNER JOIN TbXImptPdmArt anag ON espl.IdArticoloFgl = anag.IdArticolo 
                                WHERE espl.IdElabPadre = @IdElab
                                    AND espl.Sem1 <> 3
                                GROUP BY IdArticoloBase
                                ) drvImpt
                                ON drvImpt.IdArticoloBase = TbArticoli.IdArticoloBase
                            LEFT OUTER JOIN (
                                SELECT espl.IdArticoloFgl AS IdArticolo,
                                    SUM(espl.Qta) AS Qta,
                                    COUNT(1) AS NumQta
                                FROM TbArtDistEsplosaPdm espl
                                WHERE espl.IdElabPadre = @IdElab
                                    AND espl.Sem1 <> 3
                                GROUP BY espl.IdArticoloFgl
                                ) drvImptQta
                                ON drvImptQta.IdArticolo = drvImpt.IdArticolo
                            )
                            INSERT INTO #tmpDistinta (IdArticolo, IdArticoloBase, Qta, NumVrs, NumQta, FlgModificaVrs, QtaPrec, FlgPdm)
                            -- ELABORA DISTINTA 
                            -- Aggiunge righe nuova distinta
                            -- Poi Crea nuova versione
                            SELECT drvImpt.IdArticolo AS IdArticolo, drvImpt.IdArticoloBase, drvImptQta.Qta,
                                drvImpt.numVrs, drvImptQta.NumQta, 1 AS FlgModificaVrs, 0 AS QtaPrec, 0 AS FlgPdm
                            FROM (
                                SELECT IdArticoloBase AS IdArticoloBase,
                                    MAX(espl.IdArticoloFgl) AS IdArticolo,
                                    COUNT(1) AS NumVrs
                                FROM TbArtDistEsplosaPdm espl
                                INNER JOIN TbXImptPdmArt anag ON espl.IdArticoloFgl = anag.IdArticolo 
                                WHERE espl.IdElabPadre = @IdElab
                                    AND Sem1 <> 3
                                GROUP BY IdArticoloBase
                                ) drvImpt
                            LEFT OUTER JOIN VstArtDistDetStd
                                ON VstArtDistDetStd.IdArticoloFgl = drvImpt.IdArticolo
                                    AND VstArtDistDetStd.IdArticolo = @IdArticoloElab
                            LEFT OUTER JOIN (
                                SELECT espl.IdArticoloFgl AS IdArticolo,
                                    SUM(espl.Qta) AS Qta,
                                    COUNT(1) AS NumQta
                                FROM TbArtDistEsplosaPdm espl
                                WHERE espl.IdElabPadre = @IdElab
                                    AND espl.Sem1 <> 3
                                GROUP BY espl.IdArticoloFgl
                                ) drvImptQta
                                ON drvImptQta.IdArticolo = drvImpt.IdArticolo
                            LEFT OUTER JOIN cte_dist TEMP
                                ON drvImpt.IdArticolo = TEMP.IdArticolo
                            WHERE VstArtDistDetStd.IdArticolo IS NULL
                                AND TEMP.IdArticolo IS NULL

                            UNION ALL

                            SELECT IdArticolo, IdArticoloBase, Qta, numVrs, NumQta, FlgModificaVrs, QtaPrec, FlgPdm
                            FROM cte_dist

                            
                            SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                            SET @PartialExecutionTime = SYSUTCDATETIME()

                            -- @If Se la distinta ha almeno un record

                            IF @@ROWCOUNT > 0
                                BEGIN
                                    SET @InfoArtLog = CONCAT(@InfoArtLog, @CrLf, '<tr><td style="text-align:left; width:25%; border: 1px solid; padding: 5px">', @LivelloStr, ' ', @IdArticoloElab, '</td><td style="text-align:left; width:25%; border: 1px solid; padding: 5px">', @DescArticolo, '</td><td style="text-align:left; border: 1px solid; padding: 5px">')

                                    -- @If Controllo che ci siano modifche di versione

                                    IF EXISTS (
                                            SELECT *
                                            FROM #tmpDistinta
                                            WHERE FlgModificaVrs = 1
                                        )
                                        BEGIN

                                            -- @step calcolo nuova versione di distinta

                                            SET @DistVer = (
                                                    -- dav 230321 Correzione calcolo MAX(DistVer) -> MAX(convert(int,DistVer))
                                                    -- SELECT MAX(DistVer)
                                                    SELECT MAX(CONVERT(int, DistVer))
                                                    FROM TbArtDist
                                                    WHERE IdArticolo = @IdArticoloElab
                                                        AND ISNUMERIC(DistVer) = 1
                                                    )
                                            SET @DistVer = ISNULL(@DistVer, 0) + 1

                                            IF LEN(@DistVer) = 1
                                                BEGIN
                                                    SET @DistVer = '0' + @DistVer
                                                END

                                            -- @step tolgo lo standard dalle altre distinte

                                            UPDATE TbArtDist
                                            SET DistStd = 0
                                            WHERE DistStd = 1
                                                AND IdArticolo = @IdArticoloElab

                                            -- @Inserisco la nuova distinta

                                            INSERT INTO TbArtDist (IdArticolo, DistVer, DistStd, SysDateCreate, SysUserCreate)
                                            VALUES (@IdArticoloElab, @DistVer, 1, GETDATE(), @SysUser)

                                            SELECT @IdArtDist = SCOPE_IDENTITY()

                                            SET @InfoArtLogTemp = CONCAT('Variazione di distinta rilevata, genera nuova versione (', @DistVer, ' - ', @IdArtDist, ')')

                                            UPDATE TS
                                            SET Valore = Valore + 1
                                            FROM #TmpStats TS
                                            INNER JOIN #tmpXImptPdmArt TXIPA
                                                ON TS.TipoStatistica = TXIPA.TipoExpert
                                            WHERE TS.DettaglioStatistica = 'Distinte revisionate'
                                                AND TXIPA.IdArticolo = @IdArticoloElab


                                            INSERT INTO TbArtDistDet (IdArtDist, IdArticoloFgl, NRiga, QtaPz, UnitM, CodFnzTipo, SysDateCreate, SysUserCreate)
                                            SELECT @IdArtDist,
                                                #tmpDistinta.IdArticolo,
                                                ROW_NUMBER() OVER (
                                                    ORDER BY #tmpDistinta.IdArticolo ASC
                                                    ) AS NRiga,
                                                -- dav 230309 Se articolo non più in disitnta mette qta a 0 se non è impianto eletrico
                                                CASE 
                                                    WHEN ISNULL(TbArticoli.IdCategoria, '') = 'GREL'
                                                        THEN Qta
                                                    WHEN ISNULL(NumVrs, 0) = 0
                                                        THEN 0
                                                    ELSE Qta
                                                    END,
                                                'PZ',
                                                CASE 
                                                    WHEN ISNULL(TbArticoli.IdCategoria, '') = 'GREL'
                                                        THEN NULL
                                                    WHEN ISNULL(NumVrs, 0) = 0
                                                        THEN 'ELMN'
                                                    WHEN ISNULL(NumVrs, 0) <> 1
                                                        THEN 'EVRS'
                                                    WHEN ISNULL(NumQta, 0) <> 1
                                                        THEN 'EQTA'
                                                    WHEN ISNULL(Qta, 0) < ISNULL(QtaPrec, 0)
                                                        THEN 'RMQTA'
                                                    END AS CodFnzTipo,
                                                GETDATE(),
                                                @SysUser
                                            FROM #tmpDistinta
                                            LEFT OUTER JOIN TbArticoli
                                                ON TbArticoli.IdArticolo = #tmpDistinta.IdArticolo


                                            -- @step Colora di rosso se PDM ha codici doppi in distinta o versioni diverse per stesso articolo

                                            UPDATE TbArtDistDetElab
                                            SET ColRiga = DBO.FncAdmDhColor('RED')
                                            FROM TbArtDistDetElab
                                            INNER JOIN TbArtDistDet
                                                ON TbArtDistDet.IdArtDistDet = TbArtDistDetElab.IdArtDistDet
                                            WHERE CodFnzTipo IN ('EVRS', 'EQTA', 'ELMN', 'RMQTA')
                                                AND TbArtDistDet.IdArtDist = @IdArtDist

                                            -- @vreo messaggio di errore, se c'è

                                            DECLARE @FlgErrTmp BIT = 0

                                            IF EXISTS (
                                                    SELECT 1
                                                    FROM TbArtDistDet
                                                    WHERE TbArtDistDet.IdArtDist = @IdArtDist
                                                    GROUP BY IdArticoloFgl
                                                    HAVING COUNT(1) > 1
                                                )
                                                BEGIN
                                                    SET @Msg = 'doppi'
                                                    SET @FlgErrTmp = 1
                                                END

                                            IF EXISTS (
                                                    SELECT CodFnzTipo
                                                    FROM TbArtDistDet
                                                    WHERE TbArtDistDet.IdArtDist = @IdArtDist
                                                        AND CodFnzTipo = 'EVRS'
                                                        AND CodFnzTipo IS NOT NULL
                                                )
                                                BEGIN
                                                    IF @FlgErrTmp = 1
                                                        SET @Msg = CONCAT(@Msg, ', con doppia versione')
                                                    ELSE
                                                        SET @Msg = 'con doppia versione'

                                                    SET @FlgErrTmp = 1
                                                END

                                            IF EXISTS (
                                                    SELECT CodFnzTipo
                                                    FROM TbArtDistDet
                                                    WHERE TbArtDistDet.IdArtDist = @IdArtDist
                                                        AND CodFnzTipo = 'EQTA'
                                                        AND CodFnzTipo IS NOT NULL
                                                    )
                                                BEGIN
                                                    IF @FlgErrTmp = 1
                                                        SET @Msg = CONCAT(@Msg, ', con doppia qta')
                                                    ELSE
                                                        SET @Msg = 'con doppia qta'

                                                    SET @FlgErrTmp = 1
                                                END

                                            IF EXISTS (
                                                    SELECT CodFnzTipo
                                                    FROM TbArtDistDet
                                                    WHERE TbArtDistDet.IdArtDist = @IdArtDist
                                                        AND CodFnzTipo = 'ELMN'
                                                        AND CodFnzTipo IS NOT NULL
                                                )
                                                BEGIN
                                                    IF @FlgErrTmp = 1
                                                        SET @Msg = CONCAT(@Msg, ', eliminati')
                                                    ELSE
                                                        SET @Msg = 'eliminati'

                                                    SET @FlgErrTmp = 1
                                                END

                                            IF EXISTS (
                                                    SELECT CodFnzTipo
                                                    FROM TbArtDistDet
                                                    WHERE TbArtDistDet.IdArtDist = @IdArtDist
                                                        AND CodFnzTipo IN ('RMQTA')
                                                        AND CodFnzTipo IS NOT NULL
                                                    )
                                                BEGIN
                                                    IF @FlgErrTmp = 1
                                                        SET @Msg = CONCAT(@Msg, ', con riduzione di qta')
                                                    ELSE
                                                        SET @Msg = 'con riduzione di qta'

                                                    SET @FlgErrTmp = 1
                                                END

                                            IF @FlgErrTmp = 1
                                                BEGIN
                                                    SET @Msg = CONCAT(@CrLf, '<h6 style="color:red">Attenzione errore</h6>Articoli ', @Msg, ' in distinta ', @IdArticoloElab, ' (', @IdArtDist, ')')
                                                    SET @InfoArtLogTemp = CONCAT(@InfoArtLogTemp, @Msg)
                                                    SET @InfoArtLogErr = CONCAT(@InfoArtLogErr, @Msg)


                                                    UPDATE TbArtElab
                                                    SET ColRiga = dbo.FncAdmDhColor('RED')
                                                    WHERE IdArticolo = @IdArticoloElab

                                                    UPDATE TbArticoli
                                                    SET CodFnzStato = 'T',
                                                        IdArtStato = 'ERR'
                                                    WHERE IdArticolo = @IdArticoloElab

                                                    EXECUTE dbo.StpUteMsg_Ins @Msg = @Msg,
                                                        @Msg1 = 'Import PDM',
                                                        @Param = @IdArticoloElab,
                                                        @CodFnzTipoMsg = 'ALR',
                                                        @SysUser = @SysUser,
                                                        @MsgObj = 'StpXImptPdm_Articolo'
                                                END

                                            -- @step Log modifche

                                           
                                            SET @InfoArtLog = CONCAT(@InfoArtLog, @InfoArtLogTemp)

                                            ----------------------------------------------------------------
                                            -- Logga le modifiche nella distinta
                                            ----------------------------------------------------------------

                                            EXECUTE dbo.StpDataLog @TipoDoc = 'TbArtDist',
                                                @dDoc = @IdArtDist,
                                                @ObjName = 'StpXImptPdm_Articolo',
                                                @DescLog = @InfoArtLogTemp,
                                                @SysUser = @SysUser
                                        END
                                    -- @else 
                                    ELSE 
                                        BEGIN

                                            SELECT @IdArtDist = IdArtDist
                                            FROM TbArtDist
                                            WHERE IdArticolo = @IdArticoloElab
                                                AND DistStd = 1
                                                AND Disabilita = 0

                                            SET @InfoArtLog = CONCAT(@InfoArtLog, 'Nessuna variazione di distinta (', @IdArtDist, ')')

                                            UPDATE TS
                                            SET Valore = Valore + 1
                                            FROM #TmpStats TS
                                            INNER JOIN #tmpXImptPdmArt TXIPA
                                                ON TS.TipoStatistica = TXIPA.TipoExpert
                                            WHERE TXIPA.IdArticolo = @IdArticoloElab
                                                AND TS.DettaglioStatistica = 'Distinte non revisionate'

                                        END

                                    -- @Endif

                                    UPDATE TbXImptPdmArtDist
                                    SET FlgModificaPdm = 0
                                    FROM TbXImptPdmArtDist
                                    INNER JOIN #tmpDistinta
                                        ON #tmpDistinta.IdArticolo = TbXImptPdmArtDist.IdArticoloFgl
                                    AND TbXImptPdmArtDist.IdArticolo = @IdArticoloElab

                                    SET @InfoArtLog = CONCAT(@InfoArtLog, '</td></tr>')
                                END
                            -- @else
                            ELSE 
                                BEGIN
                                    -- @setp loggo modifiche senza distinta
                                    SET @InfoArtLog = CONCAT(@InfoArtLog, @CrLf, '<tr><td style="text-align:left; width:25%; border: 1px solid; padding: 5px">', @LivelloStr, ' ', @IdArticoloElab, '</td><td style="text-align:left; width:25%; border: 1px solid; padding: 5px">', @DescArticolo, '</td><td style="text-align:left; border: 1px solid; padding: 5px">Articolo senza distinta</td></tr>')
                                END

                            -- @endif

                            SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                            SET @PartialExecutionTime = SYSUTCDATETIME()
                            
                            FETCH NEXT FROM db_cursor INTO @IdArticoloElab, @IdElab, @LivelloStr, @DescArticolo
                        END
                    
                    CLOSE db_cursor
                    DEALLOCATE db_cursor

                    SET @InfoArtLog = CONCAT(@InfoArtLog, '</tbody></table>')

                    -- @endloop

                    -- @EndSection


                    -- @Section Operazioni finali

                    SELECT @IdArtDist = IdArtDist
                    FROM TbArtDist
                    WHERE IdArticolo = @IdArticolo
                        AND DistStd = 1
                        AND Disabilita = 0

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()

                    -- @Step esplode distinta articolo
                    EXECUTE StpAdmElab_002_DistEsplosa 
                        @IdArticolo = @IdArticolo,
                        @IdArtDist = @IdArtDist,
                        @SysUser = @SysUser

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()

                    -- @Step Aggiorna descrizione estesa degli assiemi BUY
                    UPDATE TbArticoli
                    SET DescArticoloExt = CONCAT (
                            TbArticoli.DescArticolo,
                            @CrLf,
                            drv.DescDist
                            )
                    FROM TbArticoli
                    INNER JOIN (
                        SELECT TADE.IdArticolo,
                            CONCAT (
                                @CrLf,
                                'Distinta:',
                                @CrLf,
                                STRING_AGG(CONCAT (
                                        '-> ',
                                        TADE.IdArticoloFgl,
                                        ' - ',
                                        LEFT(REPLACE(TAAF.DescFinitura, '  ', ' '), 7),
                                        ' - ',
                                        TADE.Descrizione,
                                        ' - Qta: ',
                                        TADE.QtaTotPrgr
                                        ), @CrLf)
                                ) AS DescDist
                        FROM TbArtDistEsplosa TADE
                        INNER JOIN TbArticoli TA
                            ON TA.IdArticolo = TADE.IdArticolo
                        LEFT OUTER JOIN TbArticoli TAF
                            ON TAF.IdArticolo = TADE.IdArticoloFgl
                        LEFT OUTER JOIN TbArtAnagFiniture TAAF
                            ON TAF.IdFinitura = TAAF.IdFinitura
                        WHERE TA.IdCategoria = '20'
                            AND DistStd = 1
                            AND Livello = 1
                            AND TA.IdArticolo LIKE 'AC%'
                        GROUP BY TADE.IdArticolo
                        ) drv
                        ON TbArticoli.IdArticolo = drv.IdArticolo


                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()


                    -- @Step Aggiorna NoteTec con figlio dell'articolo
                    UPDATE TbArticoli
                    SET NoteTec = LEFT(drv.IdArticoloLeaf, 50)
                    FROM TbArticoli
                    INNER JOIN (
                        SELECT IdArticolo,
                            STRING_AGG(Leaf.IdArticoloFgl, ', ') AS IdArticoloLeaf
                        FROM TbArtDistEsplosa Esp
                        INNER JOIN (
                            SELECT IdArtDist,
                                IdArticoloFgl
                            FROM TbArtDistEsplosa
                            WHERE FlgLivelloUltimo = 1
                                AND IdElabPadre IS NOT NULL
                                AND IdArticoloFgl NOT LIKE '%-GZ'
                            ) Leaf
                            ON Esp.IdArtDist = Leaf.IdArtDist
                        WHERE DistStd = 1
                            AND Livello = 0
                            AND IdArticolo LIKE 'CO.%'
                            AND IdArticolo LIKE '%-GZ'
                        GROUP BY IdArticolo
                        ) drv
                        ON TbArticoli.IdArticolo = drv.IdArticolo


                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()


                    -- @step dav 230315 Setta a Fantasma per distinte articoli BUY
                    UPDATE TbArtDistDet
                    SET FlgFantasma = 1
                    FROM TbArtDistDet
                    INNER JOIN TbArtDist
                        ON TbArtDist.IdArtDist = TbArtDistDet.IdArtDist
                    INNER JOIN TbArticoli
                        ON TbArticoli.IdArticolo = TbArtDist.IdArticolo
                    INNER JOIN TbArtAnagCatgr
                        ON TbArticoli.IdCategoria = TbArtAnagCatgr.IdCategoria
                    WHERE TbArtAnagCatgr.DescCategoria LIKE '%B - Buy%'

                    
                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()

                    
                    -- @step Aggiorna distinta in listini fornitori
                    INSERT INTO TbDataLog (
                        IdDoc,
                        TipoDoc,
                        ObjName,
                        SysUserCreate,
                        DescLog
                        )
                    SELECT TbForArt.IdForArt AS IdDoc,
                        'TbForArt',
                        'StpXImptPdm_Articolo',
                        @SysUser,
                        left('Aggiornamento distinta su import ' + isnull(TbArtDist.DistVer, '--') + ' -> ' + isnull(drvDistStd.DistVer, '--'), 500)
                    FROM TbForArt
                    INNER JOIN (
                        SELECT IdArticolo,
                            IdArtDist,
                            DistVer
                        FROM TbArtDist
                        WHERE DistStd = 1
                        ) drvDistStd
                        ON drvDistStd.IdArticolo = TbForArt.IdArticolo
                    LEFT OUTER JOIN TbArtDist
                        ON TbArtDist.IdArtDist = TbForArt.IdArtDist
                    WHERE TbForArt.IdArtDist IS NOT NULL
                        AND isnull(TbForArt.IdArtDist, '') <> drvDistStd.IdArtDist

                    UPDATE TbForArt
                    SET IdArtDist = drvDistStd.IdArtDist,
                        RevisioneId = drvDistStd.RevisioneId,
                        SysUserUpdate = @SysUser,
                        SysDateUpdate = GETDATE()
                    FROM TbForArt
                    INNER JOIN (
                        SELECT TbArtDist.IdArticolo,
                            TbArtDist.IdArtDist,
                            TbArticoli.RevisioneId
                        FROM TbArtDist
                        INNER JOIN TbArticoli
                            ON TbArtDist.IdArticolo = TbArticoli.IdArticolo
                        WHERE DistStd = 1
                        ) drvDistStd
                        ON drvDistStd.IdArticolo = TbForArt.IdArticolo
                    WHERE TbForArt.IdArtDist IS NOT NULL
                        AND (isnull(TbForArt.IdArtDist, '') <> drvDistStd.IdArtDist 
                            OR ISNULL(TbForArt.RevisioneId, '') <> ISNULL(drvDistStd.RevisioneId, ''))

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()

                    UPDATE #TmpStats
                    SET Valore = NumTot
                    FROM #TmpStats
                    INNER JOIN (
                        SELECT TipoStatistica, SUM(Num) AS NumTot
                        FROM #TmpStats
                        INNER JOIN (
                            SELECT IdArticoloFgl, COUNT(1) AS Num, 
                                CASE 
                                    WHEN IdArticoloFgl LIKE '%-GZ'
                                        THEN 'GZ'
                                    WHEN CHARINDEX('.', IdArticoloFgl) > 1 
                                        THEN LEFT(IdArticoloFgl, CHARINDEX('.', IdArticoloFgl) - 1)
                                    ELSE 
                                        LEFT(IdArticoloFgl, PATINDEX('%[0-9]%', IdArticoloFgl) - 1)
                                END AS TipoExpert
                            FROM TbArtDistEsplosa
                            WHERE IdArticolo = @IdArticolo
                                AND IdArtDist = @IdArtDist
                                AND IdArticoloFgl NOT LIKE '%-LAV'
                                AND ISNULL(QtaTotPrgr, 0) > 0
                            GROUP BY IdArticoloFgl
                        ) drv 
                            ON drv.TipoExpert = #TmpStats.TipoStatistica
                        WHERE DettaglioStatistica = 'Totale in macchina'
                        GROUP BY TipoStatistica
                    ) drv2 ON #TmpStats.TipoStatistica = drv2.TipoStatistica
                        AND DettaglioStatistica = 'Totale in macchina'

                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @PartialExecutionTime, SYSUTCDATETIME())
                    SET @PartialExecutionTime = SYSUTCDATETIME()

                    -------------------------------------
                    -- Registra StpCmdLog
                    -------------------------------------
                    DECLARE @DescLogSnt NVARCHAR(200)
                    SET @DescLogSnt = CONCAT('Import articolo ', @IdArticolo)
                    SET @ExecutionTime = DATEDIFF(MILLISECOND, @StartExecutionTime, SYSUTCDATETIME())

                    EXECUTE dbo.StpCmdLog 
                        @ProcedureName = 'StpXImptPdm_Articolo',
                        @StartExecutionTime = @StartExecutionTime,
                        @DescLog = @DescLogSnt,
                        @FlgErr = 0,
                        @SysUser = @SysUser


                    DECLARE @InfoStat VARCHAR(MAX)
                    SELECT @InfoStat = CONCAT(CHAR(13) + CHAR(10), STRING_AGG(CONCAT('<tr><td style="text-align:center; border: 1px solid; padding: 5px">', DescTipo, '</td>', [Desc], '</tr>'), ''))
                    FROM (
                        SELECT TOP 100 DescTipo, STRING_AGG(CONCAT('<td style="text-align:center; border: 1px solid; padding: 5px">', Valore, '</td>'), '') AS [Desc]
                        FROM (SELECT TOP 100 DescTipo, Valore, ID FROM #TmpStats ORDER BY ID) drv
                        GROUP BY DescTipo
                        ORDER BY MIN(ID)
                    ) drv

                    SET @InfoStat = CONCAT(
                        '<table style="border-collapse: collapse; text-align:center">',
                        '<caption style="caption-side:top; text-align:left"><b>RIEPILOGO CONTEGGIO ARTICOLI:</b></caption>',
                        '<thead>',
                        '<tr><th style="padding: 10px; border: 1px solid" rowspan="2">Tipo</th><th style="padding: 10px; border: 1px solid" colspan="2">Anagrafiche</th><th style="padding: 10px; border: 1px solid" colspan="2">Distinte</th><th style="padding: 10px; border: 1px solid" rowspan="2">Totale in macchina</th></tr>',
                        '<tr><th style="padding: 10px; border: 1px solid">Inserite</th><th style="padding: 10px; border: 1px solid">Modificate</th><th style="padding: 10px; border: 1px solid">Revisionate</th><th style="padding: 10px; border: 1px solid">Non revisionate</th></tr>',
                        '</thead>',
                        '<tbody>',
                        @InfoStat, 
                        '</tbody>',
                        '</table></br></br>'
                    )


                    IF @InfoArtLogErr IS NULL
                        BEGIN 
                            SET @InfoArtLog = CONCAT('<h4>IMPORTAZIONE COMPLETATA SENZA ERRORI </h4>', @CrLf, @InfoStat, @CrLf, @InfoArtLog, @CrLf, '<h4>IMPORTAZIONE COMPLETATA SENZA ERRORI </h4>')
                        END
                    ELSE
                        BEGIN
                            SET @InfoArtLog = CONCAT('<h4>## ERRORI IN IMPORTAZIONE ##</h4>', @CrLf, @InfoStat, @InfoArtLogErr, @CrLf, @InfoArtLog, @CrLf, '<h4>## ERRORI IN IMPORTAZIONE ##</h4>', @CrLf, @InfoArtLogErr)
                        END

                    -- @EndSection

                    -- SET @InfoArtLog = REPLACE(@InfoArtLog, @CrLf, '</br>')
                    
                    DECLARE @IdAttivitaTipo AS NVARCHAR(20)

                    SELECT @IdAttivitaTipo = IdAttivitaTipo
                    FROM TbAttAnagTipo
                    WHERE CodFnz = 'BATCH'

                    INSERT INTO TbAttivita (TipoDoc, IdDoc, DataAttivita, IdAttivitaTipo, DescAttivita, NoteAttivita, IdUtente, IdUtenteDest, FlgAperta, SysDateCreate, SysUserCreate)
                    VALUES ( 'TbArticoli', @IdArticolo, GETDATE(), @IdAttivitaTipo, 'Import PDM ' + @IdArticolo, @InfoArtLog, 'CYBE', @SysUser, 1, GETDATE(), 'CYBE')

                    DECLARE @IdMail INT
                    DECLARE @MailFrom NVARCHAR(300) = 'acquisti@expert-srl.com'
                    DECLARE @MailTo NVARCHAR(300) = 'ut@expert-srl.com'
                    DECLARE @Oggetto NVARCHAR(300) = CONCAT('IMPORTAZIONE MACCHINA ', @IdArticolo)
                    DECLARE @TestoMail NVARCHAR(MAX) = @InfoArtLog
                    DECLARE @TipoDoc NVARCHAR(300) = 'TbArticoli'

                    EXECUTE StpMail_KyIns @IdMail = @IdMail OUT,
                        @IdUtente = @SysUser,
                        @MailFrom = @MailFrom,
                        @MailTo = @MailTo,
                        @Oggetto = @Oggetto,
                        @TestoMail = @TestoMail,
                        @TipoDoc = @TipoDoc,
                        @IdDoc = @IdArticolo,
                        @SysUserCreate = @SysUser

                    DECLARE @Url NVARCHAR(MAX) = CONCAT('SendMail?IdMail=', @IdMail)

                    -- SQL Server Managed Instance
                    EXEC StpAdmDhWebRequestConnect @Url,
                        @SysUser,
                        @KYRequest OUT


                    -------------------------------
                    -- Richiamo DboC per disegni --
                    -------------------------------
                    DECLARE @Json NVARCHAR(MAX)
                    DECLARE @OpsJson NVARCHAR(MAX)
                    DECLARE @UrlConnect NVARCHAR(MAX)
                    DECLARE @ServiceName NVARCHAR(100) = 'service01' --nome del service che compie l'operazione di scrivere il file in locale
                     DECLARE @stpCallBack NVARCHAR(100) = 'StpArtDoc_ImptExec' -- nome della STP di ritorno che riceverà il JSON con l'array della lista file
                    
                    SET @Json = '{"serviceName":""}'

                    SELECT @UrlConnect = AdmURLConnect
                    FROM TbSetting

                    IF (RIGHT(@UrlConnect, 1) <> '/')
                        SET @UrlConnect = @UrlConnect + '/'

                    
                    SET @Json = '{"serviceName":""}'

                        --1° param: parametro di ricerca (tutti: *.*; solo pdf: *.pdf); 2° param: se cercare in tutte le cartelle (AllDirectories) oppure solo in quella superiore (TopDirectory)
                    SET @OpsJson = (
                            SELECT op, source, stpCallBack, optParams
                            FROM (
                                SELECT 'dir' AS op, PercorsoFile AS source, @stpCallBack AS stpCallBack, JSON_QUERY('["' + CONCAT(FiltroFile, '*.*') + '","TopDirectory"]') AS optParams
                                FROM #tmpXImptPdmArt TXIPA
                                INNER JOIN TbArticoli TA
                                    ON TXIPA.IdArticolo = TA.IdArticolo

                                UNION -- importante non UNION ALL

                                -- Carico disegni dello speculare se esiste
                                SELECT 'dir' AS op, REPLACE(REPLACE(TXIPA.[PATH], 'G:', '\\Srvexpert\Uff.tecnico1'), '\02\', '\01\') AS source, @stpCallBack AS stpCallBack, 
                                    JSON_QUERY('["' + CONCAT(REPLACE(NOME_FILE, '00002-', '00001-'), '*.*') + '","TopDirectory"]') AS optParams
                                FROM #tmpXImptPdmArt TXIPA
                                WHERE IdArticolo LIKE 'CO%.000.02-%'
                            ) drv
                            FOR JSON AUTO
                        )

                    --modifica nome servizio che deve eseguire le operazioni
                    SET @Json = (JSON_MODIFY(@Json, '$.serviceName', @ServiceName))
                    SET @Json = (JSON_MODIFY(@Json, '$.opsList', JSON_QUERY(@OpsJson)))

                    
                    SET @Url = @UrlConnect + 'DboConnect/'

                    EXEC StpAdmDhWebRequest @UrlConnect, 'ExecuteFileSystemOperations', 'POST', 'application/json', NULL, @Json, 1800, 'cybe', @KYRequest OUT
                COMMIT TRANSACTION
            END TRY
            BEGIN CATCH
                ROLLBACK TRANSACTION

                SET @MsgExt = ERROR_MESSAGE()
			    SET @Msg1 = 'Errore Stp'

		
                INSERT INTO TbAttivita (TipoDoc, IdDoc, DataAttivita, IdAttivitaTipo, DescAttivita, NoteAttivita, NoteEsito, IdUtente, IdUtenteDest, FlgAperta, SysDateCreate, SysUserCreate)
                VALUES ('TbArticoli', @IdArticolo, GETDATE(), @IdAttivitaTipo, 'Errore Import PDM ' + @IdArticolo, @InfoArtLog, @MsgExt, 'CYBE', @SysUser, 1, GETDATE(), 'CYBE')

                -------------------------------------
                -- Messaggio
                -------------------------------------
                EXECUTE dbo.StpUteMsg @Msg = @Msg,
                    @Msg1 = @Msg1,
                    @MsgObj = @MsgObj,
                    @Param = @PrInfo,
                    @CodFnzTipoMsg = 'ALR',
                    @SysUser = @SysUser,
                    @KYStato = @KYStato,
                    @KYRes = @KYRes,
                    @KYInfoEst = @MsgExt,
                    @KyMsg = @KyMsg OUTPUT

                SET @KYStato = - 4
            END CATCH

            RETURN
        END

    -------------------------------------
    -- @EndState
	-------------------------------------
	-------------------------------------
	-- @State 1 @Res 0 Annullamento operazione
	-------------------------------------
	IF @KYStato = 1
		AND @KYRes = 0
        BEGIN
            SET @Msg1 = 'Operazione annullata'

            EXECUTE dbo.StpUteMsg @Msg = @Msg,
                @Msg1 = @Msg1,
                @MsgObj = @MsgObj,
                @Param = @PrInfo,
                @CodFnzTipoMsg = 'WRN',
                @SysUser = @SysUser,
                @KYStato = @KYStato,
                @KYRes = @KYRes,
                @KyMsg = @KyMsg OUTPUT

            SET @KYStato = - 4

            RETURN
        END
    END
    -------------------------------------
    -- @EndState
	-------------------------------------
GO
