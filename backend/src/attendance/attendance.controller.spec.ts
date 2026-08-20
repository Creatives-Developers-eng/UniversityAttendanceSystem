import { Test, TestingModule } from '@nestjs/testing';
import { AttendanceController } from './attendance.controller';
import { AttendanceService } from './attendance.service';
import { AttendanceState, AttendanceMethod, Role } from '../prisma/prisma.service';

describe('AttendanceController', () => {
  let controller: AttendanceController;
  let service: AttendanceService;

  const mockAttendanceService = {
    syncAttendance: jest.fn(),
    manualAttendance: jest.fn(),
    getSessionAttendance: jest.fn(),
    getStudentAttendanceHistory: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [AttendanceController],
      providers: [
        {
          provide: AttendanceService,
          useValue: mockAttendanceService,
        },
      ],
    }).compile();

    controller = module.get<AttendanceController>(AttendanceController);
    service = module.get<AttendanceService>(AttendanceService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should sync attendance batch via controller', async () => {
    const dto = {
      session_id: 'sess-1',
      delegate_id: 'del-1',
      records: [
        {
          request_id: 'req-1',
          student_id: 'stud-1',
          attendance_method: AttendanceMethod.QR,
          nonce: 'nonce-1',
          timestamp: 123456,
        },
      ],
    };
    const req = { user: { id: 'admin-1', role: Role.ADMIN } };
    const expected = { success: true, synced_records_count: 1 };

    mockAttendanceService.syncAttendance.mockResolvedValue(expected);

    const result = await controller.syncAttendance(dto, req);
    expect(result).toEqual(expected);
    expect(mockAttendanceService.syncAttendance).toHaveBeenCalledWith(dto, req.user);
  });

  it('should mark manual attendance via controller', async () => {
    const dto = {
      session_id: 'sess-1',
      student_id: 'stud-1',
      attendance_state: AttendanceState.Present,
    };
    const req = { user: { id: 'teacher-1', role: Role.TEACHER } };
    const expected = { id: 'att-1', attendance_method: AttendanceMethod.Manual };

    mockAttendanceService.manualAttendance.mockResolvedValue(expected);

    const result = await controller.manualAttendance(dto, req);
    expect(result).toEqual(expected);
    expect(mockAttendanceService.manualAttendance).toHaveBeenCalledWith(dto, req.user);
  });

  it('should get session attendance via controller', async () => {
    const expected = [{ id: 'att-1' }];
    mockAttendanceService.getSessionAttendance.mockResolvedValue(expected);

    const result = await controller.getSessionAttendance('sess-1');
    expect(result).toEqual(expected);
    expect(mockAttendanceService.getSessionAttendance).toHaveBeenCalledWith('sess-1');
  });

  it('should get student attendance history via controller', async () => {
    const expected = [{ id: 'att-1' }];
    mockAttendanceService.getStudentAttendanceHistory.mockResolvedValue(expected);

    const result = await controller.getStudentAttendanceHistory('stud-1');
    expect(result).toEqual(expected);
    expect(mockAttendanceService.getStudentAttendanceHistory).toHaveBeenCalledWith('stud-1');
  });
});
