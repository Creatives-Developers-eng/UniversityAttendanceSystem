import { PrismaService } from '../prisma/prisma.service';
import { CreateEnrollmentDto } from './dto/create-enrollment.dto';
export declare class EnrollmentsService {
    private readonly prisma;
    private readonly logger;
    constructor(prisma: PrismaService);
    create(dto: CreateEnrollmentDto): Promise<{
        id: string;
        student_id: string;
        section_id: string;
        enrolled_at: Date;
    }>;
    findAll(sectionId?: string, studentId?: string): Promise<({
        student: {
            id: string;
            created_at: Date;
            academic_year_id: string;
            department_id: string;
            student_number: string;
        };
        section: {
            id: string;
            course_id: string;
            semester_id: string;
            teacher_id: string;
            section_type: import(".prisma/client").$Enums.SectionType;
            section_number: string;
        };
    } & {
        id: string;
        student_id: string;
        section_id: string;
        enrolled_at: Date;
    })[]>;
    delete(id: string): Promise<{
        message: string;
    }>;
}
