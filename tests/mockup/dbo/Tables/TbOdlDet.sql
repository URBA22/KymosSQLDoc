CREATE TABLE [dbo].[TbOdlDet] (
    [IdOdlDet]                INT            IDENTITY (1, 1) NOT NULL,
    [IdOdl]                   NVARCHAR (20)  NOT NULL,
    [IdCliOrdDet]             INT            NULL,
    [IdArticolo]              NVARCHAR (50)  NULL,
    [Qta]                     REAL           NULL,
    [UnitM]                   NVARCHAR (20)  NULL,
    [UnitMCoeff]              REAL           NULL,
    [Descrizione]             NVARCHAR (MAX) NULL,
    [IdCliente]               INT            NULL,
    [CostoUnit]               MONEY          NULL,
    [PrezzoUnit]              MONEY          NULL,
    [CicloVer]                NVARCHAR (10)  NULL,
    [DistVer]                 NVARCHAR (10)  NULL,
    [IdArtCiclo]              INT            NULL,
    [IdArtDist]               INT            NULL,
    [NRiga]                   INT            NULL,
    [FlgChiusuraMan]          BIT            CONSTRAINT [DF_TbOdlDet_FlgChiusuraMan] DEFAULT ((0)) NOT NULL,
    [FlgConsuntivato]         BIT            CONSTRAINT [DF_TbOdlDet_Consuntivato] DEFAULT ((0)) NOT NULL,
    [NoteConsuntivo]          NVARCHAR (MAX) NULL,
    [MargineMateriali]        REAL           NULL,
    [MargineLavorazioni]      REAL           NULL,
    [MargineCostiAgnt]        REAL           NULL,
    [IdMatrConformita]        NVARCHAR (20)  NULL,
    [IdLingua]                NVARCHAR (5)   NULL,
    [IdCliOffDet]             INT            NULL,
    [Utente]                  NVARCHAR (20)  NULL,
    [IdMage]                  NVARCHAR (10)  NULL,
    [IdMage1]                 NVARCHAR (10)  NULL,
    [MagePosiz]               NVARCHAR (20)  NULL,
    [MagePosiz1]              NVARCHAR (20)  NULL,
    [NoteOdlDet]              NVARCHAR (MAX) NULL,
    [FlgSchedAutomatica]      BIT            CONSTRAINT [DF_TbOdlDet_SchedAutomatica] DEFAULT ((1)) NOT NULL,
    [DataConsSchedule]        DATE           NULL,
    [IdMatrTipo]              NVARCHAR (20)  NULL,
    [CostoUnitCsnt]           MONEY          NULL,
    [CostoUnitCsntScarto]     MONEY          NULL,
    [PrezzoUnitCsnt]          MONEY          NULL,
    [RevisioneIdArt]          NVARCHAR (10)  NULL,
    [DataInizioPrevista]      DATE           NULL,
    [DataFinePrevista]        DATE           NULL,
    [NoteConformita]          NVARCHAR (MAX) NULL,
    [FlgLavInt]               BIT            CONSTRAINT [DF_TbOdlDet_FlgLavInt] DEFAULT ((0)) NOT NULL,
    [IdOdlDetOrigine]         INT            NULL,
    [DataArtDist]             DATE           NULL,
    [IdCausaleOdlDet]         NVARCHAR (20)  NULL,
    [QtaMageMov]              AS             ([Qta]/isnull([UnitMCoeff],(1))),
    [MargineLavorazioniExt]   REAL           NULL,
    [CodFnzStatoDet]          NVARCHAR (5)   NULL,
    [SysDateCreate]           DATETIME       CONSTRAINT [DF_TbOdlDet_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate]           NVARCHAR (256) NULL,
    [SysDateUpdate]           DATETIME       NULL,
    [SysUserUpdate]           NVARCHAR (256) NULL,
    [SysRowVersion]           ROWVERSION     NULL,
    [IdCliOrdDetOrigine]      INT            NULL,
    [IdCliOrdDetElab]         AS             (isnull([IdCliOrdDet],[IdCliOrdDetOrigine])),
    [IdOdlDetMaster]          INT            NULL,
    [Livello]                 INT            NULL,
    [LivelloStr]              NVARCHAR (50)  NULL,
    [Ordinamento]             NVARCHAR (50)  NULL,
    [QtaUnitMaster]           REAL           NULL,
    [SequenzaProd]            INT            NULL,
    [FlgSelezione]            BIT            CONSTRAINT [DF_TbOdlDet_FlgSelezione] DEFAULT ((0)) NOT NULL,
    [FlgNoteSpotOdl]          BIT            CONSTRAINT [DF_TbOdlDet_FlgNoteSpotOdl] DEFAULT ((0)) NOT NULL,
    [DataInoltroDoc]          DATE           NULL,
    [FlgCliOrdDetOdlAgncAuto] BIT            CONSTRAINT [DF_TbOdlDet_FlgCliOrdDetOdlAgncAuto] DEFAULT ((0)) NOT NULL,
    [CmpOpz01]                NVARCHAR (50)  NULL,
    [CmpOpz02]                NVARCHAR (50)  NULL,
    [CmpOpz03]                NVARCHAR (50)  NULL,
    [CmpOpz04]                NVARCHAR (50)  NULL,
    [CmpOpz05]                NVARCHAR (50)  NULL,
    [FlgPrioritaAlta]         BIT            CONSTRAINT [DF_TbOdlDet_FlgPrioritaAlta] DEFAULT ((0)) NOT NULL,
    [IdFornitore]             INT            NULL,
    [Acronimo]                NVARCHAR (50)  NULL,
    [FlgDistBlocco]           BIT            CONSTRAINT [DF_TbOdlDet_FlgDistBlocco] DEFAULT ((0)) NOT NULL,
    [FlgFasiBlocco]           BIT            CONSTRAINT [DF_TbOdlDet_FlgFasiBlocco] DEFAULT ((0)) NOT NULL,
    [IdCliPrj]                NVARCHAR (20)  NULL,
    [BlocDoc]                 BIT            CONSTRAINT [DF_TbOdlDet_BlocDoc] DEFAULT ((0)) NOT NULL,
    [FlgCtrlFasiTec]          BIT            CONSTRAINT [DF_TbOdlDet_FlgCtrlTecDist1] DEFAULT ((0)) NOT NULL,
    [FlgCtrlFasiQla]          BIT            CONSTRAINT [DF_TbOdlDet_FlgCtrlTecFasi1] DEFAULT ((0)) NOT NULL,
    [FlgCtrlDistTec]          BIT            CONSTRAINT [DF_TbOdlDet_FlgCtrlTecDist] DEFAULT ((0)) NOT NULL,
    [FlgCtrlDistQla]          BIT            CONSTRAINT [DF_TbOdlDet_FlgCtrlTecDist1_1] DEFAULT ((0)) NOT NULL,
    [FlgCtrlDistPrd]          BIT            CONSTRAINT [DF_TbOdlDet_FlgCtrlDistQla1] DEFAULT ((0)) NOT NULL,
    [FlgCtrlFasiPrd]          BIT            CONSTRAINT [DF_TbOdlDet_FlgCtrlFasiQla1] DEFAULT ((0)) NOT NULL,
    [SysDisableTrigger]       BIT            CONSTRAINT [DF_TbOdlDet_SysDisableTrigger_1] DEFAULT ((0)) NOT NULL,
    [IdArtVrt]                INT            NULL,
    [Provvigione]             DECIMAL (4, 2) NULL,
    CONSTRAINT [PK_TbOdlDet] PRIMARY KEY CLUSTERED ([IdOdlDet] ASC),
    CONSTRAINT [FK_TbOdlDet_TbArtCicli] FOREIGN KEY ([IdArtCiclo]) REFERENCES [dbo].[TbArtCicli] ([IdArtCiclo]),
    CONSTRAINT [FK_TbOdlDet_TbArtDist] FOREIGN KEY ([IdArtDist]) REFERENCES [dbo].[TbArtDist] ([IdArtDist]),
    CONSTRAINT [FK_TbOdlDet_TbArticoli] FOREIGN KEY ([IdArticolo]) REFERENCES [dbo].[TbArticoli] ([IdArticolo]),
    CONSTRAINT [FK_TbOdlDet_TbArtVrt] FOREIGN KEY ([IdArtVrt]) REFERENCES [dbo].[TbArtVrt] ([IdArtVrt]),
    CONSTRAINT [FK_TbOdlDet_TbClienti] FOREIGN KEY ([IdCliente]) REFERENCES [dbo].[TbClienti] ([IdCliente]),
    CONSTRAINT [FK_TbOdlDet_TbCliOffDet] FOREIGN KEY ([IdCliOffDet]) REFERENCES [dbo].[TbCliOffDet] ([IdCliOffDet]),
    CONSTRAINT [FK_TbOdlDet_TbCliOrdDet] FOREIGN KEY ([IdCliOrdDet]) REFERENCES [dbo].[TbCliOrdDet] ([IdCliOrdDet]),
    CONSTRAINT [FK_TbOdlDet_TbCliPrj] FOREIGN KEY ([IdCliPrj]) REFERENCES [dbo].[TbCliPrj] ([IdCliPrj]),
    CONSTRAINT [FK_TbOdlDet_TbFornitori] FOREIGN KEY ([IdFornitore]) REFERENCES [dbo].[TbFornitori] ([IdFornitore]),
    CONSTRAINT [FK_TbOdlDet_TbLingue] FOREIGN KEY ([IdLingua]) REFERENCES [dbo].[TbLingue] ([IdLingua]),
    CONSTRAINT [FK_TbOdlDet_TbMageAnag] FOREIGN KEY ([IdMage1]) REFERENCES [dbo].[TbMageAnag] ([IdMage]),
    CONSTRAINT [FK_TbOdlDet_TbMatrAnagConformita] FOREIGN KEY ([IdMatrConformita]) REFERENCES [dbo].[TbMatrAnagConformita] ([IdMatrConformita]),
    CONSTRAINT [FK_TbOdlDet_TbMatrAnagTipo] FOREIGN KEY ([IdMatrTipo]) REFERENCES [dbo].[TbMatrAnagTipo] ([IdMatrTipo]),
    CONSTRAINT [FK_TbOdlDet_TbOdl] FOREIGN KEY ([IdOdl]) REFERENCES [dbo].[TbOdl] ([IdOdl]) ON UPDATE CASCADE,
    CONSTRAINT [FK_TbOdlDet_TbOdlAnagCausaliDet] FOREIGN KEY ([IdCausaleOdlDet]) REFERENCES [dbo].[TbOdlAnagCausaliDet] ([IdCausaleOdlDet]),
    CONSTRAINT [FK_TbOdlDet_TbUnitM] FOREIGN KEY ([UnitM]) REFERENCES [dbo].[TbUnitM] ([UnitM])
);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdlDet_IdCliOffDet]
    ON [dbo].[TbOdlDet]([IdCliOffDet] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdlDet]
    ON [dbo].[TbOdlDet]([IdOdl] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdlDet_4]
    ON [dbo].[TbOdlDet]([IdOdlDetOrigine] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdlDet_3]
    ON [dbo].[TbOdlDet]([DataInizioPrevista] ASC, [SequenzaProd] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdlDet_2]
    ON [dbo].[TbOdlDet]([IdArticolo] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdlDet_1]
    ON [dbo].[TbOdlDet]([FlgConsuntivato] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdlDet_6]
    ON [dbo].[TbOdlDet]([FlgChiusuraMan] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdlDet_5]
    ON [dbo].[TbOdlDet]([IdOdlDetMaster] ASC);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdlDet_IdCliOrdDet]
    ON [dbo].[TbOdlDet]([IdCliOrdDet] ASC);


