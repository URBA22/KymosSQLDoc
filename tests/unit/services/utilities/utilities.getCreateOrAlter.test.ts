import { FsManager } from 'src/core/fsmanager/fsmanager';
import { Utilities } from 'src/services/parser/core/utilities';

describe('Utilities GetOCreateOrAlter', () => {
    const fsManager = new FsManager();


    test('Should work if given right parameters', async () => {
        const content = await fsManager.readFileAsync('tests/mockup/examples', 'StpXImptPdm_Articolo.sql');

        const coa = Utilities.getCreateOrAlter(content);

        expect(coa).toEqual('CREATE OR ALTER');
    });





});