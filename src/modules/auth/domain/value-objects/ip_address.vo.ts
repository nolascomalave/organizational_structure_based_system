import { isIPv6, isIP, isIPv4 } from "net";

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

    toString(): string {
        return this.value;
    }

    get getVersion(): string {
        return ("v" + this.version);
    }

    get getNumberVersion(): number {
        return this.version;
    }
}