
export class Parameter {
    public name: string;
    public type: string;
    public nullable = false;
    public output = false;
    public default?: string;
    public description?: string;

    constructor(name: string, type: string) {
        this.name = name;
        this.type = type;
    }

    /**
     * 
     * @param definition of SqlObject.definition
     * @returns array of parameters
     */
    public static async fromDefinition(definition: string) {
        //get block of header param
        let definitionHeader = definition.substring(definition.search(/\[[\w]{0,100}\][.]\[[\w]{0,100}\]/), definition.toUpperCase().search('AS BEGIN')).replace(/\[[\w]{0,100}\][.]\[[\w]{0,100}\]/, '').trim();
        if(definitionHeader[0] == '(') definitionHeader = definitionHeader.substring(1, definitionHeader.length - 1).trim();
        if(definitionHeader == '') return;
        definitionHeader += ', @';

        const parameters: Parameter[] = [];
        let start = -1;
        //cycle param of header
        while ((start = definitionHeader.indexOf('@', start + 1)) > -1 && start < definitionHeader.length - 2) {
            const endLine = definitionHeader.indexOf(', @', start);
            const paramStr = definitionHeader.substring(start, endLine).trim();
            const parameter:Parameter = await Parameter?.getParameter(paramStr);
            parameters.push(parameter);
        }

        return parameters;
    }

    private static async getParameter(parameterStr: string) {
        const parameter: Parameter = {
            name: await Parameter.getName(parameterStr),
            type: await Parameter.getType(parameterStr.toUpperCase()),
            nullable: (parameterStr.toUpperCase().indexOf(' NULL') > 0 && parameterStr.toUpperCase().indexOf('NOT NULL') < 0),
            output: (parameterStr.toUpperCase().indexOf(' OUT') > 0 || parameterStr.toUpperCase().indexOf(' OUTPUT') > 0),
            default: await Parameter?.getDefault(parameterStr)
        };
        return parameter;

    }

    private static async getName(parameterStr: string) {
        const start = parameterStr.indexOf('@');// _IdArticolo NVARCHAR(50) = NULL OUT
        const end = parameterStr.indexOf(' ', start);// @IdArticolo_NVARCHAR(50) = NULL OUT
        if (start < 0 || start > end) return '';//Something went wrong
        return parameterStr.substring(start + 1, end);// @|IdArticolo| NVARCHAR(50) = NULL OUT,
    }

    private static async getType(parameterStr: string) {
        const start = parameterStr.indexOf(' '); // @IdArticolo_NVARCHAR(50) = NULL OUT
        const end = parameterStr.indexOf('='); // @IdArticolo NVARCHAR(50, 18)_= NULL OUT
        if (start < 0) return ''; //Something went wrong
        if(end > 0) return parameterStr.substring(start, end - 1).replace('NOT NULL', '').replace('NULL', '').replace('OUTPUT', '').replace('OUT', '').trim();
        return parameterStr.substring(start).replace('NOT NULL', '').replace('NULL', '').replace('OUTPUT', '').replace('OUT', '').trim();
    }

    private static async getDefault(parameterStr: string) {
        const start = parameterStr.indexOf('='); 
        if (start < 0) return; //there isn't equal, so no default;
        const toTrimDefault = parameterStr.toUpperCase().substring(start + 1).replace(' OUTPUT', '').replace(' OUT', '').replace(' NULL', '').replace(',', '').trim();
        if(toTrimDefault == '') return;
        return toTrimDefault;
    }

}