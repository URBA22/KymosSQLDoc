CREATE TABLE [dbo].[TbOdlDetCliOrd] (
    [IdCliOrdDet]       INT            NOT NULL,
    [IdOdlDet]          INT            NOT NULL,
    [Qta]               REAL           NULL,
    [DataProdRichiesta] DATE           NULL,
    [NRiga]             INT            NULL,
    [SysDateCreate]     DATETIME       CONSTRAINT [DF_TbOdlDetCliOrd_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate]     NVARCHAR (256) NULL,
    [SysDateUpdate]     DATETIME       NULL,
    [SysUserUpdate]     NVARCHAR (256) NULL,
    [SysRowVersion]     ROWVERSION     NULL,
    CONSTRAINT [PK_TbOdlDetCliOrd] PRIMARY KEY CLUSTERED ([IdCliOrdDet] ASC, [IdOdlDet] ASC),
    CONSTRAINT [FK_TbOdlDetCliOrd_TbCliOrdDet] FOREIGN KEY ([IdCliOrdDet]) REFERENCES [dbo].[TbCliOrdDet] ([IdCliOrdDet]),
    CONSTRAINT [FK_TbOdlDetCliOrd_TbOdlDet] FOREIGN KEY ([IdOdlDet]) REFERENCES [dbo].[TbOdlDet] ([IdOdlDet])
);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdlDetCliOrd_IdOdlDet]
    ON [dbo].[TbOdlDetCliOrd]([IdOdlDet] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCliOrd', @level2type = N'TRIGGER', @level2name = N'TrOdlDetCliOrd_CliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '06/09/2013 19:07:48', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCliOrd', @level2type = N'TRIGGER', @level2name = N'TrOdlDetCliOrd_CliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCliOrd', @level2type = N'TRIGGER', @level2name = N'TrOdlDetCliOrd_CliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCliOrd', @level2type = N'TRIGGER', @level2name = N'TrOdlDetCliOrd_CliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCliOrd', @level2type = N'TRIGGER', @level2name = N'TrOdlDetCliOrd_CliOrd';


GO

-- ==========================================================================================
-- Entity Name:    TrOdlDetCliOrd_CliOrd
-- Author:         dav
-- Create date:    14/02/2013 21:23
-- Custom_Dbo:     NO
-- Standard_dbo:   YES
-- CustomNote:     
-- Description:    
-- History:
-- dav 21.08.15 Aggiornamneto QtaProgrammata senza conversione
-- dav 230328 Formattazione
-- ==========================================================================================

CREATE TRIGGER [dbo].[TrOdlDetCliOrd_CliOrd] ON [dbo].[TbOdlDetCliOrd]
AFTER INSERT,
	UPDATE,
	DELETE
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Note
	-- Il trigger non può essere controllato con if update(nomecampo) perchè la stp aggiorna tutto
	-- per evitare aggiornamenti per ogno modifica serve join su inserted e delete su campi critici
	/*******************************************
	* aggiorna la Qta programmate negli ordini cli
	*******************************************/
	-- se riga chiusa manualmente non conteggia come qta in produzione
	UPDATE TbCliOrdDetElab
	SET QtaProgrammata = ROUND(ISNULL(TbCliOrdDetElab.QtaProgrammata, 0) - ISNULL(x.QtaMov, 0), 2)
	FROM (
		SELECT SUM(Deleted.Qta / isnull(TbOdlDet.UnitMCoeff, 1)) AS QtaMov,
			Deleted.IdCliOrdDet
		FROM Deleted
		INNER JOIN TbOdlDet
			ON Deleted.IdOdlDet = TbOdlDet.IdOdlDet
		LEFT OUTER JOIN Inserted
			ON (
					Deleted.IdCliOrdDet = Inserted.IdCliOrdDet
					AND Deleted.IdOdlDet = Inserted.IdOdlDet
					AND isnull(Deleted.Qta, 0) = isnull(Inserted.Qta, 0)
					AND isnull(Deleted.IdCliOrdDet, 0) = isnull(Inserted.IdCliOrdDet, 0)
					)
		WHERE (Inserted.IdOdlDet IS NULL)
			AND TbOdlDet.FlgChiusuraMan = 0
		GROUP BY Deleted.IdCliOrdDet
		) AS x
	INNER JOIN TbCliOrdDetElab
		ON x.IdCliOrdDet = TbCliOrdDetElab.IdCliOrdDet
	INNER JOIN TbCliOrdDet
		ON x.IdCliOrdDet = TbCliOrdDet.IdCliOrdDet

	UPDATE TbCliOrdDetElab
	SET QtaProgrammata = ROUND(ISNULL(TbCliOrdDetElab.QtaProgrammata, 0) + ISNULL(x.QtaMov, 0), 2)
	FROM (
		SELECT SUM(Inserted.Qta / isnull(TbOdlDet.UnitMCoeff, 1)) AS QtaMov,
			Inserted.IdCliOrdDet
		FROM Inserted
		INNER JOIN TbOdlDet
			ON Inserted.IdOdlDet = TbOdlDet.IdOdlDet
		LEFT OUTER JOIN Deleted
			ON (
					Deleted.IdCliOrdDet = Inserted.IdCliOrdDet
					AND Deleted.IdOdlDet = Inserted.IdOdlDet
					AND isnull(Deleted.Qta, 0) = isnull(Inserted.Qta, 0)
					AND isnull(Deleted.IdCliOrdDet, 0) = isnull(Inserted.IdCliOrdDet, 0)
					)
		WHERE (Deleted.IdOdlDet IS NULL)
			AND TbOdlDet.FlgChiusuraMan = 0
		GROUP BY Inserted.IdCliOrdDet
		) AS x
	INNER JOIN TbCliOrdDetElab
		ON x.IdCliOrdDet = TbCliOrdDetElab.IdCliOrdDet
	INNER JOIN TbCliOrdDet
		ON x.IdCliOrdDet = TbCliOrdDet.IdCliOrdDet
END

GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '05/19/2013 00:00:00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Dav', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'OrdiniClienti associati a ODL', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di produzione richiesta', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCliOrd', @level2type = N'COLUMN', @level2name = N'DataProdRichiesta';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCliOrd';


GO

