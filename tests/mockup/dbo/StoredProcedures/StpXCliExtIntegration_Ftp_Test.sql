-- ==========================================================================================
-- Entity Name:   StpXCliExtIntegration_Ftp_Test
-- Author:        FRA
-- Create date:   230330
-- Custom_Dbo:    NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   Richiamata da DboC per integrazione FTP.
-- History:       
-- FRA 230330 Creazione
-- ==========================================================================================

CREATE Procedure [dbo].[StpXCliExtIntegration_Ftp_Test]
(
	@IdCliente INT,
    @FileRawContent NVARCHAR(MAX),
    @FileJsonContent NVARCHAR(MAX),    -- Contenuto del File dopo parsing JSON di DboC
    @FileName NVARCHAR(MAX),
    @FileExtension NVARCHAR(10),
    @SysUser NVARCHAR(256)
)

AS
BEGIN

-- Return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla
-- Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question

SET NOCOUNT ON

BEGIN

	-------------------------------------
	-- Esegue il comando
	-------------------------------------
	BEGIN TRY
		BEGIN TRANSACTION
            /*INSERT INTO TbLog (DataLog, TipoLog, NoteLog)
                VALUES(GETDATE(), 'SFTPD' , @FileJsonContent)*/
            
            -- Variabili per creare Ordine
            DECLARE @PurchaseOrderNumber AS NVARCHAR(30)
            DECLARE @PoDate AS DATE
            DECLARE @Buyer AS NVARCHAR(50)
            DECLARE @NotePurchaseOrder AS NVARCHAR(MAX)
            
            -- Variabili per creare Righe d'Ordine
            DECLARE @Line AS INT
            DECLARE @Item AS NVARCHAR(50)
            DECLARe @Quantity AS DECIMAL(18,8)
            DECLARE @UnitPrice AS MONEY
            DECLARE @UnitMeasure AS NVARCHAR(3)
            DECLARE @LineNotes AS NVARCHAR(MAX)
            DECLARE @RevisionNotes AS NVARCHAR(MAX)

            -- Variabili per la Creazione Ordine DBO
            DECLARE @IdCliOrd NVARCHAR(20)
            DECLARE @IdCausale NVARCHAR(20)
            DECLARE @KYStato INT
            DECLARE @KYMsg NVARCHAR(max)
            DECLARE @IdContatto INT

            -- Variabili per la Creazione Righe d'Ordine DBO
            DECLARE @IdArticolo NVARCHAR(50)
            DECLARE @IdCliOrdDet INT
            DECLARE @NoteOdl NVARCHAR(MAX)

            -- Inserisco in tabelle temporanee i dati del JSON
			CREATE TABLE #TmpJsonOrder
			(Field NVARCHAR(MAX), FieldValue NVARCHAR(MAX), FieldType INT)

			CREATE TABLE #TmpJsonOrderLine
			(Field NVARCHAR(MAX), FieldValue NVARCHAR(MAX), FieldType INT)

			INSERT INTO #TmpJsonOrder
			SELECT * FROM OPENJSON(@FileJsonContent, N'$.PurchaseOrder') 

			INSERT INTO #TmpJsonOrderLine
			SELECT * FROM OPENJSON(@FileJsonContent, N'$.PurchaseOrder.PurchaseOrderLine');

			INSERT INTO #TmpJsonOrderLine
			SELECT * FROM OPENJSON(@FileJsonContent, N'$.PurchaseOrder.PurchaseOrderLine.UnitPrice');

            -- Recupero i campi per creare l'ordine
			SELECT @PurchaseOrderNumber = FieldValue FROM #TmpJsonOrder
			WHERE Field = 'PurchaseOrderNumber'

            SELECT @PoDate = FieldValue FROM #TmpJsonOrder
			WHERE Field = 'poDate'

            SELECT @Buyer = FieldValue FROM #TmpJsonOrder
			WHERE Field = 'Buyer'

            SELECT @NotePurchaseOrder = FieldValue FROM #TmpJsonOrder
			WHERE Field = 'NotePurchaseOrder'

            -- Recupero i campi per creare le righe d'ordine
            SELECT @Line = FieldValue FROM #TmpJsonOrderLine
			WHERE Field = 'Line'

            SELECT @Item = FieldValue FROM #TmpJsonOrderLine
			WHERE Field = 'Item'

            SELECT @Quantity = FieldValue FROM #TmpJsonOrderLine
			WHERE Field = 'Quantity'

            -- Non Serve al momento, viene recuperato da Listino
            --SELECT @UnitPrice = FieldValue FROM #TmpJsonOrderLine
			--WHERE Field = 'UnitPrice'

            SELECT @UnitMeasure = FieldValue FROM #TmpJsonOrderLine
			WHERE Field = 'UnitMeasure'

            SELECT @LineNotes = FieldValue FROM #TmpJsonOrderLine
			WHERE Field = 'LineNotes'

            SELECT @RevisionNotes = FieldValue FROM #TmpJsonOrderLine
			WHERE Field = 'RevisionNotes'

            EXECUTE StpCliOrd_KyIns 
                @IdCliOrd = @IdCliOrd OUT,
	            @IdCliente = @IdCliente,
                @FlgAut = 1, -- Flag di generazione automatica da codice
	            @SysUserCreate = @SysUser,
	            @IdCausale = 'GVEN',  -- Mettiamo Fissa
	            @KYStato = @KYStato OUT,
                @KYMsg = @KYMsg OUT,
	            @KYRes = NULL

            -- Recupero contatto a partire dal nome cognome del contatto
            -- Provo, altrimenti prendo il primo che recupero
            SELECT @IdContatto = IdContatto 
                FROM VstContatti 
                WHERE TipoDoc = 'TbClienti' AND IdDoc = @IdCliente
                AND (Cognome + ' ' + Nome = @Buyer OR Nome + ' ' + Cognome = @Buyer)

            IF (@IdContatto IS NULL)
            BEGIN
                SELECT TOP(1) @IdContatto = IdContatto 
                FROM VstContatti 
                WHERE TipoDoc = 'TbClienti' AND IdDoc = @IdCliente
            END

            UPDATE TbCliOrd
                SET  
                    DescRifCliOrd = @PurchaseOrderNumber,
                    DataRicCliOrd = @PoDate,
                    IdContatto = @IdContatto,
                    NoteCliOrd = @NotePurchaseOrder,
                    IdLingua = 'EN',
                    IdUtente = NULL
                WHERE IdCliOrd = @IdCliOrd

            -- Prendo Articolo da Listino Cliente
            SELECT @IdArticolo = IdArticolo FROM VstCliArtListini
            WHERE IdCliente = @IdCliente AND ClienteArt = @Item

            SET @NoteOdl = ISNULL(@LineNotes, '') + ' - ' + ISNULL(@RevisionNotes, '')

            --INSERT INTO TbLog
            --(DataLog, TipoLog, NoteLog)
            --VALUES
            --(GETDATE(), 'TEK', @Line + ' - ' + @Quantity + ' - ' + @NoteOdl + ' - ' + @IdCliOrd + ' - ' + @IdArticolo + ' - ' + @SysUser)
            --(GETDATE(), 'TEK', CONVERT(NVARCHAR(10), @Line))
            
            EXECUTE StpCliOrdDet_KyIns 
                @IdCliOrdDet = @IdCliOrdDet OUT,
                --@NRiga = @Line,
                @Qta = @Quantity,
                --@NoteOdl = @NoteOdl,
                @NoteCliOrdDet = @NoteOdl,
                @IdCliOrd = @IdCliOrd,
                @IdArticolo = @IdArticolo,
                @SysUserCreate = @SysUser,
                @RifPosCli = @Line
 

            -- INSERISCO IN TbDocumenti il file XML
            -- Se il nome inizia con / toglilo per pulizia del nome file
            DECLARE @CharControl AS NVARCHAR(1)
            SET @CharControl = SUBSTRING(@FileName, 1, 1)
            
            IF (@CharControl = '/')
            BEGIN
                SET @FileName =SUBSTRING(@FileName, 2, LEN(@FileName))
            END

            INSERT INTO TbDocumenti
            (TipoDoc, IdDoc, Descrizione, ExtDoc, Documento, SysDateCreate, SysUserCreate)
            VALUES
            ('TbCliOrd', @IdCliOrd, @FileName, @FileExtension, CONVERT(VARBINARY(MAX), @FileRawContent), GETDATE(), @SysUser)
			
		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		-------------------------------------
		-- Gestione CATCH
		-------------------------------------

		ROLLBACK TRANSACTION
        DECLARE @Msg AS NVARCHAR(MAX)
        DECLARE @Msg1 AS NVARCHAR(MAX)
        DECLARE @MsgObj AS NVARCHAR(MAX)
        DECLARE @PrInfo AS NVARCHAR(MAX)
        DECLARE @KYRes INT

        Declare @MsgExt as nvarchar(max)
		SET @MsgExt= ERROR_MESSAGE()
		SET @Msg1= 'Errore Stp'

		EXECUTE StpUteMsg	@Msg, @Msg1,@MsgObj, @PrInfo ,'ALR',@SysUser,
			@KYStato,@KYRes,@MsgExt,null,@KYMsg OUT
		SET @KYStato = -4
	END CATCH

	RETURN
