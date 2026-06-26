import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import StartRegistrationCommand from './command';
import { Inject } from '@nestjs/common';
import type RegistrationRepository from '../../../domain/repositories/registration.repository';
import type RegistrationSourceRepository from '../../../domain/repositories/registration-source.repository';
import type TransactionManagerRepository from '../../../../../shared/application/repositories/transaction-manager.repository';
import { REGISTRATION_REPOSITORY } from '../../../domain/repositories/registration.repository';
import { REGISTRATION_SOURCE_REPOSITORY } from '../../../domain/repositories/registration-source.repository';
import { TRANSACTION_MANAGER_REPOSITORY } from '../../../../../shared/application/repositories/transaction-manager.repository';
import DatabaseException from '../../../../../shared/infrastructure/exceptions/database.exception';
import InfrastructureException from '../../../../../shared/infrastructure/exceptions/infrastructure.exception';
import { UUID } from '../../../../../shared/domain/value-objects/uuid.vo';

@CommandHandler(StartRegistrationCommand)
export default class StartRegistrationHandler implements ICommandHandler<StartRegistrationCommand> {
    constructor(
        @Inject(REGISTRATION_REPOSITORY)
        private readonly registrationRepository: RegistrationRepository,
        @Inject(TRANSACTION_MANAGER_REPOSITORY)
        private readonly transactionManagerRepository: TransactionManagerRepository,
    ) {}

    async execute(command: StartRegistrationCommand): Promise<string> {
        try {
            return (await this.transactionManagerRepository.execute(async (tx) => {
                return ((await this.registrationRepository.save({
                    source_type: command.source_type,
                    source: command.source,
                    ipAddress: command.ip_address
                })).id as UUID).toString();
            }));
        } catch(error) {
            if(error instanceof DatabaseException) {
                throw new InfrastructureException("Error saving the registration.");
            }

            throw error;
        }
    }
}