# FncVstrTransiti
sqlObject.desc

# Info 
@Summary undefined
@Author undefined
@Custom undefined
@Standard undefined
# Versions 
# Dependecies 

| schema      | name      | type       | desc          |
| ------ | -------- | -------- | ------ |
# Usages 

| schema      | name      | type       | desc          |
| ------ | -------- | -------- | ------ |
# Parameter

| name      | type      | nullable      | output       | desc          |
| ------ | -------- | -------- | -------- | ------ |
| SysUser | NVARCHAR(256) | true | false | undefined |
| DataTransito | DATE | true | false | undefined |
| IdCliDest | INT | true | false | undefined |
| IdCliente | INT | false | false | undefined |
| VstrTransiti | TABLE ( IDTRANSITO [INT], IDCLIENTE [INT], IDCLIDEST [INT], IDGUIDTOKEN [UNIQUEIDENTIFIER], ORAELABTOKEN [DATETIME], IDVSTR [INT], ORATRANSITO [DATETIME], IDUTENTEREF [NVARCHAR](256), PROVENIENZA [NVARCHAR](50), DESCUTENTEREF [NVARCHAR](50), BADGE [NVARCHAR](50), NOME [NVARCHAR](100), COGNOME [NVARCHAR](100), COGNOMENOME [NVARCHAR](100), SOCIETA [NVARCHAR](100), CELL [NVARCHAR](50), EMAIL [NVARCHAR](256), SYSDATECREATE [DATETIME], SYSUSERCREATE [NVARCHAR](256), SYSDATEUPDATE [DATETIME], SYSUSERUPDATE [NVARCHAR](256), SYSROWVERSION [VARBINARY](8) , FLGPRIVACY [BIT] , INDIRIZZOCOMPLETO [NVARCHAR](MAX) NULL | false | false | undefined |
