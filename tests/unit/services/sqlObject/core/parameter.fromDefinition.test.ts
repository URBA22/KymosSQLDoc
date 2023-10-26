import { FsManager } from 'src/core/fsmanager/fsmanager';
import { SqlObjectBuilder } from 'src/services/sqlObject';
import { ISqlObject } from 'src/services/sqlObject/sqlObject';
import { Parameter } from 'src/services/sqlObject/core';


describe('SqlObject Parameter fromDefinition ', () => {

    let sqlObject: ISqlObject;

    beforeAll(async () => {
        const fsmanager = new FsManager();
        const rawDefinition = await fsmanager.readFileAsync('./tests/mockup/dbo/StoredProcedures/', 'StpMntObjLog.sql');

        sqlObject = await SqlObjectBuilder
            .createSqlObject()
            .fromDefinition(rawDefinition)
            .build()
            .elaborateAsync();
    });

    test('Should fromDefinition parse store procedure and functions parameters from definition', async () => {

        const parameters: Parameter[] = await sqlObject.parameters as Parameter[];
        const expectedResult = [
            {
                name: 'SysUser',
                type: 'NVARCHAR(256)',
                nullable: false,
                output: false,
                default: undefined,
                description: undefined
            }, {
                name: 'KYStato',
                type: 'INT',
                nullable: true,
                output: true,
                default: undefined,
                description: undefined
            }, {
                name: 'KYMsg',
                type: 'NVARCHAR(MAX)',
                nullable: true,
                output: true,
                default: undefined,
                description: undefined
            }, {
                name: 'KYRes',
                type: 'INT',
                nullable: true,
                output: false,
                default: undefined,
                description: undefined
            }];

        expect(sqlObject.name).toEqual('StpMntObjLog');
        let i = 0;
        parameters.forEach(param => {
            expect(param).toEqual(expectedResult[i++]);
        });


    });
});