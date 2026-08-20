import { PrismaClient, Role, AccountState, SemesterType, SectionType, TeacherType } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Starting accurate database seeding for University Attendance System...');

  const passwordHash = await bcrypt.hash('password123', 10);

  // 1. Create Super Admin User
  const adminUser = await prisma.user.upsert({
    where: { username: 'admin' },
    update: {},
    create: {
      username: 'admin',
      email: 'admin@university.edu',
      password_hash: passwordHash,
      full_name: 'مدير النظام المركزي (System Admin)',
      phone_number: '+967770000000',
      role: Role.ADMIN,
      account_state: AccountState.Active,
    },
  });
  console.log('✅ Admin user ready:', adminUser.username);

  // 2. Create Academic Year
  const academicYear = await prisma.academicYear.upsert({
    where: { year_name: '2025-2026' },
    update: {},
    create: {
      year_name: '2025-2026',
      start_date: new Date('2025-09-01'),
      end_date: new Date('2026-06-30'),
      is_current: true,
    },
  });
  console.log('✅ Academic Year ready:', academicYear.year_name);

  // 3. Create Semester
  let semester = await prisma.semester.findFirst({
    where: {
      academic_year_id: academicYear.id,
      semester_type: SemesterType.FIRST,
    },
  });

  if (!semester) {
    semester = await prisma.semester.create({
      data: {
        academic_year_id: academicYear.id,
        semester_type: SemesterType.FIRST,
        is_active: true,
      },
    });
  }
  console.log('✅ Semester ready: FIRST Semester');

  // 4. Create Department
  const csDepartment = await prisma.department.upsert({
    where: { code: 'CS' },
    update: {},
    create: {
      code: 'CS',
      name: 'قسم علوم الحاسوب (Computer Science)',
      is_active: true,
    },
  });
  console.log('✅ Department ready:', csDepartment.name);

  // 5. Create Courses
  const courseProg = await prisma.course.upsert({
    where: { course_code: 'CS101' },
    update: {},
    create: {
      course_code: 'CS101',
      title: 'أساسيات البرمجة (Programming Fundamentals)',
      department_id: csDepartment.id,
      credit_hours: 3,
    },
  });

  const courseDataStruct = await prisma.course.upsert({
    where: { course_code: 'CS201' },
    update: {},
    create: {
      course_code: 'CS201',
      title: 'هياكل البيانات (Data Structures)',
      department_id: csDepartment.id,
      credit_hours: 3,
    },
  });
  console.log('✅ Courses ready: CS101, CS201');

  // 6. Create Teacher
  const teacherUser = await prisma.user.upsert({
    where: { username: 'dr_ahmed' },
    update: {},
    create: {
      username: 'dr_ahmed',
      email: 'dr.ahmed@university.edu',
      password_hash: passwordHash,
      full_name: 'أ.د. أحمد المنصوري (Dr. Ahmed)',
      role: Role.TEACHER,
      account_state: AccountState.Active,
    },
  });

  const teacher = await prisma.teacher.upsert({
    where: { id: teacherUser.id },
    update: {},
    create: {
      id: teacherUser.id,
      employee_number: 'EMP-1001',
      teacher_type: TeacherType.BOTH,
      department_id: csDepartment.id,
    },
  });
  console.log('✅ Teacher ready:', teacherUser.full_name);

  // 7. Create Sections
  let sectionTheo = await prisma.section.findFirst({
    where: {
      course_id: courseProg.id,
      semester_id: semester.id,
      section_number: 'SEC-1',
    },
  });

  if (!sectionTheo) {
    sectionTheo = await prisma.section.create({
      data: {
        course_id: courseProg.id,
        semester_id: semester.id,
        teacher_id: teacher.id,
        section_type: SectionType.THEORETICAL,
        section_number: 'SEC-1',
      },
    });
  }

  let sectionPrac = await prisma.section.findFirst({
    where: {
      course_id: courseProg.id,
      semester_id: semester.id,
      section_number: 'LAB-1A',
    },
  });

  if (!sectionPrac) {
    sectionPrac = await prisma.section.create({
      data: {
        course_id: courseProg.id,
        semester_id: semester.id,
        teacher_id: teacher.id,
        section_type: SectionType.PRACTICAL,
        section_number: 'LAB-1A',
      },
    });
  }
  console.log('✅ Sections ready: Theoretical (SEC-1) & Practical (LAB-1A)');

  // 8. Create Students
  const studentsList = [
    { username: 'owab_student', name: 'أواب النزيلي (Owab)', studentNum: 'STD-2025-001', isDelegate: true },
    { username: 'alawadi_student', name: 'محمد العواضي (Al-Awadi)', studentNum: 'STD-2025-002', isDelegate: false },
    { username: 'alaydarous_student', name: 'محمد العيدروس (Al-Aydarous)', studentNum: 'STD-2025-003', isDelegate: false },
    { username: 'mishal_student', name: 'مشعل الحاج (Mishal)', studentNum: 'STD-2025-004', isDelegate: false },
  ];

  for (const s of studentsList) {
    const studentUser = await prisma.user.upsert({
      where: { username: s.username },
      update: {},
      create: {
        username: s.username,
        email: `${s.username}@university.edu`,
        password_hash: passwordHash,
        full_name: s.name,
        role: Role.STUDENT,
        account_state: AccountState.Active,
      },
    });

    const studentRecord = await prisma.student.upsert({
      where: { id: studentUser.id },
      update: {},
      create: {
        id: studentUser.id,
        student_number: s.studentNum,
        department_id: csDepartment.id,
        academic_year_id: academicYear.id,
      },
    });

    // Enroll student in theoretical section
    await prisma.enrollment.upsert({
      where: {
        student_id_section_id: {
          student_id: studentRecord.id,
          section_id: sectionTheo.id,
        },
      },
      update: {},
      create: {
        student_id: studentRecord.id,
        section_id: sectionTheo.id,
      },
    });

    // Enroll student in practical section
    await prisma.enrollment.upsert({
      where: {
        student_id_section_id: {
          student_id: studentRecord.id,
          section_id: sectionPrac.id,
        },
      },
      update: {},
      create: {
        student_id: studentRecord.id,
        section_id: sectionPrac.id,
      },
    });

    // Assign Delegate if needed
    if (s.isDelegate) {
      const existingDelegate = await prisma.delegate.findFirst({
        where: {
          student_id: studentRecord.id,
          section_id: sectionTheo.id,
        },
      });

      if (!existingDelegate) {
        await prisma.delegate.create({
          data: {
            student_id: studentRecord.id,
            section_id: sectionTheo.id,
            assigned_by: adminUser.id,
            is_active: true,
          },
        });
        console.log('⭐ Delegate assigned: Owab is Delegate for CS101 Section 1');
      }
    }
  }

  console.log('✅ All 4 students created and enrolled in sections!');
  console.log('🎉 Database seeding completed 100% successfully!');
}

main()
  .catch((e) => {
    console.error('❌ Error during seeding:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
