CREATE VIEW dbo.VstWebCliOrd
AS
SELECT     dbo.VstCliOrd.IdCliOrd, dbo.VstCliOrd.Destinatario, dbo.VstCliOrd.Destinazione, dbo.VstCliOrd.Tel, dbo.VstCliOrd.IdIva, dbo.VstCliOrd.SpeseTraspVlt, 
                      dbo.VstCliOrd.SpeseBancarieVlt, dbo.VstCliOrd.EMail, dbo.VstCliOrd.IdCliente, dbo.VstCliOrd.PrezzoTotVlt AS PrezzoTot, dbo.VstCliOrd.Imposta AS IvaTot, 
                      drvcliorddet.PrezzoTotIvato, dbo.VstCliOrd.Importo AS ImportoTotale, dbo.VstCliOrd.Destinatario AS RagSocCompleta
FROM         dbo.VstCliOrd LEFT OUTER JOIN
                          (SELECT     IdCliOrd, SUM(PrezzoTotIvato) AS PrezzoTotIvato, SUM(IvaTot) AS IvaTot, SUM(PrezzoTotNonIvato) AS PrezzoTotNonIvato
                            FROM          dbo.VstWebCliOrdDet
                            GROUP BY IdCliOrd) AS drvcliorddet ON dbo.VstCliOrd.IdCliOrd = drvcliorddet.IdCliOrd

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebCliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[36] 2[20] 3) )"
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
         Begin Table = "VstCliOrd"
            Begin Extent = 
               Top = 8
               Left = 86
               Bottom = 158
               Right = 338
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "drvcliorddet"
            Begin Extent = 
               Top = 1
               Left = 435
               Bottom = 120
               Right = 618
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
      Begin ColumnWidths = 9
         Width = 284
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
         Column = 4380
         Alias = 3315
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebCliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'NO', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebCliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Miki', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebCliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Ordini Clienti Web', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebCliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '01/20/2013 00:00:00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebCliOrd';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstWebCliOrd';


GO

