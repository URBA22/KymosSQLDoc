





/*
 * Histroy:
 * mik 02.11.18 creata per fornire i campi presenti su setting per FatEl
 * dav 18.11.18 Correzione codici liquidazione 
 * mik 26.11.18 Aggiunto campi per gestire   Aruba
 * mik 10.01.19	Aggiunto campi FatEl Emittente e Trasmittente
 * mik 18.02.19	Aggiunto campo FatEl FatelCompany
 * mik 22.05.19 Aggiunto campi FatelCaricaRappr e FatelCodFiscaleRappr
 * mik 23.05.19 Aggiunto campi FatelCaricaDich e FatelCodFiscaleDich
 * mik 24.03.22 Aggiunto campo IdSetting
 */
CREATE VIEW [dbo].[VstSettingFatEl]
AS
SELECT
dbo.VstSetting.IdSetting,				-- IdSetting: IdSetting
dbo.VstSetting.FatelIdPaeseTrasm,				-- IdPaese: Codice della nazione del trasmittente espresso secondo lo standard ISO 3166-1 alpha-2 code (es.: IT)
dbo.VstSetting.FatelCodFiscaleTrasm,			-- IdCodice: Codice identificativo fiscale del trasmittente
dbo.VstSetting.PIVA,							-- IdCodice: Parita Iva Cedente/Prestatore
dbo.VstSetting.FatelMail,						-- ContattiTrasmittente->Email: email di fatturazione del trasmittente (non obbligatorio)
dbo.VstSetting.FatelTel,						-- ContattiTrasmittente->Telefono: Contatto telefonico fisso o mobile
--dbo.VstSetting.FatElFax,						-- ContattiTrasmittente->Fax:	Parita Iva Cedente/Prestatore
												--								questo campo non c"è nel formato SD 1.1
dbo.VstSetting.RagSoc,							-- CedentePrestatore->Anagrafica->Denominazione: Ditta, denominazione o ragione sociale (ditta, impresa, società, ente)
dbo.VstSetting.FatelRegimeFiscale,				-- CedentePrestatore->Anagrafica->RegimeFiscale: Regime Fiscale
dbo.VstSetting.Indirizzo,						-- CedentePrestatore->Sede->Indirizzo: Indirizzo della sede del cedente o prestatore
dbo.VstSetting.FatelCAP,						-- CedentePrestatore->Sede->CAP: CAP
dbo.VstSetting.FatelCitta,						-- CedentePrestatore->Sede->Comune: Citta
dbo.VstSetting.FatelProvincia,					-- CedentePrestatore->Sede->Provincia: Provincia
dbo.VstSetting.FatelIdPaese,					-- CedentePrestatore->Sede->Nazione: Nazione (es.: IT)
dbo.VstSetting.FatelRegImpPrv,					-- DatiAnagrafici->IscrizioneRea->Ufficio: sigla della provincia dell"Ufficio del registro delle imprese presso il quale è registrata la società. RM, VI etc.												
dbo.VstSetting.REA,							-- DatiAnagrafici->IscrizioneRea->NumeroREA: numero di iscrizione al registro delle imprese												
dbo.VstSetting.CapitaleSociale,				-- DatiAnagrafici->IscrizioneRea->CapitaleSociale: obbligatorio se è una società di capitali (SpA, SApA, Srl)											
(CASE WHEN ISNULL(dbo.VstSetting.FlgSocioUnico,0) = 0 THEN 'SM' ELSE 'SU' END) as FatelSocioUnico,	
												-- DatiAnagrafici->IscrizioneRea->SocioUnico: obbligatorio se è una Società a responsAbilità limitata. [SU] : socio unico [SM] : più soci												
(CASE WHEN ISNULL(dbo.VstSetting.FlgInLiquidazione,0) = 0 THEN 'LN' ELSE 'LS' END) as FatelInLiquidazione,	
												-- DatiAnagrafici->IscrizioneRea->StatoLiquidazione: Indica se la Società si trova in stato di liquidazione oppure no , valori ammessi: [LS] : in liquidazione [LN] : non in liquidazione																									
dbo.VstSetting.FatelCausalePagRitAcnt AS FatelCausalePagRitAcnt,	-- DatiGeneraliDocumento->DatiRitenuta->CausalePagamento: Causale del pagamento (quella del modello 770
dbo.VstSetting.FatelTipoRitAcnt AS FatelTipoRitAcnt,	-- DatiGeneraliDocumento->DatiRitenuta->TipoRitenuta: Tipologia della ritenuta, valori ammessi:[RT01 ]: ritenuta pers. fisiche[RT02]: ritenuta pers. giurid
dbo.VstSetting.FatelTipoContrPrev AS FatelTipoContrPrev, -- DatiGeneraliDocumento->DatiCassaPrevidenziale->TipoCassa: Tipologia cassa previdenziale di appartenenza, valori ammessi: vedi documento
dbo.VstSetting.AdmServerIP,
dbo.VstSetting.FatelAuthUrl, 
dbo.VstSetting.FatelServiceUrl, 
dbo.VstSetting.FatelUser, 
dbo.VstSetting.FatelPsw,					 
dbo.VstSetting.FatelEmailTrasm, 
dbo.VstSetting.FatelTelTrasm, 
dbo.VstSetting.FatelIdPaeseEmit, 
dbo.VstSetting.FatelPIvaEmit, 
dbo.VstSetting.FatelCodFiscaleEmit, 
dbo.VstSetting.FatelDenominazioneEmit, 
dbo.VstSetting.FatelNomeEmit, 
dbo.VstSetting.FatelCognomeEmit,
dbo.VstSetting.FatelCompany,
dbo.VstSetting.FatelCaricaDich,
dbo.VstSetting.FatelCodFiscaleDich
FROM            dbo.VstSetting

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstSettingFatEl';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "VstSetting"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 179
               Right = 259
            End
            DisplayFlags = 280
            TopColumn = 103
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstSettingFatEl';


GO

