-- =============================================================================
-- University Attendance System - Master PostgreSQL Database Schema
-- File: database/schema/schema.sql
-- Description: Complete master DDL script for all 19 entities, constraints, and indexes
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. EXTENSIONS & DOMAINS
-- -----------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- -----------------------------------------------------------------------------
-- 2. TABLES & CONSTRAINTS
-- -----------------------------------------------------------------------------

-- 1. Departments Table
CREATE TABLE departments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Academic Years Table
CREATE TABLE academic_years (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    year_name VARCHAR(50) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    is_current BOOLEAN NOT NULL DEFAULT FALSE
);

-- 3. Semesters Table
CREATE TABLE semesters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    academic_year_id UUID NOT NULL REFERENCES academic_years(id) ON DELETE CASCADE,
    semester_type VARCHAR(20) NOT NULL CHECK (semester_type IN ('FIRST', 'SECOND', 'SUMMER')),
    is_active BOOLEAN NOT NULL DEFAULT FALSE
);

-- 4. Courses Table
CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_code VARCHAR(30) NOT NULL UNIQUE,
    title VARCHAR(150) NOT NULL,
    department_id UUID NOT NULL REFERENCES departments(id) ON DELETE RESTRICT,
    credit_hours INTEGER NOT NULL CHECK (credit_hours > 0)
);

-- 5. Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    phone_number VARCHAR(20),
    role VARCHAR(30) NOT NULL CHECK (role IN ('ADMIN', 'STUDENT', 'TEACHER')),
    account_state VARCHAR(30) NOT NULL DEFAULT 'PendingActivation' 
        CHECK (account_state IN ('PendingActivation', 'Active', 'Suspended', 'Deactivated')),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 6. Students Table
CREATE TABLE students (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    student_number VARCHAR(30) NOT NULL UNIQUE,
    department_id UUID NOT NULL REFERENCES departments(id) ON DELETE RESTRICT,
    academic_year_id UUID NOT NULL REFERENCES academic_years(id) ON DELETE RESTRICT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 7. Teachers Table
CREATE TABLE teachers (
    id UUID PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    employee_number VARCHAR(30) NOT NULL UNIQUE,
    teacher_type VARCHAR(30) NOT NULL CHECK (teacher_type IN ('PRACTICAL_TEACHER', 'THEORETICAL_TEACHER', 'BOTH')),
    department_id UUID NOT NULL REFERENCES departments(id) ON DELETE RESTRICT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 8. Sections Table
CREATE TABLE sections (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    semester_id UUID NOT NULL REFERENCES semesters(id) ON DELETE CASCADE,
    teacher_id UUID NOT NULL REFERENCES teachers(id) ON DELETE RESTRICT,
    section_type VARCHAR(20) NOT NULL CHECK (section_type IN ('PRACTICAL', 'THEORETICAL')),
    section_number VARCHAR(10) NOT NULL
);

-- 9. Enrollments Table
CREATE TABLE enrollments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    section_id UUID NOT NULL REFERENCES sections(id) ON DELETE CASCADE,
    enrolled_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_student_section UNIQUE (student_id, section_id)
);

-- 10. Delegates Table
CREATE TABLE delegates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    section_id UUID NOT NULL REFERENCES sections(id) ON DELETE CASCADE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    assigned_by UUID NOT NULL REFERENCES users(id) ON DELETE RESTRICT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 11. Devices Table
CREATE TABLE devices (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    device_identifier VARCHAR(255) NOT NULL UNIQUE,
    device_fingerprint TEXT NOT NULL,
    device_state VARCHAR(30) NOT NULL DEFAULT 'Unregistered' 
        CHECK (device_state IN ('Unregistered', 'PendingVerification', 'Bound', 'Revoked')),
    bound_at TIMESTAMP WITH TIME ZONE
);

-- 12. Activation Codes Table
CREATE TABLE activation_codes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    code VARCHAR(50) NOT NULL,
    code_state VARCHAR(30) NOT NULL DEFAULT 'Generated' 
        CHECK (code_state IN ('Generated', 'Sent', 'Used', 'Expired', 'Invalidated')),
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE
);

-- 13. Sessions Table
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    section_id UUID NOT NULL REFERENCES sections(id) ON DELETE CASCADE,
    delegate_id UUID NOT NULL REFERENCES delegates(id) ON DELETE RESTRICT,
    session_state VARCHAR(30) NOT NULL DEFAULT 'Created' 
        CHECK (session_state IN ('Created', 'Opened', 'Active', 'Closing', 'Closed', 'Synced')),
    opened_at TIMESTAMP WITH TIME ZONE,
    closed_at TIMESTAMP WITH TIME ZONE,
    synced_at TIMESTAMP WITH TIME ZONE
);

