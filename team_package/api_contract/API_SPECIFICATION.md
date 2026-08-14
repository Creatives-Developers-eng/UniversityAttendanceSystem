# مواصفة عقود الـ REST API المركزية | API_SPECIFICATION.md
## نظام الحضور الجامعي الذكي (University Attendance System)

---

> [!IMPORTANT]
> **قاعدة الالزام التام بـ API Contract والحوكمة**
> 
> تعد هذه الوثيقة المرجع الحصري لجميع نقاط النهاية (`Endpoints`) وكائنات النقل (`DTOs`) في الخادم المركزي (`NestJS`).
> مسار بادئة الإصدار الموحد هو **`/api/v1/`**.
> تلتزم كافة الحقول والتسميات بـ `PROJECT_GLOSSARY.md` و `database_dictionary.md` بصرامة.
> **يُمنع تعديل أي عقد دون موافقة صريحة ومكتوبة من قائد المشروع.**

---

## 1. المصادقة والتوثيق (Authentication)

### 1.1 `POST /api/v1/auth/login`
- **Purpose:** تسجيل دخول المستخدم وإصدار رمزي النفاذ والتحديث (`AccessToken` & `RefreshToken`).
- **Required Role:** جميع الأدوار (`Public`).
- **Request:**
  - **Headers:** `Content-Type: application/json`
  - **Body Payload Schema:**
    ```json
    {
      "username": "string (Required)",
      "password": "string (Required)"
    }
    ```
- **Response:**
  - **Success (200 OK):**
    ```json
    {
      "statusCode": 200,
      "message": "Login successful",
      "data": {
        "user_id": "UUID",
        "username": "string",
        "role": "ADMIN | STUDENT | TEACHER",
        "account_state": "Active",
        "access_token": "JWT String",
        "refresh_token": "JWT String"
      }
    }
    ```
- **Validation Errors (400 Bad Request):** اسم المستخدم أو كلمة السر مفقودة أو غير صالحة.
- **Authorization Errors (401 Unauthorized):** كلمة السر غير صحيحة أو الحساب غير نشط (`Suspended` / `Deactivated`).
- **Success Cases:** مطابقة اسم المستخدم وكلمة السر وحالة الحساب `Active`.
- **Failure Cases:** بيانات تسجيل الدخول خاطئة أو حساب موقوف.

---

### 1.2 `POST /api/v1/auth/refresh`
- **Purpose:** تجديد رمز النفاذ منتهي الصلاحية باستخدام رمز التحديث.
- **Required Role:** جميع الأدوار المسجلة.
- **Request:**
  - **Headers:** `Content-Type: application/json`
  - **Body Payload Schema:**
    ```json
    {
      "refresh_token": "string (Required)"
    }
    ```
- **Response:**
  - **Success (200 OK):**
    ```json
    {
      "statusCode": 200,
      "message": "Access token refreshed successfully",
      "data": {
        "access_token": "JWT String"
      }
    }
    ```
- **Validation Errors (400 Bad Request):** صيغة `refresh_token` غير صحيحة.
- **Authorization Errors (401 Unauthorized):** رمز التحديث منتهي الصلاحية أو ملغى.
- **Success Cases:** تزويد `refresh_token` صالح وغير منتهي.
- **Failure Cases:** رمز تحديث غير صالح أو منتهي.

---

### 1.3 `POST /api/v1/auth/logout`
- **Purpose:** إبطال وإنهاء الجلسة ورموز النفاذ الحالية.
- **Required Role:** أي مستخدم مسجل.
- **Request:**
  - **Headers:** `Authorization: Bearer <AccessToken>`
- **Response:**
  - **Success (200 OK):**
    ```json
    {
      "statusCode": 200,
      "message": "Logout successful"
    }
    ```
- **Validation Errors:** لا يوجد.
- **Authorization Errors (401 Unauthorized):** رمز النفاذ مفقود أو غير صالح.
- **Success Cases:** إلغاء توثيق الرمز الحالي.
- **Failure Cases:** الرمز منتهي الصلاحية مسبقاً.

---

## 2. إدارة المستخدمين (Users)

