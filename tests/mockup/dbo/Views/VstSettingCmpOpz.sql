CREATE VIEW dbo.VstSettingCmpOpz
AS
SELECT dbo.TbSettingCmpOpz.IdCmpOpz, dbo.TbSettingCmpOpz.TipoDoc, dbo.TbSettingCmpOpz.IdDoc, dbo.TbSettingCmpOpz.NRiga, dbo.TbSettingCmpOpz.IdKey, dbo.TbSettingCmpOpz.DescKey, dbo.TbSettingCmpOpz.Value, dbo.TbSettingCmpOpz.TypeCmp, 
         dbo.TbSettingCmpOpz.SysDateCreate, dbo.TbSettingCmpOpz.SysUserCreate, dbo.TbSettingCmpOpz.SysDateUpdate, dbo.TbSettingCmpOpz.SysUserUpdate, dbo.TbSettingCmpOpz.SysRowVersion, ISNULL(dbo.TbSettingCodFnz.DescCodFnz, 
         dbo.TbSettingCmpOpz.Value) AS DescCodFnz
FROM  dbo.TbSettingCmpOpz LEFT OUTER JOIN
         dbo.TbSettingCodFnz ON dbo.TbSettingCmpOpz.Value = dbo.TbSettingCodFnz.CodFnz AND dbo.TbSettingCmpOpz.TipoDoc = dbo.TbSettingCodFnz.NomeTabella AND dbo.TbSettingCmpOpz.IdKey = dbo.TbSettingCodFnz.Tipo AND 
         dbo.TbSettingCmpOpz.TypeCmp = 'codfnz'

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstSettingCmpOpz';


GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[44] 4[15] 2[2] 3) )"
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
         Begin Table = "TbSettingCmpOpz"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 469
               Right = 263
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "TbSettingCodFnz"
            Begin Extent = 
               Top = 50
               Left = 781
               Bottom = 433
               Right = 1318
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
      Begin ColumnWidths = 15
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
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 897
         Table = 1169
         Output = 724
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstSettingCmpOpz';


GO

