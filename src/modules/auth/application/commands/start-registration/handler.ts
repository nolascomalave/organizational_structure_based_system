import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import StartRegistrationCommand from './command';
import { Inject } from '@nestjs/common';
import type RegistrationRepository from 'src/modules/auth/domain/repositories/registration.repository';
import type RegistrationSourceRepository from 'src/modules/auth/domain/repositories/registration-source.repository';
import type TransactionManagerRepository from 'src/shared/application/repositories/transaction-manager.repository';
import { REGISTRATION_REPOSITORY } from 'src/modules/auth/domain/repositories/registration.repository';
import { REGISTRATION_SOURCE_REPOSITORY } from 'src/modules/auth/domain/repositories/registration-source.repository';
import { TRANSACTION_MANAGER_REPOSITORY } from 'src/shared/application/repositories/transaction-manager.repository';

@CommandHandler(StartRegistrationCommand)
export default class StartRegistrationHandler implements ICommandHandler<StartRegistrationCommand> {
    constructor(
        @Inject(REGISTRATION_REPOSITORY)
        private readonly registrationRepository: RegistrationRepository,
        @Inject(REGISTRATION_SOURCE_REPOSITORY)
        private readonly registrationSourceRepository: RegistrationSourceRepository,
        @Inject(TRANSACTION_MANAGER_REPOSITORY)
        private readonly transactionManagerRepository: TransactionManagerRepository,
    ) {}

    async execute(command: StartRegistrationCommand) {
        return await this.transactionManagerRepository.execute(async (tx) => {
            const registrationSource = await this.registrationSourceRepository.save({
                sourceType: command.source_type,
                source: command.source
            }, tx);

            return registrationSource.id;
        });
    }
}