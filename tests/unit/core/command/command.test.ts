import { CommandBuilder, ICommand } from 'src/core';
import { describe, beforeAll, test, expect } from '@jest/globals';
import { OptionValues } from 'commander';

describe('Command tests', () => {
    let command: ICommand;

    beforeAll(() => {
        command = CommandBuilder
            .createCommand()
            .withTitle('acb ACB !£$%&/()=')
            .withVersion('10.0.0')
            .withDescription('Test description')
            .withOption('-t --test <value>', 'Test option')
            .build();
    });

    test('Pretty title', () => {
        expect(command.prettyTitle).not.toBeNull();
        expect(command.prettyTitle).not.toBeUndefined();
        expect(command.prettyTitle).not.toEqual('');
    });

    test('Options parsing', async () => {
        const argvTest = [
            '/usr/local/bin/node',
            '/Users/simone/Kymos/KymosSQLDoc/KymosSQLDoc/dist/index.js',
            '-t',
            'Test 123'
        ];
        const actual = await command.parseAsync(argvTest);
        const result: OptionValues = {
            test: 'Test 123'
        };

        expect(actual).toEqual(result);
    });

    test('Options parsing', async () => {
        const argvTest = [
            '/usr/local/bin/node',
            '/Users/simone/Kymos/KymosSQLDoc/KymosSQLDoc/dist/index.js',
            '-p',
            'Test 123'
        ];

        await expect(command.parseAsync(argvTest))
            .rejects
            .toThrow(Error);

    });
});