export class UUID {
    constructor(public readonly value: string) {
        if (!/^[0-9a-f]{8}(-[0-9a-f]{4}){2}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i.test(value)) {
            // throw new InvalidValueError('UUID', value);
            throw new Error(`Invalid UUID value: ${value}`);
        }
    }

    public static parse(value: UUID | string): UUID {
        return ((value instanceof UUID) ? value : (new UUID(value)));
    }

    public toString(): string {
        return this.value;
    }
}