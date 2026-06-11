import { BadRequestException, Body, Controller, HttpCode, HttpStatus, Ip, Post, UsePipes, ValidationPipe } from '@nestjs/common';
import { formatValidationErrors } from 'src/shared/infrastructure/http/controllers/exceptionFactory';
import { StartRegistrationDto } from '../../../shared/dto/start-registration.dto';
import StartRegistrationCommand from 'src/modules/auth/application/commands/start-registration/command';
import { CommandBus } from '@nestjs/cqrs';
// import { AuthService } from '../../../auth.service._eliminar';

@Controller("/auth")
export class AuthController {
    constructor(
        // private service: AuthService,
        private readonly commandBus: CommandBus
    ) {}

    @Post("/registrate-system_subscription")
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
}
