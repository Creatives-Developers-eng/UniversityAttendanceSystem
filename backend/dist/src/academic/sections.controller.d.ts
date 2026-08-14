import { SectionsService } from './sections.service';
import { CreateSectionDto } from './dto/create-section.dto';
export declare class SectionsController {
    private readonly sectionsService;
    constructor(sectionsService: SectionsService);
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
            is_active: boolean;
            academic_year_id: string;
            semester_type: import(".prisma/client").$Enums.SemesterType;
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
            is_active: boolean;
            academic_year_id: string;
            semester_type: import(".prisma/client").$Enums.SemesterType;
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
