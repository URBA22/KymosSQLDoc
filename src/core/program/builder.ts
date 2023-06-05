import { ICommand } from '../command';
import { IProgram, Program } from './program';
import { Guard, IParser } from '../../services';

interface IProgramBuilder_Step0 {
    withCommand(command: ICommand): IProgramBuilder_Step1
}

interface IProgramBuilder_Step1 {
    withParser(parser: IParser): IProgramBuilder_Step2
}

interface IProgramBuilder_Step2 {
    build(): IProgram;
}

export default class ProgramBuilder implements IProgramBuilder_Step0, IProgramBuilder_Step1, IProgramBuilder_Step2 {
    private command?: ICommand;
    private parser?: IParser;

    private constructor() { }

    static createProgram(): IProgramBuilder_Step0 {
        return new ProgramBuilder();
    }

    public withCommand(command: ICommand): IProgramBuilder_Step1 {
        Guard.Against.Null(command, 'command');

        this.command = command;
        return this;
    }

    public withParser(parser: IParser): IProgramBuilder_Step2 {
        Guard.Against.Null(parser, 'parser');

        this.parser = parser;
        return this;
    }

    public build(): IProgram {
        return new Program(this.command as ICommand, this.parser as IParser);
    }
}
