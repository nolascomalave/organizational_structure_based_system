import { UUID } from "crypto";
import Registration from "./registration.aggregate";
import SourceTypeVerificationMethod from "../entities/sourceTypeVerificationMethodId.entity";

type RegistrationSourceVerificationType = {
    id?: UUID;
    registration: Registration;
    sourceTypeVerificationMethodId: SourceTypeVerificationMethod;
    code: string;
    createdAt?: Date;
    usedAt?: Date;
    expiredAt?: Date;
    deletedAt?: Date;
};

export default class RegistrationSourceVerification {
    readonly id: RegistrationSourceVerificationType["id"];
    readonly registration: RegistrationSourceVerificationType["registration"];
    readonly sourceTypeVerificationMethodId: RegistrationSourceVerificationType["sourceTypeVerificationMethodId"];
    readonly code: RegistrationSourceVerificationType["code"];
    readonly createdAt: RegistrationSourceVerificationType["createdAt"];
    readonly usedAt: RegistrationSourceVerificationType["usedAt"];
    readonly expiredAt: RegistrationSourceVerificationType["expiredAt"];
    readonly deletedAt: RegistrationSourceVerificationType["deletedAt"];

    constructor(props: RegistrationSourceVerificationType/* { [key in (keyof Registration)]: Registration[keyof Registration] } */) {
        Object.assign(this, props);
    }
}