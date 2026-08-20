import { PrismaService } from '../prisma/prisma.service';
import { CreateSectionDto } from './dto/create-section.dto';
export declare class SectionsService {
    private readonly prisma;
    private readonly logger;
    constructor(prisma: PrismaService);
    create(dto: CreateSectionDto): Promise<{
        id: string;
        course_id: string;
        semester_id: string;
        teacher_id: string;
        section_type: import(".prisma/client").$Enums.SectionType;
        section_number: string;
    }>;
    findAll(semesterId?: string, teacherId?: string): Promise<({
        teacher: {
            id: string;
            created_at: Date;
            department_id: string;
            employee_number: string;
            teacher_type: import(".prisma/client").$Enums.TeacherType;
        };
        semester: {
            id: string;
            academic_year_id: string;
            semester_type: import(".prisma/client").$Enums.SemesterType;
            is_active: boolean;
        };
        course: {
            id: string;
            course_code: string;
            title: string;
            department_id: string;
            credit_hours: number;
        };
    } & {
        id: string;
        course_id: string;
        semester_id: string;
        teacher_id: string;
        section_type: import(".prisma/client").$Enums.SectionType;
        section_number: string;
    })[]>;
    findById(id: string): Promise<{
        teacher: {
            id: string;
            created_at: Date;
            department_id: string;
            employee_number: string;
            teacher_type: import(".prisma/client").$Enums.TeacherType;
        };
        semester: {
            id: string;
            academic_year_id: string;
            semester_type: import(".prisma/client").$Enums.SemesterType;
            is_active: boolean;
        };
        course: {
            id: string;
            course_code: string;
            title: string;
            department_id: string;
            credit_hours: number;
        };
    } & {
        id: string;
        course_id: string;
        semester_id: string;
        teacher_id: string;
        section_type: import(".prisma/client").$Enums.SectionType;
        section_number: string;
    }>;
}
