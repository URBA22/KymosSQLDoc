# dbo - StpUteMsg
STORED_PROCEDURE
## Info 
@Summary **Inserisce messaggi utente asincroni**  
@Author **Dav**  
@Custom **NO**  
@Standard **YES**  
## Versions 
`version `&ensp;&ensp;_author_&ensp;&ensp;&ensp;&ensp;_desc_&ensp;&ensp;&ensp;&ensp;  
`141123. `&ensp;&ensp;dav&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;se <>INF mostra indipdendentemente dallo stato  
`160217. `&ensp;&ensp;dav&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;@ERROR_MESSAGE() in dummy per evitare troncamenti a 4000  
`160817. `&ensp;&ensp;dav&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Aggiunta spid, iddoc e idrow  
`160812. `&ensp;&ensp;dav&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Disattivazione traduzioni (traduce anche i parametri in molte chiamate)  
`180522. `&ensp;&ensp;dav&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;abilitaizone messaggi di WRN  
`210329. `&ensp;&ensp;dav&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Gestione UteMsgWrnDisable  
`211202. `&ensp;&ensp;dav&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Aggiunto @ExecutionTime  
`220226. `&ensp;&ensp;dav&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Gestione isnull(@Stato,0) <> - 3 per comandi lunghi  
`221112. `&ensp;&ensp;dav&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;@KYInfoEst as nvarchar(max) = NULL  
`221227. `&ensp;&ensp;marco&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Rinomina @SysUserUpdate -> @SysUser , @Stato -> KyStato  
## Parameter
| name&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | type&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | nullable&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | output&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  |
| ------ | ------ | ------ | ------ |
| Msg  | AS NVARCHAR(300)  | false  | false  |
| Msg1  | AS NVARCHAR(300)  | false  | false  |
| MsgObj  | AS NVARCHAR(300)  | false  | false  |
| Param  | AS NVARCHAR(300)  | false  | false  |
| CodFnzTipoMsg  | AS NVARCHAR(5)  | false  | false  |
| SysUser  | AS NVARCHAR(256)  | false  | false  |
| KYStato  | AS INT  | false  | false  |
| KYRes  | AS INT  | false  | false  |
| KYInfoEst  | AS NVARCHAR(MAX)  | true  | false  |
| KyParam  | AS NVARCHAR(MAX  | false  | false  |
| KyMsg  | AS NVARCHAR(MAX)  | false  | true  |
| TipoDoc  | AS NVARCHAR(256)  | true  | false  |
| IdDoc  | AS NVARCHAR(50)  | true  | false  |
| IdDocDet  | AS NVARCHAR(100  | true  | false  |
| MsgLog  | AS NVARCHAR(MAX)  | true  | false  |
| ExecutionTime  | INT  | true  | false  |
## Dependecies 
| schema&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | name&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | type&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | description&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  |
| ------ | ------ | ------ | ------ |
## Usages 
| schema&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | name&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | type&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | description&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  |
| ------ | ------ | ------ | ------ |
| dbo  | [StpMntObjLog](./StpMntObjLog.md)  | STORED_PROCEDURE  | undefined  |
| dbo  | [StpZone_KyDel](./StpZone_KyDel.md)  | STORED_PROCEDURE  | undefined  |
