import { ExecutionContext, CallHandler } from '@nestjs/common';
import { of } from 'rxjs';
import { AuditLogInterceptor } from './audit-log.interceptor';
import { AuditService } from '../audit.service';

describe('AuditLogInterceptor', () => {
  let interceptor: AuditLogInterceptor;
  let auditService: AuditService;

  const mockAuditService = {
    logAction: jest.fn().mockResolvedValue({ id: 'audit-1' }),
  };

  beforeEach(() => {
    auditService = mockAuditService as any;
    interceptor = new AuditLogInterceptor(auditService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(interceptor).toBeDefined();
  });

  it('should intercept POST request and log action automatically', (done) => {
    const mockRequest = {
      method: 'POST',
      url: '/api/v1/sessions/start',
      user: { id: 'user-123' },
      body: { section_id: 'sec-1' },
      ip: '127.0.0.1',
      headers: {},
      connection: { remoteAddress: '127.0.0.1' },
    };

    const mockContext = {
      switchToHttp: () => ({
        getRequest: () => mockRequest,
      }),
    } as ExecutionContext;

    const mockHandler: CallHandler = {
      handle: () => of({ success: true }),
    };

    interceptor.intercept(mockContext, mockHandler).subscribe({
      next: () => {
        expect(mockAuditService.logAction).toHaveBeenCalledWith({
          userId: 'user-123',
          action: 'POST /api/v1/sessions/start',
          entityType: 'SESSIONS',
          payload: { section_id: 'sec-1' },
          ipAddress: '127.0.0.1',
        });
        done();
      },
    });
  });

  it('should skip logging GET requests', (done) => {
    const mockRequest = {
      method: 'GET',
      url: '/api/v1/sessions/active',
      user: { id: 'user-123' },
      body: {},
      ip: '127.0.0.1',
      headers: {},
      connection: { remoteAddress: '127.0.0.1' },
    };

    const mockContext = {
      switchToHttp: () => ({
        getRequest: () => mockRequest,
      }),
    } as ExecutionContext;

    const mockHandler: CallHandler = {
      handle: () => of({ data: [] }),
    };

    interceptor.intercept(mockContext, mockHandler).subscribe({
      next: () => {
        expect(mockAuditService.logAction).not.toHaveBeenCalled();
        done();
      },
    });
  });
});
