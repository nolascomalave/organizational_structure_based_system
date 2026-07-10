import { Global, Module } from "@nestjs/common";
import { MailerRepository } from "./repositories";
import { MAILER_REPOSITORY } from "../application/repositories/mailer.repository";
import { ConfigModule } from "@nestjs/config";

@Global()
@Module({
    imports: [ConfigModule.forRoot()],
    providers: [
        {
            provide: MAILER_REPOSITORY, // token que se inyecta en el handler
            useClass: MailerRepository, // implementación concreta
        },
    ],
    exports: [MAILER_REPOSITORY],
})
export class MailerModule {}