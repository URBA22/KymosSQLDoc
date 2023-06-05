import { Guard } from '../../services';
import { ICommand, Command } from './command';


interface ICommandBuilder_Step0 {
    /**
     * Set a command title. The title will be displaied before standard when the command is invoked with `-h` or `--help` argument.
     * @param title Command title
     */
    withTitle(title: string): ICommandBuilder_Step1;
}

interface ICommandBuilder_Step1 {
    /**
     * Set a command version. The version will be displaied when the command is invoked with `-V` or `--version` argument.
     * @param version Command current version
     */
    withVersion(version: string): ICommandBuilder_Step2;
}

interface ICommandBuilder_Step2 {
    /**
     * Set a command description.
     * @param description Command description.
     */
    withDescription(description: string): ICommandBuilder_Step3;
}

interface ICommandBuilder_Step3 {
    /**
     * Add an argument to the command.
     * @param option Argument flags.
     * @param description Argument description.
     * 
     * @throws {ArgumentNullOrEmptyError} if option is null or empty
     */
    withOption(option: string, description: string): ICommandBuilder_Step3;
    /**
     * Build the command.
     */
    build(): ICommand;
}

/**
 * @static
 * Static class which expose methods to create a ICommnad object.
 * @see ICommand
 */
export default class CommandBuilder implements ICommandBuilder_Step0, ICommandBuilder_Step1, ICommandBuilder_Step2, ICommandBuilder_Step3 {

    private title: string;
    private version: string;
    private description: string;
    private options: { key: string, value: string }[];

    private constructor() {
        this.title = '';
        this.version = '';
        this.description = '';
        this.options = [];
    }

    /**
     * Create a new ICommand object.
     * @see ICommand
     * @static
     */
    public static createCommand(): ICommandBuilder_Step0 {
        return new CommandBuilder();
    }

    public withTitle(title: string): ICommandBuilder_Step1 {
        Guard.Against.NullOrEmpty(title, 'title');

        this.title = title;
        return this;
    }

    public withVersion(version: string): ICommandBuilder_Step2 {
        Guard.Against.NullOrEmpty(version, 'version');

        this.version = version;
        return this;
    }

    public withDescription(description: string): ICommandBuilder_Step3 {
        Guard.Against.NullOrEmpty(description, 'description');

        this.description = description;
        return this;
    }

    public withOption(option: string, description: string): ICommandBuilder_Step3 {
        Guard.Against.NullOrEmpty(option, 'option');

        this.options.push({
            key: option,
            value: description
        });
        return this;
    }

    public build(): ICommand {
        return new Command(
            this.title,
            this.version,
            this.description,
            this.options
        );
    }
}
