/* eslint-disable max-depth */
import { Console } from 'console';
import fs, { readFileSync, readdir, readdirSync } from 'fs';
import { test } from 'node:test';
import { StringifyOptions } from 'querystring';

export interface IFsManager {
    readFileAsync(path: string): Promise<string>;
    writeFileAsync(path: string, text: string): Promise<void>;

    readDirectoryAsync(path: string): Promise<Directory>;
    writeDirectoryAsync(path: string): Promise<void>;
    readSubDirectory(path: string): Promise<PathManager>;
    isPath(path: string): Promise<boolean>;
}


export class FsManager implements IFsManager {

    private absolutePath: string;

    constructor(absolutePath?: string) {
        this.absolutePath = absolutePath ?? '';
    }

    async readDirectoryAsync(path: string): Promise<Directory> {
        //oggetto contenente tutto i percorsi 
        const dir: Directory = new Directory(path, await this.readSubDirectory(path));
        //serializzazione in json
        const jsonString = JSON.stringify(dir);
        //file di tipo json
        this.writeFileAsync('./tests/fileJson.json', jsonString);

        return dir;
        
    }

    public async readSubDirectory(path: string): Promise<PathManager> {
        //oggetto di tipo PathManager che serve a trovare tutti i percorsi
        const pm: PathManager = new PathManager(path, [], []);
        //legge tutto quello che c'è dopo il percorso dato
        const content: string[] = readdirSync(path);
        //controlla per ogni percorso che trova se è un file o una cartella, nel primo caso
        //aggiunge il file ai file del percorso originale, nel secondo caso richiama il metodo 
        //passando il percorso della cartella trovata
        for (const nextFile of content) {
            if (await this.isPath(path + '/' + nextFile))
                pm.children?.push(await this.readSubDirectory(path + '/' + nextFile));
            else
                pm.files?.push(nextFile);
        }        

        return pm;
    }

    async isPath(path: string): Promise<boolean> {
        //controlla se il percorso passato è una cartella
        let ispath = false;
        let file = '';
        try {
            file = readFileSync(path, 'utf-8');
        } catch (err) {
            ispath = true;
        }
        return ispath;
    }



    async writeDirectoryAsync(path: string): Promise<void> {
        //non sono sicuro funzioni
        if (!fs.existsSync(path)) {
            fs.mkdirSync(path);
        }
    }

    async readFileAsync(path: string): Promise<string> {
        //funziona
        const content: string = fs.readFileSync(path, 'utf8');
        return content;
    }
    async writeFileAsync(path: string, text: string): Promise<void> {
        //funziona
        fs.writeFile(path, text, (err) => {
            if (err)
                console.log(err);
            else
                console.log('File written correctly');
        });


    }
}

export class PathManager {

    public originalDirectory?: string;   //directory che contiene i file e le altre directory
    public files?: string[];             //file presenti nella directory
    public children?: PathManager[];     //directory presenti nella directory originale


    constructor(originalDirectory?: string, files?: string[], children?: PathManager[]) {
        this.originalDirectory = originalDirectory;
        this.files = files;
        this.children = children;
    }
}

export class Directory {
    public path: string;
    public child: PathManager;

    constructor(path: string, child: PathManager) {
        this.path = path;
        this.child = child;
    }

}

