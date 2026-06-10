import { ValidationError } from "class-validator";

/**
 * Formatea los errores de validación de `ValidationError` (`class-validator`) que provienen del `ValidationPipe` class.
 * Extrae el primer mensaje de error de cada propiedad y los devuelve en un array de strings.
 * Esta función se usa como formatter en la propiedad `exceptionFactory` del `ValidationPipe` para personalizar la respuesta de error cuando la validación falla en los controladores de NestJS.
 *
 * @param errors - El arreglo de errores `ValidationError` de `class-validator`.
 * @returns `messages` (string[]) - Un array de mensajes de error formateados solo tomando en cuenta el primer mensaje de cada propiedad validada.
 *
 * @example
 * @UsePipes(new ValidationPipe({
 *    exceptionFactory: (errors) => (new BadRequestException(formatValidationErrors(errors))),
 *    transform: true
 * }))
 */
export function formatValidationErrors(errors: ValidationError[]): string[] {
    const messages: string[] = [];

    for(const i in errors) {
        const constraints = errors[i].constraints;
        for(const eKey in constraints) {
            messages.push(constraints[eKey as keyof typeof constraints]);
            break;
        }
    }

    return messages;
}