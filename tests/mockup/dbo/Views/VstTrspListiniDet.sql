


-- ==========================================================================================
-- Entity Name:   VstTrspListiniDet
-- Author:        Vale
-- Create date:   
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- vale 020323 aggiunto campo
-- vale 230912 Aggiunta FlgImpMinEscludi
-- ==========================================================================================
      

CREATE VIEW [dbo].[VstTrspListiniDet]
AS
SELECT        dbo.TbTrspListiniTratteDet.PesoMax, dbo.TbTrspListiniTratteDet.Costo, dbo.TbTrspListini.IdListino, dbo.TbTrspListiniTratte.IdProvGrp1, dbo.TbTrspListiniTratte.IdProvGrp2, dbo.TbTrspListiniTratte.ImpMin, 
                         CAST(dbo.TbTrspListiniTratte.IdListino AS nvarchar(5)) + dbo.TbTrspListiniTratte.IdProvGrp1 + dbo.TbTrspListiniTratte.IdProvGrp1 AS IdListinoTratta, dbo.TbTrspListini.UnitM, dbo.TbTrspListini.CodFnzTipo, 
                         dbo.TbTrspListiniTratte.KgMin, CASE WHEN KgMin > 0 THEN ImpMin ELSE 0 END AS ImportoMinSommare, dbo.TbTrspListiniTratteDet.HMax, dbo.TbTrspListini.CodFnzTipologia, .TbTrspListiniTratteDet.Percentuale,
                         TbTrspListiniTratteDet.FlgImpMinEscludi
FROM            dbo.TbTrspListiniTratte INNER JOIN
                         dbo.TbTrspListini ON dbo.TbTrspListiniTratte.IdListino = dbo.TbTrspListini.IdListino INNER JOIN
                         dbo.TbTrspListiniTratteDet ON dbo.TbTrspListiniTratte.IdListinoTratta = dbo.TbTrspListiniTratteDet.IdListinoTratta

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstTrspListiniDet';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[31] 4[30] 2[20] 3) )"
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
         Begin Table = "TbTrspListiniTratte"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 227
               Right = 229
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "TbTrspListini"
            Begin Extent = 
               Top = 6
               Left = 267
               Bottom = 236
               Right = 458
            End
            DisplayFlags = 280
            TopColumn = 7
         End
         Begin Table = "TbTrspListiniTratteDet"
            Begin Extent = 
               Top = 6
               Left = 496
               Bottom = 136
               Right = 687
            End
            DisplayFlags = 280
            TopColumn = 6
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
         Column = 2070
         Alias = 1530
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstTrspListiniDet';


GO

