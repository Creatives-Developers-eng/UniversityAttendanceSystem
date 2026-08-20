import { Test, TestingModule } from '@nestjs/testing';
import { AuditController } from './audit.controller';
import { AuditService } from './audit.service';

describe('AuditController', () => {
  let controller: AuditController;
  let service: AuditService;

  const mockAuditService = {
    getLogs: jest.fn(),
    getStatistics: jest.fn(),
    getLogById: jest.fn(),
    getEntityLogs: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AuditController],
      providers: [
        {
          provide: AuditService,
          useValue: mockAuditService,
        },
      ],
    }).compile();

    controller = module.get<AuditController>(AuditController);
    service = module.get<AuditService>(AuditService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should get audit logs via controller', async () => {
    const query = { page: 1, limit: 10 };
    const expected = { total: 1, logs: [{ id: 'log-1' }] };

    mockAuditService.getLogs.mockResolvedValue(expected);

    const result = await controller.getLogs(query);
    expect(result).toEqual(expected);
    expect(mockAuditService.getLogs).toHaveBeenCalledWith(query);
  });

  it('should get statistics via controller', async () => {
    const expected = { total_logs: 10, today_logs: 2, top_actions: [] };
    mockAuditService.getStatistics.mockResolvedValue(expected);

    const result = await controller.getStatistics();
    expect(result).toEqual(expected);
  });

  it('should get log by id via controller', async () => {
    const expected = { id: 'log-1' };
    mockAuditService.getLogById.mockResolvedValue(expected);

    const result = await controller.getLogById('log-1');
    expect(result).toEqual(expected);
    expect(mockAuditService.getLogById).toHaveBeenCalledWith('log-1');
  });

  it('should get entity logs via controller', async () => {
    const expected = [{ id: 'log-1' }];
    mockAuditService.getEntityLogs.mockResolvedValue(expected);

    const result = await controller.getEntityLogs('Session', 'sess-1');
    expect(result).toEqual(expected);
    expect(mockAuditService.getEntityLogs).toHaveBeenCalledWith('Session', 'sess-1');
  });
});
