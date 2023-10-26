CREATE TABLE [dbo].[TbOdlAnagCausaliCosti] (
    [IdCausaleCosto]     NVARCHAR (20)  NOT NULL,
    [DescCausaleCosto]   NVARCHAR (200) NULL,
    [FlgExtraProduzione] BIT            CONSTRAINT [DF_TbOdlAnagCausaliCosti_FlgExtraProduzione] DEFAULT ((0)) NOT NULL,
    [FlgCostoSuCommessa] BIT            CONSTRAINT [DF_TbOdlAnagCausaliCosti_FlgCostoSuCommessa] DEFAULT ((0)) NOT NULL,
    [Disabilita]         BIT            CONSTRAINT [DF_TbOdlAnagCausaliCosti_Disabilita] DEFAULT ((0)) NOT NULL,
    [Predefinita]        BIT            CONSTRAINT [DF_TbOdlAnagCausaliCosti_Predefinita] DEFAULT ((0)) NOT NULL,
    [NoteCausaleCosto]   NVARCHAR (MAX) NULL,
    [SysDateCreate]      DATETIME       CONSTRAINT [DF_TbOdlAnagCausaliCosti_SysDateCreate] DEFAULT (getdate()) NULL,
    [SysUserCreate]      NVARCHAR (256) NULL,
    [SysDateUpdate]      DATETIME       NULL,
    [SysUserUpdate]      NVARCHAR (256) NULL,
    [SysRowVersion]      ROWVERSION     NULL,
    CONSTRAINT [PK_TbOdlAnagCausaliCosti] PRIMARY KEY CLUSTERED ([IdCausaleCosto] ASC)
);


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliCosti';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliCosti';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliCosti';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliCosti';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbOdlAnagCausaliCosti';


GO

