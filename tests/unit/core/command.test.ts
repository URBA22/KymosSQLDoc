import { CommandBuilder, ICommand } from 'src/core';
import { describe, beforeAll, test, expect } from '@jest/globals';

describe('Command tests', () => {
    let command: ICommand;

    beforeAll(() => {
        command = CommandBuilder
            .createCommand()
            .withTitle('acb ACB !£$%&/()=')
            .withVersion('10.0.0')
            .withDescription('Test description')
            .build();
    });

    test('Pretty title', () => {
        expect(command.prettyTitle).not.toBeNull();
        expect(command.prettyTitle).not.toBeUndefined();
        expect(command.prettyTitle).not.toEqual('');
    });
});