import { PrismaService } from '../prisma/prisma.service';
import { CreateDepartmentDto } from './dto/create-department.dto';
export declare class DepartmentsService {
    private readonly prisma;
    private readonly logger;
    constructor(prisma: PrismaService);
    create(dto: CreateDepartmentDto): Promise<{
        id: string;
        created_at: Date;
        name: string;
        code: string;
        is_active: boolean;
    }>;
    findAll(): Promise<{
        id: string;
        created_at: Date;
        name: string;
        code: string;
        is_active: boolean;
    }[]>;
    findById(id: string): Promise<{
        id: string;
        created_at: Date;
        name: string;
        code: string;
        is_active: boolean;
    }>;
}
