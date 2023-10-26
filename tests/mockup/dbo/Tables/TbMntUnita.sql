CREATE TABLE [dbo].[TbMntUnita] (
    [IdUnita]                    INT             IDENTITY (1, 1) NOT NULL,
    [IdCliente]                  INT             NULL,
    [DataValutazione]            DATE            NULL,
    [StatoUnita]                 VARCHAR (1)     NULL,
    [IdCdlUnita]                 NVARCHAR (20)   NULL,
    [CodUnita]                   NVARCHAR (20)   NULL,
    [IdUnitaTipo]                NVARCHAR (20)   NULL,
    [Descrizione]                NVARCHAR (MAX)  NULL,
    [Modello]                    NVARCHAR (200)  NULL,
    [Costruttore]                NVARCHAR (200)  NULL,
    [Matricola]                  NVARCHAR (20)   NULL,
    [Targa]                      NVARCHAR (20)   NULL,
    [Anno]                       INT             NULL,
    [DataImmatricolazione]       DATE            NULL,
    [LayoutSito]                 VARBINARY (MAX) NULL,
    [Immagine]                   VARBINARY (MAX) NULL,
    [CncControllo]               NVARCHAR (50)   NULL,
    [Posizione]                  NVARCHAR (50)   NULL,
    [DataDismissione]            DATE            NULL,
    [FlgFuoriServizio]           AS              (case when [DataDismissione] IS NULL then (0) else (1) end),
    [FlgEnrgElettrica]           BIT             CONSTRAINT [DF_Table_1_FlgEnergiaElettrica] DEFAULT ((0)) NOT NULL,
    [FlgEnrgPneumatica]          BIT             CONSTRAINT [DF_Table_1_FlgEnergiaElettrica1] DEFAULT ((0)) NOT NULL,
    [FlgEnrgTermica]             BIT             CONSTRAINT [DF_Table_1_FlgEnergiaElettrica1_1] DEFAULT ((0)) NOT NULL,
    [FlgEnrgTOleodinamica]       BIT             CONSTRAINT [DF_Table_1_FlgEnrgTermica1] DEFAULT ((0)) NOT NULL,
    [DatiElettrci]               NVARCHAR (50)   NULL,
    [DatiPneumatici]             NVARCHAR (50)   NULL,
    [DatiTermici]                NVARCHAR (50)   NULL,
    [DatiOleodinamici]           NVARCHAR (50)   NULL,
    [FlgDocUsoManutenzione]      BIT             CONSTRAINT [DF_TbMntUnita_FlgDocUsoManutenzione] DEFAULT ((0)) NOT NULL,
    [FlgDocDichiarazioneCe]      BIT             CONSTRAINT [DF_TbMntUnita_FlgDocDichiarazioneCe] DEFAULT ((0)) NOT NULL,
    [FlgDocTarghettaCE]          BIT             CONSTRAINT [DF_TbMntUnita_FlgDocTarghettaCE] DEFAULT ((0)) NOT NULL,
    [FlgDocPrescrizioni]         BIT             CONSTRAINT [DF_TbMntUnita_FlgDocPrescrizioni] DEFAULT ((0)) NOT NULL,
    [SysUserCreate]              NVARCHAR (256)  NULL,
    [SysDateUpdate]              DATETIME        NULL,
    [SysUserUpdate]              NVARCHAR (256)  NULL,
    [SysRowVersion]              ROWVERSION      NULL,
    [SysDateCreate]              DATETIME        CONSTRAINT [DF_TbMntUnita_SysDateCreate] DEFAULT (getdate()) NULL,
    [NoteUnita]                  NVARCHAR (MAX)  NULL,
    [DataRevamping]              DATE            NULL,
    [UnitMDim]                   NVARCHAR (20)   NULL,
    [DimAltezza]                 REAL            NULL,
    [DimLunghezza]               REAL            NULL,
    [DimLarghezza]               REAL            NULL,
    [DimSpessore]                REAL            NULL,
    [UnitMPeso]                  NVARCHAR (20)   NULL,
    [DimPeso]                    REAL            NULL,
    [FlgDocAnalisiAllV]          BIT             CONSTRAINT [DF_TbMntUnita_FlgDocTarghettaCE1] DEFAULT ((0)) NOT NULL,
    [FlgDocAttestazioneConf]     BIT             CONSTRAINT [DF_TbMntUnita_FlgDocTarghettaCE1_1] DEFAULT ((0)) NOT NULL,
    [EmissioniGas]               NVARCHAR (MAX)  NULL,
    [EmissioniElettromagnetiche] NVARCHAR (MAX)  NULL,
    [CodFnzComplessita]          NVARCHAR (5)    NULL,
    [IdUnitaImpianto]            INT             NULL,
    [IdFornitore]                INT             NULL,
    [FlgUnitaAtrz]               BIT             CONSTRAINT [DF_TbMntUnita_FlgUnitaArtz] DEFAULT ((0)) NOT NULL,
    [IdCespite]                  NVARCHAR (20)   NULL,
    [IdCliPrj]                   NVARCHAR (20)   NULL,
    [IdCliDest]                  INT             NULL,
    CONSTRAINT [PK_TbMntUnita] PRIMARY KEY CLUSTERED ([IdUnita] ASC),
    CONSTRAINT [FK_TbMntUnita_TbCliDest] FOREIGN KEY ([IdCliDest]) REFERENCES [dbo].[TbCliDest] ([IdCliDest]),
    CONSTRAINT [FK_TbMntUnita_TbCliPrj] FOREIGN KEY ([IdCliPrj]) REFERENCES [dbo].[TbCliPrj] ([IdCliPrj]),
    CONSTRAINT [FK_TbMntUnita_TbCntCespiti] FOREIGN KEY ([IdCespite]) REFERENCES [dbo].[TbCntCespiti] ([IdCespite]),
    CONSTRAINT [FK_TbMntUnita_TbFornitori] FOREIGN KEY ([IdFornitore]) REFERENCES [dbo].[TbFornitori] ([IdFornitore]),
    CONSTRAINT [FK_TbMntUnita_TbMntAnagUnitaTipo] FOREIGN KEY ([IdUnitaTipo]) REFERENCES [dbo].[TbMntAnagUnitaTipo] ([IdUnitaTipo]),
    CONSTRAINT [FK_TbMntUnita_TbProdCdlUnita] FOREIGN KEY ([IdCdlUnita]) REFERENCES [dbo].[TbProdCdlUnita] ([IdCdlUnita])
);


GO

CREATE NONCLUSTERED INDEX [IX_TbMntUnita]
    ON [dbo].[TbMntUnita]([IdCdlUnita] ASC);


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'M Macchina, I Insieme di macchine, Q Quasi macchina, U Macchina Usata', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbMntUnita', @level2type = N'COLUMN', @level2name = N'StatoUnita';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Poszione fisica della macchina ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbMntUnita', @level2type = N'COLUMN', @level2name = N'Posizione';


GO

EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'Indentifica se l''unità e di tipo attrezzatura', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'TbMntUnita', @level2type = N'COLUMN', @level2name = N'FlgUnitaAtrz';


GO

