import { DepartmentsService } from './departments.service';
import { CreateDepartmentDto } from './dto/create-department.dto';
export declare class DepartmentsController {
    private readonly departmentsService;
    constructor(departmentsService: DepartmentsService);
    create(dto: CreateDepartmentDto): Promise<{
        id: string;
        created_at: Date;
        name: string;
        is_active: boolean;
        code: string;
    }>;
    findAll(): Promise<{
        id: string;
        created_at: Date;
        name: string;
        is_active: boolean;
        code: string;
    }[]>;
    findById(id: string): Promise<{
        id: string;
        created_at: Date;
        name: string;
        is_active: boolean;
        code: string;
    }>;
}
