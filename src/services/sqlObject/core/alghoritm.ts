
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

// 0    -- Return -1: Normal; return -2: Refresh data; return -3: Chiude la maschera; -4: Non fa nulla
// 1    -- Tipo Messaggio: INF Informativo, ALR Allert, WRN Warning, QST Question