GO


-- ==========================================================================================
-- Entity Name:   TrOdlDet_OdlDet
-- Author:        dav
-- Create date:   210403
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	  
-- Description:	  Aggiorn ail FlgRigaEvasa in Elab
-- History:
-- dav 210403 Creazione
-- dav 210609 Modifica logica per gestione qtaprodottaelab su cambio unitmcoeff
-- dav 210614 Correzione aggiornamneto
-- dav 210902 Modifica join con TbOdlDetRegQta per intercettare FlgChiusuraMan
-- dav 220224 Gestione SysDisableTrigger
-- ==========================================================================================

CREATE TRIGGER [dbo].[TrOdlDet_OdlDet] 
   ON  [dbo].[TbOdlDet] 
   AFTER  INSERT,UPDATE,DELETE
AS 
BEGIN

	SET NOCOUNT ON;

	IF	NOT EXISTS (select SysDisableTrigger from inserted where SysDisableTrigger=0)
		AND NOT EXISTS ((select SysDisableTrigger from deleted where SysDisableTrigger=0))
	BEGIN
		RETURN
	END

	BEGIN
	/*******************************************
	* Aggiorna la Qta scaricate in odldet
	*******************************************/
		
	UPDATE    TbOdlDetElab
	SET              
	QtaProdotta = Round(ISNULL(TbOdlDetElab.QtaProdotta, 0) - ROUND(ISNULL(x.QtaMov, 0) * ISNULL(x.UnitMCoeff, 1), 2),2), 
	QtaScarto = Round(ISNULL(TbOdlDetElab.QtaScarto,0) - ROUND(ISNULL(x.QtaMovScr, 0) * ISNULL(x.UnitMCoeff, 1), 2),2),
	
	FlgRigaEvasa = CASE WHEN
		x.Qta > Round(ISNULL(TbOdlDetElab.QtaProdotta, 0) - ROUND(ISNULL(x.QtaMov, 0) * ISNULL(x.UnitMCoeff, 1), 2),2)
		AND x.FlgChiusuraMan = 0  THEN 0 ELSE 1 END

	FROM TbOdlDetElab INNER JOIN
		(
		SELECT
		SUM(TbOdlDetRegQta.QtaMageMov) AS QtaMov, 
		SUM(TbOdlDetRegQta.QtaMageMovScr) AS QtaMovScr, 
		Deleted.UnitMCoeff,
		Deleted.Qta,
		Deleted.FlgChiusuraMan,
		Deleted.IdOdlDet
		FROM Deleted LEFT OUTER JOIN
		TbOdlDetRegQta ON TbOdlDetRegQta.IdOdlDet = Deleted.IdOdlDet LEFT OUTER JOIN
		Inserted ON Deleted.IdOdlDet = Inserted.IdOdlDet AND 
					ISNULL(Deleted.Qta, 0) = ISNULL(Inserted.Qta, 0) AND 
					ISNULL(Deleted.UnitMCoeff, 0) = ISNULL(Inserted.UnitMCoeff, 0) AND 
					ISNULL(Deleted.FlgChiusuraMan, 0) = ISNULL(Inserted.FlgChiusuraMan, 0)
		WHERE      (Inserted.IdOdlDet IS NULL)
		GROUP BY Deleted.IdOdlDet, Deleted.UnitMCoeff, Deleted.Qta, Deleted.FlgChiusuraMan
		) x on TbOdlDetElab.IdOdlDet = x.IdOdlDet
	

	UPDATE    TbOdlDetElab
	SET              
	QtaProdotta = Round(ISNULL(TbOdlDetElab.QtaProdotta, 0) + ROUND(ISNULL(x.QtaMov, 0) * ISNULL(x.UnitMCoeff, 1), 2),2), 
	QtaScarto = Round(ISNULL(TbOdlDetElab.QtaScarto,	0) + ROUND(ISNULL(x.QtaMovScr, 0) * ISNULL(x.UnitMCoeff, 1), 2),2),

	FlgRigaEvasa = CASE WHEN
		x.Qta > Round(ISNULL(TbOdlDetElab.QtaProdotta, 0) + ROUND(ISNULL(x.QtaMov, 0) * ISNULL(x.UnitMCoeff, 1), 2),2)
		AND x.FlgChiusuraMan = 0  THEN 0 ELSE 1 END

	FROM TbOdlDetElab INNER JOIN 
		(
		SELECT
		SUM(TbOdlDetRegQta.QtaMageMov) AS QtaMov, 
		SUM(TbOdlDetRegQta.QtaMageMovScr) AS QtaMovScr, 
		Inserted.UnitMCoeff,
		Inserted.Qta,
		Inserted.FlgChiusuraMan,
		Inserted.IdOdlDet
		FROM Inserted LEFT OUTER JOIN
		TbOdlDetRegQta ON TbOdlDetRegQta.IdOdlDet = Inserted.IdOdlDet LEFT OUTER JOIN
		Deleted ON Deleted.IdOdlDet = Inserted.IdOdlDet AND 
					ISNULL(Deleted.Qta, 0) = ISNULL(Inserted.Qta, 0) AND 
					ISNULL(Deleted.UnitMCoeff, 0) = ISNULL(Inserted.UnitMCoeff, 0) AND 
					ISNULL(Deleted.FlgChiusuraMan, 0) = ISNULL(Inserted.FlgChiusuraMan, 0) AND 
					Deleted.SysDisableTrigger = Inserted.SysDisableTrigger 
		WHERE      (Deleted.IdOdlDet IS NULL)
		GROUP BY Inserted.IdOdlDet, Inserted.UnitMCoeff, Inserted.Qta, Inserted.FlgChiusuraMan
		) x on TbOdlDetElab.IdOdlDet = x.IdOdlDet

	--UPDATE    TbOdlDetElab
	--SET   

	--FlgRigaEvasa = CASE WHEN
	--	Deleted.Qta > ISNULL(TbOdlDetElab.QtaProdotta, 0) 
	--	AND Deleted.FlgChiusuraMan = 0  THEN 0 ELSE 1 END

	--FROM          
	--	Deleted INNER JOIN
	--	TbOdlDetElab ON TbOdlDetElab.IdOdlDet = Deleted.IdOdldet LEFT OUTER JOIN
	--	Inserted ON 
	--		Deleted.IdOdlDet = Inserted.IdOdlDet AND 
	--		ISNULL(Deleted.Qta, 0) = ISNULL(Inserted.Qta, 0) AND 
	--		(Deleted.FlgChiusuraMan  =  Inserted.FlgChiusuraMan) AND  
	--		(Deleted.FlgConsuntivato  =  Inserted.FlgConsuntivato) 
	--WHERE        
	--	(Inserted.IdOdlDet IS NULL) 

	--UPDATE    TbOdlDetElab
	--SET   

	--FlgRigaEvasa = CASE WHEN
	--	Inserted.Qta > ISNULL(TbOdlDetElab.QtaProdotta, 0) 
	--	AND Inserted.FlgChiusuraMan = 0  THEN 0 ELSE 1 END

	--FROM          
	--	Inserted INNER JOIN
	--	TbOdlDetElab ON TbOdlDetElab.IdOdlDet = Inserted.IdOdldet  LEFT OUTER JOIN
	--	Deleted ON 
	--		Deleted.IdOdlDet = Inserted.IdOdlDet AND 
	--		ISNULL(Deleted.Qta, 0) = ISNULL(Inserted.Qta, 0) AND 
	--		(Deleted.FlgChiusuraMan  =  Inserted.FlgChiusuraMan) AND  
	--		(Deleted.FlgConsuntivato  =  Inserted.FlgConsuntivato) 
	--WHERE        
	--	(Deleted.IdOdlDet IS NULL)
	END
