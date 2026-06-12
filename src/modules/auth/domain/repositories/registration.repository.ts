import { UUID } from "src/shared/domain/value-objects/uuid.vo";
import Registration from "../aggregates/registration.aggregate";

export default interface RegistrationRepository {
    save(registration: Registration): Promise<UUID>
}