import { SemestersService } from './semesters.service';
import { CreateSemesterDto } from './dto/create-semester.dto';
export declare class SemestersController {
    private readonly semestersService;
    constructor(semestersService: SemestersService);
    create(dto: CreateSemesterDto): Promise<{
        id: string;
        academic_year_id: string;
        semester_type: import(".prisma/client").$Enums.SemesterType;
        is_active: boolean;
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
        academic_year_id: string;
        semester_type: import(".prisma/client").$Enums.SemesterType;
        is_active: boolean;
    })[]>;
}
