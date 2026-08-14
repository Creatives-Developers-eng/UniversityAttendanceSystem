import { PrismaService } from '../prisma/prisma.service';
import { CreateAcademicYearDto } from './dto/create-academic-year.dto';
export declare class AcademicYearsService {
    private readonly prisma;
    private readonly logger;
    constructor(prisma: PrismaService);
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
