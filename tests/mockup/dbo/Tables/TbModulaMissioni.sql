CREATE TABLE [dbo].[TbModulaMissioni] (
    [IdMissione]    NVARCHAR (20)  NOT NULL,
    [TipoDoc]       NVARCHAR (20)  NULL,
    [IdDoc]         NVARCHAR (20)  NULL,
    [DescDoc]       NVARCHAR (200) NULL,
    [TipoOp]        NVARCHAR (1)   NULL,
    [CodFnzStatoOp] NVARCHAR (5)   NULL,
    [SysModulaExec] DATETIME       NULL,
    [SysDateCreate] DATETIME       CONSTRAINT [DF_TbModulaMissioni_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate] NVARCHAR (256) NULL,
    [SysDateUpdate] DATETIME       NULL,
    [SysUserUpdate] NVARCHAR (256) NULL,
    [SysRowVersion] ROWVERSION     NULL,
    [FlgSospeso]    BIT            CONSTRAINT [DF_TbModulaMissioni_FlgSospeso] DEFAULT ((1)) NOT NULL,
    CONSTRAINT [PK_TbModulaMissioni] PRIMARY KEY CLUSTERED ([IdMissione] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Stato dell''operazione rilasciato da Modula', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbModulaMissioni', @level2type = N'COLUMN', @level2name = N'CodFnzStatoOp';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Tipo Operazione, V versamento P Prelievo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbModulaMissioni', @level2type = N'COLUMN', @level2name = N'IdMissione';


GO

