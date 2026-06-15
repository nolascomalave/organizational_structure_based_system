import { CommandHandler, ICommandHandler } from '@nestjs/cqrs';
import StartRegistrationCommand from './command';
import { Inject } from '@nestjs/common';
import type RegistrationRepository from 'src/modules/auth/domain/repositories/registration.repository';
import type RegistrationSourceRepository from 'src/modules/auth/domain/repositories/registration-source.repository';
import { DrizzleService } from 'src/lib/drizzle.service';
import { PgTransaction } from 'drizzle-orm/pg-core';
import { PostgresJsQueryResultHKT } from 'drizzle-orm/postgres-js';
import { ExtractTablesWithRelations } from 'drizzle-orm';
import type TransactionManagerRepository from 'src/shared/domain/repositories/transaction-manager.repository';

@CommandHandler(StartRegistrationCommand)
export default class StartRegistrationHandler implements ICommandHandler<StartRegistrationCommand> {
    constructor(
        @Inject('RegistrationRepository')
        private readonly registrationRepository: RegistrationRepository,
        @Inject('RegistrationSourceRepository')
        private readonly registrationSourceRepository: RegistrationSourceRepository,
        @Inject('TransactionManagerRepository')
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