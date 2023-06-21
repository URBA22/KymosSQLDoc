import { copyFileSync } from 'fs';
import { FsManager } from 'src/core/fsmanager/fsmanager';
import { Utilities } from 'src/services/parser/core/utilities';

describe('FsManager ReadFileAsync', () => {
    const utility = new Utilities();
    const fsManager = new FsManager();



    test('Should work fine', async () => {
        const split = Utilities.splitDefinitionComment(await fsManager.readFileAsync('tests/mockup/examples/', 'StpXImptPdm_Articolo.sql'));

        const x=Utilities.getCreateOrAlter(split.definition);
        const type=Utilities.getObjectType(split.definition,x);
        const name=Utilities.getObjectName(split.definition, type);
        console.log(name);
        expect('').toEqual('');
    });



});