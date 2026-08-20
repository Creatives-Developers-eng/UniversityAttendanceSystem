import { PrismaService } from '../prisma/prisma.service';
import { CreateCourseDto } from './dto/create-course.dto';
export declare class CoursesService {
    private readonly prisma;
    private readonly logger;
    constructor(prisma: PrismaService);
    create(dto: CreateCourseDto): Promise<{
        id: string;
        course_code: string;
        title: string;
        department_id: string;
        credit_hours: number;
    }>;
    findAll(departmentId?: string): Promise<({
        department: {
            id: string;
            created_at: Date;
            name: string;
            is_active: boolean;
            code: string;
        };
    } & {
        id: string;
        course_code: string;
        title: string;
        department_id: string;
        credit_hours: number;
    })[]>;
}
