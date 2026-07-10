import { UUID } from "crypto";
import { SourceType } from "src/models/schema";

type SourceTypeVerificationMethodType = {
    id?: UUID;
    sourceType: SourceType | string;
    name: string;
    description?: string | null;
    isActive?: boolean;
    createdAt?: Date;
    annulledAt?: Date;
    deletedAt?: Date;
};

export default class SourceTypeVerificationMethod {
    readonly id: SourceTypeVerificationMethodType["id"];
    readonly sourceType: SourceTypeVerificationMethodType["sourceType"];
    readonly name: SourceTypeVerificationMethodType["name"];
    readonly description: SourceTypeVerificationMethodType["description"];
    readonly isActive: SourceTypeVerificationMethodType["isActive"];
    readonly createdAt: SourceTypeVerificationMethodType["createdAt"];
    readonly annulledAt: SourceTypeVerificationMethodType["annulledAt"];
    readonly deletedAt: SourceTypeVerificationMethodType["deletedAt"];

    constructor(props: SourceTypeVerificationMethodType/* { [key in (keyof Registration)]: Registration[keyof Registration] } */) {
        Object.assign(this, props);
    }
}