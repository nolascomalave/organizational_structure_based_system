import { Module } from "@nestjs/common";
import { CqrsModule } from "@nestjs/cqrs";
import { AuthController } from "./interface/http/controllers/auth.controller";
import StartRegistrationHandler from "./application/commands/start-registration/handler";
import { RegistrationRepository } from "./infrastructure/repositories";
import { RegistrationSourceRepository } from "./infrastructure/repositories";
import { TransactionManagerRepository } from "src/shared/infrastructure/repositories/";

@Module({
    controllers: [
        AuthController
    ],
    providers: [
        StartRegistrationHandler,
        {
            provide: 'RegistrationSourceRepository', // token que se inyecta en el handler
            useClass: RegistrationSourceRepository, // implementación concreta
        },
        {
            provide: 'RegistrationRepository', // token que se inyecta en el handler
            useClass: RegistrationRepository, // implementación concreta
        },
        {
            provide: 'TransactionManagerRepository', // token que se inyecta en el handler
            useClass: TransactionManagerRepository, // implementación concreta
        },
    ],
    imports: [CqrsModule],
})
export class AuthModule {}