END

GO


-- ==========================================================================================
-- Entity Name:    TrOdlDet_ArtVrt
-- Author:         dav
-- Create date:    230223
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    @Descrizione
-- History:
-- dav 230223 Creazione
-- ==========================================================================================
CREATE TRIGGER [dbo].[TrOdlDet_ArtVrt] ON [dbo].[TbOdlDet]
AFTER INSERT,
	UPDATE,
	DELETE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (
			SELECT SysDisableTrigger
			FROM inserted
			WHERE SysDisableTrigger = 0
			)
		AND NOT EXISTS (
			(
				SELECT SysDisableTrigger
				FROM deleted
				WHERE SysDisableTrigger = 0
				)
			)
	BEGIN
		RETURN
	END

	-- Note
	-- Il trigger non può essere controllato con if update(nomecampo) perchè la stp aggiorna tutto
	-- per evitare aggiornamenti per ogno modifica serve join su inserted e delete su campi critici
	/*******************************************
	* aggiorna la Qta in produzione
	*******************************************/
	UPDATE TbArtVrtElab
	SET QtaMageDispOdl = ISNULL(TbArtVrtElab.QtaMageDispOdl, 0) - ISNULL(x.QtaMov, 0)
	FROM (
		SELECT SUM(CASE 
					WHEN Deleted.FlgChiusuraMan = 0
						THEN Deleted.QtaMageMov
					ELSE isnull(TbOdlDetElab.QtaProdotta, 0) / isnull(Deleted.UnitMCoeff, 1)
					END) AS QtaMov,
			Deleted.IdArtVrt
		FROM Deleted
		INNER JOIN TbOdl
			ON Deleted.IdOdl = TbOdl.IdOdl
		LEFT OUTER JOIN TbOdlDetElab
			ON Deleted.IdOdlDet = TbOdlDetElab.IdOdlDet
		LEFT OUTER JOIN Inserted
			ON (
					Deleted.IdOdlDet = Inserted.IdOdlDet
					AND Deleted.FlgChiusuraMan = Inserted.FlgChiusuraMan
					AND Deleted.UnitMCoeff = Inserted.UnitMCoeff
					AND isnull(Deleted.QtaMageMov, 0) = isnull(Inserted.QtaMageMov, 0)
					AND Deleted.IdArtVrt = Inserted.IdArtVrt
					)
		WHERE (Inserted.IdOdl IS NULL)
		GROUP BY Deleted.IdArtVrt
		) AS x
	INNER JOIN TbArtVrtElab
		ON x.IdArtVrt = TbArtVrtElab.IdArtVrt

	UPDATE TbArtVrtElab
	SET QtaMageDispOdl = ISNULL(TbArtVrtElab.QtaMageDispOdl, 0) + ISNULL(x.QtaMov, 0)
	FROM (
		SELECT SUM(CASE 
					WHEN Inserted.FlgChiusuraMan = 0
						THEN Inserted.QtaMageMov
					ELSE isnull(TbOdlDetElab.QtaProdotta, 0) / isnull(Inserted.UnitMCoeff, 1)
					END) AS QtaMov,
			Inserted.IdArtVrt
		FROM Inserted
		INNER JOIN TbOdl
			ON Inserted.IdOdl = TbOdl.IdOdl
		LEFT OUTER JOIN TbOdlDetElab
			ON Inserted.IdOdlDet = TbOdlDetElab.IdOdlDet
		LEFT OUTER JOIN Deleted
			ON (
					Deleted.IdOdlDet = Inserted.IdOdlDet
					AND Deleted.FlgChiusuraMan = Inserted.FlgChiusuraMan
					AND Deleted.UnitMCoeff = Inserted.UnitMCoeff
					AND isnull(Deleted.QtaMageMov, 0) = isnull(Inserted.QtaMageMov, 0)
					AND Deleted.IdArtVrt = Inserted.IdArtVrt
					AND Deleted.SysDisableTrigger = Inserted.SysDisableTrigger
					)
		WHERE (Deleted.IdOdl IS NULL)
		GROUP BY Inserted.IdArtVrt
		) AS x
	INNER JOIN TbArtVrtElab
		ON x.IdArtVrt = TbArtVrtElab.IdArtVrt

	/*******************************************
	* aggiorna la Qta impegnata
	*******************************************/
	UPDATE TbArtVrtElab
	SET QtaMageImpOdl = ISNULL(TbArtVrtElab.QtaMageImpOdl, 0) - ISNULL(x.QtaMov, 0)
	FROM (
		SELECT SUM(CASE 
					WHEN Deleted.FlgChiusuraMan = 0
						THEN Deleted.QtaMageMov
					ELSE isnull(TbOdlDetElab.QtaProdotta, 0) / isnull(Deleted.UnitMCoeff, 1)
					END * TbOdlDetDist.QtaMageMov) AS QtaMov,
			TbOdlDetDist.IdArtVrt
		FROM Deleted
		INNER JOIN TbOdl
			ON Deleted.IdOdl = TbOdl.IdOdl
		INNER JOIN TbOdlDetDist
			ON Deleted.IdOdlDet = TbOdlDetDist.IdOdlDet
		LEFT OUTER JOIN TbOdlDetElab
			ON Deleted.IdOdlDet = TbOdlDetElab.IdOdlDet
		LEFT OUTER JOIN Inserted
			ON (
					Deleted.IdOdlDet = Inserted.IdOdlDet
					AND Deleted.FlgChiusuraMan = Inserted.FlgChiusuraMan
					AND Deleted.UnitMCoeff = Inserted.UnitMCoeff
					AND isnull(Deleted.QtaMageMov, 0) = isnull(Inserted.QtaMageMov, 0)
					AND Deleted.IdArtVrt = Inserted.IdArtVrt
					)
		WHERE (Inserted.IdOdl IS NULL)
		GROUP BY TbOdlDetDist.IdArtVrt
		) AS x
	INNER JOIN TbArtVrtElab
		ON x.IdArtVrt = TbArtVrtElab.IdArtVrt

	UPDATE TbArtVrtElab
	SET QtaMageImpOdl = ISNULL(TbArtVrtElab.QtaMageImpOdl, 0) + ISNULL(x.QtaMov, 0)
	FROM (
		SELECT SUM(CASE 
					WHEN Inserted.FlgChiusuraMan = 0
						THEN Inserted.QtaMageMov
					ELSE isnull(TbOdlDetElab.QtaProdotta, 0) / isnull(Inserted.UnitMCoeff, 1)
					END * TbOdlDetDist.QtaMageMov) AS QtaMov,
			TbOdlDetDist.IdArtVrt
		FROM Inserted
		INNER JOIN TbOdl
			ON Inserted.IdOdl = TbOdl.IdOdl
		INNER JOIN TbOdlDetDist
			ON Inserted.IdOdlDet = TbOdlDetDist.IdOdlDet
		LEFT OUTER JOIN TbOdlDetElab
			ON Inserted.IdOdlDet = TbOdlDetElab.IdOdlDet
		LEFT OUTER JOIN Deleted
			ON (
					Deleted.IdOdlDet = Inserted.IdOdlDet
					AND Deleted.FlgChiusuraMan = Inserted.FlgChiusuraMan
					AND Deleted.UnitMCoeff = Inserted.UnitMCoeff
					AND isnull(Deleted.QtaMageMov, 0) = isnull(Inserted.QtaMageMov, 0)
					AND Deleted.IdArtVrt = Inserted.IdArtVrt
					AND Deleted.SysDisableTrigger = Inserted.SysDisableTrigger
					)
		WHERE (Deleted.IdOdl IS NULL)
		GROUP BY TbOdlDetDist.IdArtVrt
		) AS x
	INNER JOIN TbArtVrtElab
		ON x.IdArtVrt = TbArtVrtElab.IdArtVrt
