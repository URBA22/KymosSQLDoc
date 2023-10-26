# StpMntObjKey_KyUpd
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
| dbo | StpUteMsg | 2 | (dependecy as ISqlObject).desc |
# Usages 

| schema      | name      | type       | desc          |
| ------ | -------- | -------- | ------ |
# Parameter

| name      | type      | nullable      | output       | desc          |
| ------ | -------- | -------- | -------- | ------ |
| IdObjKey | INT | false | false | undefined |
| IdKey | NVARCHAR(200) | false | false | undefined |
| IdObject | NVARCHAR(256) | false | false | undefined |
| Value | NVARCHAR(MAX) | false | false | undefined |
| SysRowVersion | TIMESTAMP | false | false | undefined |
| SysUserUpdate | NVARCHAR(256) | false | false | undefined |
| KYStato | INT | true | true | undefined |
| KYMsg | NVARCHAR(MAX) | true | true | undefined |
| KYRes | INT | true | false | undefined |
