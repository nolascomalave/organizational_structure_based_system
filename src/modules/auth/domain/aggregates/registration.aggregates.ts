import { UUID } from "src/shared/domain/value-objects/uuid.vo";
import { IpAddress } from "../value-objects/ip_address.vo";

class Registration {
    public readonly id: UUID;
    public readonly registrationSourceId: UUID;
    public readonly ipAddress: IpAddress;
    public readonly confirmRegistrationAt: Date | null;
    public readonly createdAt: Date;
    public readonly expiredAt: Date;
    public readonly deletedAt: Date | null;

    constructor(params: {
        id: UUID;
        registrationSourceId: UUID;
        ipAddress: IpAddress;
        // confirmRegistrationAt: Date | null;
        // createdAt: Date;
        // expiredAt: Date;
        // deletedAt: Date | null;
    }) {
        Object.assign(this, params);
    }
}