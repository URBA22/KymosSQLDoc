CREATE TABLE [dbo].[TbModulaBaieMov] (
    [IdBaiaMov]     NVARCHAR (20)  NOT NULL,
    [IdMage]        NVARCHAR (10)  NULL,
    [IdMage1]       NVARCHAR (10)  NULL,
    [NoteBaiaMov]   NVARCHAR (200) NULL,
    [SysModulaExec] DATETIME       NULL,
    [SysDateCreate] DATETIME       CONSTRAINT [DF_TbModulaBaieMov_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate] NVARCHAR (256) NULL,
    [SysDateUpdate] DATETIME       NULL,
    [SysUserUpdate] NVARCHAR (256) NULL,
    [SysRowVersion] ROWVERSION     NULL,
    [MagePosiz]     NVARCHAR (20)  NULL,
    [MagePosiz1]    NVARCHAR (20)  NULL,
    CONSTRAINT [PK_TbModulaBaieMov] PRIMARY KEY CLUSTERED ([IdBaiaMov] ASC),
    CONSTRAINT [FK_TbModulaBaieMov_TbMageAnag] FOREIGN KEY ([IdMage]) REFERENCES [dbo].[TbMageAnag] ([IdMage]),
    CONSTRAINT [FK_TbModulaBaieMov_TbMageAnag1] FOREIGN KEY ([IdMage1]) REFERENCES [dbo].[TbMageAnag] ([IdMage])
);


GO

