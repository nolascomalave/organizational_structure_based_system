import { Module } from "@nestjs/common";
import { CqrsModule } from "@nestjs/cqrs";
import { AuthController } from "./interface/http/controllers/auth.controller";
import StartRegistrationHandler from "./application/commands/start-registration/handler";
import { RegistrationRepository } from "./infrastructure/repositories";
import { RegistrationSourceRepository } from "./infrastructure/repositories";
import { REGISTRATION_REPOSITORY } from "./domain/repositories/registration.repository";
import { REGISTRATION_SOURCE_REPOSITORY } from "./domain/repositories/registration-source.repository";

@Module({
    controllers: [
        AuthController
    ],
    providers: [
        StartRegistrationHandler,
        {
            provide: REGISTRATION_REPOSITORY, // token que se inyecta en el handler
            useClass: RegistrationRepository, // implementación concreta
        },
        {
            provide: REGISTRATION_SOURCE_REPOSITORY, // token que se inyecta en el handler
            useClass: RegistrationSourceRepository, // implementación concreta
        },
    ],
    imports: [CqrsModule],
})
export class AuthModule {}