### 2.1 `POST /api/v1/users`
- **Purpose:** إنشاء حساب جديد للمستخدم في النظام.
- **Required Role:** `ADMIN`
- **Request:**
  - **Headers:** `Authorization: Bearer <AccessToken>`
  - **Body Payload Schema:**
    ```json
    {
      "username": "string (Required, Unique)",
      "email": "string (Required, Email, Unique)",
      "password": "string (Required, Min 8 chars)",
      "full_name": "string (Required)",
      "phone_number": "string (Optional)",
      "role": "ADMIN | STUDENT | TEACHER"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "message": "User account created successfully",
      "data": {
        "id": "UUID",
        "username": "string",
        "email": "string",
        "full_name": "string",
        "role": "ADMIN | STUDENT | TEACHER",
        "account_state": "PendingActivation",
        "created_at": "ISO-8601 Timestamp"
      }
    }
    ```
- **Validation Errors (400 Bad Request):** الحقول المطلوبة مفقودة أو اسم المستخدم/البريد مكرر.
- **Authorization Errors (403 Forbidden):** المستخدم الحالي ليس `ADMIN`.
- **Success Cases:** إدخال بيانات حساب غير مكررة بواسطة الأدمن.
- **Failure Cases:** تكرار اسم المستخدم أو البريد الإلكتروني.

---

### 2.2 `GET /api/v1/users`
- **Purpose:** استعراض قائمة الحسابات مع إمكانية التصفية.
- **Required Role:** `ADMIN`
- **Request:**
  - **Headers:** `Authorization: Bearer <AccessToken>`
  - **Query Parameters:** `role`, `account_state`, `page`, `limit`
- **Response:**
  - **Success (200 OK):**
    ```json
    {
      "statusCode": 200,
      "data": [
        {
          "id": "UUID",
          "username": "string",
          "email": "string",
          "full_name": "string",
          "role": "string",
          "account_state": "string",
          "created_at": "ISO-8601 Timestamp"
        }
      ]
    }
    ```
- **Validation Errors:** معاملات التصفية غير صحيحة.
- **Authorization Errors (403 Forbidden):** نفاذ من دور غير مخول.
- **Success Cases:** جلب الحسابات حسب الصلاحيات.
- **Failure Cases:** عدم وجود نفاذ أدمن.

---

### 2.3 `PATCH /api/v1/users/:id/state`
- **Purpose:** تحديث حالة الحساب (`PendingActivation`, `Active`, `Suspended`, `Deactivated`).
- **Required Role:** `ADMIN`
- **Request:**
  - **Path Parameter:** `id` (UUID)
  - **Body Payload Schema:**
    ```json
    {
      "account_state": "Active | Suspended | Deactivated"
    }
    ```
- **Response:**
  - **Success (200 OK):**
    ```json
    {
      "statusCode": 200,
      "message": "User account state updated successfully",
      "data": {
        "id": "UUID",
        "account_state": "string",
        "updated_at": "ISO-8601 Timestamp"
      }
    }
    ```
- **Validation Errors (400 Bad Request):** حالة حساب غير مجازة في `SYSTEM_STATES.md`.
- **Authorization Errors (403 Forbidden):** نفاذ غير مخول.
- **Success Cases:** انتقالة حالة حساب مجازة ومسموحة.
- **Failure Cases:** محاولة تنفيذ انتقال محظور (`Forbidden Transition`).

---

## 3. إدارة الطلاب (Students)