END
END


/***************************************
 ParamCtrl
 ***************************************
<ParamCtrl><ParamCtrlKy  Name="StpName" Value="StpCliExtIntegration_Ftp" Type="string" Passo="1" Description="StpName:"/><ParamCtrlKy  Name="StpCmdTitolo" Value="Integrazione FTP per EDI Clienti" Type="string" Passo="1" Description="Titolo:"/><ParamCtrlKy  Name="StpCmdDesc" Value="Richiama DboC per integrazione FTP. Legge dati su FTP del Cliente e richiama stored procedure personalizzata" Type="string" Passo="1" Description="Descrizione:"/><ParamCtrlKy  Name="StpParamKey" Value="Id" Type="string" Passo="1" Description="Parametro Key IN (Se presente, senza @):"/><ParamCtrlKy  Name="StpParamKeyType" Value="INT" Type="string" Passo="1" Description="Tipo SQL:"/><ParamCtrlKy  Name="StpMsgConferma" Value="Confermi l'operazione?" Type="string" Passo="1" Description="Messaggio Conferma:"/><ParamCtrlKy  Name="StpMsgOk" Value="Operazione Completata" Type="string" Passo="1" Description="Messaggio OK:"/><ParamCtrlKy  Name="StpMsgCancel" Value="Operazione Annullata" Type="string" Passo="1" Description="Messaggio Annulla:"/></ParamCtrl>
***************************************/

GO

