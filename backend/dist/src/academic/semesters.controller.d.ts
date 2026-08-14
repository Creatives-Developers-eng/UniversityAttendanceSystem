import { SemestersService } from './semesters.service';
import { CreateSemesterDto } from './dto/create-semester.dto';
export declare class SemestersController {
    private readonly semestersService;
    constructor(semestersService: SemestersService);
    create(dto: CreateSemesterDto): Promise<{
        id: string;
        is_active: boolean;
        academic_year_id: string;
        semester_type: import(".prisma/client").$Enums.SemesterType;
    }>;
    findAll(academicYearId?: string): Promise<({
        academic_year: {
            id: string;
            year_name: string;
            start_date: Date;
            end_date: Date;
            is_current: boolean;
        };
    } & {
        id: string;
        is_active: boolean;
        academic_year_id: string;
        semester_type: import(".prisma/client").$Enums.SemesterType;
    })[]>;
}
