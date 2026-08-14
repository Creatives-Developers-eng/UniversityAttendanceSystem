import { AcademicYearsService } from './academic-years.service';
import { CreateAcademicYearDto } from './dto/create-academic-year.dto';
export declare class AcademicYearsController {
    private readonly academicYearsService;
    constructor(academicYearsService: AcademicYearsService);
    create(dto: CreateAcademicYearDto): Promise<{
        id: string;
        year_name: string;
        start_date: Date;
        end_date: Date;
        is_current: boolean;
    }>;
    findAll(): Promise<{
        id: string;
        year_name: string;
        start_date: Date;
        end_date: Date;
        is_current: boolean;
    }[]>;
    setCurrent(id: string): Promise<{
        id: string;
        year_name: string;
        start_date: Date;
        end_date: Date;
        is_current: boolean;
    }>;
}
