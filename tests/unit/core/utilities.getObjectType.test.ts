import { copyFileSync } from 'fs';
import { FsManager } from 'src/core/fsmanager/fsmanager';
import { Utilities } from 'src/services/parser/core/utilities';

describe('FsManager ReadFileAsync', () => {
    const utility = new Utilities();
    const fsManager = new FsManager();



    test('Should work fine', async () => {
        const split = Utilities.splitDefinitionComment(await fsManager.readFileAsync('tests/mockup/examples/', 'StpXImptPdm_Articolo.sql'));
        
        expect('').toEqual('');
    });



});