import { Test, TestingModule } from '@nestjs/testing';
import { BiometricsController } from './biometrics.controller';
import { BiometricsService } from './biometrics.service';
import { Role } from '../../prisma/prisma.service';

describe('BiometricsController', () => {
  let controller: BiometricsController;
  let service: BiometricsService;

  const mockBiometricsService = {
    enrollTemplate: jest.fn(),
    getSectionBiometrics: jest.fn(),
    getStudentBiometric: jest.fn(),
    deleteBiometric: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [BiometricsController],
      providers: [
        {
          provide: BiometricsService,
          useValue: mockBiometricsService,
        },
      ],
    }).compile();

    controller = module.get<BiometricsController>(BiometricsController);
    service = module.get<BiometricsService>(BiometricsService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should enroll template via controller', async () => {
    const dto = { template_hash: 'a'.repeat(64), encrypted_template_data: 'enc-data' };
    const req = { user: { id: 'admin-1', role: Role.ADMIN } };
    const expected = { id: 'tmpl-1', student_id: 'stud-1' };

    mockBiometricsService.enrollTemplate.mockResolvedValue(expected);

    const result = await controller.enrollTemplate('stud-1', dto, req);
    expect(result).toEqual(expected);
    expect(mockBiometricsService.enrollTemplate).toHaveBeenCalledWith('stud-1', dto, req.user);
  });

  it('should get section biometrics via controller', async () => {
    const req = { user: { id: 'teacher-1', role: Role.TEACHER } };
    const expected = { section_id: 'sec-1', templates_count: 5 };

    mockBiometricsService.getSectionBiometrics.mockResolvedValue(expected);

    const result = await controller.getSectionBiometrics('sec-1', req);
    expect(result).toEqual(expected);
    expect(mockBiometricsService.getSectionBiometrics).toHaveBeenCalledWith('sec-1', req.user);
  });

  it('should get student biometric via controller', async () => {
    const req = { user: { id: 'stud-1', role: Role.STUDENT } };
    const expected = { student_id: 'stud-1', template_hash: 'a'.repeat(64) };

    mockBiometricsService.getStudentBiometric.mockResolvedValue(expected);

    const result = await controller.getStudentBiometric('stud-1', req);
    expect(result).toEqual(expected);
    expect(mockBiometricsService.getStudentBiometric).toHaveBeenCalledWith('stud-1', req.user);
  });

  it('should delete biometric via controller', async () => {
    const req = { user: { id: 'admin-1', role: Role.ADMIN } };
    const expected = { message: 'revoked' };

    mockBiometricsService.deleteBiometric.mockResolvedValue(expected);

    const result = await controller.deleteBiometric('stud-1', req);
    expect(result).toEqual(expected);
    expect(mockBiometricsService.deleteBiometric).toHaveBeenCalledWith('stud-1', req.user);
  });
});
