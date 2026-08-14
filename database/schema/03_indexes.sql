-- =============================================================================
-- University Attendance System - Database Indexes
-- File: database/schema/03_indexes.sql
-- Description: Performance and lookup indexes for Foreign Keys and State fields
-- =============================================================================

-- 1. Users & Auth Indexes
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_account_state ON users(account_state);

-- 2. Students & Teachers Indexes
CREATE INDEX idx_students_department ON students(department_id);
CREATE INDEX idx_students_academic_year ON students(academic_year_id);
CREATE INDEX idx_teachers_department ON teachers(department_id);

-- 3. Academic Structure Indexes
CREATE INDEX idx_semesters_academic_year ON semesters(academic_year_id);
CREATE INDEX idx_courses_department ON courses(department_id);
CREATE INDEX idx_sections_course ON sections(course_id);
CREATE INDEX idx_sections_semester ON sections(semester_id);
CREATE INDEX idx_sections_teacher ON sections(teacher_id);
CREATE INDEX idx_enrollments_student ON enrollments(student_id);
CREATE INDEX idx_enrollments_section ON enrollments(section_id);

-- 4. Delegates & Devices Indexes
CREATE INDEX idx_delegates_student ON delegates(student_id);
CREATE INDEX idx_delegates_section ON delegates(section_id);
CREATE INDEX idx_devices_user ON devices(user_id);
CREATE INDEX idx_devices_state ON devices(device_state);
CREATE INDEX idx_activation_codes_user ON activation_codes(user_id);
CREATE INDEX idx_activation_codes_state ON activation_codes(code_state);

-- 5. Sessions & Attendance Indexes
CREATE INDEX idx_sessions_section ON sessions(section_id);
CREATE INDEX idx_sessions_delegate ON sessions(delegate_id);
CREATE INDEX idx_sessions_state ON sessions(session_state);
CREATE INDEX idx_attendance_session ON attendance(session_id);
CREATE INDEX idx_attendance_student ON attendance(student_id);
CREATE INDEX idx_attendance_state ON attendance(attendance_state);

-- 6. Requests, QR, Sync & Audit Indexes
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
