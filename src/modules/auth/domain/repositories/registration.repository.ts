import { UUID } from "src/shared/domain/value-objects/uuid.vo";
import Registration from "../aggregates/registration.aggregate";

export const REGISTRATION_REPOSITORY = Symbol("REGISTRATION_REPOSITORY");

export default interface RegistrationRepository {
    save(registration: Registration): Promise<UUID>
}