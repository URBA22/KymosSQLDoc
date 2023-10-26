
  CREATE VIEW [dbo].[vw_aspnet_WebPartState_Shared]
  AS SELECT [dbo].[aspnet_PersonalizationAllUsers].[PathId], [DataSize]=DATALENGTH([dbo].[aspnet_PersonalizationAllUsers].[PageSettings]), [dbo].[aspnet_PersonalizationAllUsers].[LastUpdatedDate]
  FROM [dbo].[aspnet_PersonalizationAllUsers]

GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_WebPartState_Shared';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_WebPartState_Shared';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_WebPartState_Shared';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_WebPartState_Shared';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'vw_aspnet_WebPartState_Shared';


GO

