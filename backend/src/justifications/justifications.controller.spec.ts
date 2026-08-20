import { Test, TestingModule } from '@nestjs/testing';
import { JustificationsController } from './justifications.controller';
import { JustificationsService } from './justifications.service';
import { Role } from '../prisma/prisma.service';

describe('JustificationsController', () => {
  let controller: JustificationsController;
  let service: JustificationsService;

  const mockJustificationsService = {
    submitJustification: jest.fn(),
    reviewJustification: jest.fn(),
    getSectionJustifications: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [JustificationsController],
      providers: [
        {
          provide: JustificationsService,
          useValue: mockJustificationsService,
        },
      ],
    }).compile();

    controller = module.get<JustificationsController>(JustificationsController);
    service = module.get<JustificationsService>(JustificationsService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should submit justification via controller', async () => {
    const dto = { session_id: 'sess-1', reason: 'Medical' };
    const req = { user: { id: 'stud-1', role: Role.STUDENT } };
    const expected = { justification_id: 'just-1', status: 'PENDING' };

    mockJustificationsService.submitJustification.mockResolvedValue(expected);

    const result = await controller.submitJustification(dto, req);
    expect(result).toEqual(expected);
    expect(mockJustificationsService.submitJustification).toHaveBeenCalledWith('stud-1', dto, req.user);
  });

  it('should review justification via controller', async () => {
    const dto = { status: 'APPROVED' as const, notes: 'Valid' };
    const req = { user: { id: 'teacher-1', role: Role.TEACHER } };
    const expected = { justification_id: 'just-1', status: 'APPROVED' };

    mockJustificationsService.reviewJustification.mockResolvedValue(expected);

    const result = await controller.reviewJustification('just-1', dto, req);
    expect(result).toEqual(expected);
    expect(mockJustificationsService.reviewJustification).toHaveBeenCalledWith('just-1', dto, req.user);
  });
});
