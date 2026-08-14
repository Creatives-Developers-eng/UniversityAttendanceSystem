# قواعد التسمية والمعايير البرمجية الموحدة | CODING_RULES.md
## نظام الحضور الجامعي الذكي (University Attendance System)

---

> [!IMPORTANT]
> **قاعدة التوافق والالتزام بالقاموس الرسمي**
> 
> تفصّل هذه الوثيقة معايير التسمية الموحدة (**Naming Conventions**) لجميع أجزاء المشروع، وتضمن التوافق التام والتكامل المنطقي بين تقنيات المشروع الرسمية: **Flutter (Dart)**, **NestJS (TypeScript)**, **PostgreSQL (SQL)**, و **REST API**.
> **قاعدة المصطلحات:** يُمنع تعديل أي اسم مصطلح رسمي معرف في `docs/PROJECT_GLOSSARY.md`.

---

## 1. قواعد توزيع اللغات في المشروع (Language Division Rules)

- **اللغة العربية:**
  - واجهات المستخدم (`User Interface` / UI Display Strings / Dialogs).
  - الوثائق والشروحات والتعليقات الموضحة (`Documentation`, `Markdown Docs`, `Explanations`).
  - رسائل الخطأ والتنبيهات الموجهة للمستخدمين.

- **اللغة الإنجليزية:**
  - كود المشروع ومُعرفات البرمجة (`Code Identifiers`).
  - أسماء الملفات والمجلدات (`File & Folder Names`).
  - أسماء الكلاسات والدوال والمتغيرات (`Classes`, `Methods`, `Variables`).
  - كائنات ومخططات قاعدة البيانات (`Database Tables`, `Columns`, `Constraints`, `Indexes`).
  - مسارات ونقاط نهاية الـ REST API ومفاتيح الـ JSON.

---

## 2. جدول قواعد التسمية الموحدة الشامل (Naming Conventions Table)

| العنصر البرمجي (Component) | صيغة التسمية (Convention) | مثال توضيحي (Example) | ملاحظات وقواعد خاصة |
| :--- | :--- | :--- | :--- |
| **Folder Names** | `snake_case` | `academic_structure/`, `session_management/` | أحرف صغيرة، الفصل بشرطة سفلى |
| **File Names (Flutter)** | `snake_case.dart` | `attendance_session_screen.dart`, `user_repository.dart` | الالتزام بالـ Dart Linter الرسمي |
| **File Names (NestJS)** | `kebab-case.ts` | `users.service.ts`, `create-user.dto.ts` | استخدام النمط القياسي لـ NestJS |
| **File Names (SQL)** | `snake_case.sql` | `01_init.sql`, `02_tables.sql` | البدء برقم الترتيب عند الحاجة |
| **Classes** | `PascalCase` | `AttendanceService`, `StudentRepository` | اسم الكائن يبدأ بحرف كبير |
| **Methods / Functions** | `camelCase` | `markAttendance()`, `verifySession()` | أفعال واضحة تعبر عن الوظيفة |
| **Variables** | `camelCase` | `sessionId`, `studentNumber`, `isCurrent` | تعبير واضح عن المحتوى والنوع |
| **Constants** | `SCREAMING_SNAKE_CASE` | `MAX_RETRY_ATTEMPTS`, `DEFAULT_PORT` | أحرف كبيرة مفصولة بشرطة سفلى |
| **Enums (Class)** | `PascalCase` | `AccountState`, `SessionState` | الاسم المفرد للكلاس |
| **Enums (Values)** | `PascalCase` / `SCREAMING_SNAKE_CASE` | `PendingActivation`, `Active`, `PRACTICAL_TEACHER` | مطابقة القيم في `SYSTEM_STATES.md` |
| **DTOs (Class)** | `PascalCase` (مع لاحقة `Dto`) | `CreateUserDto`, `SyncBatchDto` | كائنات نقل البيانات |
| **DTOs (JSON Payload)**| `snake_case` | `user_id`, `account_state`, `session_id` | مفاتيح الـ JSON تكون دائمًا `snake_case` |
| **Services** | `PascalCase` (مع لاحقة `Service`)| `AuthService`, `SessionsService` | طبقة منطق الأعمال |
| **Repositories** | `PascalCase` (مع لاحقة `Repository`)| `UserRepository`, `AttendanceRepository` | طبقة التعامل مع البيانات |
| **Entities** | `PascalCase` (مع لاحقة `Entity` أو المفرد)| `UserEntity`, `SessionEntity` | النماذج المقترنة بقاعدة البيانات |
| **Models** | `PascalCase` (مع لاحقة `Model`) | `StudentModel`, `DeviceModel` | نماذج البيانات في الموبايل والفرونت إند |
| **API Endpoints** | `/api/v1/` + `kebab-case` | `/api/v1/academic-years`, `/api/v1/devices/activation-code` | صيغة الجمع والمسار القياسي |
| **Database Tables** | `snake_case` (صيغة الجمع) | `departments`, `academic_years`, `students` | أسماء الجداول بصيغة الجمع |
| **Database Columns** | `snake_case` | `student_id`, `account_state`, `created_at` | مطابقة لـ `database_dictionary.md` |
| **Foreign Keys** | `<entity_singular>_id` | `department_id`, `section_id`, `user_id` | معرف الكائن المفرد متبوعاً بـ `_id` |
| **Primary Keys** | `id` (أو `<entity>_id`) | `id`, `request_id` | معرف UUID مفرد |
| **Database Indexes** | `idx_<table_name>_<column_name>`| `idx_users_role`, `idx_sessions_state` | بادئة `idx_` متبوعة باسم الجدول والحقل |
| **Database Constraints**| `uq_` / `chk_` | `uq_session_student`, `chk_session_state` | بادئة القيد المحددة لنوعه |

---

## 3. التوافق العابر للطبقات (Cross-Tech Compatibility Matrix)

لضمان سلاسة انتقال البيانات عبر طبقات التطبيق المخلفة:

1. **الـ REST API (JSON):** تستخدم المفاتيح دائمًا صيغة **`snake_case`** (مثل `student_number`, `session_state`).
2. **الـ NestJS (TypeScript):**
   - الكلاسات والـ DTOs تستخدم **`PascalCase`**.
   - الخصائص الداخلية في الكلاسات تستخدم **`camelCase`**، ويتم عمل mapping تلقائي محلي لخصائص الـ JSON الـ `snake_case` عند الاستلام/الإرسال.
3. **الـ Flutter (Dart):**
   - الكلاسات والـ Models تستخدم **`PascalCase`**.
   - المتغيرات والخصائص تستخدم **`camelCase`**، مع استخدام `json_serializable` لربط حقول الـ `snake_case` القادمة من الـ API.
4. **الـ PostgreSQL (Database):**
   - الجداول والحقول والفهارس تستخدم **`snake_case`** حصرياً دون أي تغيير.

---