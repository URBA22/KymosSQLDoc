CREATE TABLE [dbo].[TbOdl] (
    [IdOdl]          NVARCHAR (20)    NOT NULL,
    [DataOdl]        DATE             NULL,
    [DataInoltroDoc] DATE             NULL,
    [DataProd]       DATE             NULL,
    [IdReparto]      NVARCHAR (20)    NULL,
    [NoteOdl]        NVARCHAR (MAX)   NULL,
    [BlocDoc]        BIT              CONSTRAINT [DF_TbOdl_BlocDoc] DEFAULT ((0)) NOT NULL,
    [DataFinePrev]   DATE             NULL,
    [IdCausaleOdl]   NVARCHAR (20)    NULL,
    [IdMage]         NVARCHAR (10)    NULL,
    [IdMage1]        NVARCHAR (10)    NULL,
    [MagePosiz]      NVARCHAR (20)    NULL,
    [MagePosiz1]     NVARCHAR (20)    NULL,
    [GenIdDoc]       NVARCHAR (20)    NULL,
    [GenIdDocDet]    INT              NULL,
    [GenDocTipo]     NVARCHAR (20)    NULL,
    [StatoDoc]       INT              NULL,
    [CodFnzStato]    NVARCHAR (5)     NULL,
    [IdSUID]         UNIQUEIDENTIFIER NULL,
    [SysDateCreate]  DATETIME         CONSTRAINT [DF_TbOdl_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate]  NVARCHAR (256)   NULL,
    [SysDateUpdate]  DATETIME         NULL,
    [SysUserUpdate]  NVARCHAR (256)   NULL,
    [SysRowVersion]  ROWVERSION       NULL,
    [CmpOpz01]       NVARCHAR (50)    NULL,
    [CmpOpz02]       NVARCHAR (50)    NULL,
    [CmpOpz03]       NVARCHAR (50)    NULL,
    CONSTRAINT [PK_TbOdl] PRIMARY KEY CLUSTERED ([IdOdl] ASC),
    CONSTRAINT [FK_TbOdl_TbMageAnag] FOREIGN KEY ([IdMage]) REFERENCES [dbo].[TbMageAnag] ([IdMage]),
    CONSTRAINT [FK_TbOdl_TbMageAnag1] FOREIGN KEY ([IdMage1]) REFERENCES [dbo].[TbMageAnag] ([IdMage]),
    CONSTRAINT [FK_TbOdl_TbOdlAnagCausali] FOREIGN KEY ([IdCausaleOdl]) REFERENCES [dbo].[TbOdlAnagCausali] ([IdCausaleOdl]),
    CONSTRAINT [FK_TbOdl_TbProdReparti] FOREIGN KEY ([IdReparto]) REFERENCES [dbo].[TbProdReparti] ([IdReparto])
);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdl_2]
    ON [dbo].[TbOdl]([GenIdDoc] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdl_3]
    ON [dbo].[TbOdl]([GenIdDocDet] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdl]
    ON [dbo].[TbOdl]([SysDateCreate] DESC);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdl_1]
    ON [dbo].[TbOdl]([GenDocTipo] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'TRIGGER', @level2name = N'TrOdl_Elab';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'TRIGGER', @level2name = N'TrOdl_Elab';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'TRIGGER', @level2name = N'TrOdl_Elab';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'TRIGGER', @level2name = N'TrOdl_Elab';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '06/09/2013 19:07:00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'TRIGGER', @level2name = N'TrOdl_Elab';


GO

-- =============================================
-- Author:		Dav
-- Create date: 01/03/13
-- Description: Crea record su tabella elab
-- =============================================
CREATE TRIGGER [dbo].[TrOdl_Elab]
   ON  dbo.TbOdl 
   AFTER INSERT  
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO TbOdlElab (IdOdl)
	SELECT     IdOdl
	FROM  Inserted 

END

GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'TRIGGER', @level2name = N'TrOdl_Mage';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'TRIGGER', @level2name = N'TrOdl_Mage';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'TRIGGER', @level2name = N'TrOdl_Mage';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '06/09/2013 19:07:00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'TRIGGER', @level2name = N'TrOdl_Mage';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'TRIGGER', @level2name = N'TrOdl_Mage';


GO


-- ==========================================================================================
-- Entity Name:   TrOdl_Mage
-- Author:        Dav
-- Create date:   14/02/2013 21:23
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   This stored procedure is intended for inserting values to table
-- History:
-- dav 28.02.18 Aggiunta test FlgCostoSuCommessa
-- dav 11.04.18 Gesione mage prelievo distinta se CL Cliente
-- dav 21.07.19 Gestione mage tipo CF su mage1 vrt (TrOdlDetRegQta_Mage_13, TrOdlDetRegQta_Mage_14)
-- dav 21.07.19 Ottimizzazione parametri TrOdlDetDist_Mage_01,TrOdlDetDist_Mage_02 per gesitone cl
-- dav 21.07.19 Gestione carico mage1 con gestione cl TrOdlDetRegQta_Mage_11,TrOdlDetRegQta_Mage_12
-- dav 200506 Ottimizzaiozione con controllo su cambio causale anche su Mage1
-- dav 201230 Sostituito X -> NULL da FncKeyMage
-- dav 221227 Formattazione
-- sim 221230 Aggiunto IdArtVrt
-- dav 230306 Gestione OL
-- dav 230328 Gestione FncKeyMage1
-- ==========================================================================================
CREATE TRIGGER [dbo].[TrOdl_Mage] ON [dbo].[TbOdl]
AFTER UPDATE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--IF NOT( UPDATE (IdMage) OR UPDATE (IdMage1) OR UPDATE (MagePosiz) or UPDATE (MagePosiz1) or UPDATE (IdCausleOdl)) )
	--	BEGIN
	--		RETURN
	--	END
	-- Note
	-- Il trigger non può essere controllato con if update(nomecampo) perchè la stp aggiorna tutto
	-- per evitare aggiornamenti per ogno modifica serve join su inserted e delete su campi critici
	-- per eviare azioni impreviste su Cambio codice serve join tra insert e delete su idOdl
	/*******************************************
	 * Aggiorna i contatori di magazzino Mage
	 * Magazzino di prelievo
	 *******************************************/
	BEGIN
		-- toglie dist
		-- test dav 16.03.15
		INSERT INTO TbMageMov (
			InfoMov,
			TipoDoc,
			IdDoc,
			IdDocDet,
			IdArticolo,
			KeyMage,
			IdMage,
			Qta,
            IdArtVrt,
			MagePosiz
			)
		SELECT 'TrOdlDetDist_Mage_01',
			'TbOdl' AS TipoDoc,
			Deleted.IdOdl,
			TbOdlDetDist.IdOdlDetDist,
			TbOdlDetDist.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente), 'C', 'ODL', Deleted.IdOdl, TbOdlDet.IdOdlDet, COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, TbOdlDet.IdMage, Deleted.IdMage, '000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN Deleted.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, TbOdlDet.IdMage, Deleted.IdMage, '000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, TbOdlDet.IdMage, Deleted.IdMage, '000') AS IdMage,
			-- ROUND(( TbOdlDetDist.QtaMageMov * TbOdlDetRegQta.QtaMageMovProdScr)   , 4) AS QtaMov,
			CASE 
				WHEN IsNull(dbo.TbOdlAnagCausaliCosti.FlgCostoSuCommessa, 0) = 0
					THEN ROUND(dbo.TbOdlDetDist.QtaMageMov * TbOdlDetRegQta.QtaMageMovProdScr, 4)
				ELSE ROUND(dbo.TbOdlDetDist.QtaMageMov, 4)
				END AS QtaMov,
            TbOdlDetDist.IdArtVrt,
			COALESCE(TbOdlDetDist.MagePosiz, TbOdlDet.MagePosiz, Deleted.MagePosiz) AS MagePosiz
		FROM TbOdlDet
		INNER JOIN Deleted
			ON TbOdlDet.IdOdl = Deleted.IdOdl
		INNER JOIN TbOdlDetRegQta
			ON TbOdlDet.IdOdlDet = TbOdlDetRegQta.IdOdlDet
		INNER JOIN TbOdlAnagCausali
			ON Deleted.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbOdlDetDist
			ON TbOdlDet.IdOdlDet = TbOdlDetDist.IdOdlDet
		LEFT OUTER JOIN dbo.TbOdlAnagCausaliCosti
			ON dbo.TbOdlDetDist.IdCausaleCosto = dbo.TbOdlAnagCausaliCosti.IdCausaleCosto
		LEFT OUTER JOIN (
			SELECT IdOdlDetDist,
				MAX(IdMage1) AS IdMage1Vrsm
			FROM dbo.TbOdlDetDistVrsm AS TbOdlDetDistVrsm_1
			GROUP BY IdOdlDetDist
			) AS drvVrsm
			ON TbOdlDetDist.IdOdlDetDist = drvVrsm.IdOdlDetDist
		INNER JOIN TbMageAnag
			ON COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, TbOdlDet.IdMage, Deleted.IdMage, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN inserted
			ON inserted.IdOdl = deleted.IdOdl
				AND ISNULL(inserted.IdMage, '') = ISNULL(deleted.IdMage, '')
				AND ISNULL(inserted.MagePosiz, '') = ISNULL(deleted.MagePosiz, '')
				AND ISNULL(inserted.IdCausaleOdl, '') = ISNULL(deleted.IdCausaleOdl, '')
		WHERE (inserted.IdOdl IS NULL)
			AND (TbOdlDetDist.IdArticolo IS NOT NULL)
			AND (TbOdlDetDist.FlgNoMovMag = 0)
			AND (TbOdlDetDist.FlgGrpVirtuale = 0)
			AND (
				TbOdlAnagCausali.FlgMovMag = 1
				OR COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, TbOdlDet.IdMage, Deleted.IdMage) IS NOT NULL
				)

		-- aggiunge dist
		-- test dav 16.03.15
		INSERT INTO TbMageMov (
			InfoMov,
			TipoDoc,
			IdDoc,
			IdDocDet,
			IdArticolo,
			KeyMage,
			IdMage,
			Qta,
            IdArtVrt,
			MagePosiz
			)
		SELECT 'TrOdlDetDist_Mage_02',
			'TbOdl' AS TipoDoc,
			Inserted.IdOdl,
			TbOdlDetDist.IdOdlDetDist,
			TbOdlDetDist.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente), 'C', 'ODL', Inserted.IdOdl, TbOdlDet.IdOdlDet, COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, TbOdlDet.IdMage, Inserted.IdMage, '000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,	
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN Inserted.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, TbOdlDet.IdMage, Inserted.IdMage, '000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, TbOdlDet.IdMage, Inserted.IdMage, '000') AS IdMage,
			-- - ROUND(( TbOdlDetDist.QtaMageMov * TbOdlDetRegQta.QtaMageMovProdScr)   , 4) AS QtaMov,
			CASE 
				WHEN IsNull(dbo.TbOdlAnagCausaliCosti.FlgCostoSuCommessa, 0) = 0
					THEN - ROUND(dbo.TbOdlDetDist.QtaMageMov * TbOdlDetRegQta.QtaMageMovProdScr, 4)
				ELSE - ROUND(dbo.TbOdlDetDist.QtaMageMov, 4)
				END AS QtaMov,
            TbOdlDetDist.IdArtVrt,
			COALESCE(TbOdlDetDist.MagePosiz, TbOdlDet.MagePosiz, Inserted.MagePosiz) AS MagePosiz
		FROM TbOdlDet
		INNER JOIN Inserted
			ON TbOdlDet.IdOdl = Inserted.IdOdl
		INNER JOIN TbOdlDetRegQta
			ON TbOdlDet.IdOdlDet = TbOdlDetRegQta.IdOdlDet
		INNER JOIN TbOdlAnagCausali
			ON Inserted.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbOdlDetDist
			ON TbOdlDet.IdOdlDet = TbOdlDetDist.IdOdlDet
		LEFT OUTER JOIN dbo.TbOdlAnagCausaliCosti
			ON dbo.TbOdlDetDist.IdCausaleCosto = dbo.TbOdlAnagCausaliCosti.IdCausaleCosto
		LEFT OUTER JOIN (
			SELECT IdOdlDetDist,
				MAX(IdMage1) AS IdMage1Vrsm
			FROM dbo.TbOdlDetDistVrsm AS TbOdlDetDistVrsm_1
			GROUP BY IdOdlDetDist
			) AS drvVrsm
			ON TbOdlDetDist.IdOdlDetDist = drvVrsm.IdOdlDetDist
		INNER JOIN TbMageAnag
			ON COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, TbOdlDet.IdMage, Inserted.IdMage, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN deleted
			ON inserted.IdOdl = deleted.IdOdl
				AND ISNULL(inserted.IdMage, '') = ISNULL(deleted.IdMage, '')
				AND ISNULL(inserted.MagePosiz, '') = ISNULL(deleted.MagePosiz, '')
				AND ISNULL(inserted.IdCausaleOdl, '') = ISNULL(deleted.IdCausaleOdl, '')
		WHERE (deleted.IdOdl IS NULL)
			AND (TbOdlDetDist.IdArticolo IS NOT NULL)
			AND (TbOdlDetDist.FlgNoMovMag = 0)
			AND (TbOdlDetDist.FlgGrpVirtuale = 0)
			AND (
				TbOdlAnagCausali.FlgMovMag = 1
				OR COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, TbOdlDet.IdMage, Deleted.IdMage) IS NOT NULL
				)
	END

	/*******************************************
	 * Aggiorna i contatori di magazzino Mage1
	 * Destinazione
	 *******************************************/
	BEGIN
		-- toglie 
		-- test dav 15.03.15
		INSERT INTO TbMageMov (
			InfoMov,
			TipoDoc,
			IdDoc,
			IdDocDet,
			IdArticolo,
			KeyMage,
			IdMage,
			Qta,
            IdArtVrt,
			MagePosiz
			)
		SELECT 'TrOdlDetRegQta_Mage_11' AS Expr1,
			'TbOdl' AS TipoDoc,
			Deleted.IdOdl,
			TbOdlDetRegQta.IdOdlDetRegQta,
			TbOdlDet.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente), 'C', 'ODL', Deleted.IdOdl, TbOdlDet.IdOdlDet, COALESCE(TbOdlDet.IdMage1, Deleted.IdMage1, N'000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,	
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN Deleted.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(TbOdlDet.IdMage1, Deleted.IdMage1, N'000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(TbOdlDet.IdMage1, Deleted.IdMage1, '000') AS IdMage,
			- ROUND(ISNULL(TbOdlDetRegQta.QtaMageMov, 0), 4) AS QtaMov,
            TbOdlDet.IdArtVrt,
			COALESCE(TbOdlDet.MagePosiz, Deleted.MagePosiz) AS MagePosiz
		FROM TbOdlDetRegQta
		INNER JOIN TbOdlDet
			ON TbOdlDetRegQta.IdOdlDet = TbOdlDet.IdOdlDet
		INNER JOIN Deleted
			ON TbOdlDet.IdOdl = Deleted.IdOdl
		INNER JOIN TbOdlAnagCausali
			ON Deleted.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbMageAnag
			ON COALESCE(TbOdlDet.IdMage1, Deleted.IdMage1, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN Inserted
			ON Inserted.IdOdl = Deleted.IdOdl
				AND ISNULL(Inserted.IdMage1, '') = ISNULL(Deleted.IdMage1, '')
				AND ISNULL(Inserted.MagePosiz1, '') = ISNULL(TbOdlDet.MagePosiz1, '')
				AND ISNULL(inserted.IdCausaleOdl, '') = ISNULL(deleted.IdCausaleOdl, '')
		WHERE (Inserted.IdOdl IS NULL)
			AND (TbOdlDet.IdArticolo IS NOT NULL)
			AND (
				TbOdlAnagCausali.FlgMovMag1 = 1
				OR COALESCE(TbOdlDet.IdMage1, Deleted.IdMage1) IS NOT NULL
				)

		-- aggiunge
		-- test dav 15.03.15
		INSERT INTO TbMageMov (
			InfoMov,
			TipoDoc,
			IdDoc,
			IdDocDet,
			IdArticolo,
			KeyMage,
			IdMage,
			Qta,
            IdArtVrt,
			MagePosiz
			)
		SELECT 'TrOdlDetRegQta_Mage_12' AS Expr1,
			'TbOdl' AS TipoDoc,
			Inserted.IdOdl,
			TbOdlDetRegQta.IdOdlDetRegQta,
			TbOdlDet.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente), 'C', 'ODL', Inserted.IdOdl, TbOdlDet.IdOdlDet, COALESCE(TbOdlDet.IdMage1, Inserted.IdMage1, N'000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,	
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN Inserted.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(TbOdlDet.IdMage1, Inserted.IdMage1, N'000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(TbOdlDet.IdMage1, Inserted.IdMage1, '000') AS IdMage,
			ROUND(ISNULL(TbOdlDetRegQta.QtaMageMov, 0), 4) AS QtaMov,
            TbOdlDet.IdArtVrt,
			COALESCE(TbOdlDet.MagePosiz, Inserted.MagePosiz) AS MagePosiz
		FROM TbOdlDetRegQta
		INNER JOIN TbOdlDet
			ON TbOdlDetRegQta.IdOdlDet = TbOdlDet.IdOdlDet
		INNER JOIN Inserted
			ON TbOdlDet.IdOdl = Inserted.IdOdl
		INNER JOIN TbOdlAnagCausali
			ON Inserted.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbMageAnag
			ON COALESCE(TbOdlDet.IdMage1, Inserted.IdMage1, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN Deleted
			ON Inserted.IdOdl = Deleted.IdOdl
				AND ISNULL(Inserted.IdMage1, '') = ISNULL(Deleted.IdMage1, '')
				AND ISNULL(Inserted.MagePosiz1, '') = ISNULL(TbOdlDet.MagePosiz1, '')
				AND ISNULL(inserted.IdCausaleOdl, '') = ISNULL(deleted.IdCausaleOdl, '')
		WHERE (Deleted.IdOdl IS NULL)
			AND (TbOdlDet.IdArticolo IS NOT NULL)
			AND (
				TbOdlAnagCausali.FlgMovMag1 = 1
				OR COALESCE(TbOdlDet.IdMage1, Inserted.IdMage1) IS NOT NULL
				)

		-- toglie vrt
		-- test dav 15.03.15
		INSERT INTO TbMageVrtMov (
			InfoMov,
			TipoDoc,
			IdDoc,
			IdDocDet,
			IdArticolo,
			KeyMage,
			IdMage,
			Qta,
			QtaMageMov,
            IdArtVrt,
			MagePosiz,
			IdLotto,
			IdColore,
			IdVariante,
			DimLunghezza,
			DimLarghezza,
			DimAltezza,
			IdMatricola
			)
		SELECT 'TrOdlDetRegQta_Mage_13' AS Expr1,
			'TbOdl' AS TipoDoc,
			Deleted.IdOdl,
			TbOdlDetRegQta.IdOdlDetRegQta,
			TbOdlDet.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente), 'C', 'ODL', Deleted.IdOdl, TbOdlDet.IdOdlDet, COALESCE(TbOdlDet.IdMage1, Deleted.IdMage1, N'000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,	
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN Deleted.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(TbOdlDet.IdMage1, Deleted.IdMage1, N'000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(TbOdlDet.IdMage1, Deleted.IdMage1, '000') AS IdMage,
			- ROUND(ISNULL(TbOdlDetRegQta.QtaVrt, 0), 4) AS QtaMov,
			- ROUND(ISNULL(TbOdlDetRegQta.QtaMageMov, 0), 4) AS QtaMageMov,
            TbOdlDet.IdArtVrt,
			COALESCE(TbOdlDet.MagePosiz, Deleted.MagePosiz) AS MagePosiz,
			TbOdlDetRegQta.IdLotto,
			TbOdlDetRegQta.IdColore,
			TbOdlDetRegQta.IdVariante,
			TbOdlDetRegQta.[DimLunghezza],
			TbOdlDetRegQta.[DimLarghezza],
			TbOdlDetRegQta.[DimAltezza],
			TbOdlDetRegQta.IdMatricola
		FROM TbOdlDetRegQta
		INNER JOIN TbOdlDet
			ON TbOdlDetRegQta.IdOdlDet = TbOdlDet.IdOdlDet
		INNER JOIN Deleted
			ON TbOdlDet.IdOdl = Deleted.IdOdl
		INNER JOIN TbOdlAnagCausali
			ON Deleted.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbMageAnag
			ON COALESCE(TbOdlDet.IdMage1, Deleted.IdMage1, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN Inserted
			ON Inserted.IdOdl = Deleted.IdOdl
				AND ISNULL(Inserted.IdMage1, '') = ISNULL(Deleted.IdMage1, '')
				AND ISNULL(Inserted.MagePosiz1, '') = ISNULL(TbOdlDet.MagePosiz1, '')
				AND ISNULL(inserted.IdCausaleOdl, '') = ISNULL(deleted.IdCausaleOdl, '')
		WHERE (Inserted.IdOdl IS NULL)
			AND (TbOdlDet.IdArticolo IS NOT NULL)
			AND (TbOdlDetRegQta.QtaPz IS NOT NULL)
			AND (
				TbOdlAnagCausali.FlgMovMag1 = 1
				OR COALESCE(TbOdlDet.IdMage1, Deleted.IdMage1) IS NOT NULL
				)

		-- aggiunge vrt
		-- test dav 15.03.15
		INSERT INTO TbMageVrtMov (
			InfoMov,
			TipoDoc,
			IdDoc,
			IdDocDet,
			IdArticolo,
			KeyMage,
			IdMage,
			Qta,
			QtaMageMov,
            IdArtVrt,
			MagePosiz,
			IdLotto,
			IdColore,
			IdVariante,
			DimLunghezza,
			DimLarghezza,
			DimAltezza,
			IdMatricola
			)
		SELECT 'TrOdlDetRegQta_Mage_14' AS Expr1,
			'TbOdl' AS TipoDoc,
			Inserted.IdOdl,
			TbOdlDetRegQta.IdOdlDetRegQta,
			TbOdlDet.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente), 'C', 'ODL', Inserted.IdOdl, TbOdlDet.IdOdlDet, COALESCE(TbOdlDet.IdMage1, Inserted.IdMage1, N'000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,	
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN Inserted.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, TbOdlDet.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(TbOdlDet.IdMage1, Inserted.IdMage1, N'000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(TbOdlDet.IdMage1, Inserted.IdMage1, '000') AS IdMage,
			ROUND(ISNULL(TbOdlDetRegQta.QtaVrt, 0), 4) AS QtaMov,
			ROUND(ISNULL(TbOdlDetRegQta.QtaMageMov, 0), 4) AS QtaMageMov,
            TbOdlDet.IdArtVrt,
			COALESCE(TbOdlDet.MagePosiz, Inserted.MagePosiz) AS MagePosiz,
			TbOdlDetRegQta.IdLotto,
			TbOdlDetRegQta.IdColore,
			TbOdlDetRegQta.IdVariante,
			TbOdlDetRegQta.[DimLunghezza],
			TbOdlDetRegQta.[DimLarghezza],
			TbOdlDetRegQta.[DimAltezza],
			TbOdlDetRegQta.IdMatricola
		FROM TbOdlDetRegQta
		INNER JOIN TbOdlDet
			ON TbOdlDetRegQta.IdOdlDet = TbOdlDet.IdOdlDet
		INNER JOIN Inserted
			ON TbOdlDet.IdOdl = Inserted.IdOdl
		INNER JOIN TbOdlAnagCausali
			ON Inserted.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbMageAnag
			ON COALESCE(TbOdlDet.IdMage1, Inserted.IdMage1, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN Deleted
			ON Inserted.IdOdl = Deleted.IdOdl
				AND ISNULL(Inserted.IdMage1, '') = ISNULL(Deleted.IdMage1, '')
				AND ISNULL(Inserted.MagePosiz1, '') = ISNULL(TbOdlDet.MagePosiz1, '')
				AND ISNULL(inserted.IdCausaleOdl, '') = ISNULL(deleted.IdCausaleOdl, '')
		WHERE (Deleted.IdOdl IS NULL)
			AND (TbOdlDet.IdArticolo IS NOT NULL)
			AND (TbOdlDetRegQta.QtaPz IS NOT NULL)
			AND (
				TbOdlAnagCausali.FlgMovMag1 = 1
				OR COALESCE(TbOdlDet.IdMage1, Inserted.IdMage1) IS NOT NULL
				)
	END
END

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di produzione fine prevista', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'COLUMN', @level2name = N'DataFinePrev';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sessione genratrice da programmazione ordini clienti', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'COLUMN', @level2name = N'IdSUID';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di inoltro in produzione', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'COLUMN', @level2name = N'DataInoltroDoc';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data prevista di inizio produzione', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'COLUMN', @level2name = N'DataProd';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Reparto', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'COLUMN', @level2name = N'IdReparto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di creazione dell''ordine di lavoro', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl', @level2type = N'COLUMN', @level2name = N'DataOdl';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdl';


GO

