import { ArgumentsHost, Catch, ExceptionFilter, HttpException, Logger } from "@nestjs/common";
import { DomainException } from "../domain/exceptions/domain.exception";
import { Request, Response } from "express";

// shared/filters/global-exception.filter.ts
@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  constructor(private readonly logger: Logger) {}

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    let status = 500;
    let code = 'INTERNAL_SERVER_ERROR';
    let message = 'An unexpected error has occurred.';

    if (exception instanceof DomainException) {
      status = exception.status || 400;
      code = exception.code;
      message = exception.message;
    } else if (exception instanceof HttpException) {
      // Excepciones nativas de Nest (para casos no cubiertos)s
      status = exception.getStatus();
      const errorResponse = exception.getResponse();
      message = typeof errorResponse === 'string' ? errorResponse : (errorResponse as any).message || message;
    } else {
      // Errores no esperados (500)
      this.logger.error('An error was not controlled.', exception);
      // En desarrollo devolvemos el stack, en producción solo el genérico
      if (process.env.NODE_ENV !== 'production') {
        message = exception instanceof Error ? exception.message : String(exception);
      }
    }

    response.status(status).json({
      statusCode: status,
      code,
      message,
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}