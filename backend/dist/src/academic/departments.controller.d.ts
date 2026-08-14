import { DepartmentsService } from './departments.service';
import { CreateDepartmentDto } from './dto/create-department.dto';
export declare class DepartmentsController {
    private readonly departmentsService;
    constructor(departmentsService: DepartmentsService);
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
