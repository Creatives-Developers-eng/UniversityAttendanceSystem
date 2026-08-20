import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { AuditService } from '../audit.service';

@Injectable()
export class AuditLogInterceptor implements NestInterceptor {
  constructor(private readonly auditService: AuditService) {}

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const { method, url, user, body, ip, headers } = request;

    // Only log state-changing HTTP methods
    const isStateModifying = ['POST', 'PUT', 'PATCH', 'DELETE'].includes(method);

    // Skip auth/login from body dumping to preserve privacy
    const isAuthRoute = url.includes('/auth/login') || url.includes('/auth/refresh');

    const clientIp =
      headers['x-forwarded-for'] || request.connection?.remoteAddress || ip;

    return next.handle().pipe(
      tap(async (responseBody) => {
        if (isStateModifying && !isAuthRoute) {
          const action = `${method} ${url}`;
          const entityType = this.extractEntityType(url);
          const userId = user?.id || user?.sub;

          await this.auditService.logAction({
            userId,
            action,
            entityType,
            payload: body,
            ipAddress: String(clientIp),
          });
        }
      }),
    );
  }

  private extractEntityType(url: string): string {
    const parts = url.split('/').filter(Boolean);
    // e.g. /api/v1/sessions/start -> Sessions
    if (parts.length >= 3) {
      return parts[2].toUpperCase();
    }
    return 'SYSTEM';
  }
}
