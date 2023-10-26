CREATE TABLE [dbo].[TbModulaMovLog] (
    [STO_ID]           INT            NULL,
    [STO_TIME]         NVARCHAR (50)  NULL,
    [STO_OPESTO]       NVARCHAR (50)  NULL,
    [STO_ORDINE]       NVARCHAR (20)  NULL,
    [STO_HOSTINF]      NVARCHAR (100) NULL,
    [STO_EFF_ARTICOLO] NVARCHAR (50)  NULL,
    [STO_EFF_QTA]      REAL           NULL,
    [STO_GIAC]         REAL           NULL,
    [STO_SCOMPARTO]    NVARCHAR (50)  NULL,
    [STO_CORRIDOIO]    NVARCHAR (50)  NULL,
    [STO_UDC]          NCHAR (10)     NULL,
    [STO_BAIA]         NVARCHAR (50)  NULL,
    [STO_SUB1]         NVARCHAR (50)  NULL,
    [SysUserCreate]    NVARCHAR (256) NULL,
    [SysDateCreate]    DATETIME       NULL
);


GO

