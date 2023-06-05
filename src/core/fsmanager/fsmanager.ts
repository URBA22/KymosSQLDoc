
export interface IFsManager {
    readFileAsync(path: string): Promise<string>;
    writeFileAsync(path: string): Promise<void>;

    readDirectoryAsync(path: string): Promise<void>;
    writeDirectoryAsync(path: string): Promise<void>;
}
const fs = require('fs');

export class FsManager implements IFsManager {

    private absolutePath: string;

    constructor(absolutePath?: string) {
        this.absolutePath = absolutePath ?? '';
    }

    async readDirectoryAsync(path: string): Promise<void> {
        //non sono sicuro funzioni e non so se è giusto il Promise<void> essendo un read(penso dovesse restituire una stringa)
        fs.readdirSync(path);

    }
    async writeDirectoryAsync(path: string): Promise<void> {
        //non sono sicuro funzioni
        if (!fs.existsSync(path)) {
            fs.mkdirSync(path);
        }
    }

    async readFileAsync(path: string): Promise<string> {
        //funziona
        const contenuto: string = fs.readFileSync(path, 'utf8');
        return contenuto;
    }
    async writeFileAsync(path: string): Promise<void> {
        //non sono sicuro funzioni mancherebbe l'input dell'utente
        fs.writeFile(path, 'prova file');
    }

}



