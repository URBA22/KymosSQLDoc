CREATE TABLE [dbo].[TbMntUnitaDpi] (
    [IdUnitaDpi]    INT            IDENTITY (1, 1) NOT NULL,
    [IdUnita]       INT            NOT NULL,
    [IdDpi]         NVARCHAR (20)  NOT NULL,
    [SysUserCreate] NVARCHAR (256) NULL,
    [SysDateUpdate] DATETIME       NULL,
    [SysUserUpdate] NVARCHAR (256) NULL,
    [SysRowVersion] ROWVERSION     NULL,
    [SysDateCreate] DATETIME       CONSTRAINT [DF_TbMntUnitaDpi_SysDateCreate] DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_TbMntUnitaDpi] PRIMARY KEY CLUSTERED ([IdUnitaDpi] ASC),
    CONSTRAINT [FK_TbMntUnitaDpi_TbMntAnagDpi] FOREIGN KEY ([IdDpi]) REFERENCES [dbo].[TbMntAnagDpi] ([IdDpi]),
    CONSTRAINT [FK_TbMntUnitaDpi_TbMntUnita] FOREIGN KEY ([IdUnita]) REFERENCES [dbo].[TbMntUnita] ([IdUnita])
);


GO

