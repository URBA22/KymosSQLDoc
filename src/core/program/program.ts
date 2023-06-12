import { ICommand } from '../command';
import { IParser } from 'src/services';
import { FsManagerBuilder } from '../fsmanager';

export interface IProgram {
    executeAsync(argv: string[]): Promise<void>;
}

export class Program implements IProgram {
    private command: ICommand;
    private parser: IParser;

    constructor(command: ICommand, parser: IParser) {
        this.command = command;
        this.parser = parser;
    }

    public async executeAsync(argv: string[]): Promise<void> {
        const programOptions = await this.command.parseAsync(argv);

        const fsManager = FsManagerBuilder
            .createFsManager()
            .build();


        // 1. prende argomento -s oppure ./ -> source
        // 2. prende argomento -o oppure ./ -> destination

        // 3. contrtolla che source e destination sia una directory

        // 4. legge la directory source
        // 5. guarda la cartella restituita
        // 6. per ogni file nella cartella:
        //      6.1. esegue il parsing della documentazione
        //      6.2. crea una cartella speculare in destination
        //      6.3. crea un file .md con stesso nome e con documentazione
        // 7. ripete punto 6 per tutte le sotto directory 

        console.log(programOptions);
    }
}