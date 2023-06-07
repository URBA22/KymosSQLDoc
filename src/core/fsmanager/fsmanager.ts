/* eslint-disable max-depth */
import { Console } from 'console';
import fs, { readFileSync, readdirSync } from 'fs';
import { test } from 'node:test';
import { StringifyOptions } from 'querystring';
export interface IFsManager {
    readFileAsync(path: string): Promise<string>;
    writeFileAsync(path: string): Promise<void>;

    readDirectoryAsync(path: string): Promise<PathManager>;
    writeDirectoryAsync(path: string): Promise<void>;
}


export class FsManager implements IFsManager {

    private absolutePath: string;

    constructor(absolutePath?: string) {
        this.absolutePath = absolutePath ?? '';
    }

    async readDirectoryAsync(path: string): Promise<PathManager> {
        //creao due array il primo conterrà le directories, l'altro conterrà le cartelle successive
        const directories: Directory[] = [];
        const pathmanager: PathManager[] = [];
        //dichiaro variabili, files contiene i file che si trovano all'interno della cartella,
        //diverso è un booleano che serve a controllare che lo stesso file non venga letto più volte
        //file è la variabile contenente il file che poi verrà aggiunto a files
        let files: string[] = [];
        let different = true;
        let file = '';


        //ciclo per inizializzare files per dichiarare il primo PathManager che ha come path 'path'
        do {
            try {
                //leggo idealmente il primo file
                file = await this.readFileAsync(path);
            }
            catch (err) {
                console.log('non è un file!');
            }
            //controllo sia diverso
            for (let i = 0; i < files.length; i++) {
                // eslint-disable-next-line max-depth
                if (file == files[i])
                    different = false;
            }
            //se diverso e diverso da nullo lo aggiungo
            if (file != null && different)
                files.push(file);
            console.log(file);
        } while (file != null && different);

        //inizializzo il primo pathmanager con il path originale
        const pm: PathManager = new PathManager(path, files, pathmanager);
        //creo la prima directory e la aggiungo all'array contenete le directory
        const tempDir: Directory = new Directory(path, pm);
        directories.push(tempDir);

        //svuoto l'array che contiene i file per riusarlo evitando errrori
        files = [];

        //creo un array di stringhe che conterrà idealmente tutti i path presenti nel path originale
        let paths: string[] = [];

        try {
            paths = fs.readdirSync(path);
        } catch (err) {
            console.log('errore nella lettura dei path successivi');
        }
        /*
                //variabile che conterrà il path successivo
                let nextPath = path;
                //inizializzo tre variabili booleane che controlleranno se è un file o una directory 
                //o se deve finire il ciclo
                let isFile = true;
                let isDirectory = true;
                let isNotFinished = true;
        
                const foundPaths: string[] = [];
        
                console.log('inizio ciclo:');
                paths.forEach(function(p:string){
                    do {
                        //ciclo per ogni path presente in paths, quindi ciclo per ogni path del path originale
                        nextPath = nextPath + '/' + p;
                        console.log('p: '+ p);
                        try {
                            paths = fs.readdirSync(nextPath);
                        } catch (err) {
                            isDirectory = false;
                            console.log('nodir');
                        }
        
                        if (isDirectory) {
                            console.log(nextPath);
                        }
                        //leggo un file presente nella path attuale e lo aggiungo all'array files per poi
                        //inizializzare un nuovo PathManager
                        try {
                            file = fs.readFileSync(p, 'utf8');
                        } catch (err) {
                            isFile = false;
                            console.log('nofile');
                        }
        
                        if (isFile) {
                            console.log(p);
                        
                                
                            //controllo sia diverso
                            for (let i = 0; i < files.length; i++) {
                                // eslint-disable-next-line max-depth
                                if (file == files[i])
                                    different = false;
                            }
                            //se diverso e diverso da nullo lo aggiungo
                            if (file != null && different)
                                files.push(file);
                        
                        }
                        
        
                        //inizializzo un nuovo PathManager
                        pm = new PathManager(p, files, pathmanager);
                        //creo una nuova directory con il path attuale   
                        tempDir = new Directory(p, pm);
                        //aggiungo entrambi ai rispttivi array
                        directories.push(tempDir);
                        pathmanager.push(pm);
                        //risvuoto files per evitare errori
                        files = [];
        
        
        
                        if (!isFile && !isDirectory) {
                            isNotFinished = false;
                        }
                        else {
                            isFile = true;
                            isDirectory = true;
                        }
        
                        foundPaths.push(nextPath);
        
                    } while (isNotFinished);
                });
                foundPaths.forEach(function (s: string) {
                    console.log(s);
                });
        
        */

        let isfinished = false;
        let nextPath = path;
        const foundPaths: string[] = [];
        const foundFiles: string[] = [];
        const foundDirectories: string[] = [];
        let isFile = true;
        let isDirectory = true;
        let testPaths: string[] = [];
        let testpath = '';
        const savedpath = '';

        try {
            testPaths = readdirSync(path);
        } catch (err) {
            isDirectory = false;
        }
        if (isDirectory)
            foundDirectories.push(path);

        try {
            testpath = readFileSync(path, 'utf-8');
        } catch (err) {
            isFile = false;
        }
        if (isFile)
            foundFiles.push(path);
        isDirectory = true;
        isFile = true;

        do {
            for (let i = 0; i < paths.length; i++) {
                nextPath += '/' + paths[i];

                console.log(nextPath);

                try {
                    testPaths = readdirSync(nextPath);
                } catch (err) {
                    isDirectory = false;
                }
                if (isDirectory) {
                    paths = readdirSync(nextPath);
                    foundDirectories.push(nextPath);
                    foundPaths.push(nextPath);
                }
                else {

                    try {
                        testpath = readFileSync(nextPath, 'utf-8');
                    } catch (err) {
                        isFile = false;
                    }
                    if (isFile) {
                        foundFiles.push(nextPath);
                        foundPaths.push(nextPath);
                    }
                }



            }
            if (!isDirectory && !isFile)
                isfinished = true;
        } while (!isfinished);

        foundDirectories.forEach(function (p: string) {
            console.log(p);
        });
        console.log('-----------');

        foundFiles.forEach(function (p: string) {
            console.log(p);
        });
        console.log('-----------');

        foundPaths.forEach(function (p: string) {
            console.log(p);
        });







        return pm;

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
    async writeFileAsync(path: string): Promise<void> {
        //non sono sicuro funzioni mancherebbe l'input dell'utente
        fs.writeFile(path, 'prova file', (err) => {
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

    async getChild(): Promise<PathManager> {
        return this.child;
    }
}