END

GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'TRIGGER', @level2name = N'TrOdlDet_Elab';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'TRIGGER', @level2name = N'TrOdlDet_Elab';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '06/09/2013 19:08:00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'TRIGGER', @level2name = N'TrOdlDet_Elab';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'TRIGGER', @level2name = N'TrOdlDet_Elab';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'TRIGGER', @level2name = N'TrOdlDet_Elab';


GO

-- =============================================
-- Author:		Dav
-- Create date: 01/03/13
-- Description: Crea record su tabella elab
-- =============================================
CREATE TRIGGER [dbo].[TrOdlDet_Elab]
   ON  dbo.TbOdlDet 
   AFTER INSERT  --,DELETE,UPDATE>
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO TbOdlDetElab (IdOdlDet)
	SELECT     IdOdlDet
	FROM  Inserted 

END

GO




-- ==========================================================================================
-- Entity Name:   TrOdlDet_CliOrd
-- Author:        Dav
-- Create date:   14/08/2013 19:23
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for inserting values to table
-- History:
-- dav 200331 Gestione QtaProgrammata
-- dav 201211 Correzione join qtaprogrammata
-- dav 220224 Gestione SysDisableTrigger
-- dav 220719 Disabilita qtaprogrammata, se programma ora inserisce in TbOdldetcliord
-- ==========================================================================================

