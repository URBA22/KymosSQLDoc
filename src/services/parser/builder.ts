import { Guard } from '../guardClauses';
import { IParser } from './parser';
import { StoredProcedureParser } from './storedProcedureParser';

interface IParserBuilder_Step0 {
    withDefinition(definition: string): IParserBuilder_Step1;
}

interface IParserBuilder_Step1 {
    build(): IParser;
}

export default class ParserBuilder implements IParserBuilder_Step0, IParserBuilder_Step1 {
    private definition?: string;
    
    private constructor() { }

    private getSQLTypeObject(): IParser {
        /*
            CREATE / CREATE<sl>OR<sl>ALTER / ALTER
            <sl>
            PROCEDURE / TRIGGER / VIEW / FUNCTION / TABLE
            <sl>
            ?? [SCHEMA]. ??
            [NOME_OGGETTO]

            <sl> -> uno o più spazi o 'a capo'

        */
        
        return new StoredProcedureParser(this.definition as string);
    }

    public static createParser(): IParserBuilder_Step0 {
        return new ParserBuilder();
    }

    withDefinition(definition: string): IParserBuilder_Step1 {
        Guard.Against.NullOrEmpty(definition, 'definition');

        this.definition = definition;
        return this;
    }

    public build(): IParser {
        return this.getSQLTypeObject();
    }
}