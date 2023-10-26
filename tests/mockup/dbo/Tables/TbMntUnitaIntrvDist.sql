CREATE TABLE [dbo].[TbMntUnitaIntrvDist] (
    [IdIntrvDist]   INT            IDENTITY (1, 1) NOT NULL,
    [IdIntrv]       NVARCHAR (20)  NOT NULL,
    [IdArticolo]    NVARCHAR (50)  NULL,
    [Descrizione]   NVARCHAR (MAX) NULL,
    [UnitM]         NVARCHAR (20)  NULL,
    [UnitMCoeff]    REAL           NULL,
    [Qta]           REAL           NULL,
    [CostoUnit]     MONEY          NULL,
    [CostoTot]      AS             (CONVERT([money],[Qta]*[CostoUnit],(0))),
    [SysUserCreate] NVARCHAR (256) NULL,
    [SysDateUpdate] DATETIME       NULL,
    [SysUserUpdate] NVARCHAR (256) NULL,
    [SysRowVersion] ROWVERSION     NULL,
    [SysDateCreate] DATETIME       CONSTRAINT [DF_TbMntUnitaIntrvDist_SysDateCreate] DEFAULT (getdate()) NULL,
    [Tavola]        NVARCHAR (15)  NULL,
    [TavolaPosiz]   NVARCHAR (10)  NULL,
    CONSTRAINT [PK_TbMntUnitaIntrvDist] PRIMARY KEY CLUSTERED ([IdIntrvDist] ASC),
    CONSTRAINT [FK_TbMntUnitaIntrvDist_TbArticoli] FOREIGN KEY ([IdArticolo]) REFERENCES [dbo].[TbArticoli] ([IdArticolo]),
    CONSTRAINT [FK_TbMntUnitaIntrvDist_TbMntUnitaIntrv] FOREIGN KEY ([IdIntrv]) REFERENCES [dbo].[TbMntUnitaIntrv] ([IdIntrv]),
    CONSTRAINT [FK_TbMntUnitaIntrvDist_TbUnitM] FOREIGN KEY ([UnitM]) REFERENCES [dbo].[TbUnitM] ([UnitM])
);


GO

