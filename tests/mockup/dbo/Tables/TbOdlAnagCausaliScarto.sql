CREATE TABLE [dbo].[TbOdlAnagCausaliScarto] (
    [IdCausaleScarto]   NVARCHAR (20)  NOT NULL,
    [DescCausaleScarto] NVARCHAR (200) NULL,
    [Disabilita]        BIT            CONSTRAINT [DF_TbOdlAnagCausaliScarto_Disabilita] DEFAULT ((0)) NOT NULL,
    [Predefinita]       BIT            CONSTRAINT [DF_TbOdlAnagCausaliScarto_Predefinita] DEFAULT ((0)) NOT NULL,
    [NoteCausaleScarto] NVARCHAR (MAX) NULL,
    [SysDateCreate]     DATETIME       CONSTRAINT [DF_TbOdlAnagCausaliScarto_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate]     NVARCHAR (256) NULL,
    [SysDateUpdate]     DATETIME       NULL,
    [SysUserUpdate]     NVARCHAR (256) NULL,
    [SysRowVersion]     ROWVERSION     NULL,
    CONSTRAINT [PK_TbOdlAnagCausaliScarto] PRIMARY KEY CLUSTERED ([IdCausaleScarto] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliScarto';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliScarto';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliScarto';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliScarto';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliScarto';


GO

