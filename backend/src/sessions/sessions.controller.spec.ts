import { Test, TestingModule } from '@nestjs/testing';
import { SessionsController } from './sessions.controller';
import { SessionsService } from './sessions.service';
import { SessionState, Role } from '../prisma/prisma.service';

describe('SessionsController', () => {
  let controller: SessionsController;
  let service: SessionsService;

  const mockSessionsService = {
    startSession: jest.fn(),
    closeSession: jest.fn(),
    getActiveSessions: jest.fn(),
    getSessionById: jest.fn(),
    getSectionSessions: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [SessionsController],
      providers: [
        {
          provide: SessionsService,
          useValue: mockSessionsService,
        },
      ],
    }).compile();

    controller = module.get<SessionsController>(SessionsController);
    service = module.get<SessionsService>(SessionsService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should start session via controller', async () => {
    const dto = { section_id: 'sec-1', delegate_id: 'del-1' };
    const req = { user: { id: 'admin-1', role: Role.ADMIN } };
    const expected = { id: 'sess-1', session_state: SessionState.Active };

    mockSessionsService.startSession.mockResolvedValue(expected);

    const result = await controller.startSession(dto, req);
    expect(result).toEqual(expected);
    expect(mockSessionsService.startSession).toHaveBeenCalledWith(dto, req.user);
  });

  it('should close session via controller', async () => {
    const dto = { session_id: 'sess-1' };
    const req = { user: { id: 'admin-1', role: Role.ADMIN } };
    const expected = { id: 'sess-1', session_state: SessionState.Closed };

    mockSessionsService.closeSession.mockResolvedValue(expected);

    const result = await controller.closeSession(dto, req);
    expect(result).toEqual(expected);
    expect(mockSessionsService.closeSession).toHaveBeenCalledWith(dto, req.user);
  });

  it('should get active sessions via controller', async () => {
    const expected = [{ id: 'sess-1', session_state: SessionState.Active }];
    mockSessionsService.getActiveSessions.mockResolvedValue(expected);

    const result = await controller.getActiveSessions();
    expect(result).toEqual(expected);
  });

  it('should get session by id via controller', async () => {
    const expected = { id: 'sess-1', session_state: SessionState.Active };
    mockSessionsService.getSessionById.mockResolvedValue(expected);

    const result = await controller.getSessionById('sess-1');
    expect(result).toEqual(expected);
    expect(mockSessionsService.getSessionById).toHaveBeenCalledWith('sess-1');
  });

  it('should get section sessions via controller', async () => {
    const expected = [{ id: 'sess-1' }];
    mockSessionsService.getSectionSessions.mockResolvedValue(expected);

    const result = await controller.getSectionSessions('sec-1');
    expect(result).toEqual(expected);
    expect(mockSessionsService.getSectionSessions).toHaveBeenCalledWith('sec-1');
  });
});
