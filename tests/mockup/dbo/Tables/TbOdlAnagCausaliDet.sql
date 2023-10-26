CREATE TABLE [dbo].[TbOdlAnagCausaliDet] (
    [IdCausaleOdlDet] NVARCHAR (20)  NOT NULL,
    [DescCausale]     NVARCHAR (200) NULL,
    [Disabilita]      BIT            CONSTRAINT [DF_TbOdlAnagCausaliDet_Disabilita] DEFAULT ((0)) NOT NULL,
    [NoteCausale]     NVARCHAR (MAX) NULL,
    [IdMage]          NVARCHAR (10)  NULL,
    [IdMage1]         NVARCHAR (10)  NULL,
    [SysDateCreate]   DATETIME       CONSTRAINT [DF_TbOdlAnagCausaliDet_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate]   NVARCHAR (256) NULL,
    [SysDateUpdate]   DATETIME       NULL,
    [SysUserUpdate]   NVARCHAR (256) NULL,
    [SysRowVersion]   ROWVERSION     NULL,
    CONSTRAINT [PK_TbOdlAnagCausaliDet] PRIMARY KEY CLUSTERED ([IdCausaleOdlDet] ASC),
    CONSTRAINT [FK_TbOdlAnagCausaliDet_TbMageAnag] FOREIGN KEY ([IdMage]) REFERENCES [dbo].[TbMageAnag] ([IdMage]),
    CONSTRAINT [FK_TbOdlAnagCausaliDet_TbMageAnag1] FOREIGN KEY ([IdMage1]) REFERENCES [dbo].[TbMageAnag] ([IdMage])
);


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliDet';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Magazzino di prelievo predefinito', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliDet', @level2type = N'COLUMN', @level2name = N'IdMage';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliDet';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliDet';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '05/19/2013 11:42:47', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliDet';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Magazzino di destinazione Predefinito', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliDet', @level2type = N'COLUMN', @level2name = N'IdMage1';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliDet';


GO

