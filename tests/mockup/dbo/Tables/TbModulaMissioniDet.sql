CREATE TABLE [dbo].[TbModulaMissioniDet] (
    [IdMissioneDet] INT             IDENTITY (1, 1) NOT NULL,
    [IdMissione]    NVARCHAR (20)   NOT NULL,
    [IdRigaDoc]     INT             NULL,
    [NRiga]         INT             NULL,
    [IdArticolo]    NVARCHAR (50)   NULL,
    [Qta]           DECIMAL (18, 8) NULL,
    [Lotto]         NVARCHAR (50)   NULL,
    [NoteMov]       NVARCHAR (200)  NULL,
    [QtaMov]        DECIMAL (18, 8) NULL,
    [IdArticoloMov] NVARCHAR (50)   NULL,
    [LottoMov]      NVARCHAR (50)   NULL,
    [SysModulaExec] DATETIME        NULL,
    [SysDateCreate] DATETIME        CONSTRAINT [DF_TbModulaMissioniDet_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate] NVARCHAR (256)  NULL,
    [SysDateUpdate] DATETIME        NULL,
    [SysUserUpdate] NVARCHAR (256)  NULL,
    [SysRowVersion] ROWVERSION      NULL,
    [Attributo]     NVARCHAR (100)  NULL,
    [QtaMovTot]     DECIMAL (18, 8) NULL,
    [SysModulaSend] DATETIME        NULL,
    [IdMatricola]   INT             NULL,
    [IdMagePosiz]   INT             NULL,
    [IdCdlUnita]    NVARCHAR (20)   NULL,
    CONSTRAINT [PK_TbModulaMissioniDet] PRIMARY KEY CLUSTERED ([IdMissioneDet] ASC),
    CONSTRAINT [FK_TbModulaMissioniDet_TbModulaMissioni] FOREIGN KEY ([IdMissione]) REFERENCES [dbo].[TbModulaMissioni] ([IdMissione])
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Qta movimentata in totale fino a quel momento', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbModulaMissioniDet', @level2type = N'COLUMN', @level2name = N'QtaMovTot';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Note sul movimento rilasciate dall''operatore in mdula', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbModulaMissioniDet', @level2type = N'COLUMN', @level2name = N'NoteMov';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo Operazione, V versamento P Prelievo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbModulaMissioniDet', @level2type = N'COLUMN', @level2name = N'IdMissione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Qta Richiesta', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbModulaMissioniDet', @level2type = N'COLUMN', @level2name = N'Qta';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Ultima Qta movimentata dall''operatore in modula', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbModulaMissioniDet', @level2type = N'COLUMN', @level2name = N'QtaMov';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Lotto di produzione (opzionale)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbModulaMissioniDet', @level2type = N'COLUMN', @level2name = N'Lotto';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Lotto di produzione (opzionale)', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbModulaMissioniDet', @level2type = N'COLUMN', @level2name = N'LottoMov';


GO

