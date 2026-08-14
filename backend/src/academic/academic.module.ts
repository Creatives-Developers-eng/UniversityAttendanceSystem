import { Module } from '@nestjs/common';
import { PrismaModule } from '../prisma/prisma.module';

import { DepartmentsController } from './departments.controller';
import { DepartmentsService } from './departments.service';

import { AcademicYearsController } from './academic-years.controller';
import { AcademicYearsService } from './academic-years.service';

import { SemestersController } from './semesters.controller';
import { SemestersService } from './semesters.service';

import { CoursesController } from './courses.controller';
import { CoursesService } from './courses.service';

import { SectionsController } from './sections.controller';
import { SectionsService } from './sections.service';

import { EnrollmentsController } from './enrollments.controller';
import { EnrollmentsService } from './enrollments.service';

@Module({
  imports: [PrismaModule],
  controllers: [
    DepartmentsController,
    AcademicYearsController,
    SemestersController,
    CoursesController,
    SectionsController,
    EnrollmentsController,
  ],
  providers: [
    DepartmentsService,
    AcademicYearsService,
    SemestersService,
    CoursesService,
    SectionsService,
    EnrollmentsService,
  ],
  exports: [
    DepartmentsService,
    AcademicYearsService,
    SemestersService,
    CoursesService,
    SectionsService,
    EnrollmentsService,
  ],
})
export class AcademicModule {}
