import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import { RegistrateSystemSubscriptionCommand } from './registrate-system_subscription.command';

@CommandHandler(RegistrateSystemSubscriptionCommand)
export default class RegistrateSystemSubscriptionHandler implements ICommandHandler<RegistrateSystemSubscriptionCommand> {
    constructor() {}

    async execute(command: RegistrateSystemSubscriptionCommand) {
        // Implement the logic to registrate system subscription here
    }
}