import { BadRequestException, Body, Controller, HttpCode, HttpStatus, Post, UsePipes, ValidationPipe } from '@nestjs/common';
import { formatValidationErrors } from 'src/shared/infrastructure/http/controllers/exceptionFactory';
import { StartRegistrationDto } from './dto/start-registration.dto';
import { AuthService } from './auth.service';

@Controller("/auth")
export class AuthController {
    constructor(
        private service: AuthService
    ) {}

    @Post("/registrate-system_subscription")
    @HttpCode(HttpStatus.CREATED)
    @UsePipes(new ValidationPipe({
        exceptionFactory: (errors) => (new BadRequestException(formatValidationErrors(errors))),
        transform: true
    }))
    async startRegistration(@Body() commandData: StartRegistrationDto) {
        const data = {data: await this.service.startRegistration(commandData)};
        return data;
    }
}
