import { unlinkSync } from 'fs';
import { FsManager } from 'src/core/fsmanager/fsmanager';
import { InvalidPathError } from 'src/services/guardClauses/errors';
import { describe, beforeAll, test, expect } from '@jest/globals';

describe('FsManager ReadFileAsync', () => {
    
    const fsManagerTest = new FsManager();
    const absPath = 'tests/mockup/';
    const relPath = './tests/mockup/';
    const wrongPath = './t//tests/mockup';
    const fileName = 'test.txt';
    const fileContent = ' prova ';

    beforeAll(() => {
        fsManagerTest.writeFileAsync(absPath, fileName, fileContent);
    });

    test('Should read file when path is absolute', async () => {
        expect( await fsManagerTest.readFileAsync(absPath, fileName)).toEqual(fileContent);
    });
    
    test('Should read file when path is relative', async () => {
        expect(await fsManagerTest.readFileAsync(relPath, fileName)).toEqual(fileContent);
    });
    
    test('Should throw InvalidPathError when path is not valid', async () => {
        await expect(fsManagerTest.readFileAsync(wrongPath, fileName)).rejects.toBeInstanceOf(InvalidPathError);
    });

    afterAll(() => {
        unlinkSync(absPath+fileName);
    });

});