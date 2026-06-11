import { isIPv6, isIPv4 } from "net";

export class IpAddress {
    private readonly version: 4 | 6;

    constructor(public readonly value: string) {
        if(isIPv6(value)) {
            this.version = 6;
        } else if(isIPv4(value)) {
            this.version = 4;
        }

        if(!this.version) {
            throw new Error(`Invalid IP value: ${value}`);
        }
    }

    public static parse(value: IpAddress | string): IpAddress {
        return ((value instanceof IpAddress) ? value : (new IpAddress(value)));
    }

    public toString(): string {
        return this.value;
    }

    get getVersion(): string {
        return ("v" + this.version);
    }

    get getNumberVersion(): number {
        return this.version;
    }
}