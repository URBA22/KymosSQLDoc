CREATE TABLE [dbo].[TbModulaArticoli] (
    [IdArticolo]    NVARCHAR (50)   NOT NULL,
    [DescArticolo]  NVARCHAR (500)  NULL,
    [UnitM]         NVARCHAR (20)   NULL,
    [SysModulaExec] DATETIME        NULL,
    [SysDateCreate] DATETIME        CONSTRAINT [DF_TbModulaArticoli_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate] NVARCHAR (256)  NULL,
    [SysDateUpdate] DATETIME        NULL,
    [SysUserUpdate] NVARCHAR (256)  NULL,
    [SysRowVersion] ROWVERSION      NULL,
    [QtaMin]        DECIMAL (18, 8) NULL,
    CONSTRAINT [PK_TbModulaArticoli] PRIMARY KEY CLUSTERED ([IdArticolo] ASC)
);


GO

