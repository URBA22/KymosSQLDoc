# StpMntDataTable_Exprt
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
| dbo | StpMntObjStartup_Exprt | 2 | (usage as ISqlObject).desc |
# Parameter

| name      | type      | nullable      | output       | desc          |
| ------ | -------- | -------- | -------- | ------ |
| table_name | VARCHAR(776) | false | false | undefined |
| ActionFile | NVARCHAR(20) | false | false | undefined |
| file_name | NVARCHAR(4000) | true | false | undefined |
| target_table | VARCHAR(776) | true | false | undefined |
| include_column_list | BIT | false | false | undefined |
| from | VARCHAR(800) | true | false | undefined |
| where | VARCHAR(800) | true | false | undefined |
| include_syscolumn | BIT | false | false | undefined |
| include_timestamp | BIT | false | false | undefined |
| debug_mode | BIT | false | false | undefined |
| owner | VARCHAR(64) | true | false | undefined |
| ommit_images | BIT | false | false | undefined |
| ommit_identity | BIT | false | false | undefined |
| top | INT | true | false | undefined |
| cols_to_include | VARCHAR(8000) | true | false | undefined |
| cols_to_exclude | VARCHAR(8000) | true | false | undefined |
| disable_constraints | BIT | false | false | undefined |
| ommit_computed_cols | BIT | false | false | undefined |
