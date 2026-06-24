import { BadRequestException, Body, Controller, HttpCode, HttpStatus, Ip, Post, UsePipes, ValidationPipe } from '@nestjs/common';
import { formatValidationErrors } from 'src/shared/interface/http/controllers/exceptionFactory';
import { StartRegistrationDto } from '../../../shared/dto/start-registration.dto';
import StartRegistrationCommand from 'src/modules/auth/application/commands/start-registration/command';
import { CommandBus } from '@nestjs/cqrs';
import SendVerificationSourceCodeDto from 'src/modules/auth/shared/dto/send-verification-source-code.dto';

@Controller("/auth")
export class AuthController {
    constructor(
        // private service: AuthService,
        private readonly commandBus: CommandBus
    ) {}

    @Post("/start-registration")
    @HttpCode(HttpStatus.CREATED)
    @UsePipes(new ValidationPipe({
        exceptionFactory: (errors) => (new BadRequestException(formatValidationErrors(errors))),
        transform: true
    }))
    async startRegistration(@Body() props: StartRegistrationDto, @Ip() ip_address: string) {
        // const data = {data: await this.service.startRegistration(props)};
        return {
            data: await this.commandBus.execute(new StartRegistrationCommand({
                ...props,
                ip_address: ip_address
            }))
        };
    }

    @Post("/send-verification-source-code")
    @HttpCode(HttpStatus.CREATED)
    async sendVerificationSourceCode(@Body() props: SendVerificationSourceCodeDto) {
    }

    /* @Post("/create-system_subscription")
    @HttpCode(HttpStatus.CREATED)
    async createSystemSubscription() {

    } */
}
