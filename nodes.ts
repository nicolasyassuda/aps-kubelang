export class BaseNode {
    private static id: number = 0;
    public value: any;
    public children: BaseNode[];
    public id: number;

    constructor(value: any, children: BaseNode[]) {
        this.value = value;
        this.children = children;
        this.id = BaseNode.generateId();
    }

    private static generateId(): number {
        return ++BaseNode.id; 
    }

    public Evaluate(symbolTable: any): void {
    }

    public Generate(symbolTable: any): void {
    }
}

