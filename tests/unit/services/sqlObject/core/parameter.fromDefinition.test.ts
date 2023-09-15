import { FsManager } from 'src/core/fsmanager/fsmanager';
import { SqlObjectBuilder } from 'src/services/sqlObject';
import { ISqlObject } from 'src/services/sqlObject/sqlObject';
import { Parameter } from 'src/services/sqlObject/core';


describe('SqlObject Parameter fromDefinition ', () => {

    let sqlObject: ISqlObject;

    beforeAll(async () => {
        const fsmanager = new FsManager();
        const rawDefinition = await fsmanager.readFileAsync('./tests/mockup/examples/', 'StpXImptPdm_Articolo.sql');

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
                name: 'IdArticolo',
                type: 'NVARCHAR(50)',
                nullable: true,
                output: true,
                default: undefined,
                description: undefined
            }, {
                name: 'SysUser',
                type: 'NVARCHAR(256)',
                nullable: false,
                output: false,
                default: undefined,
                description: undefined
            }, {
                name: 'Prova',
                type: 'DECIMAL(18, 8)',
                nullable: false,
                output: false,
                default: undefined,
                description: undefined
            }, {
                name: 'Prova1',
                type: 'DECIMAL(18, 8)',
                nullable: true,
                output: false,
                default: undefined,
                description: undefined
            }, {
                name: 'Prova2',
                type: 'DECIMAL(18, 8)',
                nullable: true,
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
                name: 'NULLKy',
                type: 'BIT',
                nullable: false,
                output: false,
                default: undefined,
                description: undefined
            }, {
                name: 'KYRes',
                type: 'INT',
                nullable: true,
                output: false,
                default: undefined,
                description: undefined
            }, {
                name: 'KYRequest',
                type: 'UNIQUEIDENTIFIER',
                nullable: true,
                output: true,
                default: undefined,
                description: undefined
            }, {
                name: 'Debug',
                type: 'BIT',
                nullable: false,
                output: false,
                default: '0',
                description: undefined
            }];

        expect(sqlObject.name).toEqual('StpXImptPdm_Articolo');
        let i = 0;
        parameters.forEach(param => {
            expect(param).toEqual(expectedResult[i++]);
        });


    });
});