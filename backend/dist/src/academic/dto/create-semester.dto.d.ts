import { SemesterType } from '../../prisma/prisma.service';
export declare class CreateSemesterDto {
    academic_year_id: string;
    semester_type: SemesterType;
    is_active?: boolean;
}
