CREATE TABLE [dbo].[TbModulaArticoliUbc] (
    [IdArtUbc]         INT             IDENTITY (1, 1) NOT NULL,
    [IdArticolo]       NVARCHAR (50)   NOT NULL,
    [Lotto]            NVARCHAR (50)   NULL,
    [DescArticolo]     NVARCHAR (500)  NULL,
    [UnitM]            NVARCHAR (20)   NULL,
    [Qta]              DECIMAL (18, 8) NULL,
    [SysModulaExec]    DATETIME        NULL,
    [SysDateCreate]    DATETIME        CONSTRAINT [DF_TbModulaArticoliUbc_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate]    NVARCHAR (256)  NULL,
    [SysDateUpdate]    DATETIME        NULL,
    [SysUserUpdate]    NVARCHAR (256)  NULL,
    [SysRowVersion]    ROWVERSION      NULL,
    [SysModulaExecMod] DATETIME        NULL,
    [UBI_Scomparto]    NVARCHAR (50)   NULL,
    [UBI_Area]         NVARCHAR (50)   NULL,
    [UBI_Corridoio]    NVARCHAR (50)   NULL,
    [UBI_Udc]          NVARCHAR (50)   NULL,
    [IdMage]           NVARCHAR (10)   NULL,
    CONSTRAINT [PK_TbModulaArticoliUbc] PRIMARY KEY CLUSTERED ([IdArtUbc] ASC)
);


GO

