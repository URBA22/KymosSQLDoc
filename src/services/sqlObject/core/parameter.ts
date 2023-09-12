
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

    // 230912 - Marco add function fromDefinition() getParameter() getName() getType()
    public static async fromDefinition(definition: string) {
        const regexDefinitionHeader = /\[[\w]{0,}\][.]\[[\w]{0,}\]/; // [*something*].[*something*]
        let start = definition.toUpperCase().search(regexDefinitionHeader);
        const end = definition.toUpperCase().indexOf('BEGIN');
        if (end >= start) return; //something went wrong
        const parameters: Parameter[] = [];

        //cycle param
        while ((start = definition.indexOf('@', start)) < end) {
            const endLine = definition.indexOf('\n', start);
            const paramStr = definition.substring(start, endLine);
            const parameter = await Parameter.getParameter(paramStr);
            parameters.push(parameter as Parameter);
        }
        return parameters;
    }

    private static async getParameter(parameterStr: string) {
        const parameter: Parameter = {
            name: await Parameter.getName(parameterStr),
            type: await Parameter.getType(parameterStr),
            nullable: parameterStr.indexOf(' NULL ') > 0,
            output: parameterStr.indexOf(' OUT') > 0
        };
        return parameter;
    }

    private static async getName(parameterStr: string) {
        const start = parameterStr.indexOf('@');// _IdArticolo NVARCHAR(50) = NULL OUT,
        const end = parameterStr.indexOf(' ', start);// @IdArticolo_NVARCHAR(50) = NULL OUT,
        if (start < -1 || start > end) return ''; //Something went wrong
        return parameterStr.substring(start + 1, end);// @|IdArticolo| NVARCHAR(50) = NULL OUT,
    }

    private static async getType(parameterStr: string) {
        const start = parameterStr.indexOf(' ', parameterStr.indexOf('@')); // @IdArticolo_NVARCHAR(50) = NULL OUT,
        const end = parameterStr.indexOf(' ', start); // @IdArticolo NVARCHAR(50)_= NULL OUT,
        if (start < -1 || start > end) return ''; //Something went wrong
        return parameterStr.substring(start + 1, end);// @IdArticolo |NVARCHAR(50)| = NULL OUT,
    }

}