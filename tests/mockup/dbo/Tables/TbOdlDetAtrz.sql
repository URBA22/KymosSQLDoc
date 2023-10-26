CREATE TABLE [dbo].[TbOdlDetAtrz] (
    [IdAtrz]         INT            IDENTITY (1, 1) NOT NULL,
    [IdOdlDet]       INT            NOT NULL,
    [IdCdlUnita]     NVARCHAR (20)  NULL,
    [IdArticoloAtrz] NVARCHAR (50)  NULL,
    [Qta]            REAL           NULL,
    [DescAtrz]       NVARCHAR (300) NULL,
    [Disabilita]     BIT            CONSTRAINT [DF_TbOdlDetAtrz_Disabilita] DEFAULT ((0)) NOT NULL,
    [SysDateCreate]  DATETIME       CONSTRAINT [DF_TbOdlDetAtrz_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate]  NVARCHAR (256) NULL,
    [SysDateUpdate]  DATETIME       NULL,
    [SysUserUpdate]  NVARCHAR (256) NULL,
    [SysRowVersion]  ROWVERSION     NULL,
    [NRiga]          INT            NULL,
    [CodFnzTipo]     NVARCHAR (5)   NULL,
    [Posiz]          NVARCHAR (50)  NULL,
    [IdMatricola]    INT            NULL,
    [CostoUnit]      MONEY          NULL,
    [CostoTot]       AS             ([Qta]*[CostoUnit]),
    [UnitM]          NVARCHAR (20)  NULL,
    CONSTRAINT [PK_TbOdlDetAtrz] PRIMARY KEY CLUSTERED ([IdAtrz] ASC),
    CONSTRAINT [FK_TbOdlDetAtrz_TbArticoli] FOREIGN KEY ([IdArticoloAtrz]) REFERENCES [dbo].[TbArticoli] ([IdArticolo]),
    CONSTRAINT [FK_TbOdlDetAtrz_TbMatricole] FOREIGN KEY ([IdMatricola]) REFERENCES [dbo].[TbMatricole] ([IdMatricola]),
    CONSTRAINT [FK_TbOdlDetAtrz_TbOdlDet] FOREIGN KEY ([IdOdlDet]) REFERENCES [dbo].[TbOdlDet] ([IdOdlDet]),
    CONSTRAINT [FK_TbOdlDetAtrz_TbProdCdlUnita] FOREIGN KEY ([IdCdlUnita]) REFERENCES [dbo].[TbProdCdlUnita] ([IdCdlUnita]),
    CONSTRAINT [FK_TbOdlDetAtrz_TbUnitM] FOREIGN KEY ([UnitM]) REFERENCES [dbo].[TbUnitM] ([UnitM])
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Codice attrezzatura', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetAtrz', @level2type = N'COLUMN', @level2name = N'IdArticoloAtrz';


GO

