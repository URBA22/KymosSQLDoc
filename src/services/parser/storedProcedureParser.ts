import { IParser } from './parser';
import { Utilities } from './core/utilities';

export class StoredProcedureParser implements IParser {
    private definition: string;


    public constructor(definition: string) {
        this.definition = definition;
    }
    public async parseAsync() {
        this.definition+='#{'+Utilities.getObjectName(this.definition, Utilities.getObjectType(this.definition, Utilities.getCreateOrAlter(this.definition)))+'}\n';
        const tokens = Utilities.getTokensDescription(this.definition);
        this.definition+='{'+tokens[0]+'}\n';

        return this.definition;
    }

}