import { UUID } from "src/shared/domain/value-objects/uuid.vo";
import Registration from "../../../domain/aggregates/registration.aggregate";
import RegistrationRepository from "../../../domain/repositories/registration.repository";
import type RegistrationSourceRepository from "../../../domain/repositories/registration-source.repository";
import { DrizzleService } from "src/lib/drizzle.service";
import { Inject, Injectable } from "@nestjs/common";
import { REGISTRATION_SOURCE_REPOSITORY } from "../../../domain/repositories/registration-source.repository";

@Injectable()
export class DrizzleRegistrationRepository implements RegistrationRepository {
    constructor(
        @Inject(REGISTRATION_SOURCE_REPOSITORY)
        private readonly registrationSourceRepository: RegistrationSourceRepository,
        private readonly drizzleDB: DrizzleService
    ) {}

    public async save(registration: Registration): Promise<UUID> {
        return new UUID("")/* await this.registrationSourceRepository.save({
            sourceType: "",
            source: ""
        }); */
    }
}