### 3.1 `POST /api/v1/students`
- **Purpose:** ربط حساب مستخدم بسجل طالب وأكاديميات القسم.
- **Required Role:** `ADMIN`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "user_id": "UUID (Required)",
      "student_number": "string (Required, Unique)",
      "department_id": "UUID (Required)",
      "academic_year_id": "UUID (Required)"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "message": "Student profile created successfully",
      "data": {
        "id": "UUID",
        "student_number": "string",
        "department_id": "UUID",
        "academic_year_id": "UUID"
      }
    }
    ```
- **Validation Errors (400 Bad Request):** الرقم الجامعي مكرر أو المعرفات مفقودة.
- **Authorization Errors (403 Forbidden):** ليس `ADMIN`.
- **Success Cases:** ربط طالب بحساب قائم بنجاح.
- **Failure Cases:** الرقم الجامعي مستخدم مسبقاً.

---

### 3.2 `GET /api/v1/students/:id`
- **Purpose:** جلب ملف وبيانات الطالب.
- **Required Role:** `ADMIN`, `TEACHER`, أو الطالب نفسه (`STUDENT`).
- **Request:**
  - **Path Parameter:** `id` (UUID)
- **Response:**
  - **Success (200 OK):**
    ```json
    {
      "statusCode": 200,
      "data": {
        "id": "UUID",
        "student_number": "string",
        "full_name": "string",
        "email": "string",
        "department_name": "string",
        "academic_year_name": "string"
      }
    }
    ```
- **Validation Errors (404 Not Found):** الطالب غير موجود.
- **Authorization Errors (403 Forbidden):** طالب يحاول قراءة بيانات طالب آخر.
- **Success Cases:** جلب بيانات الطالب المخول.
- **Failure Cases:** محاولة نفاذ غير مصرح بها.

---

## 4. إدارة الأساتذة (Teachers)

### 4.1 `POST /api/v1/teachers`
- **Purpose:** إنشاء وتحديد اختصاص الأستاذ (عملي/نظري/كلاهما).
- **Required Role:** `ADMIN`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "user_id": "UUID (Required)",
      "employee_number": "string (Required, Unique)",
      "teacher_type": "PRACTICAL_TEACHER | THEORETICAL_TEACHER | BOTH",
      "department_id": "UUID (Required)"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "message": "Teacher profile created successfully",
      "data": {
        "id": "UUID",
        "employee_number": "string",
        "teacher_type": "string",
        "department_id": "UUID"
      }
    }
    ```
- **Validation Errors (400 Bad Request):** الرقم الوظيفي مكرر أو النوع غير صحيح.
- **Authorization Errors (403 Forbidden):** ليس `ADMIN`.
- **Success Cases:** إنشاء سجل أستاذ بنجاح.
- **Failure Cases:** تكرار الرقم الوظيفي.

---

## 5. إدارة المندوبين (Delegates)

### 5.1 `POST /api/v1/delegates`
- **Purpose:** تفويض طالب بدور مندوب لشعبة محددة.
- **Required Role:** `ADMIN`, `PRACTICAL_TEACHER`, `THEORETICAL_TEACHER`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "student_id": "UUID (Required)",
      "section_id": "UUID (Required)"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "message": "Delegate assigned successfully",
      "data": {
        "id": "UUID",
        "student_id": "UUID",
        "section_id": "UUID",
        "is_active": true,
        "assigned_by": "UUID"
      }
    }
    ```
- **Validation Errors (400 Bad Request):** الطالب غير مسجل بالشعبة.
- **Authorization Errors (403 Forbidden):** أستاذ يحاول التنديب لشعبة لا يدرسها.
- **Success Cases:** إسناد التنديب لطالب مسجل بالشعبة.
- **Failure Cases:** الطالب غير ينتمي للشعبة.

---

## 6. إدارة الأقسام الأكاديمية (Departments)

### 6.1 `POST /api/v1/departments`
- **Purpose:** إضافة قسم أكاديمي جديد.
- **Required Role:** `ADMIN`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "code": "string (Required, Unique)",
      "name": "string (Required)"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "data": {
        "id": "UUID",
        "code": "string",
        "name": "string",
        "is_active": true
      }
    }
    ```
- **Validation Errors (400 Bad Request):** كود القسم مكرر.
- **Authorization Errors (403 Forbidden):** ليس `ADMIN`.
- **Success Cases:** إضافة القسم بنجاح.
- **Failure Cases:** كود القسم مستخدم مسبقاً.

---

## 7. الهيكل الأكاديمي (Academic Structure)

### 7.1 `POST /api/v1/academic-years`
- **Purpose:** تعريف سنة دراسية جديدة.
- **Required Role:** `ADMIN`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "year_name": "string (Required, e.g. 2025-2026)",
      "start_date": "YYYY-MM-DD",
      "end_date": "YYYY-MM-DD",
      "is_current": "boolean"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "data": {
        "id": "UUID",
        "year_name": "string",
        "is_current": true
      }
    }
    ```
- **Validation Errors (400 Bad Request):** مسمى السنة مكرر أو التواريخ غير منطقية.

---

### 7.2 `POST /api/v1/semesters`
- **Purpose:** إضافة فصل دراسي لسنة أكاديمية.
- **Required Role:** `ADMIN`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "academic_year_id": "UUID (Required)",
      "semester_type": "FIRST | SECOND | SUMMER",
      "is_active": "boolean"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "data": {
        "id": "UUID",
        "academic_year_id": "UUID",
        "semester_type": "string",
        "is_active": true
      }
    }
    ```

