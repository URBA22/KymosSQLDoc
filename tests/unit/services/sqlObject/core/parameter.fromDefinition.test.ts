import { FsManager } from 'src/core/fsmanager/fsmanager';
import { SqlObjectBuilder } from 'src/services/sqlObject';
import { ISqlObject } from 'src/services/sqlObject/sqlObject';
import { Parameter } from 'src/services/sqlObject/core';


describe('SqlObject Parameter fromDefinition ', () => {

    let sqlObject: ISqlObject;

    beforeAll(async() => {
        const fsmanager = new FsManager();
        const rawDefinition = await fsmanager.readFileAsync('/Users/marco/Documents/Kymos/KymosSQLDoc/tests/mockup/examples/', 'StpXImptPdm_Articolo.sql');

        sqlObject = await SqlObjectBuilder
            .createSqlObject()
            .fromDefinition(rawDefinition)
            .build()
            .elaborateAsync();
    });

    test('Should fromDefinition parse store procedure and functions parameters from definition', async () => {
        
        const parameters: Parameter[] = await sqlObject.parameters as Parameter[];
        const expectedResult = ['IdArticolo', 'SysUser', 'Prova', 'KYStato', 'KYMsg', 'NULLKy', 'KYRes', 'KYRequest', 'Debug'];
        expect(sqlObject.name).toEqual('StpXImptPdm_Articolo');
        let i = 0;
        let str =  '';
        parameters.forEach(param => {
            if(param.default == undefined)str += '' + param.name + ' ' + param.type + ' ' + param.nullable + ' ' + param.output + '\n'; 
            else str += '' + param.name + ' ' + param.type + ' ' + param.nullable + ' ' + param.output + ' ' + param.default + '\n'; 
            expect(param.name).toEqual(expectedResult[i++]);
        });

        
    });
});