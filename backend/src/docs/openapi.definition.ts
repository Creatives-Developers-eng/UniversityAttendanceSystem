export const openApiSpecification = {
  openapi: '3.0.3',
  info: {
    title: 'University Attendance System - Central Backend API',
    description: `
# Central Backend & Offline Classroom Attendance API
## Designed by Leader Qahtan Alshagea

Comprehensive REST API for Offline Classroom Attendance Verification, Face Biometrics Template Management, QR Code Verification, Dynamic Academic Structure, Security Audit Trails, and Deprivation Reports.

### Security Architecture
- **Authentication**: JWT Bearer Token (\`Authorization: Bearer <token>\`)
- **Role-Based Access Control (RBAC)**: \`ADMIN\`, \`TEACHER\`, \`STUDENT\`
- **Zero Raw Image Policy**: Only 512-dim encrypted embeddings are stored
- **Idempotency Guard**: Anti-replay nonce protection for offline sync packages
    `,
    version: '1.0.0',
    contact: {
      name: 'Qahtan Alshagea',
      email: 'qahtan@uas.edu.ye',
    },
  },
  servers: [
    {
      url: '/api/v1',
      description: 'Central Production / Local API v1',
    },
  ],
  tags: [
    { name: 'Auth', description: 'Authentication, Device Activation, and Token Management' },
    { name: 'Devices', description: 'Classroom Mobile Devices & Trusted Binding' },
    { name: 'Academic', description: 'Academic Years, Semesters, Departments, Courses, and Sections' },
    { name: 'Sessions', description: 'Lecture Attendance Session Management' },
    { name: 'Attendance', description: 'Attendance Record Synchronization & Verification' },
    { name: 'Biometrics', description: 'Encrypted Biometric Templates (Embeddings Only)' },
    { name: 'Audit', description: 'System-wide Security Audit Trail' },
    { name: 'Reports', description: 'Attendance Analytics & Deprivation (Herman) Reports' },
    { name: 'Justifications', description: 'Absence Excuses & Medical Justification Workflow' },
  ],
  components: {
    securitySchemes: {
      bearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
      },
    },
    schemas: {
      LoginDto: {
        type: 'object',
        required: ['username', 'password'],
        properties: {
          username: { type: 'string', example: 'admin' },
          password: { type: 'string', example: 'Admin@123456' },
        },
      },
      StartSessionDto: {
        type: 'object',
        required: ['section_id'],
        properties: {
          section_id: { type: 'string', format: 'uuid' },
          expected_duration_minutes: { type: 'integer', default: 90 },
        },
      },
      SyncAttendanceDto: {
        type: 'object',
        required: ['session_id', 'delegate_id', 'records'],
        properties: {
          session_id: { type: 'string', format: 'uuid' },
          delegate_id: { type: 'string', format: 'uuid' },
          records: {
            type: 'array',
            items: {
              type: 'object',
              required: ['request_id', 'student_id', 'attendance_method', 'nonce', 'timestamp'],
              properties: {
                request_id: { type: 'string', format: 'uuid' },
                student_id: { type: 'string', format: 'uuid' },
                attendance_method: { type: 'string', enum: ['QR', 'Biometric', 'Manual'] },
                nonce: { type: 'string' },
                timestamp: { type: 'integer' },
              },
            },
          },
        },
      },
      EnrollBiometricDto: {
        type: 'object',
        required: ['template_hash', 'encrypted_template_data'],
        properties: {
          template_hash: { type: 'string', example: 'a'.repeat(64) },
          encrypted_template_data: { type: 'string' },
        },
      },
      SubmitJustificationDto: {
        type: 'object',
        required: ['session_id', 'reason'],
        properties: {
          session_id: { type: 'string', format: 'uuid' },
          reason: { type: 'string', example: 'Medical hospitalization' },
          document_url: { type: 'string', example: 'https://docs.example.com/report.pdf' },
        },
      },
    },
  },
  security: [
    {
      bearerAuth: [],
    },
  ],
  paths: {
    '/health': {
      get: {
        tags: ['Health'],
        summary: 'System health check',
        responses: { 200: { description: 'Server is healthy' } },
      },
    },
    '/auth/login': {
      post: {
        tags: ['Auth'],
        summary: 'Authenticate user with username and password',
        requestBody: {
          required: true,
          content: { 'application/json': { schema: { $ref: '#/components/schemas/LoginDto' } } },
        },
        responses: { 200: { description: 'JWT tokens and user profile' } },
      },
    },
    '/auth/refresh': {
      post: {
        tags: ['Auth'],
        summary: 'Refresh expired JWT access token',
        responses: { 200: { description: 'New JWT access token' } },
      },
    },
    '/sessions/start': {
      post: {
        tags: ['Sessions'],
        summary: 'Start an attendance session for an academic section',
        requestBody: {
          required: true,
          content: { 'application/json': { schema: { $ref: '#/components/schemas/StartSessionDto' } } },
        },
        responses: { 201: { description: 'Session created and opened' } },
      },
    },
    '/sessions/close': {
      post: {
        tags: ['Sessions'],
        summary: 'Close an active attendance session',
        responses: { 200: { description: 'Session closed' } },
      },
    },
    '/attendance/sync': {
      post: {
        tags: ['Attendance'],
        summary: 'Synchronize offline attendance batch with idempotency guard',
        requestBody: {
          required: true,
          content: { 'application/json': { schema: { $ref: '#/components/schemas/SyncAttendanceDto' } } },
        },
        responses: { 200: { description: 'Attendance batch saved with duplicate statistics' } },
      },
    },
    '/students/{studentId}/biometrics': {
      post: {
        tags: ['Biometrics'],
        summary: 'Enroll encrypted biometric template (Zero Raw Image Storage)',
        requestBody: {
          required: true,
          content: { 'application/json': { schema: { $ref: '#/components/schemas/EnrollBiometricDto' } } },
        },
        responses: { 201: { description: 'Biometric template registered' } },
      },
      get: {
        tags: ['Biometrics'],
        summary: 'Get biometric template metadata',
        responses: { 200: { description: 'Biometric metadata' } },
      },
    },
    '/students/biometrics/section/{sectionId}': {
      get: {
        tags: ['Biometrics'],
        summary: 'Export encrypted biometric packages for authorized classroom devices',
        responses: { 200: { description: 'List of encrypted templates for offline verification' } },
      },
    },
    '/audit-logs': {
      get: {
        tags: ['Audit'],
        summary: 'Get paginated audit logs (Admin only)',
        responses: { 200: { description: 'Paginated audit trail' } },
      },
    },
    '/reports/sections/{sectionId}': {
      get: {
        tags: ['Reports'],
        summary: 'Generate section attendance report with deprivation warning levels',
        responses: { 200: { description: 'Detailed section attendance calculations' } },
      },
    },
    '/reports/courses/{courseId}/deprivation': {
      get: {
        tags: ['Reports'],
        summary: 'Generate official course deprivation (Herman) list (>25% absence)',
        responses: { 200: { description: 'List of deprived students' } },
      },
    },
    '/reports/dashboard': {
      get: {
        tags: ['Reports'],
        summary: 'High-level system dashboard analytics',
        responses: { 200: { description: 'System metrics' } },
      },
    },
    '/justifications': {
      post: {
        tags: ['Justifications'],
        summary: 'Submit absence excuse and justification report',
        requestBody: {
          required: true,
          content: { 'application/json': { schema: { $ref: '#/components/schemas/SubmitJustificationDto' } } },
        },
        responses: { 201: { description: 'Justification submitted and queued' } },
      },
    },
    '/justifications/{id}/review': {
      patch: {
        tags: ['Justifications'],
        summary: 'Approve or reject justification (Teacher/Admin)',
        responses: { 200: { description: 'Justification reviewed and attendance updated to Excused' } },
      },
    },
  },
};
