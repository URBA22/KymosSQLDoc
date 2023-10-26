CREATE TABLE [dbo].[TbMntUnitaIntrvRegTmp] (
    [IdIntrvRegTmp] INT            IDENTITY (1, 1) NOT NULL,
    [IdIntrv]       NVARCHAR (20)  NOT NULL,
    [IdUtente]      NVARCHAR (256) NULL,
    [DataReg]       DATE           NULL,
    [DataInizio]    DATETIME       NULL,
    [DataFine]      DATETIME       NULL,
    [Durata]        REAL           NULL,
    [IdTipoAtvt]    NVARCHAR (20)  NULL,
    [NoteRegTmp]    NVARCHAR (MAX) NULL,
    [SysDateCreate] DATETIME       CONSTRAINT [DF_TbMntUnitaIntrvRegTmp_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate] NVARCHAR (256) NULL,
    [SysDateUpdate] DATETIME       NULL,
    [SysUserUpdate] NVARCHAR (256) NULL,
    [SysRowVersion] ROWVERSION     NULL,
    CONSTRAINT [PK_TbMntUnitaIntrvRegTmp] PRIMARY KEY CLUSTERED ([IdIntrvRegTmp] ASC),
    CONSTRAINT [FK_TbMntUnitaIntrvRegTmp_TbMntAnagIntrvTipoAtvt] FOREIGN KEY ([IdTipoAtvt]) REFERENCES [dbo].[TbMntAnagIntrvTipoAtvt] ([IdTipoAtvt]),
    CONSTRAINT [FK_TbMntUnitaIntrvRegTmp_TbMntUnitaIntrv] FOREIGN KEY ([IdIntrv]) REFERENCES [dbo].[TbMntUnitaIntrv] ([IdIntrv]),
    CONSTRAINT [FK_TbMntUnitaIntrvRegTmp_TbUtenti] FOREIGN KEY ([IdUtente]) REFERENCES [dbo].[TbUtenti] ([IdUtente])
);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Data di fine, utilizzata per registrazioni dirette dal campo', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbMntUnitaIntrvRegTmp', @level2type = N'COLUMN', @level2name = N'DataFine';


GO

