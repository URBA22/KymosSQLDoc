import chalk from 'chalk';
import { Command as CLICommand, OptionValues } from 'commander';
import figlet from 'figlet';

export interface ICommand {
    parseAsync(argv: string[]): Promise<OptionValues>;
    get prettyTitle(): string;
}

export class Command implements ICommand {
    private command: CLICommand;
    private title: string;
    private version: string;
    private description: string;
    private options: { key: string, value: string }[];

    constructor(
        title: string,
        version: string,
        description: string,
        options: { key: string, value: string }[]
    ) {
        this.title = title;
        this.version = version;
        this.description = description;
        this.options = options;

        this.command = new CLICommand()
            .version(version)
            .description(description)
            .addHelpText('beforeAll', this.prettyTitle);

        for (const option of options) {
            this.command.option(
                option.key,
                option.value
            );
        }
    }

    /**
     * Command title but prettier
     */
    get prettyTitle(): string {
        let prettyTitle = '';

        const colors = [
            chalk.hex('#FF0000'),
            chalk.hex('#FFA500'),
            chalk.hex('#FFFF00'),
            chalk.hex('#00FF00'),
            chalk.hex('#00BFFF'),
            chalk.hex('#0000FF'),
        ];

        let i = 0;
        for (const row of figlet.textSync(this.title).split('\n')) {
            prettyTitle = prettyTitle + '\n' + colors[i](row);
            i = (i + 1) % 6;
        }

        return prettyTitle + '\n\n';
    }

    public async parseAsync(argv: string[]): Promise<OptionValues> {
        await this.command.parseAsync(argv);
        return this.command.opts();
    }
}

