import { BadRequestException, Body, Controller, HttpCode, HttpStatus, Post, UsePipes, ValidationPipe } from '@nestjs/common';
import { CommandBus } from '@nestjs/cqrs';
import { RegistrateSystemSubscriptionCommand } from 'src/modules/auth/application/commands/registrate-system_subscription.command';
import { RegistrateSystemSubscriptionDto } from 'src/modules/auth/shared/dto/registrate-system_subscription.dto';
import { formatValidationErrors } from 'src/shared/infrastructure/http/controllers/exceptionFactory';

@Controller("/auth")
export class AuthController {
    constructor(
        private readonly commandBus: CommandBus
    ) {}

    @Post("/registrate-system_subscription")
    @HttpCode(HttpStatus.CREATED)
    @UsePipes(new ValidationPipe({
        exceptionFactory: (errors) => (new BadRequestException(formatValidationErrors(errors))),
        transform: true
    }))
    async registrateSystemSubscription(@Body() commandData: RegistrateSystemSubscriptionDto) {
        // Aquí puedes construir el comando con los datos necesarios
        await this.commandBus.execute(new RegistrateSystemSubscriptionCommand(commandData));
        return { message: "System subscription registered successfully" };
    }
}