CREATE TRIGGER [dbo].[TrOdlDet_CliOrd] 
   ON  [dbo].[TbOdlDet] 
   AFTER  INSERT,UPDATE,DELETE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF	NOT EXISTS (select SysDisableTrigger from inserted where SysDisableTrigger=0)
		AND NOT EXISTS ((select SysDisableTrigger from deleted where SysDisableTrigger=0))
	BEGIN
		RETURN
	END

	 -- Note
	 -- Il trigger non può essere controllato con if update(nomecampo) perchè la stp aggiorna tutto
	 -- per evitare aggiornamenti per ogno modifica serve join su xinserted e delete su campi critici

	/*******************************************
	* aggiorna la Qta programmate negli ordini cli
	*******************************************/

	-- se riga chiusa manualmente non conteggia come qta in produzione
	-- conteggia come programmata la sola qta prodotta
	
	UPDATE    TbCliOrdDetElab
	SET              QtaProgrammata = ROUND (ISNULL(TbCliOrdDetElab.QtaProgrammata, 0) - ISNULL(x.QtaMov, 0)  * Isnull(TbCliOrdDet.UnitMCoeff,1),2)
	FROM         (SELECT        SUM((CASE WHEN (Deleted.FlgChiusuraMan = 0) THEN TbOdlDetCliOrd.Qta ELSE drvqtaprod.QtaProdotta END) / ISNULL(Deleted.UnitMCoeff, 1)) AS QtaMov, 
	TbOdlDetCliOrd.IdCliOrdDet
	FROM            Deleted INNER JOIN
	TbOdlDetCliOrd ON TbOdlDetCliOrd.IdOdlDet = Deleted.IdOdlDet LEFT OUTER JOIN
	(SELECT        IdCliOrdDet, IdOdlDet, SUM(QtaMageMov) AS QtaProdotta
	FROM            TbOdlDetRegQta
	GROUP BY IdCliOrdDet, IdOdlDet) AS drvqtaprod ON TbOdlDetCliOrd.IdCliOrdDet = drvqtaprod.IdCliOrdDet AND 
	TbOdlDetCliOrd.IdOdlDet = drvqtaprod.IdOdlDet LEFT OUTER JOIN
	Inserted ON (
		Inserted.IdOdlDet = Deleted.IdOdlDet AND 
		Inserted.FlgChiusuraMan = Deleted.FlgChiusuraMan
		)
	WHERE
	(Inserted.IdOdlDet IS NULL) 
	GROUP BY TbOdlDetCliOrd.IdCliOrdDet) AS x INNER JOIN
	TbCliOrdDetElab ON x.IdCliOrdDet = TbCliOrdDetElab.IdCliOrdDet INNER JOIN
	TbCliOrdDet ON x.IdCliOrdDet = TbCliOrdDet.IdCliOrdDet
	

	UPDATE    TbCliOrdDetElab
	SET              QtaProgrammata = ROUND (ISNULL(TbCliOrdDetElab.QtaProgrammata, 0) + ISNULL(x.QtaMov, 0) * Isnull(TbCliOrdDet.UnitMCoeff,1),2)
	FROM         (SELECT        SUM((CASE WHEN (Inserted.FlgChiusuraMan = 0) THEN TbOdlDetCliOrd.Qta ELSE drvqtaprod.QtaProdotta END) / ISNULL(Deleted.UnitMCoeff, 1)) AS QtaMov, 
	TbOdlDetCliOrd.IdCliOrdDet
	FROM            Inserted INNER JOIN
	TbOdlDetCliOrd ON TbOdlDetCliOrd.IdOdlDet = Inserted.IdOdlDet LEFT OUTER JOIN
	(SELECT        IdCliOrdDet, IdOdlDet, SUM(QtaMageMov) AS QtaProdotta
	FROM            TbOdlDetRegQta
	GROUP BY IdCliOrdDet, IdOdlDet) AS drvqtaprod ON TbOdlDetCliOrd.IdCliOrdDet = drvqtaprod.IdCliOrdDet AND 
	TbOdlDetCliOrd.IdOdlDet = drvqtaprod.IdOdlDet LEFT OUTER JOIN
	Deleted ON (
		Inserted.IdOdlDet = Deleted.IdOdlDet AND 
		Inserted.FlgChiusuraMan = Deleted.FlgChiusuraMan AND 
		Deleted.SysDisableTrigger = Inserted.SysDisableTrigger 
		)
	WHERE        
	(Deleted.IdOdlDet IS NULL) 
	GROUP BY TbOdlDetCliOrd.IdCliOrdDet) AS x INNER JOIN
	TbCliOrdDetElab ON x.IdCliOrdDet = TbCliOrdDetElab.IdCliOrdDet INNER JOIN
	TbCliOrdDet ON x.IdCliOrdDet = TbCliOrdDet.IdCliOrdDet

	/*******************************************
	* aggiorna la Qta programmate negli ordini cli a programma (non inserisce in odldetcliord)
	*******************************************/

	-- dav 220719 Disabilita qtaprogrammata, se programma ora inserisce in TbOdldetcliord
	/*
	UPDATE TbCliOrdDetElab
	SET QtaProgrammata = ROUND (ISNULL(TbCliOrdDetElab.QtaProgrammata, 0) - ISNULL(x.QtaMov, 0)  ,2)
	FROM (SELECT SUM(Deleted.Qta/isnull(Deleted.UnitMCoeff,1)) AS QtaMov, Deleted.IdCliOrdDet
	FROM  Deleted LEFT OUTER JOIN
	Inserted on (
		Deleted.IdCliOrdDet=Inserted.IdCliOrdDet and 
		Deleted.IdOdlDet=Inserted.IdOdlDet and 
		isnull(Deleted.Qta,0)=isnull(Inserted.Qta,0) and 
		isnull(Deleted.IdCliOrdDet,0)=isnull(Inserted.IdCliOrdDet,0)
		)
	Where (Inserted.IdOdlDet is null) and Deleted.FlgChiusuraMan=0
	GROUP BY Deleted.IdCliOrdDet) AS x INNER JOIN
	TbCliOrdDetElab ON x.IdCliOrdDet = TbCliOrdDetElab.IdCliOrdDet INNER JOIN
	TbCliOrdDet ON x.IdCliOrdDet = TbCliOrdDet.IdCliOrdDet INNER JOIN
	TbCliOrd ON TbCliOrdDet.IdCliOrd = TbCliOrd.IdCliOrd INNER JOIN
	TbCliAnagOrdCausali ON TbCliAnagOrdCausali.IdCausaleOrd = TbCliOrd.IdCausaleOrd
	Where TbCliAnagOrdCausali.FlgProgramma = 1
	

	UPDATE TbCliOrdDetElab
	SET QtaProgrammata = ROUND (ISNULL(TbCliOrdDetElab.QtaProgrammata, 0) +ISNULL(x.QtaMov, 0) ,2)
	FROM (SELECT SUM(Inserted.Qta/isnull(Inserted.UnitMCoeff,1)) AS QtaMov, Inserted.IdCliOrdDet
	FROM Inserted LEFT OUTER JOIN
	Deleted on (
		Deleted.IdCliOrdDet=Inserted.IdCliOrdDet and 
		Deleted.IdOdlDet=Inserted.IdOdlDet and 
		isnull(Deleted.Qta,0)=isnull(Inserted.Qta,0) and 
		isnull(Deleted.IdCliOrdDet,0)=isnull(Inserted.IdCliOrdDet,0) AND 
		Deleted.SysDisableTrigger = Inserted.SysDisableTrigger 
		)
	Where (Deleted.IdOdlDet is null) and Inserted.FlgChiusuraMan=0
	GROUP BY Inserted.IdCliOrdDet) AS x INNER JOIN
	TbCliOrdDetElab ON x.IdCliOrdDet = TbCliOrdDetElab.IdCliOrdDet INNER JOIN
	TbCliOrdDet ON x.IdCliOrdDet = TbCliOrdDet.IdCliOrdDet INNER JOIN
	TbCliOrd ON TbCliOrdDet.IdCliOrd = TbCliOrd.IdCliOrd INNER JOIN
	TbCliAnagOrdCausali ON TbCliAnagOrdCausali.IdCausaleOrd = TbCliOrd.IdCausaleOrd
	Where TbCliAnagOrdCausali.FlgProgramma = 1
	*/	
END

GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'TRIGGER', @level2name = N'TrOdlDet_Mage';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'TRIGGER', @level2name = N'TrOdlDet_Mage';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'TRIGGER', @level2name = N'TrOdlDet_Mage';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '06/09/2013 19:08:00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'TRIGGER', @level2name = N'TrOdlDet_Mage';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'TRIGGER', @level2name = N'TrOdlDet_Mage';


GO


