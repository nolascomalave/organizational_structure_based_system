import { Global, Module } from "@nestjs/common";
import { TRANSACTION_MANAGER_REPOSITORY } from "src/shared/application/repositories/transaction-manager.repository";
import { TransactionManagerRepository } from "./repositories";

@Global()
@Module({
    providers: [
        {
            provide: TRANSACTION_MANAGER_REPOSITORY, // token que se inyecta en el handler
            useClass: TransactionManagerRepository, // implementación concreta
        },
    ],
    exports: [TRANSACTION_MANAGER_REPOSITORY],
})
export class TransactionManagerModule {}