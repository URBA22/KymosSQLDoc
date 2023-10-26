CREATE TABLE [dbo].[TbMntUnitaIntrvPianiElab] (
    [IdPiano]           INT           NOT NULL,
    [DeltaPeriodicita]  REAL          NULL,
    [DataIntrvUltimo]   DATE          NULL,
    [DataIntrvProssimo] DATE          NULL,
    [ColRiga]           NVARCHAR (7)  NULL,
    [CodFnzStato]       NVARCHAR (5)  NULL,
    [IdCdlUnita]        NVARCHAR (50) NULL,
    CONSTRAINT [PK_TbMntUnitaIntrvPianiElab] PRIMARY KEY CLUSTERED ([IdPiano] ASC),
    CONSTRAINT [FK_TbMntUnitaIntrvPianiElab_TbMntUnitaIntrvPiani] FOREIGN KEY ([IdPiano]) REFERENCES [dbo].[TbMntUnitaIntrvPiani] ([IdPiano]) ON DELETE CASCADE ON UPDATE CASCADE
);


GO

CREATE NONCLUSTERED INDEX [IX_TbMntUnitaIntrvPianiElab]
    ON [dbo].[TbMntUnitaIntrvPianiElab]([DataIntrvUltimo] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data Prevista prossimo controllo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbMntUnitaIntrvPianiElab', @level2type = N'COLUMN', @level2name = N'DataIntrvProssimo';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Delat su periodicità (ad esempio ore di lavoro da ultimo controllo o pezzi prodotti)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbMntUnitaIntrvPianiElab', @level2type = N'COLUMN', @level2name = N'DeltaPeriodicita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data Ultimo controllo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbMntUnitaIntrvPianiElab', @level2type = N'COLUMN', @level2name = N'DataIntrvUltimo';


GO

