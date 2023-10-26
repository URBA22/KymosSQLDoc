CREATE TABLE [dbo].[TbOdlDetCostiAgnt] (
    [IdOdlDetCostoAgnt]   INT            IDENTITY (1, 1) NOT NULL,
    [IdOdlDet]            INT            NOT NULL,
    [IdForOrdDet]         INT            NULL,
    [IdArticolo]          NVARCHAR (50)  NULL,
    [NRiga]               INT            NULL,
    [DescCosto]           NVARCHAR (MAX) NULL,
    [IdCausaleCosto]      NVARCHAR (20)  NULL,
    [CostoUnit]           MONEY          NULL,
    [Qta]                 REAL           NULL,
    [UnitM]               NVARCHAR (20)  NULL,
    [CostoTot]            AS             ([CostoUnit]*isnull([Qta],(1))),
    [NoteOdlDetCostoAgnt] NVARCHAR (MAX) NULL,
    [MargineCostoAgnt]    REAL           NULL,
    [SysDateCreate]       DATETIME       CONSTRAINT [DF_TbOdlDetCostiAgnt_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate]       NVARCHAR (256) NULL,
    [SysDateUpdate]       DATETIME       NULL,
    [SysUserUpdate]       NVARCHAR (256) NULL,
    [SysRowVersion]       ROWVERSION     NULL,
    [CostoUnit1]          MONEY          NULL,
    [CostoUnit2]          MONEY          NULL,
    [CostoTot1]           AS             ([CostoUnit1]*isnull([Qta],(1))),
    [CostoTot2]           AS             ([CostoUnit2]*isnull([Qta],(1))),
    [DataCosto]           DATE           NULL,
    [CodFnzTipoCosto]     NVARCHAR (5)   NULL,
    [IdCliPrvCostoAgnt]   INT            NULL,
    [CmpOpz01]            NVARCHAR (50)  NULL,
    [CmpOpz02]            NVARCHAR (50)  NULL,
    [CmpOpz03]            NVARCHAR (50)  NULL,
    [CmpOpz04]            NVARCHAR (50)  NULL,
    [CmpOpz05]            NVARCHAR (50)  NULL,
    CONSTRAINT [PK_TbOdlDetCostiAgnt] PRIMARY KEY CLUSTERED ([IdOdlDetCostoAgnt] ASC),
    CONSTRAINT [FK_TbOdlDetCostiAgnt_TbAnagUnitM] FOREIGN KEY ([UnitM]) REFERENCES [dbo].[TbUnitM] ([UnitM]),
    CONSTRAINT [FK_TbOdlDetCostiAgnt_TbArticoli] FOREIGN KEY ([IdArticolo]) REFERENCES [dbo].[TbArticoli] ([IdArticolo]),
    CONSTRAINT [FK_TbOdlDetCostiAgnt_TbCliPrvCostiAgnt] FOREIGN KEY ([IdCliPrvCostoAgnt]) REFERENCES [dbo].[TbCliPrvCostiAgnt] ([IdCliPrvCostoAgnt]),
    CONSTRAINT [FK_TbOdlDetCostiAgnt_TbForOrdDet] FOREIGN KEY ([IdForOrdDet]) REFERENCES [dbo].[TbForOrdDet] ([IdForOrdDet]),
    CONSTRAINT [FK_TbOdlDetCostiAgnt_TbOdlAnagCausaliCosti] FOREIGN KEY ([IdCausaleCosto]) REFERENCES [dbo].[TbOdlAnagCausaliCosti] ([IdCausaleCosto]),
    CONSTRAINT [FK_TbOdlDetCostiAgnt_TbOdlDet] FOREIGN KEY ([IdOdlDet]) REFERENCES [dbo].[TbOdlDet] ([IdOdlDet])
);


GO

CREATE NONCLUSTERED INDEX [IX_TbOdlDetCostiAgnt]
    ON [dbo].[TbOdlDetCostiAgnt]([IdOdlDet] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCostiAgnt';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCostiAgnt';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data del costo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCostiAgnt', @level2type = N'COLUMN', @level2name = N'DataCosto';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCostiAgnt';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCostiAgnt';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlDetCostiAgnt';


GO

