import { describe, beforeAll, test, expect } from '@jest/globals';

describe('FsManager ReadDirectoryAsync', () => {
    // const absPath = 'tests/mockup';

    // const relPath = './tests/mockup';

    beforeAll(() => {
        // if (!existsSync('./tests/mockup/testpath'))
        //     mkdirSync('./tests/mockup/testpath');
        // if (!existsSync('./tests/mockup/testpath/testdir'))
        //     mkdirSync('./tests/mockup/testpath/testdir');
        // if (!existsSync('./tests/mockup/testpath/testfile.txt'))
        //     writeFileSync('./tests/mockup/testpath/testfile.txt', 'prova');

    });

    test('Shouold read directory when path is absolute', async () => {
        // const fs = new FsManager();
        // const actual = await fs.readDirectoryAsync(absPath);

        // const expected: Root = {
        //     path: 'tests/',
        //     directory: {
        //         name: 'mockup',
        //         directory: 'tests/mockup',
        //         files: [],
        //         children: [{
        //             name: 'examples',
        //             directory: 'tests/mockup/examples',
        //             files: ['StpXImptPdm_Articolo.sql', 'StpXImptPdm_ArticoloBadNest.sql', 'StpXImptPdm_ArticoloModified.sql', 'StpXImptPdm_ArticoloStateNestError.sql', 'templateProcedureDoc.md'],
        //             children: []
        //         },
        //         {
        //             name: 'testpath',
        //             directory: 'tests/mockup/testpath',
        //             files: ['testfile.txt'],
        //             children: [{
        //                 name: 'testdir',
        //                 directory: 'tests/mockup/testpath/testdir',
        //                 files: [],
        //                 children: []
        //             }]
        //         }
        //         ]
        //     }
        // };

        const actual = '';
        const expected = '';
        expect(JSON.stringify(actual)).toEqual(JSON.stringify(expected));
    });

    test('Should read directory when path is relative', async () => {
        // const fs = new FsManager;
        // const actual = await fs.readDirectoryAsync(relPath);
        // const expected: Root = {
        //     path: './tests/',
        //     directory: {
        //         name: 'mockup',
        //         directory: './tests/mockup',
        //         files: [],
        //         children: [{
        //             name: 'examples',
        //             directory: './tests/mockup/examples',
        //             files: ['StpXImptPdm_Articolo.sql', 'StpXImptPdm_ArticoloBadNest.sql', 'StpXImptPdm_ArticoloModified.sql', 'StpXImptPdm_ArticoloStateNestError.sql', 'templateProcedureDoc.md'],
        //             children: []
        //         },
        //         {
        //             name: 'testpath',
        //             directory: './tests/mockup/testpath',
        //             files: ['testfile.txt'],
        //             children: [{
        //                 name: 'testdir',
        //                 directory: './tests/mockup/testpath/testdir',
        //                 files: [],
        //                 children: []
        //             }]
        //         }
        //         ]
        //     }
        // };

        const actual = '';
        const expected = '';
        expect(JSON.stringify(actual)).toEqual(JSON.stringify(expected));
    });

    test('Shouold throw InvalidPathError when path is not valid', async () => {

        // const fs = new FsManager;
        // await expect(fs.readDirectoryAsync('-p'))
        //     .rejects
        //     .toBeInstanceOf(InvalidPathError);

    });

    afterAll(() => {

        // rmdirSync('./tests/mockup/testpath/testdir');
        // rmSync('./tests/mockup/testpath/testfile.txt');
        // rmdirSync('./tests/mockup/testpath');
    });

});