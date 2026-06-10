import { RegistrateSystemSubscriptionDto } from "../../shared/dto/registrate-system_subscription.dto";

export class RegistrateSystemSubscriptionCommand {
    constructor(params: RegistrateSystemSubscriptionDto) {
        Object.assign(this, params);
    }
}