---

## 8. المقررات الدراسية (Courses)

### 8.1 `POST /api/v1/courses`
- **Purpose:** إنشاء مقرر دراسي جديد.
- **Required Role:** `ADMIN`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "course_code": "string (Required, Unique)",
      "title": "string (Required)",
      "department_id": "UUID (Required)",
      "credit_hours": "number (Required > 0)"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "data": {
        "id": "UUID",
        "course_code": "string",
        "title": "string",
        "credit_hours": 3
      }
    }
    ```

---

## 9. الشعب والأقسام (Sections)

### 9.1 `POST /api/v1/sections`
- **Purpose:** إنشاء شعبة دراسية مخصصة (عملية أو نظرية) وتعيين الأستاذ.
- **Required Role:** `ADMIN`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "course_id": "UUID (Required)",
      "semester_id": "UUID (Required)",
      "teacher_id": "UUID (Required)",
      "section_type": "PRACTICAL | THEORETICAL",
      "section_number": "string (Required)"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "data": {
        "id": "UUID",
        "course_id": "UUID",
        "section_type": "PRACTICAL",
        "section_number": "01"
      }
    }
    ```

---

## 10. تسجيل الطلاب بالمقررات (Enrollments)

### 10.1 `POST /api/v1/enrollments`
- **Purpose:** تسجيل طالب بشعبة دراسية.
- **Required Role:** `ADMIN`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "student_id": "UUID (Required)",
      "section_id": "UUID (Required)"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "data": {
        "id": "UUID",
        "student_id": "UUID",
        "section_id": "UUID",
        "enrolled_at": "ISO-8601 Timestamp"
      }
    }
    ```
- **Validation Errors (409 Conflict):** الطالب مسجل مسبقاً في هذه الشعبة.

---

## 11. الأجهزة والتوثيق (Devices)

### 11.1 `POST /api/v1/devices/activation-code`
- **Purpose:** توليد رمز تفعيل جهاز مستخدم جديد.
- **Required Role:** `ADMIN`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "user_id": "UUID (Required)"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "data": {
        "id": "UUID",
        "user_id": "UUID",
        "code": "string (Generated Code)",
        "code_state": "Generated",
        "expires_at": "ISO-8601 Timestamp"
      }
    }
    ```

---

### 11.2 `POST /api/v1/devices/bind`
- **Purpose:** تقديم رمز التفعيل وبصمة الجهاز لربط وتوثيق هاتف المستخدم.
- **Required Role:** `STUDENT`, `DELEGATE`, `TEACHER`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "code": "string (Required)",
      "device_identifier": "string (Required, Unique)",
      "device_fingerprint": "string (Required)"
    }
    ```
- **Response:**
  - **Success (200 OK):**
    ```json
    {
      "statusCode": 200,
      "message": "Device bound successfully",
      "data": {
        "device_id": "UUID",
        "device_state": "Bound",
        "bound_at": "ISO-8601 Timestamp"
      }
    }
    ```
- **Validation Errors (400 Bad Request):** رمز تفعيل غير صالح أو منتهي الصلاحية (`Expired`).
- **Authorization Errors (401 Unauthorized):** فشل التوثيق.

---

## 12. جلسات الحضور (Sessions)

### 12.1 `POST /api/v1/sessions`
- **Purpose:** إنشاء وتأكيد مزامنة جلسة حضور من تطبيق الهاتف.
- **Required Role:** `DELEGATE`, `PRACTICAL_TEACHER`, `THEORETICAL_TEACHER`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "section_id": "UUID (Required)",
      "delegate_id": "UUID (Required)",
      "session_state": "Synced",
      "opened_at": "ISO-8601 Timestamp",
      "closed_at": "ISO-8601 Timestamp"
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "data": {
        "id": "UUID",
        "section_id": "UUID",
        "session_state": "Synced"
      }
    }
    ```

---

## 13. سجلات الحضور والتحضير (Attendance)

