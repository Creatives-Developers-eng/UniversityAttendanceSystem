import { Test, TestingModule } from '@nestjs/testing';
import { ReportsController } from './reports.controller';
import { ReportsService } from './reports.service';

describe('ReportsController', () => {
  let controller: ReportsController;
  let service: ReportsService;

  const mockReportsService = {
    getSectionAttendanceReport: jest.fn(),
    getStudentAttendanceReport: jest.fn(),
    getCourseDeprivationList: jest.fn(),
    getTeacherSectionsSummary: jest.fn(),
    getSystemDashboardStats: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      controllers: [ReportsController],
      providers: [
        {
          provide: ReportsService,
          useValue: mockReportsService,
        },
      ],
    }).compile();

    controller = module.get<ReportsController>(ReportsController);
    service = module.get<ReportsService>(ReportsService);
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(controller).toBeDefined();
  });

  it('should get dashboard stats via controller', async () => {
    const expected = { total_students: 100, system_attendance_rate: 94.5 };
    mockReportsService.getSystemDashboardStats.mockResolvedValue(expected);

    const result = await controller.getDashboardStats();
    expect(result).toEqual(expected);
  });

  it('should get section report via controller', async () => {
    const expected = { section_id: 'sec-1', deprived_students_count: 0 };
    mockReportsService.getSectionAttendanceReport.mockResolvedValue(expected);

    const result = await controller.getSectionReport('sec-1');
    expect(result).toEqual(expected);
    expect(mockReportsService.getSectionAttendanceReport).toHaveBeenCalledWith('sec-1');
  });

  it('should get student report via controller', async () => {
    const expected = { student_id: 'stud-1', total_enrolled_courses: 5 };
    mockReportsService.getStudentAttendanceReport.mockResolvedValue(expected);

    const result = await controller.getStudentReport('stud-1', 'sem-1');
    expect(result).toEqual(expected);
    expect(mockReportsService.getStudentAttendanceReport).toHaveBeenCalledWith('stud-1', 'sem-1');
  });

  it('should get course deprivation list via controller', async () => {
    const query = { threshold_percent: 25.0 };
    const expected = { course_id: 'course-1', deprived_count: 2 };
    mockReportsService.getCourseDeprivationList.mockResolvedValue(expected);

    const result = await controller.getCourseDeprivation('course-1', query);
    expect(result).toEqual(expected);
    expect(mockReportsService.getCourseDeprivationList).toHaveBeenCalledWith('course-1', query);
  });
});
