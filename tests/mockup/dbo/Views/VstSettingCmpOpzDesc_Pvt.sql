CREATE VIEW dbo.VstSettingCmpOpzDesc_Pvt
AS
SELECT     IdDoc, TipoDoc, [1] AS 'C01', [2] AS 'C02', [3] AS 'C03', [4] AS 'C04', [5] AS 'C05', [6] AS 'C06', [7] AS 'C07', [8] AS 'C08', [9] AS 'C09', [10] AS 'C10', [11] AS 'C11', 
                      [12] AS 'C12', [13] AS 'C13', [14] AS 'C14', [15] AS 'C15', [16] AS 'C16', [17] AS 'C17', [18] AS 'C18', [19] AS 'C19', [20] AS 'C20', [21] AS 'C21', [22] AS 'C22', [23] AS 'C23', 
                      [24] AS 'C24', [25] AS 'C25', [26] AS 'C26', [27] AS 'C27', [28] AS 'C28', [29] AS 'C29', [30] AS 'C30', [31] AS 'C31', [32] AS 'C32', [33] AS 'C33', [34] AS 'C34', [35] AS 'C35', 
                      [36] AS 'C36', [37] AS 'C37', [38] AS 'C38', [39] AS 'C39', [40] AS 'C40', [41] AS 'C41', [42] AS 'C42', [43] AS 'C43', [44] AS 'C44', [45] AS 'C45', [46] AS 'C46', [47] AS 'C47', 
                      [48] AS 'C48', [49] AS 'C49', [50] AS 'C50'
FROM         (SELECT     IdDoc, TipoDoc, NRiga, isnull(TbSettingCodFnz.DescCodFnz, TbSettingCmpOpz.Value) AS Value
                       FROM          TbSettingCmpOpz LEFT OUTER JOIN
                                              TbSettingCodFnz ON TbSettingCmpOpz.TipoDoc = TbSettingCodFnz.NomeTabella AND TbSettingCmpOpz.IdKey = TbSettingCodFnz.Tipo AND 
                                              TbSettingCmpOpz.Value = TbSettingCodFnz.CodFnz) AS SourceTable PIVOT (Max(Value) FOR NRiga IN ([1], [2], [3], [4], [5], [6], [7], [8], [9], [10], [11], [12], 
                      [13], [14], [15], [16], [17], [18], [19], [20], [21], [22], [23], [24], [25], [26], [27], [28], [29], [30], [31], [32], [33], [34], [35], [36], [37], [38], [39], [40], [41], [42], [43], [44], [45], 
                      [46], [47], [48], [49], [50])) AS PivotTable;

GO

EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstSettingCmpOpzDesc_Pvt';


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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VstSettingCmpOpzDesc_Pvt';


GO

