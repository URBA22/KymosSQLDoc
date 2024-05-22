
enum StepType {
    STEP = '@step',
    SECTION = '@section',
    ENDSECTION = '@endsection',
    STATE = '@state',
    ENDSTATE = '@endstate',
    RES = '@res',
    CONDITION = '@condition',
    ENDCONDITION = '@endcondition',
    LOOP = '@loop',
    ENDLOOP = '@endloop'
}

export class Step {
    public index?: number;
    public description?: string;
    public type?: StepType;
    public steps?: Step[];
    public state?: number;
    public res?: number;


    public static async stepFromComments(comments: string, charIndex = 0, stepIndex = 0) {
        const steps: Step[] = [];
        let closerStep = false;
        //continua fino a fine commenti o closerStep
        while((charIndex = comments.indexOf('@', charIndex +1)) > 0 && !closerStep){
            // riga commento
            const line = comments.substring(charIndex, comments.indexOf('\n', charIndex));

            // create object {step, newCharIndex, newStepIndex}
            // {step, charIndex, stepIndex + 1}             returned normal step
            // {undefined, charIndex, stepIndex}            returned undefined step
            // {undefined, charIndex, -1}                   returned closer step
            const res = Step.createStep(line,comments, charIndex, stepIndex);
            const step = (await res).step;
            charIndex = (await res).charIndex;
            // stepIndex = -1 closerStep
            closerStep = ((await res).stepIndex == -1); //iscloserStep: take precStep + 1;
            stepIndex = (closerStep)  ? stepIndex : (await res).stepIndex + 1;
            (step != undefined) ? steps.push(step) : 0; // step is undefined doing nothing
        }
        return{
            steps,
            charIndex,
            stepIndex
        };
    }

    private static async createStep(comment: string, comments: string, charIndex:number , stepIndex:number ){
        // create step
        const step: Step = {
            index: stepIndex,
            description: await Step.getDescription(comment),
            type: (await Step.getType(comment))?.type,
            state: await Step.getValue(comment, StepType.STATE),
            res: await Step.getValue(comment, StepType.RES)
        };
        // invalid step
        if(step.type == undefined)
            return{
                undefined,
                charIndex,
                stepIndex
            };

        // closer step
        if(await Step.isEndPoint(step.type))
            return{
                step,
                charIndex,
                stepIndex: -1
            };

        // se stepMaster, step successivi saranno contenuti in esso
        if(await Step.isMaster(step.type)){
            const res = Step.stepFromComments(comments, charIndex, stepIndex + 1);
            step.steps = (await res).steps;
            charIndex = (await res).charIndex;
            stepIndex = (await res).stepIndex;
        }
        
        // normal/master step
        return{
            step,
            charIndex,
            stepIndex: stepIndex + 1
        };

    }
    

    private static async getValue(comment: string, type: StepType | undefined){
        if(type == undefined) return;
        let indexType = comment.indexOf(type);
        if(indexType < 0) return;
        return Number(
            comment.substring(
                (indexType = comment.indexOf(' ', indexType)), 
                comment.indexOf(' ', indexType + 1)
            ).trim()
        );
    }

    private static async getDescription(comment: string){
        return comment.replace('--', '').replace(/(@\w{1,100}\W\d{1,3})|(@\w{1,100})/g, '').trim();
    }

    private static async isMaster(type: StepType){
        return(type != StepType.STEP);
    }

    private static async isEndPoint(type: StepType){
        return(
            type == StepType.ENDSECTION ||
            type == StepType.ENDSTATE ||
            type == StepType.ENDCONDITION ||
            type == StepType.ENDLOOP
        );
    }

    private static async getType(comment: string){
        if(comment.indexOf(StepType.STEP) > -1) return { type: StepType.STEP, valid: true};
        if(comment.indexOf(StepType.SECTION) > -1) return { type: StepType.SECTION, valid: true};
        if(comment.indexOf(StepType.ENDSECTION) > -1) return { type: StepType.ENDSECTION, valid: true};
        if(comment.indexOf(StepType.STATE) > -1) return { type: StepType.STATE, valid: true};
        if(comment.indexOf(StepType.ENDSTATE) > -1) return { type: StepType.ENDSTATE, valid: true};
        if(comment.indexOf(StepType.RES) > -1) return { type: StepType.RES, valid: true};
        if(comment.indexOf(StepType.CONDITION) > -1) return { type: StepType.CONDITION, valid: true};
        if(comment.indexOf(StepType.ENDCONDITION) > -1) return { type: StepType.ENDCONDITION, valid: true};
        if(comment.indexOf(StepType.LOOP) > -1) return { type: StepType.LOOP, valid: true};
        if(comment.indexOf(StepType.ENDLOOP) > -1) return { type: StepType.ENDLOOP, valid: true};
        return {type: undefined, valid: false};
    }

}

// 0    -- Return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla
// 1    -- Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question
