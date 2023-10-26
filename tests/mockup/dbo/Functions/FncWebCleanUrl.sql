-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION FncWebCleanUrl
(
	@Url as nvarchar(256)
)
RETURNS nvarchar(256)
AS
BEGIN
	DECLARE @result as nvarchar(256)
	SET @result = @Url
	SET @result = (SELECT REPLACE(@result, ' ', '_'))
	SET @result = (SELECT REPLACE(@result, '/', '_'))
	SET @result = (SELECT REPLACE(@result, ',', '_'))
	SET @result = (SELECT REPLACE(@result, '.', '_'))
	SET @result = (SELECT REPLACE(@result, ';', '_'))
	SET @result = (SELECT REPLACE(@result, '?', '_'))
	SET @result = (SELECT REPLACE(@result, '&', '&amp;'))
	SET @result = (SELECT REPLACE(@result, '"', '&quot;'))
	SET @result = (SELECT REPLACE(@result, '<', '&lt;'))
	SET @result = (SELECT REPLACE(@result, '>', '&gt;'))
	
	return @result
END

GO

EXECUTE sp_addextendedproperty @name = N'EP_Release', @value = N'01.00.00', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'FncWebCleanUrl';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Note', @value = N'Web', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'FncWebCleanUrl';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Utente', @value = N'Miki', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'FncWebCleanUrl';


GO

EXECUTE sp_addextendedproperty @name = N'EP_Personalizzato', @value = N'xx', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'FncWebCleanUrl';


GO

EXECUTE sp_addextendedproperty @name = N'EP_DataRelease', @value = '01/26/2013 11:53:17', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'FncWebCleanUrl';


GO

