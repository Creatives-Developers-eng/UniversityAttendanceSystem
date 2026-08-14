import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(HttpExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;

    const exceptionResponse: any =
      exception instanceof HttpException
        ? exception.getResponse()
        : { message: 'Internal server error' };

    const message =
      typeof exceptionResponse === 'object' && exceptionResponse.message
        ? exceptionResponse.message
        : exceptionResponse;

    const errorResponse = {
      statusCode: status,
      message: message,
      error:
        typeof exceptionResponse === 'object' && exceptionResponse.error
          ? exceptionResponse.error
          : status === HttpStatus.INTERNAL_SERVER_ERROR
          ? 'Internal Server Error'
          : undefined,
      timestamp: new Date().toISOString(),
      path: request.url,
    };

    this.logger.error(
      `HTTP ${status} Error on ${request.method} ${request.url}: ${JSON.stringify(
        message,
      )}`,
      exception instanceof Error ? exception.stack : undefined,
    );

    response.status(status).json(errorResponse);
  }
}
