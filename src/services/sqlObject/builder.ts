import { Guard } from '../guardClauses';
import { ISqlObject, SqlObject } from './sqlObject';


interface ISqlObjectBuilder_Step0 {
    fromDefinition(definition: string): ISqlObjectBuilder_Step1;
}

interface ISqlObjectBuilder_Step1 {
    build(definition: string): ISqlObject;
}

export default class SqlObjectBuilder implements ISqlObjectBuilder_Step0, ISqlObjectBuilder_Step1 {
    private definition?: string;

    private constructor() { }

    static createSqlObject(): ISqlObjectBuilder_Step0 {
        return new SqlObjectBuilder();
    }

    public fromDefinition(definition: string): ISqlObjectBuilder_Step1 {
        Guard.Against.NullOrEmpty(definition, 'definition');

        this.definition = definition;
        return this;
    }

    public build(definition: string): ISqlObject {
        return new SqlObject(definition);
    }
}