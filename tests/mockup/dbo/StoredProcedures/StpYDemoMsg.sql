-- ==========================================================================================
-- Entity Name:   dav
-- Author:        29-10-19
-- Create date:   
-- Custom_Dbo:	  NO
-- Standard_dbo:  YES
-- CustomNote:    
-- Description:   
-- History:
-- dav 210220 Gestione menu a tendina multiplo
-- ==========================================================================================
CREATE PROCEDURE [dbo].[StpYDemoMsg]
(
	@IdArticolo nvarchar(50),
	@SysUser nvarchar(256),
	@KYStato int = NULL output,
	@KYMsg nvarchar(max) = NULL output,
	@KYRes int = NULL
)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ParamCtrl nvarchar(max)

	Declare @Msg nvarchar(300)
	Declare @Msg1 nvarchar(300)
	Declare @MsgObj nvarchar(300)
	Declare @CodFnzTipoMsg as nvarchar(5)

	SET @Msg= 'Aggiorna'
	SET @MsgObj='StpYDemoMsg'
	SET @ParamCtrl = '<ParamCtrl>' + REPLACE(REPLACE(@KYMsg,'-|', '<'), '|-', '>') + '</ParamCtrl>'

	DECLARE @QtaPz AS real
	DECLARE @CostoUnit AS money
	DECLARE @DataFornitura AS date
	DECLARE @DataEffettiva AS datetime
	DECLARE @OraInvio AS time
	DECLARE @FlgInvio AS bit
	DECLARE @CodFnzStato AS nvarchar(20)
	DECLARE @Idcategoria AS nvarchar(50)
	DECLARE @Password AS nvarchar(50)
	DECLARE @NoteProduzione AS nvarchar(MAX)

	DECLARE @C_QtaPz AS NVARCHAR(MAX)
	DECLARE @C_CostoUnit AS NVARCHAR(MAX)
	DECLARE @C_DataFornitura AS NVARCHAR(MAX)
	DECLARE @C_DataEffettiva AS NVARCHAR(MAX)
	DECLARE @C_OraInvio AS NVARCHAR(MAX)
	DECLARE @C_FlgInvio AS NVARCHAR(MAX)
	DECLARE @C_CodFnzStato AS NVARCHAR(MAX)
	DECLARE @C_Idcategoria AS NVARCHAR(MAX)
	DECLARE @C_Password AS NVARCHAR(MAX)
	DECLARE @C_NoteProduzione AS NVARCHAR(MAX)
	DECLARE @C_IdCategoriaMacro AS NVARCHAR(MAX)
	DECLARE @C_IdCliente AS NVARCHAR(MAX)

	DECLARE @C_Linea AS NVARCHAR(MAX)

	/****************************************************************
	* Stato 0
	****************************************************************/
	IF @KYStato  = 0
	BEGIN
		set  @KYStato = 1

		--SELECT @QtaPz=QtaPz, @CostoUnit=CostoUnit, @DataFornitura=DataFornitura, @DataEffettiva=DataEffettiva, @OraInvio=OraInvio, @FlgInvio=FlgInvio, @CodFnzStato=CodFnzStato, @Idcategoria=Idcategoria, @Password=Password, @NoteProduzione=NoteProduzione
		--FROM TbXArticoli
		--WHERE (IdArticolo = @IdArticolo)

		--=============================== Creazione elementi
		SET @C_QtaPz = dbo.FncKyMsgTextBox('QtaPz' ,@KYStato,'Qta Pz:', @QtaPz, 'real' )
		SET @C_CostoUnit = dbo.FncKyMsgTextBox('CostoUnit' ,@KYStato,'CostoUnit:', ISNULL(@CostoUnit,1.34), 'money' )
		SET @C_CostoUnit =  dbo.FncKyMsgAddAttribute(@C_CostoUnit,'StringFormat', 'c4')
		
		--=============================== Date
		SET @C_DataFornitura = dbo.FncKyMsgTextBox('DataFornitura' ,@KYStato,'DataFornitura:', @DataFornitura, 'datetime' )
		SET @C_DataEffettiva = dbo.FncKyMsgTextBox('DataEffettiva' ,@KYStato,'DataEffettiva:', @DataEffettiva, 'datetime' )

		SET @C_DataFornitura =  dbo.FncKyMsgAddAttribute(@C_DataFornitura,'SetFocus', 'True')
		--=============================== Ore checkbox
		SET @C_OraInvio = dbo.FncKyMsgTextBox('OraInvio' ,@KYStato,'OraInvio:', @OraInvio, 'string' )
		SET @C_FlgInvio = dbo.FncKyMsgTextBox('FlgInvio' ,@KYStato,'FlgInvio:', @FlgInvio, 'bool' )
		--=============================== Menu a tendina
		DECLARE @DescStato nvarchar(50)
		DECLARE @DescCategoria nvarchar(50)
		
		-- Metodo 1 deprecato
		SELECT @DescStato = DescCodFnz FROM TbSettingCodFnz WHERE NomeTabella = 'TbXArticoliBarabba' AND Tipo = 'CodFnzStato' AND CodFnz = @CodFnzStato
		-- Metodo 2 più meglio
		-- Ricavo la descrizione del codice funzionale
		SET @DescStato = dbo.FncDescCodFnz(@CodFnzStato, 'TbXArticoliBarabba','CodFnzStato')

		SET @C_CodFnzStato = dbo.FncKyMsgCodFnz('CodFnzStato' ,@KYStato,'CodFnzStato:', @CodFnzStato, @DescStato, 'DescCodFnz', 'TbXArticoliBarabba' )
		
		SELECT @DescCategoria = DescCategoria FROM VstArtAnagCatgr WHERE IdCategoria = @IdCategoria

		-- ComboBox Standard
		--										   Nome			 Stato	  Caption	    Valore DB	  Valore Passato Visualizzato    Colonne									    DomainDataContext Rif. Metodo Get ... s
		SET @C_Idcategoria = dbo.FncKyMsgComboBox('Idcategoria' ,@KYStato,'Categoria:', @Idcategoria, 'IdCategoria', 'DescCategoria','DescCategoria;IdCategoria;DescCategoriaMacro','DboArtDomainContext','GetVstArtAnagCatgrs', 'True')
		-- ComboBox Standard Text
		--										   Nome			 Stato	  Caption			Valore DB	  Testo Vis.	   Valore Passato Visualizzato    Colonne									    DomainDataContext Rif. Metodo Get ... s
		SET @C_Idcategoria = dbo.FncKyMsgComboBoxText('Idcategoria' ,@KYStato,'Categoria:', @Idcategoria, @DescCategoria , 'IdCategoria', 'DescCategoria','DescCategoria;IdCategoria;DescCategoriaMacro','DboArtDomainContext','GetVstArtAnagCatgrs', 'True')
		
		-- ComboBox Value per Valore
		SET @C_Idcategoria = dbo.FncKyMsgComboBoxValue('Idcategoria' ,@KYStato,'Categoria:', @Idcategoria, '1;Aperti;2;Chiusi' , 'Value')
		-- ComboBox Value per Desc
		SET @C_Idcategoria = dbo.FncKyMsgComboBoxValue('Idcategoria' ,@KYStato,'Categoria:', @Idcategoria, '1;Aperti;2;Chiusi' , 'Description')
		
		-- ComboBoxSQL
		SET @C_Idcategoria = dbo.FncKyMsgComboBoxSQL('Idcategoria' ,@KYStato,'Categoria:', @Idcategoria, 'IdCategoria', 'DescCategoria','DescCategoria;IdCategoria;DescCategoriaMacro','SELECT DescCategoria, IdCategoria, DescCategoriaMacro FROM VstArtAnagCatgr WHERE Disabilita = 0')
		SET @C_Idcategoria = dbo.FncKyMsgComboBoxSQLText('Idcategoria' ,@KYStato,'Categoria:', @Idcategoria, @DescCategoria, 'IdCategoria', 'DescCategoria','DescCategoria;IdCategoria;DescCategoriaMacro','SELECT DescCategoria, IdCategoria, DescCategoriaMacro FROM VstArtAnagCatgr WHERE Disabilita = 0')
		
		--===============================
		SET @C_Password = dbo.FncKyMsgTextBox('Password' ,@KYStato,'Password:', @Password, 'string' )

		--===============================
		SET @C_IdCategoriaMacro = dbo.FncKyMsgComboBoxMulti('IdCategoriaMacro',@KYStato,'Categoria:', NULL, NULL,
															'Macro Categorie', 'IdCategoriaMacro', 'DescCategoriaMacro', 'IdCategoriaMacro;DescCategoriaMacro', 'DboArtDomainContext', 'GetVstArtAnagCatgrMacros',
															'Categorie','IdCategoria', 'DescCategoria', 'IdCategoria;DescCategoria', 'DboArtDomainContext', 'GetVstArtAnagCatgrs',
															NULL, NULL, NULL, NULL, NULL, NULL,
															'True')
		
		-- ComboBox multipla
		--												    Nome			 Stato	  Caption	    Valore DB	  Valore Passato Visualizzato    Colonne	DomainDataContext Rif. Metodo Get ... s
		SET @C_IdCliente = dbo.FncKyMsgComboBoxSelMulti('TmpClienti' ,@KYStato,'Clienti:', NULL, 'IdCliente', 'RagSoc', 'IdCliente;RagSoc','DboCliDomainContext','GetVstClientiSnts', 'True')
	
		--=============================== Note
		SET @C_NoteProduzione = dbo.FncKyMsgTextBox('NoteProduzione' ,@KYStato,'NoteProduzione:', @NoteProduzione, 'string' )
		SET @C_NoteProduzione =  dbo.FncKyMsgAddAttribute(@C_NoteProduzione,'AceptReturn', 'True')
		SET @C_NoteProduzione =  dbo.FncKyMsgAddAttribute(@C_NoteProduzione,'Height', '120')
		SET @C_NoteProduzione =  dbo.FncKyMsgAddAttribute(@C_NoteProduzione,'Width', '120')
		SET @C_NoteProduzione =  dbo.FncKyMsgAddAttribute(@C_NoteProduzione,'IsReadOnly', 'True')
		SET @C_NoteProduzione =  dbo.FncKyMsgAddAttribute(@C_NoteProduzione,'Border', '#FF0000')
		--===============================

		SET @C_Linea = dbo.FncKyMsgLine('Date', @KYStato)

		SET @C_OraInvio =  dbo.FncKyMsgAddAttribute(@C_OraInvio,'Border', '#FF0000')
		SET @C_OraInvio =  dbo.FncKyMsgAddAttribute(@C_OraInvio,'Background', '#c083c4')
		SET @C_OraInvio =  dbo.FncKyMsgAddAttribute(@C_OraInvio,'Foreground', '#ffffff')
		
		SET @C_Linea =  dbo.FncKyMsgAddAttribute(@C_Linea,'Border', '#000000')
		SET @C_Linea =  dbo.FncKyMsgAddAttribute(@C_Linea,'Foreground', '#FF0000')
		--===============================
		
		--=============================== Aggiungo Elementi
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_CostoUnit)
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_QtaPz)
		
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_Linea)
		
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_DataFornitura)
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_DataEffettiva)
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_OraInvio)
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_FlgInvio)
		
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_Linea)

		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_CodFnzStato)
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_Idcategoria)
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_Password)
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_IdCategoriaMacro)
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_IdCliente)
		SET @ParamCtrl =  dbo.FncKyMsgAddControl(@ParamCtrl,@KYStato, @C_NoteProduzione)
		
		-- Senza Messaggi
		--SET @KYMsg = dbo.FncKYMsg(@Msg,Null,Null, Null,Null)
		
		SET @Msg1= 'Precedura DEMO'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, '' ,'QST',@SysUser,
				@KYStato,@KYRes,'', '1:Ok;0:Cancel',@KYMsg out
				
		SET @KYMsg = @KYMsg + '<ParamCtrl>' + @ParamCtrl + '</ParamCtrl>'
		--===============================
		RETURN
	END
	/****************************************************************
	* Stato 1 - risposta affermativa
	****************************************************************/
	IF @KYStato = 1 
	BEGIN
		DECLARE @TmpClienti as xml

		SET @Msg = ''
		SET @QtaPz = dbo.FncKyMsgCtrlValueNumeric(@ParamCtrl, 'QtaPz',1)
		SET @CostoUnit = dbo.FncKyMsgCtrlValueNumeric(@ParamCtrl, 'CostoUnit',1)
		SET @DataFornitura = dbo.FncKyMsgCtrlValueDate(@ParamCtrl, 'DataFornitura',1)
		SET @DataEffettiva = dbo.FncKyMsgCtrlValueDate(@ParamCtrl, 'DataEffettiva',1)
		SET @OraInvio = dbo.FncKyMsgCtrlValueNumeric(@ParamCtrl, 'OraInvio',1)
		SET @FlgInvio = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'FlgInvio',1)
		SET @CodFnzStato = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'CodFnzStato',1)
		SET @Idcategoria = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'Idcategoria',1)
		SET @Password = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'Password',1)
		SET @NoteProduzione = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'NoteProduzione',1)
		SET @TmpClienti = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'TmpClienti',1)

		SELECT Col.value('value[1]', 'nvarchar(300)') AS 'IdCdl' 
		Into #TmpClienti
		FROM @TmpClienti.nodes('/row') AS Tab(Col)


		IF ISNULL(@CodFnzStato,'') = '' SET @CodFnzStato = NULL

		DECLARE @ClientiSel nvarchar(max)

		SET @ClientiSel = dbo.FncKyMsgCtrlValue(@ParamCtrl, 'IdCliente',1)

		DECLARE @xml xml 
		SET @xml = CONVERT(xml, @ClientiSel)

		SELECT T.c.value('.','int') AS IdCliente FROM   @xml.nodes('row/value') T(c)
		--IF not  EXISTS(SELECT IdArticolo FROM TbXArticoli WHERE IdArticolo= @IdArticolo) 
		--BEGIN
		--	INSERT INTO TbXArticoli 
		--	(IdArticolo)
		--	VALUES        (@IdArticolo)
		--END


		--UPDATE       TbXArticoli 
		--SET          QtaPz=@QtaPz, CostoUnit=@CostoUnit, DataFornitura=@DataFornitura, DataEffettiva=@DataEffettiva, OraInvio=@OraInvio, FlgInvio=@FlgInvio, CodFnzStato=@CodFnzStato, Idcategoria=@Idcategoria, Password=@Password, NoteProduzione=@NoteProduzione 
		--WHERE        (IdArticolo = @IdArticolo)
		
		SET @Msg1= 'Operazione completata'
		EXECUTE StpUteMsg @Msg, @Msg1,@MsgObj, '' ,'INF',@SysUser,
				@KYStato,@KYRes,'',null,@KYMsg out
		SET @KYStato = -4
		RETURN
	END
END

GO

