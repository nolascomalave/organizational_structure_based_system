import { Module } from "@nestjs/common";
import DrizzleRegistrationRepository from "./infrastructure/repositories/drizzle-registration.repository";
import { CqrsModule } from "@nestjs/cqrs";
import { AuthController } from "./interface/http/controllers/auth.controller";
import StartRegistrationHandler from "./application/commands/start-registration/handler";

@Module({
    controllers: [
        AuthController
    ],
    providers: [
        StartRegistrationHandler,
        {
            provide: 'RegistrationRepository', // token que se inyecta en el handler
            useClass: DrizzleRegistrationRepository, // implementación concreta
        },
    ],
    imports: [CqrsModule],
})
export class AuthModule {}