-- ==========================================================================================
-- Entity Name:   TrOdlDet_Mage
-- Author:        Dav
-- Create date:   14/02/2013 21:23
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:	Write custom note here
-- Description:	This stored procedure is intended for inserting values to table
-- History
-- dav 28.02.18 Aggiunta test FlgCostoSuCommessa
-- dav 11.04.18 Gesione mage prelievo distinta se CL Cliente
-- dav 21.07.19 Gestione mage tipo CF su mage1 vrt (TrOdlDetRegQta_Mage_13, TrOdlDetRegQta_Mage_14)
-- dav 21.07.19 Ottimizzazione parametri per gesitone cl (TrOdlDetDist_Mage_01,TrOdlDetDist_Mage_02)
-- dav 21.07.19 Gestione carico mage1 con gestione cl (TrOdlDetRegQta_Mage_11,TrOdlDetRegQta_Mage_12)
-- dav 201230 Tolto X da FncKeyMage
-- dav 220224 Gestione SysDisableTrigger
-- dav 221227 Formattazione
-- sim 221230 Aggiunto IdArtVrt
-- dav 230306 Gestione OL
-- dav 230328 Gestione FncKeyMage1
-- ==========================================================================================
CREATE TRIGGER [dbo].[TrOdlDet_Mage] ON [dbo].[TbOdlDet]
AFTER INSERT,
	UPDATE,
	DELETE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (
			SELECT SysDisableTrigger
			FROM inserted
			WHERE SysDisableTrigger = 0
			)
		AND NOT EXISTS (
			(
				SELECT SysDisableTrigger
				FROM deleted
				WHERE SysDisableTrigger = 0
				)
			)
	BEGIN
		RETURN
	END

	-- Note
	-- Il trigger non può essere controllato con if update(nomecampo) perchè la stp aggiorna tutto
	-- per evitare aggiornamenti per ogno modifica serve join su inserted e delete su campi critici
	/*******************************************
	 * Aggiorna i contatori di magazzino Mage
	 * Prelievo
	 *******************************************/
	BEGIN
		-- toglie dist
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
		SELECT 'TrOdlDetDist_Mage_01',
			'TbOdlDet' AS TipoDoc,
			TbOdl.IdOdl,
			TbOdlDetDist.IdOdlDetDist,
			TbOdlDetDist.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, Deleted.IdCliente), 'C', 'ODL', dbo.TbOdl.IdOdl, deleted.IdOdlDet, COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, Deleted.IdMage, TbOdl.IdMage, '000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN dbo.TbOdl.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, Deleted.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, Deleted.IdMage, TbOdl.IdMage, '000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, Deleted.IdMage, TbOdl.IdMage, '000') AS IdMage,
			-- ROUND(( TbOdlDetDist.QtaMageMov * TbOdlDetRegQta.QtaMageMovProdScr)   , 4) AS QtaMov,
			CASE 
				WHEN IsNull(dbo.TbOdlAnagCausaliCosti.FlgCostoSuCommessa, 0) = 0
					THEN ROUND(dbo.TbOdlDetDist.QtaMageMov * TbOdlDetRegQta.QtaMageMovProdScr, 4)
				ELSE ROUND(dbo.TbOdlDetDist.QtaMageMov, 4)
				END AS QtaMov,
			TbOdlDetDist.IdArtVrt,
            COALESCE(TbOdlDetDist.MagePosiz, Deleted.MagePosiz, TbOdl.MagePosiz) AS MagePosiz
		FROM Deleted
		INNER JOIN TbOdl
			ON Deleted.IdOdl = TbOdl.IdOdl
		INNER JOIN TbOdlDetRegQta
			ON Deleted.IdOdlDet = TbOdlDetRegQta.IdOdlDet
		INNER JOIN TbOdlAnagCausali
			ON TbOdl.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbOdlDetDist
			ON Deleted.IdOdlDet = TbOdlDetDist.IdOdlDet
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
			ON COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, Deleted.IdMage, TbOdl.IdMage, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN Inserted
			ON Inserted.IdOdlDet = Deleted.IdOdlDet
				AND ISNULL(Deleted.IdMage, '') = ISNULL(Inserted.IdMage, '')
				AND ISNULL(Deleted.MagePosiz, '') = ISNULL(Inserted.MagePosiz, '')
				AND ISNULL(Deleted.IdCliente, '') = ISNULL(Inserted.IdCliente, '')
		WHERE (Inserted.IdOdlDet IS NULL)
			AND (TbOdlDetDist.IdArticolo IS NOT NULL)
			AND (TbOdlDetDist.FlgNoMovMag = 0)
			AND (TbOdlDetDist.FlgGrpVirtuale = 0)
			AND (
				TbOdlAnagCausali.FlgMovMag = 1
				OR COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, Deleted.IdMage, TbOdl.IdMage) IS NOT NULL
				)

		-- aggiunge dist
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
		SELECT 'TrOdlDetDist_Mage_02',
			'TbOdlDet' AS TipoDoc,
			TbOdl.IdOdl,
			TbOdlDetDist.IdOdlDetDist,
			TbOdlDetDist.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, Inserted.IdCliente), 'C', 'ODL', dbo.TbOdl.IdOdl, Inserted.IdOdlDet, COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, Inserted.IdMage, TbOdl.IdMage, '000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN dbo.TbOdl.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, Inserted.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, Inserted.IdMage, TbOdl.IdMage, '000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, Inserted.IdMage, TbOdl.IdMage, '000') AS IdMage,
			-- - ROUND(( TbOdlDetDist.QtaMageMov * TbOdlDetRegQta.QtaMageMovProdScr)   , 4) AS QtaMov,
			CASE 
				WHEN IsNull(dbo.TbOdlAnagCausaliCosti.FlgCostoSuCommessa, 0) = 0
					THEN - ROUND(dbo.TbOdlDetDist.QtaMageMov * TbOdlDetRegQta.QtaMageMovProdScr, 4)
				ELSE - ROUND(dbo.TbOdlDetDist.QtaMageMov, 4)
				END AS QtaMov,
			TbOdlDetDist.IdArtVrt,
            COALESCE(TbOdlDetDist.MagePosiz, Inserted.MagePosiz, TbOdl.MagePosiz) AS MagePosiz
		FROM Inserted
		INNER JOIN TbOdl
			ON Inserted.IdOdl = TbOdl.IdOdl
		INNER JOIN TbOdlDetRegQta
			ON Inserted.IdOdlDet = TbOdlDetRegQta.IdOdlDet
		INNER JOIN TbOdlAnagCausali
			ON TbOdl.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbOdlDetDist
			ON Inserted.IdOdlDet = TbOdlDetDist.IdOdlDet
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
			ON COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, Inserted.IdMage, TbOdl.IdMage, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN Deleted
			ON Inserted.IdOdlDet = Deleted.IdOdlDet
				AND ISNULL(Deleted.IdMage, '') = ISNULL(Inserted.IdMage, '')
				AND ISNULL(Deleted.MagePosiz, '') = ISNULL(Inserted.MagePosiz, '')
				AND ISNULL(Deleted.IdCliente, '') = ISNULL(Inserted.IdCliente, '')
				AND Deleted.SysDisableTrigger = Inserted.SysDisableTrigger
		WHERE (Deleted.IdOdlDet IS NULL)
			AND (TbOdlDetDist.IdArticolo IS NOT NULL)
			AND (TbOdlDetDist.FlgNoMovMag = 0)
			AND (TbOdlDetDist.FlgGrpVirtuale = 0)
			AND (
				TbOdlAnagCausali.FlgMovMag = 1
				OR COALESCE(drvVrsm.IdMage1Vrsm, TbOdlDetDist.IdMage, Inserted.IdMage, TbOdl.IdMage) IS NOT NULL
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
			'TbOdlDet' AS TipoDoc,
			TbOdl.IdOdl,
			TbOdlDetRegQta.IdOdlDetRegQta,
			Deleted.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, Deleted.IdCliente), 'C', 'ODL', dbo.TbOdl.IdOdl, Deleted.IdOdlDet, COALESCE(Deleted.IdMage1, TbOdl.IdMage1, N'000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN dbo.TbOdl.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, Deleted.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(Deleted.IdMage1, TbOdl.IdMage1, N'000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(Deleted.IdMage1, TbOdl.IdMage1, '000') AS IdMage,
			- ROUND(ISNULL(TbOdlDetRegQta.QtaMageMov, 0), 4) AS QtaMov,
			Deleted.IdArtVrt,
            COALESCE(Deleted.MagePosiz, TbOdl.MagePosiz) AS MagePosiz
		FROM TbOdlDetRegQta
		INNER JOIN Deleted
			ON TbOdlDetRegQta.IdOdlDet = Deleted.IdOdlDet
		INNER JOIN TbOdl
			ON Deleted.IdOdl = TbOdl.IdOdl
		INNER JOIN TbOdlAnagCausali
			ON TbOdl.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbMageAnag
			ON COALESCE(Deleted.IdMage1, TbOdl.IdMage1, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN Inserted
			ON Inserted.IdOdlDet = Deleted.IdOdlDet
				AND isnull(Inserted.IdArticolo, '') = isnull(Deleted.IdArticolo, '')
				AND ISNULL(Deleted.IdMage1, '') = ISNULL(Inserted.IdMage1, '')
				AND ISNULL(Deleted.MagePosiz1, '') = ISNULL(Inserted.MagePosiz1, '')
				AND ISNULL(Deleted.IdCliente, '') = ISNULL(Inserted.IdCliente, '')
		WHERE (Inserted.IdOdlDet IS NULL)
			AND (Deleted.IdArticolo IS NOT NULL)
			AND (
				TbOdlAnagCausali.FlgMovMag1 = 1
				OR COALESCE(Deleted.IdMage1, TbOdl.IdMage1) IS NOT NULL
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
			'TbOdlDet' AS TipoDoc,
			TbOdl.IdOdl,
			TbOdlDetRegQta.IdOdlDetRegQta,
			Inserted.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, Inserted.IdCliente), 'C', 'ODL', dbo.TbOdl.IdOdl, Inserted.IdOdlDet, COALESCE(Inserted.IdMage1, TbOdl.IdMage1, N'000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN dbo.TbOdl.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, Inserted.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(Inserted.IdMage1, TbOdl.IdMage1, N'000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(Inserted.IdMage1, TbOdl.IdMage1, '000') AS IdMage,
			ROUND(ISNULL(TbOdlDetRegQta.QtaMageMov, 0), 4) AS QtaMov,
			Inserted.IdArtVrt,
            COALESCE(Inserted.MagePosiz, TbOdl.MagePosiz) AS MagePosiz
		FROM TbOdlDetRegQta
		INNER JOIN Inserted
			ON TbOdlDetRegQta.IdOdlDet = Inserted.IdOdlDet
		INNER JOIN TbOdl
			ON Inserted.IdOdl = TbOdl.IdOdl
		INNER JOIN TbOdlAnagCausali
			ON TbOdl.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbMageAnag
			ON COALESCE(Inserted.IdMage1, TbOdl.IdMage1, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN Deleted
			ON Inserted.IdOdlDet = Deleted.IdOdlDet
				AND isnull(Inserted.IdArticolo, '') = isnull(Deleted.IdArticolo, '')
				AND ISNULL(Deleted.IdMage1, '') = ISNULL(Inserted.IdMage1, '')
				AND ISNULL(Deleted.MagePosiz1, '') = ISNULL(Inserted.MagePosiz1, '')
				AND ISNULL(Deleted.IdCliente, '') = ISNULL(Inserted.IdCliente, '')
				AND Deleted.SysDisableTrigger = Inserted.SysDisableTrigger
		WHERE (Deleted.IdOdlDet IS NULL)
			AND (Inserted.IdArticolo IS NOT NULL)
			AND (
				TbOdlAnagCausali.FlgMovMag1 = 1
				OR COALESCE(Inserted.IdMage1, TbOdl.IdMage1) IS NOT NULL
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
			'TbOdlDet' AS TipoDoc,
			TbOdl.IdOdl,
			TbOdlDetRegQta.IdOdlDetRegQta,
			Deleted.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, Deleted.IdCliente), 'C', 'ODL', dbo.TbOdl.IdOdl, Deleted.IdOdlDet, COALESCE(Deleted.IdMage1, TbOdl.IdMage1, N'000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN dbo.TbOdl.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, Deleted.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(Deleted.IdMage1, TbOdl.IdMage1, N'000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(Deleted.IdMage1, TbOdl.IdMage1, '000') AS IdMage,
			- ROUND(ISNULL(TbOdlDetRegQta.QtaVrt, 0), 4) AS QtaMov,
			- ROUND(ISNULL(TbOdlDetRegQta.QtaMageMov, 0), 4) AS QtaMageMov,
			Deleted.IdArtVrt,
            COALESCE(Deleted.MagePosiz, TbOdl.MagePosiz) AS MagePosiz,
			TbOdlDetRegQta.IdLotto,
			TbOdlDetRegQta.IdColore,
			TbOdlDetRegQta.IdVariante,
			TbOdlDetRegQta.[DimLunghezza],
			TbOdlDetRegQta.[DimLarghezza],
			TbOdlDetRegQta.[DimAltezza],
			TbOdlDetRegQta.IdMatricola
		FROM TbOdlDetRegQta
		INNER JOIN Deleted
			ON TbOdlDetRegQta.IdOdlDet = Deleted.IdOdlDet
		INNER JOIN TbOdl
			ON Deleted.IdOdl = TbOdl.IdOdl
		INNER JOIN TbOdlAnagCausali
			ON TbOdl.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbMageAnag
			ON COALESCE(Deleted.IdMage1, TbOdl.IdMage1, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN Inserted
			ON Inserted.IdOdlDet = Deleted.IdOdlDet
				AND isnull(Inserted.IdArticolo, '') = isnull(Deleted.IdArticolo, '')
				AND ISNULL(Deleted.IdMage1, '') = ISNULL(Inserted.IdMage1, '')
				AND ISNULL(Deleted.MagePosiz1, '') = ISNULL(Inserted.MagePosiz1, '')
		WHERE (Inserted.IdOdlDet IS NULL)
			AND (Deleted.IdArticolo IS NOT NULL)
			AND (TbOdlDetRegQta.QtaPz IS NOT NULL)
			AND (
				TbOdlAnagCausali.FlgMovMag1 = 1
				OR COALESCE(Deleted.IdMage1, TbOdl.IdMage1) IS NOT NULL
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
			'TbOdlDet' AS TipoDoc,
			TbOdl.IdOdl,
			TbOdlDetRegQta.IdOdlDetRegQta,
			Inserted.IdArticolo,
            dbo.FncKeyMage1(IsNull(TbCliOrd.IdCliente, Inserted.IdCliente), 'C', 'ODL', dbo.TbOdl.IdOdl, Inserted.IdOdlDet, COALESCE(Inserted.IdMage1, TbOdl.IdMage1, N'000'), dbo.TbMageAnag.CodFnzTipo) AS KeyMage,
			-- dbo.FncKeyMage(CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN dbo.TbOdl.IdOdl
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN IsNull(TbCliOrd.IdCliente, Inserted.IdCliente)
			-- 		ELSE 0
			-- 		END, CASE 
            --         WHEN dbo.TbMageAnag.CodFnzTipo = 'OL'
			-- 			THEN 'O'
			-- 		WHEN dbo.TbMageAnag.CodFnzTipo = 'CF'
			-- 			THEN 'C'
			-- 		ELSE NULL
			-- 		END, COALESCE(Inserted.IdMage1, TbOdl.IdMage1, N'000'), TbMageAnag.CodFnzTipo) AS KeyMage,
			COALESCE(Inserted.IdMage1, TbOdl.IdMage1, '000') AS IdMage,
			ROUND(ISNULL(TbOdlDetRegQta.QtaVrt, 0), 4) AS QtaMov,
			ROUND(ISNULL(TbOdlDetRegQta.QtaMageMov, 0), 4) AS QtaMageMov,
			Inserted.IdArtVrt,
            COALESCE(Inserted.MagePosiz, TbOdl.MagePosiz) AS MagePosiz,
			TbOdlDetRegQta.IdLotto,
			TbOdlDetRegQta.IdColore,
			TbOdlDetRegQta.IdVariante,
			TbOdlDetRegQta.[DimLunghezza],
			TbOdlDetRegQta.[DimLarghezza],
			TbOdlDetRegQta.[DimAltezza],
			TbOdlDetRegQta.IdMatricola
		FROM TbOdlDetRegQta
		INNER JOIN Inserted
			ON TbOdlDetRegQta.IdOdlDet = Inserted.IdOdlDet
		INNER JOIN TbOdl
			ON Inserted.IdOdl = TbOdl.IdOdl
		INNER JOIN TbOdlAnagCausali
			ON TbOdl.IdCausaleOdl = TbOdlAnagCausali.IdCausaleOdl
		INNER JOIN TbMageAnag
			ON COALESCE(Inserted.IdMage1, TbOdl.IdMage1, '000') = TbMageAnag.IdMage
		LEFT OUTER JOIN dbo.TbCliOrdDet
			ON TbOdlDetRegQta.IdCliOrdDet = dbo.TbCliOrdDet.IdCliOrdDet
		LEFT OUTER JOIN dbo.TbCliOrd
			ON dbo.TbCliOrd.IdCliOrd = dbo.TbCliOrdDet.IdCliOrd
		LEFT OUTER JOIN Deleted
			ON Inserted.IdOdlDet = Deleted.IdOdlDet
				AND isnull(Inserted.IdArticolo, '') = isnull(Deleted.IdArticolo, '')
				AND ISNULL(Deleted.IdMage1, '') = ISNULL(Inserted.IdMage1, '')
				AND ISNULL(Deleted.MagePosiz1, '') = ISNULL(Inserted.MagePosiz1, '')
				AND Deleted.SysDisableTrigger = Inserted.SysDisableTrigger
		WHERE (Deleted.IdOdlDet IS NULL)
			AND (Inserted.IdArticolo IS NOT NULL)
			AND (TbOdlDetRegQta.QtaPz IS NOT NULL)
			AND (
				TbOdlAnagCausali.FlgMovMag1 = 1
				OR COALESCE(Inserted.IdMage1, TbOdl.IdMage1) IS NOT NULL
				)
	END
END

GO


-- ==========================================================================================
-- Entity Name:    TrOdlDet_Art
-- Author:         dav
-- Create date:    14/02/2013 21:23
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    
-- History:
-- dav 14/02/2013 Creazione
-- dav 220224 Gestione SysDisableTrigger
-- dav 230223 Formattazione
-- ==========================================================================================
CREATE TRIGGER [dbo].[TrOdlDet_Art] ON [dbo].[TbOdlDet]
AFTER INSERT,
	UPDATE,
	DELETE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF NOT EXISTS (
			SELECT SysDisableTrigger
			FROM inserted
			WHERE SysDisableTrigger = 0
			)
		AND NOT EXISTS (
			(
				SELECT SysDisableTrigger
				FROM deleted
				WHERE SysDisableTrigger = 0
				)
			)
	BEGIN
		RETURN
	END

	-- Note
	-- Il trigger non può essere controllato con if update(nomecampo) perchè la stp aggiorna tutto
	-- per evitare aggiornamenti per ogno modifica serve join su inserted e delete su campi critici
	/*******************************************
	* aggiorna la Qta in produzione
	*******************************************/
	UPDATE TbArtElab
	SET QtaMageDispOdl = ISNULL(TbArtElab.QtaMageDispOdl, 0) - ISNULL(x.QtaMov, 0)
	FROM (
		SELECT SUM(CASE 
					WHEN Deleted.FlgChiusuraMan = 0
						THEN Deleted.QtaMageMov
					ELSE isnull(TbOdlDetElab.QtaProdotta, 0) / isnull(Deleted.UnitMCoeff, 1)
					END) AS QtaMov,
			Deleted.IdArticolo
		FROM Deleted
		INNER JOIN TbOdl
			ON Deleted.IdOdl = TbOdl.IdOdl
		LEFT OUTER JOIN TbOdlDetElab
			ON Deleted.IdOdlDet = TbOdlDetElab.IdOdlDet
		LEFT OUTER JOIN Inserted
			ON (
					Deleted.IdOdlDet = Inserted.IdOdlDet
					AND Deleted.FlgChiusuraMan = Inserted.FlgChiusuraMan
					AND Deleted.UnitMCoeff = Inserted.UnitMCoeff
					AND isnull(Deleted.QtaMageMov, 0) = isnull(Inserted.QtaMageMov, 0)
					AND Deleted.IdArticolo = Inserted.IdArticolo
					)
		WHERE (Inserted.IdOdl IS NULL)
		GROUP BY Deleted.IdArticolo
		) AS x
	INNER JOIN TbArtElab
		ON x.IdArticolo = TbArtElab.IdArticolo

	UPDATE TbArtElab
	SET QtaMageDispOdl = ISNULL(TbArtElab.QtaMageDispOdl, 0) + ISNULL(x.QtaMov, 0)
	FROM (
		SELECT SUM(CASE 
					WHEN Inserted.FlgChiusuraMan = 0
						THEN Inserted.QtaMageMov
					ELSE isnull(TbOdlDetElab.QtaProdotta, 0) / isnull(Inserted.UnitMCoeff, 1)
					END) AS QtaMov,
			Inserted.IdArticolo
		FROM Inserted
		INNER JOIN TbOdl
			ON Inserted.IdOdl = TbOdl.IdOdl
		LEFT OUTER JOIN TbOdlDetElab
			ON Inserted.IdOdlDet = TbOdlDetElab.IdOdlDet
		LEFT OUTER JOIN Deleted
			ON (
					Deleted.IdOdlDet = Inserted.IdOdlDet
					AND Deleted.FlgChiusuraMan = Inserted.FlgChiusuraMan
					AND Deleted.UnitMCoeff = Inserted.UnitMCoeff
					AND isnull(Deleted.QtaMageMov, 0) = isnull(Inserted.QtaMageMov, 0)
					AND Deleted.IdArticolo = Inserted.IdArticolo
					AND Deleted.SysDisableTrigger = Inserted.SysDisableTrigger
					)
		WHERE (Deleted.IdOdl IS NULL)
		GROUP BY Inserted.IdArticolo
		) AS x
	INNER JOIN TbArtElab
		ON x.IdArticolo = TbArtElab.IdArticolo

	/*******************************************
	* aggiorna la Qta impegnata
	*******************************************/
	UPDATE TbArtElab
	SET QtaMageImpOdl = ISNULL(TbArtElab.QtaMageImpOdl, 0) - ISNULL(x.QtaMov, 0)
	FROM (
		SELECT SUM(CASE 
					WHEN Deleted.FlgChiusuraMan = 0
						THEN Deleted.QtaMageMov
					ELSE isnull(TbOdlDetElab.QtaProdotta, 0) / isnull(Deleted.UnitMCoeff, 1)
					END * TbOdlDetDist.QtaMageMov) AS QtaMov,
			TbOdlDetDist.IdArticolo
		FROM Deleted
		INNER JOIN TbOdl
			ON Deleted.IdOdl = TbOdl.IdOdl
		INNER JOIN TbOdlDetDist
			ON Deleted.IdOdlDet = TbOdlDetDist.IdOdlDet
		LEFT OUTER JOIN TbOdlDetElab
			ON Deleted.IdOdlDet = TbOdlDetElab.IdOdlDet
		LEFT OUTER JOIN Inserted
			ON (
					Deleted.IdOdlDet = Inserted.IdOdlDet
					AND Deleted.FlgChiusuraMan = Inserted.FlgChiusuraMan
					AND Deleted.UnitMCoeff = Inserted.UnitMCoeff
					AND isnull(Deleted.QtaMageMov, 0) = isnull(Inserted.QtaMageMov, 0)
					AND Deleted.IdArticolo = Inserted.IdArticolo
					)
		WHERE (Inserted.IdOdl IS NULL)
		GROUP BY TbOdlDetDist.IdArticolo
		) AS x
	INNER JOIN TbArtElab
		ON x.IdArticolo = TbArtElab.IdArticolo

	UPDATE TbArtElab
	SET QtaMageImpOdl = ISNULL(TbArtElab.QtaMageImpOdl, 0) + ISNULL(x.QtaMov, 0)
	FROM (
		SELECT SUM(CASE 
					WHEN Inserted.FlgChiusuraMan = 0
						THEN Inserted.QtaMageMov
					ELSE isnull(TbOdlDetElab.QtaProdotta, 0) / isnull(Inserted.UnitMCoeff, 1)
					END * TbOdlDetDist.QtaMageMov) AS QtaMov,
			TbOdlDetDist.IdArticolo
		FROM Inserted
		INNER JOIN TbOdl
			ON Inserted.IdOdl = TbOdl.IdOdl
		INNER JOIN TbOdlDetDist
			ON Inserted.IdOdlDet = TbOdlDetDist.IdOdlDet
		LEFT OUTER JOIN TbOdlDetElab
			ON Inserted.IdOdlDet = TbOdlDetElab.IdOdlDet
		LEFT OUTER JOIN Deleted
			ON (
					Deleted.IdOdlDet = Inserted.IdOdlDet
					AND Deleted.FlgChiusuraMan = Inserted.FlgChiusuraMan
					AND Deleted.UnitMCoeff = Inserted.UnitMCoeff
					AND isnull(Deleted.QtaMageMov, 0) = isnull(Inserted.QtaMageMov, 0)
					AND Deleted.IdArticolo = Inserted.IdArticolo
					AND Deleted.SysDisableTrigger = Inserted.SysDisableTrigger
					)
		WHERE (Deleted.IdOdl IS NULL)
		GROUP BY TbOdlDetDist.IdArticolo
		) AS x
	INNER JOIN TbArtElab
		ON x.IdArticolo = TbArtElab.IdArticolo
END

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento alla riga ODL iniziale genratrice', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'COLUMN', @level2name = N'IdOdlDetMaster';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento alla riga ordl generatrice', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'COLUMN', @level2name = N'IdOdlDetOrigine';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indica la presenza di note spot nell''odl', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'COLUMN', @level2name = N'FlgNoteSpotOdl';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Comando di diabilitaizone trigger per operazioni massive', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'COLUMN', @level2name = N'SysDisableTrigger';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Quantità da produrre richiesta dalla distinta padre (unitaria)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'COLUMN', @level2name = N'QtaUnitMaster';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data della distinta da attivare', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'COLUMN', @level2name = N'DataArtDist';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Sequenza di produzione gestita da mrp se date di produzioni uguali tra due odldet', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'COLUMN', @level2name = N'SequenzaProd';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Riferimento alla riga ordine della riga odl generatrice', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDet', @level2type = N'COLUMN', @level2name = N'IdCliOrdDetOrigine';


GO

