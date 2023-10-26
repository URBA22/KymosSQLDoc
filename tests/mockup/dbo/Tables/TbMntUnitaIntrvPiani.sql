CREATE TABLE [dbo].[TbMntUnitaIntrvPiani] (
    [IdPiano]               INT            IDENTITY (1, 1) NOT NULL,
    [IdUnita]               INT            NOT NULL,
    [NRiga]                 INT            NULL,
    [IdPianoTipo]           NVARCHAR (20)  NULL,
    [Periodicita]           INT            NULL,
    [CodFnzTipoPeriodicita] NVARCHAR (5)   NULL,
    [Descrizione]           NVARCHAR (MAX) NULL,
    [DPI]                   NVARCHAR (50)  NULL,
    [NotePiano]             NVARCHAR (MAX) NULL,
    [FlgInterna]            BIT            CONSTRAINT [DF_TbMntUnitaIntrvPiani_FlgInterna] DEFAULT ((0)) NOT NULL,
    [Disabilita]            AS             (case when [DataDisabilita] IS NULL then (0) else (1) end),
    [SysUserCreate]         NVARCHAR (256) NULL,
    [SysDateUpdate]         DATETIME       NULL,
    [SysUserUpdate]         NVARCHAR (256) NULL,
    [SysRowVersion]         ROWVERSION     NULL,
    [SysDateCreate]         DATETIME       CONSTRAINT [DF_TbMntUnitaIntrvPiani_SysDateCreate] DEFAULT (getdate()) NULL,
    [DataDisabilita]        DATETIME       NULL,
    [IdArticolo]            NVARCHAR (50)  NULL,
    [DurataPrevIntrv]       INT            NULL,
    CONSTRAINT [PK_TbMntUnitaIntrvPiani] PRIMARY KEY CLUSTERED ([IdPiano] ASC),
    CONSTRAINT [FK_TbMntUnitaIntrvPiani_TbArticoli] FOREIGN KEY ([IdArticolo]) REFERENCES [dbo].[TbArticoli] ([IdArticolo]),
    CONSTRAINT [FK_TbMntUnitaIntrvPiani_TbMntAnagPianiTipo] FOREIGN KEY ([IdPianoTipo]) REFERENCES [dbo].[TbMntAnagPianiTipo] ([IdPianoTipo]),
    CONSTRAINT [FK_TbMntUnitaIntrvPiani_TbMntUnita] FOREIGN KEY ([IdUnita]) REFERENCES [dbo].[TbMntUnita] ([IdUnita])
);


GO

CREATE NONCLUSTERED INDEX [IX_TbMntUnitaIntrvPiani]
    ON [dbo].[TbMntUnitaIntrvPiani]([IdUnita] ASC);


GO

-- =============================================
-- Author:		Dav
-- Create date: 10.04.19
-- Description: Crea record su tabella elab
-- =============================================
create TRIGGER [dbo].[TrMntUnitaIntrvPiani_Elab]
   ON  [dbo].[TbMntUnitaIntrvPiani] 
   AFTER INSERT  --,DELETE,UPDATE>
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    INSERT INTO TbMntUnitaIntrvPianiElab (IdPiano)
	SELECT     IdPiano
	FROM  Inserted 

END

GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Km, Ore, GG', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbMntUnitaIntrvPiani', @level2type = N'COLUMN', @level2name = N'Periodicita';


GO

