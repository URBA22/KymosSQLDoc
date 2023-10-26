CREATE VIEW dbo.VstWebArticoli
AS
SELECT     dbo.TbArticoli.IdArticolo, dbo.TbArticoli.DescCompleta, dbo.TbArticoli.UnitMDim, dbo.TbArticoli.DimAltezza, dbo.TbArticoli.DimLunghezza, 
                      dbo.TbArticoli.DimLarghezza, dbo.TbArticoli.DimSpessore, dbo.TbArticoli.UnitMPeso, dbo.TbArticoli.DimPeso, dbo.TbArticoli.Immagine, dbo.TbArticoli.WebDescrizione,
                       dbo.TbArticoli.WebTitolo, dbo.TbArticoli.PrezzoVendita, ('~/SchedaProdotto.aspx' + '?id=') + ('art_' + dbo.TbArticoli.IdArticolo) AS Url, 
                      'art_' + dbo.TbArticoli.IdArticolo AS IdPagina, ROUND(dbo.TbArticoli.PrezzoVendita * CONVERT(money, 1 + DrvIva.Aliquota / 100), 2) AS Importo, DrvIva.Aliquota, 
                      ROUND(dbo.TbArticoli.PrezzoVendita * CONVERT(money, DrvIva.Aliquota / 100), 2) AS Imposta
FROM         dbo.TbArticoli LEFT OUTER JOIN
                          (SELECT     IdIva, Aliquota
                            FROM          dbo.TbCntIva) AS DrvIva ON ISNULL(dbo.TbArticoli.IdIva,
                          (SELECT     TOP (1) IdIva
                            FROM          dbo.TbCntIva
                            WHERE      (Predefinita = 1))) = DrvIva.IdIva
WHERE     (dbo.TbArticoli.FlgVisibilitaWeb = 1)

GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebArticoli';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '01/11/2013 00:00:00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebArticoli';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'XX', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebArticoli';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebArticoli';


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
         Begin Table = "TbArticoli"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 125
               Right = 244
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DrvIva"
            Begin Extent = 
               Top = 6
               Left = 282
               Bottom = 95
               Right = 442
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 19
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebArticoli';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Miki', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebArticoli';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'@Togliere il disabilita', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebArticoli';


GO

