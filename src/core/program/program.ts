import { ICommand } from '@core';
import { IParser } from '@services';

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

        console.log(programOptions);
    }
}