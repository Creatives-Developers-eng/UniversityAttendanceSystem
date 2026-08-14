import { SectionType } from '../../prisma/prisma.service';
export declare class CreateSectionDto {
    course_id: string;
    semester_id: string;
    teacher_id: string;
    section_type: SectionType;
    section_number: string;
}
