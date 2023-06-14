import { mkdirSync, rmdirSync, writeFileSync, rmSync, existsSync } from 'fs';
import { Directory } from 'src/core/fsmanager/core/Directory';
import { Root } from 'src/core/fsmanager/core/Root';
import { FsManager } from 'src/core/fsmanager/fsmanager';
import { InvalidPathError } from 'src/services/guardClauses/errors';
import { describe, beforeAll, test, expect } from '@jest/globals';

describe('FsManager ReadDirectoryAsync', () => {
    beforeAll(() => {
        if (!existsSync('./tests/mockup/testpath'))
            mkdirSync('./tests/mockup/testpath');
        if (!existsSync('./tests/mockup/testpath/testdir'))
            mkdirSync('./tests/mockup/testpath/testdir');
        if (!existsSync('./tests/mockup/testpath/testfile.txt'))
            writeFileSync('./tests/mockup/testpath/testfile.txt', 'prova');

    });

    test('Shouold read directory when path is absolute', async () => {
        const path = 'C:/Users/HP/Desktop/SCUOLA/pcto/KymosSQLDoc/tests/mockup';
        const fs = new FsManager;
        const actual = await fs.readDirectoryAsync(path);
        const res = JSON.stringify(actual);
        expect(res).toEqual('{"path":"C:/Users/HP/Desktop/SCUOLA/pcto/KymosSQLDoc/tests/","directory":{"name":"mockup","directory":"C:/Users/HP/Desktop/SCUOLA/pcto/KymosSQLDoc/tests/mockup","files":[],"children":[{"name":"examples","directory":"C:/Users/HP/Desktop/SCUOLA/pcto/KymosSQLDoc/tests/mockup/examples","files":["StpXImptPdm_Articolo.sql","templateProcedureDoc.md"],"children":[]},{"name":"testpath","directory":"C:/Users/HP/Desktop/SCUOLA/pcto/KymosSQLDoc/tests/mockup/testpath","files":["testfile.txt"],"children":[{"name":"testdir","directory":"C:/Users/HP/Desktop/SCUOLA/pcto/KymosSQLDoc/tests/mockup/testpath/testdir","files":[],"children":[]}]}]}}');

    });

    test('Shouold read directory when path is relative', async () => {
        const fs = new FsManager;
        const path = './tests/mockup';
        const actual = await fs.readDirectoryAsync(path);
        const res = JSON.stringify(actual);
        //res.replace('\', '');
        expect(res).toEqual('{"path":"./tests/","directory":{"name":"mockup","directory":"./tests/mockup","files":[],"children":[{"name":"examples","directory":"./tests/mockup/examples","files":["StpXImptPdm_Articolo.sql","templateProcedureDoc.md"],"children":[]},{"name":"testpath","directory":"./tests/mockup/testpath","files":["testfile.txt"],"children":[{"name":"testdir","directory":"./tests/mockup/testpath/testdir","files":[],"children":[]}]}]}}');
    });

    test('Shouold throw InvalidPathError when path is not valid', async () => {
        
        const fs = new FsManager;
        await expect(fs.readDirectoryAsync('-p'))
            .rejects
            .toBeInstanceOf(InvalidPathError);

    });

    afterAll(() => {
        
        rmdirSync('./tests/mockup/testpath/testdir');
        rmSync('./tests/mockup/testpath/testfile.txt');
        rmdirSync('./tests/mockup/testpath');
    });

});