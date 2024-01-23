# dbo - StpZone_KyDel
STORED_PROCEDURE
## Info 
@Summary **undefined**  
@Author **undefined**  
@Custom **undefined**  
@Standard **undefined**  
## Versions 
`version `&ensp;&ensp;_author_&ensp;&ensp;&ensp;&ensp;_desc_&ensp;&ensp;&ensp;&ensp;  
## Parameter
| name&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | type&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | nullable&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | output&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  |
| ------ | ------ | ------ | ------ |
| IdZona  | NVARCHAR(20)  | false  | false  |
| SysRowVersion  | TIMESTAMP  | false  | false  |
| SysUserUpdate  | NVARCHAR(256)  | false  | false  |
| KYStato  | INT  | true  | true  |
| KYMsg  | NVARCHAR(MAX)  | true  | true  |
| KYRes  | INT  | true  | false  |
## Dependecies 
| schema&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | name&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | type&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | description&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  |
| ------ | ------ | ------ | ------ |
| dbo  | [StpUteMsg](./StpUteMsg.md)  | STORED_PROCEDURE  | Inserisce messaggi utente asincroni  |
## Usages 
| schema&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | name&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | type&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  | description&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;  |
| ------ | ------ | ------ | ------ |
