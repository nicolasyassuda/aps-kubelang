class Token {
    public type: "string" | "int" | "bool";
    public value: string | number | boolean;
}
class Tokenizer {
    public value: any;
    public pos: number;
    public current_char: Token
}