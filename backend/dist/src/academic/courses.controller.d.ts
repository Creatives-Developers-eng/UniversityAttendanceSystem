import { CoursesService } from './courses.service';
import { CreateCourseDto } from './dto/create-course.dto';
export declare class CoursesController {
    private readonly coursesService;
    constructor(coursesService: CoursesService);
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
            code: string;
            is_active: boolean;
        };
    } & {
        id: string;
        course_code: string;
        title: string;
        department_id: string;
        credit_hours: number;
    })[]>;
}
