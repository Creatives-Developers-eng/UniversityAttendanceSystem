import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';

export interface ResponseFormat<T> {
  statusCode: number;
  message?: string;
  data: T;
}

@Injectable()
export class TransformInterceptor<T>
  implements NestInterceptor<T, ResponseFormat<T>>
{
  intercept(
    context: ExecutionContext,
    next: CallHandler,
  ): Observable<ResponseFormat<T>> {
    const statusCode = context.switchToHttp().getResponse().statusCode;
    return next.handle().pipe(
      map((data) => {
        // If data is already in expected format, return as is
        if (data && typeof data === 'object' && 'statusCode' in data && 'data' in data) {
          return data;
        }
        return {
          statusCode,
          message: 'Operation completed successfully',
          data: data !== undefined ? data : null,
        };
      }),
    );
  }
}
