import { Guard } from '../guardClauses';
import { IParser } from './parser';
import { StoredProcedureParser } from './storedProcedureParser';
import { Utilities } from './core/utilities';
import { TriggerParser } from './triggerParser';
import { ViewParser } from './viewParser';
import { ScalarFunctionParser } from './scalarFunctionParser';
import { TableFunctionParser } from './tableFunctionParser';
import { TableParser } from './tableParser';

interface IParserBuilder_Step0 {
    withDefinition(definition: string): IParserBuilder_Step1;
}

interface IParserBuilder_Step1 {
    build(): IParser | undefined;
}

export default class ParserBuilder implements IParserBuilder_Step0, IParserBuilder_Step1 {
    private definition?: string;
    
    private constructor() { }

    private getSQLTypeObject():IParser | undefined {
        /*
            CREATE / CREATE<sl>OR<sl>ALTER / ALTER
            <sl>
            PROCEDURE / TRIGGER / VIEW / FUNCTION / TABLE
            <sl>
            ?? [SCHEMA]. ??
            [NOME_OGGETTO]

            <sl> -> uno o più spazi o 'a capo'

        */
        const splitDefinition = Utilities.splitDefinitionComment(this.definition as string);
        const typeOfObject = Utilities.getObjectType(splitDefinition.definition, Utilities.getCreateOrAlter(splitDefinition.definition));

        switch(typeOfObject){

        case 'PROCEDURE':
            return new StoredProcedureParser(this.definition as string);
            break;

        case 'TRIGGER':
            return new TriggerParser(this.definition as string);
            break;

        case 'VIEW':
            return new ViewParser(this.definition as string);
            break;
        case 'FUNCTION':
            return new ScalarFunctionParser(this.definition as string);
            return new TableFunctionParser(this.definition as string);
            break;

        case 'TABLE':
            return new TableParser(this.definition as string);
            break;
        }

        return undefined;
        
    }

    public static createParser(): IParserBuilder_Step0 {
        return new ParserBuilder();
    }

    withDefinition(definition: string): IParserBuilder_Step1 {
        Guard.Against.NullOrEmpty(definition, 'definition');

        this.definition = definition;
        return this;
    }

    public build(): IParser | undefined {
        return this.getSQLTypeObject();
    }
}