### 13.1 `POST /api/v1/attendance/manual`
- **Purpose:** تسجيل أو تعديل الحضور يدويًا من قبل الأستاذ المعني.
- **Required Role:** `PRACTICAL_TEACHER`, `THEORETICAL_TEACHER`
- **Request:**
  - **Body Payload Schema:**
    ```json
    {
      "session_id": "UUID (Required)",
      "student_id": "UUID (Required)",
      "attendance_state": "Present | Absent | Late | Excused",
      "reason": "string (Required for Manual Attendance)"
    }
    ```
- **Response:**
  - **Success (200 OK):**
    ```json
    {
      "statusCode": 200,
      "message": "Manual attendance recorded successfully",
      "data": {
        "id": "UUID",
        "attendance_state": "string",
        "attendance_method": "Manual",
        "marked_at": "ISO-8601 Timestamp"
      }
    }
    ```
- **Validation Errors (400 Bad Request):** عدم إدخال مبرر التحضير اليدوي.
- **Authorization Errors (403 Forbidden):** أستاذ يحاول التحضير اليدوي لمادة لا يشرف عليها.

---

## 14. المزامنة والرفع المركزي (Synchronization)

### 14.1 `POST /api/v1/sync`
- **Purpose:** رفع دفعة حزمة طلبات وسجلات الحضور من الخادم المحلي على هاتف المندوب للمركز.
- **Required Role:** `DELEGATE`, `PRACTICAL_TEACHER`, `THEORETICAL_TEACHER`
- **Request:**
  - **Headers:** `Authorization: Bearer <AccessToken>`
  - **Body Payload Schema:**
    ```json
    {
      "session_id": "UUID (Required)",
      "delegate_id": "UUID (Required)",
      "records_count": "number (Required)",
      "attendance_list": [
        {
          "student_id": "UUID (Required)",
          "request_id": "UUID (Required)",
          "attendance_state": "Present | Late",
          "attendance_method": "QR | Biometric",
          "marked_at": "ISO-8601 Timestamp"
        }
      ]
    }
    ```
- **Response:**
  - **Success (201 Created):**
    ```json
    {
      "statusCode": 201,
      "message": "Attendance batch synchronized successfully",
      "data": {
        "sync_record_id": "UUID",
        "session_id": "UUID",
        "sync_state": "Success",
        "processed_count": "number",
        "synced_at": "ISO-8601 Timestamp"
      }
    }
    ```
- **Validation Errors (400 Bad Request):** وجود طلب مكرر بنفس `request_id` أو طالب مكرر بالجلسة.
- **Authorization Errors (403 Forbidden):** المندوب ليس المكلّف بهذه الجلسة.

---

## 15. التقارير والإحصائيات (Reports)

### 15.1 `GET /api/v1/reports/attendance`
- **Purpose:** استخراج وتنزيل تقارير الحضور والغياب والإحصائيات الشاملة.
- **Required Role:** `ADMIN`, `PRACTICAL_TEACHER`, `THEORETICAL_TEACHER`, `STUDENT` (لحضوره الشخصي فقط)
- **Request:**
  - **Query Parameters:** `course_id`, `section_id`, `student_id`, `start_date`, `end_date`
- **Response:**
  - **Success (200 OK):**
    ```json
    {
      "statusCode": 200,
      "data": {
        "total_sessions": "number",
        "total_present": "number",
        "total_absent": "number",
        "attendance_percentage": "number (Float)",
        "records": [
          {
            "session_id": "UUID",
            "session_date": "ISO-8601",
            "student_name": "string",
            "attendance_state": "string",
            "attendance_method": "string"
          }
        ]
      }
    }
    ```

---

## 16. التدقيق والعمليات (Audit)

### 16.1 `GET /api/v1/audit-logs`
- **Purpose:** استعراض سجل الأحداث الحساسة وتتبع التدقيق الأمني بالنظام.
- **Required Role:** `ADMIN`
- **Request:**
  - **Query Parameters:** `user_id`, `action`, `entity_type`, `page`, `limit`
- **Response:**
  - **Success (200 OK):**
    ```json
    {
      "statusCode": 200,
      "data": [
        {
          "id": "UUID",
          "user_id": "UUID",
          "action": "string",
          "entity_type": "string",
          "entity_id": "UUID",
          "payload": "string",
          "timestamp": "ISO-8601 Timestamp"
        }
      ]
    }
    ```
- **Authorization Errors (403 Forbidden):** محاولة نفاذ من دور غير `ADMIN`.

---