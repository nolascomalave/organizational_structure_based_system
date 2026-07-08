import { Global, Module } from "@nestjs/common";
import { PhoneNumberRepository } from "./repositories";
import { PHONE_NUMBER_REPOSITORY } from "../application/repositories/phone-number.repository";

@Global()
@Module({
    providers: [
        {
            provide: PHONE_NUMBER_REPOSITORY, // token que se inyecta en el handler
            useClass: PhoneNumberRepository, // implementación concreta
        },
    ],
    exports: [PHONE_NUMBER_REPOSITORY],
})
export class PhoneNumberModule {}