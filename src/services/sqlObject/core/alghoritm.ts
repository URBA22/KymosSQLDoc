
enum StepType {
    STEP,
    TAB,
    SECTION,
    STATE
}

export class Step {
    public index: number;
    public description: string;
    public type: StepType;
    public steps?: Step[];
    public state?: number;
    public result?: number;

    constructor(index: number, description: string, type: StepType) {
        this.index = index;
        this.description = description;
        this.type = type;
    }
}