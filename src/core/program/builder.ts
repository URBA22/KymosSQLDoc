import { ICommand } from '../command';
import { IProgram, Program } from './program';
import { Guard } from '../../services';
import { IFsManager } from '../fsmanager';
import { FsManager } from '../fsmanager/fsmanager';

interface IProgramBuilder_Step0 {
    withCommand(command: ICommand): IProgramBuilder_Step1
}

interface IProgramBuilder_Step1 {
    withFsManager(fsManager: IFsManager): IProgramBuilder_Step2
}

interface IProgramBuilder_Step2 {
    build(): IProgram;
}

export default class ProgramBuilder implements IProgramBuilder_Step0, IProgramBuilder_Step1, IProgramBuilder_Step2 {
    private command?: ICommand;
    private fsManager?: IFsManager;

    private constructor() { }

    static createProgram(): IProgramBuilder_Step0 {
        return new ProgramBuilder();
    }

    public withCommand(command: ICommand): IProgramBuilder_Step1 {
        Guard.Against.Null(command, 'command');

        this.command = command;
        return this;
    }

    public withFsManager(fsManager: IFsManager): IProgramBuilder_Step2 {
        Guard.Against.Null(fsManager, 'fsManager');

        this.fsManager = fsManager;
        return this;
    }

    public build(): IProgram {
        return new Program(this.command as ICommand, this.fsManager as FsManager);
    }
}
