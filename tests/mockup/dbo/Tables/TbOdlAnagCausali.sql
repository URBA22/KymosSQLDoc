CREATE TABLE [dbo].[TbOdlAnagCausali] (
    [IdCausaleOdl]            NVARCHAR (20)  NOT NULL,
    [DescCausaleOdl]          NVARCHAR (200) NULL,
    [PrefDoc]                 NVARCHAR (2)   NULL,
    [Disabilita]              BIT            CONSTRAINT [DF_TbOdlAnagCausali_Disabilita] DEFAULT ((0)) NOT NULL,
    [Predefinita]             BIT            CONSTRAINT [DF_TbOdlAnagCausali_Predefinita] DEFAULT ((0)) NOT NULL,
    [NoteCausaleOdl]          NVARCHAR (MAX) NULL,
    [IdMage]                  NVARCHAR (10)  NULL,
    [IdMage1]                 NVARCHAR (10)  NULL,
    [FlgMovMag]               BIT            CONSTRAINT [DF_TbOdlAnagCausali_FlgMovMag] DEFAULT ((0)) NOT NULL,
    [FlgMovMag1]              BIT            CONSTRAINT [DF_TbOdlAnagCausali_FlgMovMag1] DEFAULT ((0)) NOT NULL,
    [CodFnzDocP]              NVARCHAR (5)   NULL,
    [CodFnzTipoMage]          NVARCHAR (5)   NULL,
    [CodFnzTipoMage1]         NVARCHAR (5)   NULL,
    [FlgRiparazione]          BIT            CONSTRAINT [DF_TbOdlAnagCausali_FlgRiparazione] DEFAULT ((0)) NOT NULL,
    [SysDateCreate]           DATETIME       CONSTRAINT [DF_TbOdlAnagCausali_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate]           NVARCHAR (256) NULL,
    [SysDateUpdate]           DATETIME       NULL,
    [SysUserUpdate]           NVARCHAR (256) NULL,
    [SysRowVersion]           ROWVERSION     NULL,
    [FlgNoCosto]              BIT            CONSTRAINT [DF_TbOdlAnagCausali_FlgNoCosto] DEFAULT ((0)) NOT NULL,
    [FlgProgramma]            BIT            CONSTRAINT [DF_TbOdlAnagCausali_FlgProgramma] DEFAULT ((0)) NOT NULL,
    [FlgCliOrdDetOdlAgncAuto] BIT            CONSTRAINT [DF_TbOdlAnagCausali_FlgCliOrdDetOdlAgncAuto] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_TbOdlAnagCausali] PRIMARY KEY CLUSTERED ([IdCausaleOdl] ASC),
    CONSTRAINT [FK_TbOdlAnagCausali_TbMageAnag] FOREIGN KEY ([IdMage]) REFERENCES [dbo].[TbMageAnag] ([IdMage]),
    CONSTRAINT [FK_TbOdlAnagCausali_TbMageAnag1] FOREIGN KEY ([IdMage1]) REFERENCES [dbo].[TbMageAnag] ([IdMage])
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologie di magazzini selezioanbili, se null permette la scelta di tutti', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali', @level2type = N'COLUMN', @level2name = N'CodFnzTipoMage1';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag che abilita la movimentazione di magazzino 1  su testata documento', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali', @level2type = N'COLUMN', @level2name = N'FlgMovMag1';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ordine a programma a scalare', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali', @level2type = N'COLUMN', @level2name = N'FlgProgramma';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di causale di riparazione, richiede il compoennte stesso in distinta ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali', @level2type = N'COLUMN', @level2name = N'FlgRiparazione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Magazzino di prelievo predefinito', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali', @level2type = N'COLUMN', @level2name = N'IdMage';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Magazzino di destinazione Predefinito', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali', @level2type = N'COLUMN', @level2name = N'IdMage1';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologie dei documenti padri generatori, utilizzato come filtro per la compilazione del documento', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali', @level2type = N'COLUMN', @level2name = N'CodFnzDocP';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag che abilita la movimentazione di magazzino su testata documento', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali', @level2type = N'COLUMN', @level2name = N'FlgMovMag';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Flag di esclusione dell''ordine dalla elaborazione costi', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali', @level2type = N'COLUMN', @level2name = N'FlgNoCosto';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipologie di magazzini selezioanbili, se null permette la scelta di tutti', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausali', @level2type = N'COLUMN', @level2name = N'CodFnzTipoMage';


GO

