import { Module } from "@nestjs/common";
import RegistrateSystemSubscriptionHandler from "./application/commands/registrate-system_subscription.handler";
import DrizzleAuthRepository from "./infrastructure/repositories/drizzle-auth.repository";
import { CqrsModule } from "@nestjs/cqrs";
import { AuthController } from "./interface/http/controllers/auth.controller";

@Module({
    controllers: [
        AuthController
    ],
    providers: [
        RegistrateSystemSubscriptionHandler,
        {
            provide: 'AuthRepository',     // token que se inyecta en el handler
            useClass: DrizzleAuthRepository, // implementación concreta
        },
    ],
    imports: [CqrsModule],
})
export class AuthModule {}