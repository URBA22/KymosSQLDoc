# FncVstr
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
| IdCliente | INT | false | false | undefined |
| Vstr | TABLE ( IDVSTR [INT], IDGUIDVSTR [NVARCHAR](256) , NOME [NVARCHAR](100) NOT , COGNOME [NVARCHAR](100) NOT NULL, COGNOMENOME [NVARCHAR](100) NOT NULL, SOCIETA [NVARCHAR](100), CELL [NVARCHAR](50), EMAIL [NVARCHAR](256), SYSDATECREATE [DATETIME], SYSUSERCREATE [NVARCHAR](256), SYSDATEUPDATE [DATETIME], SYSUSERUPDATE [NVARCHAR](256), SYSROWVERSION [VARBINARY](8) NULL, IDCLIENTE [INT], FLGPRIVACY [BIT] NOT NULL | false | false | undefined |
