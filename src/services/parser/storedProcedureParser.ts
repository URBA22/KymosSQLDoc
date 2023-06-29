import { IParser } from './parser';
import { Utilities } from './core/utilities';
import { setPriority } from 'os';
import { StoredProcedureParserGuard } from './core/storedProcedureParserGuards';
export class StoredProcedureParser implements IParser {
    private definition: string;
    private static index: number[] = [0];
    private static indexArrDepth = 0;


    public constructor(definition: string) {
        this.definition = definition;
    }




    public async parseAsync() {



        //constant that contains both commented part and non-commented part of definition
        const split = Utilities.splitDefinitionComment(this.definition);

        const content = split.comments.toUpperCase().replace(/((@STEP)|(\n)|(\t)|(\r)|[ ]|-)+/g, ' ');

        StoredProcedureParserGuard.Guard.stateGuard(split.comments);
        StoredProcedureParserGuard.Guard.checkIfWrittenCorrectly(content, []);
        StoredProcedureParserGuard.Guard.ifGuard(split.comments);
        StoredProcedureParserGuard.Guard.sectionGuard(split.comments);
        StoredProcedureParserGuard.Guard.whileGuard(split.comments);

        //writes the name of the procedure 
        let newDefinition = '# ' + Utilities.getObjectName(split.definition, Utilities.getObjectType(this.definition, Utilities.getCreateOrAlter(this.definition))) + '\n';

        //obtain and write tokens
        const tokens = Utilities.getTokensDescription(split.comments);
        newDefinition += tokens[0].trim() + '\n';
        newDefinition += '- Autore : ' + tokens[1].trim() + '\n';
        newDefinition += '- Custom : ' + tokens[2].trim() + '\n';
        newDefinition += '- Standard : ' + tokens[3].trim() + '\n';

        //writes the title of the versions and initzializes the table
        newDefinition += '\n## Versioni\nAutore | Versione | Descrizione\n--- | --- | --- \n';
        //writes the versions in a table
        for (let i = 4; i < tokens.length; i++) {
            let tokensTemp: string[] = [];
            tokens[i] = tokens[i].replace(/[ ]+/g, ' ');
            tokens[i] = tokens[i].replace(/(\t|\n|\r)+/g, '');
            tokensTemp = Utilities.getVersionDescription(tokens[i].split(' '));
            newDefinition += tokensTemp[0] + ' | ';
            newDefinition += tokensTemp[1] + ' | ';
            newDefinition += tokensTemp[2] + '\n';
        }

        //gets all the parameters and writes them
        const parameters = Utilities.getParameters(split.definition, Utilities.getObjectName(this.definition, Utilities.getObjectType(this.definition, Utilities.getCreateOrAlter(this.definition))));

        //writes parameters title and initializes the parameters table
        newDefinition += '\n## Parametri\nNome | Tipo | Null | Output | Descrizione\n--- | --- | --- | --- | --- \n';
        //writes the parameters in a table
        for (const param of parameters) {
            newDefinition += param.substring(0, param.indexOf(' ')) + ' | ';
            newDefinition += Utilities.getParameterType(param) + ' | ';
            newDefinition += Utilities.getParameterOutPut(param) + ' | descrizione? \n';
        }

        const inAndOutOfState = Utilities.getProcedureContent(split.comments);

        newDefinition += '\n### Nessuno Stato\nStep di esecuzione che vengono eseguiti indipendentemente dallo stato della procedura\n';

        for (let i = 0; i < inAndOutOfState.outOfStateContent.length; i++) {
            newDefinition += StoredProcedureParser.getFormattedProcedureStep(inAndOutOfState.outOfStateContent[i]);
        }

        for (let i = 0; i < inAndOutOfState.inStateContent.length; i++) {
            newDefinition += StoredProcedureParser.getFormattedProcedureStep(inAndOutOfState.inStateContent[i]);
        }


        return newDefinition;
    }

    public static getFormattedProcedureStep(procedureStep: string): string {

        let formattedString = '';

        if (procedureStep.includes('@ENDSTATE')) {
            return '\n';
        }


        if (procedureStep.includes('@STEP'))
            formattedString = this.writeStep(procedureStep);


        if (procedureStep.includes('@ENDWHILE')) {
            this.index.pop();
            this.indexArrDepth--;
            return '';
        }


        if (procedureStep.includes('@WHILE')) {
            this.index[this.indexArrDepth]++;
            this.indexArrDepth++;
            const format = this.index.join('.');
            this.index.push(0);
            return this.getTabs() + format + ' WHILE ' + (procedureStep.substring(procedureStep.indexOf(' '))).trim() + '\n';
        }



        if (procedureStep.includes('@ENDIF')) {
            this.index.pop();
            this.indexArrDepth--;
            return '';
        }

        if (procedureStep.includes('@IF')) {
            this.index[this.indexArrDepth]++;
            this.indexArrDepth++;
            const format = this.index.join('.');
            this.index.push(0);
            return this.getTabs() + format + ' IF ' + (procedureStep.substring(procedureStep.indexOf(' '))).trim() + '\n';
        }



        if (procedureStep.includes('@ENDSECTION')) {
            this.index.pop();
            this.indexArrDepth--;
            return '</details>\n\n';
        }

        if (procedureStep.includes('@SECTION')) {
            this.index[this.indexArrDepth]++;
            this.index.push(0);
            this.indexArrDepth++;
            return '<details>\n' + this.getTabs() + '<summary>' + (procedureStep.substring(procedureStep.indexOf(' '))).trim() + '</summary>\n\n';
        }



        if (procedureStep.includes('@STATE')) {
            this.index = [0];
            this.indexArrDepth = 0;
            const number = procedureStep.substring(7, procedureStep.indexOf(' ', 8));
            const description = procedureStep.substring(procedureStep.indexOf(number) + number.length);
            return '\n### Stato ' + number + '\n' + description + '\n\n';
        }



        return formattedString;
    }

    public static writeStep(step: string): string {

        this.index[this.indexArrDepth]++;
        const format = this.index.join('.');


        return this.getTabs() +'\t' + format + '. ' + (step.substring(step.indexOf(' '))).trim() + '\n';
    }

    public static getTabs(): string {
        let tabs = '';
        for (const i of this.index) {
            tabs += '\t';
        }
        return tabs;
    }


}