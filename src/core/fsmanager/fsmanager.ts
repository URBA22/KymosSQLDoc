import fs, { readdirSync } from 'fs';
import { Guard } from 'src/services';
import { IRoot, Root } from './core/Root';
import { Directory } from './core/Directory';

export interface IFsManager {

    get absolutePath(): string;
    set absolutePath(absolutePath: string);

    readFileAsync(path: string, name: string): Promise<string>;
    writeFileAsync(path: string, name: string, text: string): Promise<void>;

    readDirectoryAsync(path: string): Promise<IRoot>;
    writeDirectoryAsync(path: string, name: string): Promise<void>;
    isPath(path: string): Promise<boolean>;
}


export class FsManager implements IFsManager {

    public absolutePath: string;

    constructor(absolutePath?: string) {
        this.absolutePath = absolutePath ?? '';
    }

    private static async mergePath(root: string, path: string) {
        if (root.endsWith('/')) {
            root.substring(0, root.length - 1);
        }

        if (!path.startsWith('/')) {
            path = '/' + path;
        }

        return root + path;
    }

    public async isPath(path: string): Promise<boolean> {
        path = await FsManager.mergePath(this.absolutePath, path);

        //controlla se il percorso passato è una cartella
        if (fs.existsSync(path) && fs.lstatSync(path).isDirectory()) {
            return true;
        }
        return false;
    }

    private async readNexFileOrDirectory(path: string, nextFile: string, arrDirectories: Promise<Directory>[], dir: Directory) {
        if (await this.isPath(path + '/' + nextFile)) {
            arrDirectories.push(this.readSubDirectory(path + '/' + nextFile));
        }
        else {
            dir.files?.push(nextFile);
        }
    }

    private async readSubDirectory(path: string): Promise<Directory> {
        //oggetto di tipo Directory che conterrà tutti i percorsi dopo quello passato
        const dir: Directory = new Directory(path, path.substring(path.lastIndexOf('/') + 1), [], []);
        //legge tutto quello che c'è dopo il percorso dato
        const content: string[] = readdirSync(path);
        //array contenente i percorsi figli del percorso passato, dichiarato come Promise<> per
        //migliorare le prestazioni evitando l'await
        const arrDirectories: Promise<Directory>[] = [];
        //controlla per ogni percorso che trova se è un file o una cartella, nel primo caso
        //aggiunge il file ai file del percorso originale, nel secondo caso richiama il metodo 
        //passando il percorso della cartella trovata
        for (const nextFile of content) {
            await this.readNexFileOrDirectory(path, nextFile, arrDirectories, dir);
        }
        //dopo che tutti i thread iniziati hanno finito assegna i valori dei percorsi presenti
        dir.children = await Promise.all(arrDirectories);

        return dir;
    }

    /**
     * Read a directory
     * @param path Location of the directory to read
     * @returns 
     */
    async readDirectoryAsync(path: string): Promise<IRoot> {
        path = await FsManager.mergePath(this.absolutePath, path);

        Guard.Against.InvalidPath(path);

        const root = new Root(path.substring(0, path.lastIndexOf('/') + 1), await this.readSubDirectory(path));
        return root;
    }

    /**
     * Create a new directory
     * @param path Location where the new directory will be create
     * @param name Name of the new directory
     */
    public async writeDirectoryAsync(path: string, name: string): Promise<void> {
        path = await FsManager.mergePath(this.absolutePath, path);

        Guard.Against.InvalidPath(path);
        Guard.Against.NullOrEmpty(name, 'name');

        path = await FsManager.mergePath(path, name);

        if (!fs.existsSync(path)) {
            fs.mkdirSync(path);
        }
    }

    /**
     * Read a text file
     * @param path Location of the file to read
     * @param name File name
     * @returns File content with utf-8 encoded
     */
    async readFileAsync(path: string, name: string): Promise<string> {
        path = await FsManager.mergePath(this.absolutePath, path);

        Guard.Against.InvalidPath(path);
        Guard.Against.NullOrEmpty(name, 'name');

        path = await FsManager.mergePath(path, name);

        Guard.Against.InvalidPath(path);

        const content: string = fs.readFileSync(path, 'utf8');
        return content;
    }

    /**
     * Create a new file
     * @param path Location where the new file will be created
     * @param name Name of the new file
     * @param text Content of the file (utf-8 encoded)
     */
    async writeFileAsync(path: string, name: string, text: string): Promise<void> {
        path = await FsManager.mergePath(this.absolutePath, path);

        Guard.Against.InvalidPath(path);
        Guard.Against.NullOrEmpty(name, 'name');

        path = await FsManager.mergePath(path, name);

        fs.writeFileSync(path, text);
    }
}


