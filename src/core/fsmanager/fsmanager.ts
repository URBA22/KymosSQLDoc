
export interface IFsManager {
    readFileAsync(path: string): Promise<string>;
    writeFileAsync(path: string): Promise<void>;

    readDirectoryAsync(path: string): Promise<void>;
    writeDirectoryAsync(path: string): Promise<void>;
}

export class FsManager implements IFsManager {

    private absolutePath: string;

    constructor(absolutePath?: string) {
        this.absolutePath = absolutePath ?? '';
    }

    readDirectoryAsync(path: string): Promise<void> {
        throw new Error('Method not implemented.');
    }
    writeDirectoryAsync(path: string): Promise<void> {
        throw new Error('Method not implemented.');
    }

    readFileAsync(path: string): Promise<string> {
        throw new Error('Method not implemented.');
    }
    writeFileAsync(path: string): Promise<void> {
        throw new Error('Method not implemented.');
    }

}



