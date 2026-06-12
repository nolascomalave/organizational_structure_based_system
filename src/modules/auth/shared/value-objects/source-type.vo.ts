export default class SourceType {
    constructor(private readonly sourceType: string) {}

    public toString(): string {
        return this.sourceType;
    }

    public static parse(value: SourceType | string): SourceType {
        return ((value instanceof SourceType) ? value : (new SourceType(value)));
    }
}