-- 14. Attendance Table
CREATE TABLE attendance (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    attendance_state VARCHAR(30) NOT NULL DEFAULT 'Present' 
        CHECK (attendance_state IN ('Present', 'Absent', 'Late', 'Excused')),
    attendance_method VARCHAR(30) NOT NULL CHECK (attendance_method IN ('QR', 'Biometric', 'Manual')),
    marked_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_session_student UNIQUE (session_id, student_id)
);

-- 15. Attendance Requests Table
CREATE TABLE attendance_requests (
    request_id UUID PRIMARY KEY,
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    request_state VARCHAR(30) NOT NULL DEFAULT 'Received' 
        CHECK (request_state IN ('Received', 'Validating', 'Accepted', 'Rejected', 'QueuedForSync')),
    nonce VARCHAR(100) NOT NULL,
    timestamp BIGINT NOT NULL
);

-- 16. QR Sessions Table
CREATE TABLE qr_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    current_nonce VARCHAR(100) NOT NULL UNIQUE,
    qr_state VARCHAR(30) NOT NULL DEFAULT 'Generated' 
        CHECK (qr_state IN ('Generated', 'Active', 'Expired', 'Invalidated')),
    valid_until TIMESTAMP WITH TIME ZONE NOT NULL,
    generated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 17. Biometric Templates Table
CREATE TABLE biometric_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL UNIQUE REFERENCES students(id) ON DELETE CASCADE,
    template_hash VARCHAR(255) NOT NULL UNIQUE,
    encrypted_template_data TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 18. Sync Records Table
CREATE TABLE sync_records (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    delegate_id UUID NOT NULL REFERENCES delegates(id) ON DELETE RESTRICT,
    sync_state VARCHAR(30) NOT NULL DEFAULT 'Idle' 
        CHECK (sync_state IN ('Idle', 'Preparing', 'Syncing', 'Success', 'Failed')),
    records_count INTEGER NOT NULL CHECK (records_count >= 0),
    synced_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 19. Audit Logs Table
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID REFERENCES users(id) ON DELETE SET NULL,
    action VARCHAR(100) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id UUID,
    payload TEXT,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------------------------------
-- 3. INDEXES FOR PERFORMANCE
-- -----------------------------------------------------------------------------
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_account_state ON users(account_state);
CREATE INDEX idx_students_department ON students(department_id);
CREATE INDEX idx_students_academic_year ON students(academic_year_id);
CREATE INDEX idx_teachers_department ON teachers(department_id);
CREATE INDEX idx_semesters_academic_year ON semesters(academic_year_id);
CREATE INDEX idx_courses_department ON courses(department_id);
CREATE INDEX idx_sections_course ON sections(course_id);
CREATE INDEX idx_sections_semester ON sections(semester_id);
CREATE INDEX idx_sections_teacher ON sections(teacher_id);
CREATE INDEX idx_enrollments_student ON enrollments(student_id);
CREATE INDEX idx_enrollments_section ON enrollments(section_id);
CREATE INDEX idx_delegates_student ON delegates(student_id);
CREATE INDEX idx_delegates_section ON delegates(section_id);
CREATE INDEX idx_devices_user ON devices(user_id);
CREATE INDEX idx_devices_state ON devices(device_state);
CREATE INDEX idx_activation_codes_user ON activation_codes(user_id);
CREATE INDEX idx_activation_codes_state ON activation_codes(code_state);
CREATE INDEX idx_sessions_section ON sessions(section_id);
CREATE INDEX idx_sessions_delegate ON sessions(delegate_id);
CREATE INDEX idx_sessions_state ON sessions(session_state);
CREATE INDEX idx_attendance_session ON attendance(session_id);
CREATE INDEX idx_attendance_student ON attendance(student_id);
CREATE INDEX idx_attendance_state ON attendance(attendance_state);
CREATE INDEX idx_attendance_requests_session ON attendance_requests(session_id);
CREATE INDEX idx_attendance_requests_student ON attendance_requests(student_id);
CREATE INDEX idx_attendance_requests_state ON attendance_requests(request_state);
CREATE INDEX idx_qr_sessions_session ON qr_sessions(session_id);
CREATE INDEX idx_qr_sessions_state ON qr_sessions(qr_state);
CREATE INDEX idx_sync_records_session ON sync_records(session_id);
CREATE INDEX idx_sync_records_delegate ON sync_records(delegate_id);
CREATE INDEX idx_sync_records_state ON sync_records(sync_state);
CREATE INDEX idx_audit_logs_user ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_timestamp ON audit_logs(timestamp);
