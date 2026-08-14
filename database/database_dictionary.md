# قاموس البيانات المنطقي الرسمي | database_dictionary.md
## نظام الحضور الجامعي الذكي (University Attendance System)

---

> [!IMPORTANT]
> **قاعدة التطابق المنطقي والصارم مع قاموس المصطلحات والحالات**
> 
> يحدد هذا المستند التصميم المنطقي الشامل لجداول قاعدة البيانات لجميع الكيانات المعتمدة في المشروع.
> تلتزم جميع الجداول والحقول بالتسميات الإنجليزية الرسمية المعرفة في `PROJECT_GLOSSARY.md` وتدعم بشكل كامل حالات النظام المعرفة في `SYSTEM_STATES.md`.

---

## 1. جدول المستخدمين (`users`)

- **Table Name:** `users`
- **Purpose:** تخزين الحسابات الأساسية والبيانات التعريفية لجميع المستخدمين بجميع الأدوار.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد الأساسي للمستخدم | - |
| `username` | VARCHAR(50) | No | Yes | No | اسم المستخدم لتسجيل الدخول | - |
| `email` | VARCHAR(100) | No | Yes | No | البريد الإلكتروني الرسمي | - |
| `password_hash` | VARCHAR(255) | No | No | No | كلمة المرور المشفرة | - |
| `full_name` | VARCHAR(150) | No | No | No | الاسم الكامل الرسمي للمستخدم | - |
| `phone_number` | VARCHAR(20) | Yes | No | No | رقم الهاتف المحمول | - |
| `role` | VARCHAR(30) | No | No | No | نوع الدور (`ADMIN`, `STUDENT`, `TEACHER`) | - |
| `account_state` | VARCHAR(30) | No | No | No | حالة الحساب (`PendingActivation`, `Active`, `Suspended`, `Deactivated`) | - |
| `created_at` | TIMESTAMP | No | No | No | تاريخ ووقت إنشاء الحساب | - |
| `updated_at` | TIMESTAMP | No | No | No | تاريخ ووقت آخر تحديث | - |

---

## 2. جدول الطلاب (`students`)

- **Table Name:** `students`
- **Purpose:** حفظ البيانات الأكاديمية والشخصية المخصصة للطالب المربوط بحسابه.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | Yes | المعرف الفريد للطالب ومفتاح أجنبي لحساب المستخدم | `users(id)` |
| `student_number` | VARCHAR(30) | No | Yes | No | الرقم الجامعي الرسمي للطالب | - |
| `department_id` | UUID | No | No | Yes | القسم الأكاديمي الذي ينتمي إليه الطالب | `departments(id)` |
| `academic_year_id` | UUID | No | No | Yes | السنة الدراسية الحالية المقيد بها | `academic_years(id)` |
| `created_at` | TIMESTAMP | No | No | No | تاريخ ووقت التسجيل | - |

---

## 3. جدول التدريسيين (`teachers`)

- **Table Name:** `teachers`
- **Purpose:** حفظ البيانات الوظيفية للكادر التدريسي (الأستاذ العملي والنظري).
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | Yes | المعرف الفريد للأستاذ ومفتاح أجنبي لحساب المستخدم | `users(id)` |
| `employee_number` | VARCHAR(30) | No | Yes | No | الرقم الوظيفي الرسمي للأستاذ | - |
| `teacher_type` | VARCHAR(30) | No | No | No | نوع الاختصاص (`PRACTICAL_TEACHER`, `THEORETICAL_TEACHER`, `BOTH`) | - |
| `department_id` | UUID | No | No | Yes | القسم الأكاديمي الرئيسي المنتمي إليه | `departments(id)` |
| `created_at` | TIMESTAMP | No | No | No | تاريخ إنشاء السجل | - |

---

## 4. جدول النواب / المندوبين (`delegates`)

- **Table Name:** `delegates`
- **Purpose:** توثيق تفويض الطالب بدور مندوب لإدارة وتفعيل الخادم المحلي بالجلسات.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد لسجل التنديب | - |
| `student_id` | UUID | No | No | Yes | معرف الطالب الممنوح صلاحية المندوب | `students(id)` |
| `section_id` | UUID | No | No | Yes | الشعبة الأكاديمية المكلّف بإدارتها | `sections(id)` |
| `is_active` | BOOLEAN | No | No | No | حالة التكليف بالمندوبية | - |
| `assigned_by` | UUID | No | No | Yes | معرف الأستاذ أو الأدمن الذي قام بالتكليف | `users(id)` |
| `created_at` | TIMESTAMP | No | No | No | تاريخ صدور التكليف | - |

---

## 5. جدول الأقسام الأكاديمية (`departments`)

- **Table Name:** `departments`
- **Purpose:** حفظ بيانات الأقسام العلمية والكليات داخل الجامعة.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد للقسم | - |
| `code` | VARCHAR(20) | No | Yes | No | كود القسم الأكاديمي الموحد | - |
| `name` | VARCHAR(150) | No | No | No | اسم القسم الأكاديمي بالكامل | - |
| `is_active` | BOOLEAN | No | No | No | حالة نشاط القسم | - |
| `created_at` | TIMESTAMP | No | No | No | تاريخ إنشاء القسم | - |

---

## 6. جدول السنوات الدراسية (`academic_years`)

- **Table Name:** `academic_years`
- **Purpose:** تعريف وتخزين السنوات الأكاديمية الجامعية.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد للسنة الدراسية | - |
| `year_name` | VARCHAR(50) | No | Yes | No | المسمى الأكاديمي للسنة (مثل 2025-2026) | - |
| `start_date` | DATE | No | No | No | تاريخ بداية السنة الدراسية | - |
| `end_date` | DATE | No | No | No | تاريخ نهاية السنة الدراسية | - |
| `is_current` | BOOLEAN | No | No | No | هل هي السنة الدراسية الحالية | - |

---

## 7. جدول الفصول الدراسية (`semesters`)

- **Table Name:** `semesters`
- **Purpose:** تقسيم السنة الدراسية إلى فصول دراسية (أول، ثاني، صيفي).
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد للفصل الدراسي | - |
| `academic_year_id` | UUID | No | No | Yes | مفتاح أجنبي للسنة الدراسية التابع لها | `academic_years(id)` |
| `semester_type` | VARCHAR(20) | No | No | No | نوع الفصل (`FIRST`, `SECOND`, `SUMMER`) | - |
| `is_active` | BOOLEAN | No | No | No | هل الفصل نشط حالياً | - |

---

## 8. جدول المقررات الدراسية (`courses`)

- **Table Name:** `courses`
- **Purpose:** تخزين المواد والمقررات الدراسية المعتمدة في الخطة التعليمية.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد للمقرر | - |
| `course_code` | VARCHAR(30) | No | Yes | No | رمز المقرر الموحد | - |
| `title` | VARCHAR(150) | No | No | No | عنوان المقرر الدراسي | - |
| `department_id` | UUID | No | No | Yes | القسم العلمي المالك للمادة | `departments(id)` |
| `credit_hours` | INTEGER | No | No | No | عدد الساعات المعتمدة | - |

---

## 9. جدول الشعب / الفئات (`sections`)

- **Table Name:** `sections`
- **Purpose:** تقسيم المقررات إلى شعب عملية ونظرية وتعيين التدريسيين المباشرين.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد للشعبة | - |
| `course_id` | UUID | No | No | Yes | المقرر التابعة له الشعبة | `courses(id)` |
| `semester_id` | UUID | No | No | Yes | الفصل الدراسي المفتوحة به | `semesters(id)` |
| `teacher_id` | UUID | No | No | Yes | الأستاذ المشرف على الشعبة | `teachers(id)` |
| `section_type` | VARCHAR(20) | No | No | No | نوع الشعبة (`PRACTICAL`, `THEORETICAL`) | - |
| `section_number` | VARCHAR(10) | No | No | No | رقم الشعبة | - |

---

## 10. جدول تسجيل الطلاب بالمقررات (`enrollments`)

- **Table Name:** `enrollments`
- **Purpose:** ربط الطلاب بالشعب والمقررات الدراسية المسجلين فيها رسمياً.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد لسجل التسجيل | - |
| `student_id` | UUID | No | No | Yes | الطالب المسجل بالمادة | `students(id)` |
| `section_id` | UUID | No | No | Yes | الشعبة المسجل بها | `sections(id)` |
| `enrolled_at` | TIMESTAMP | No | No | No | تاريخ ووقت التسجيل بالماة | - |

---

## 11. جدول الأجهزة الموثقة (`devices`)

- **Table Name:** `devices`
- **Purpose:** توثيق هواتف المستخدمين وتخزين حالة التوثيق وبصمة الجهاز الرقمية.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد لجهاز المستخدم | - |
| `user_id` | UUID | No | No | Yes | المستخدم المالك للجهاز | `users(id)` |
| `device_identifier` | VARCHAR(255) | No | Yes | No | المعرف الرقمي الفريد للهاتف | - |
| `device_fingerprint` | TEXT | No | No | No | البصمة المشفرة لهاتف المستخدم | - |
| `device_state` | VARCHAR(30) | No | No | No | حالة الجهاز (`Unregistered`, `PendingVerification`, `Bound`, `Revoked`) | - |
| `bound_at` | TIMESTAMP | Yes | No | No | تاريخ نجاح توثيق الجهاز | - |

---

## 12. جدول رموز التفعيل (`activation_codes`)

- **Table Name:** `activation_codes`
- **Purpose:** إدارة رموز التفعيل الصادرة لربط وتوثيق الأجهزة بالحسابات.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد لسجل الرمز | - |
| `user_id` | UUID | No | No | Yes | المستخدم المستهدف بالتفعيل | `users(id)` |
| `code` | VARCHAR(50) | No | No | No | رمز التفعيل الآمن | - |
| `code_state` | VARCHAR(30) | No | No | No | حالة الرمز (`Generated`, `Sent`, `Used`, `Expired`, `Invalidated`) | - |
| `expires_at` | TIMESTAMP | No | No | No | تاريخ ووقت انتهاء صلاحية الرمز | - |
| `used_at` | TIMESTAMP | Yes | No | No | تاريخ ووقت استهلاك الرمز | - |

---

## 13. جدول جلسات الحضور (`sessions`)

- **Table Name:** `sessions`
- **Purpose:** السجل الأساسي لجلسات التحضير المفتوحة والمغلقة والمزامنة للمحاضرات.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد لجلسة الحضور | - |
| `section_id` | UUID | No | No | Yes | الشعبة الأكاديمية للجلسة | `sections(id)` |
| `delegate_id` | UUID | No | No | Yes | المندوب المستضيف للجلسة المحلية | `delegates(id)` |
| `session_state` | VARCHAR(30) | No | No | No | حالة الجلسة (`Created`, `Opened`, `Active`, `Closing`, `Closed`, `Synced`) | - |
| `opened_at` | TIMESTAMP | Yes | No | No | تاريخ وقت فتح الجلسة محلياً | - |
| `closed_at` | TIMESTAMP | Yes | No | No | تاريخ وقت إغلاق الجلسة محلياً | - |
| `synced_at` | TIMESTAMP | Yes | No | No | تاريخ وقت نجاح المزامنة مع المركز | - |

---

## 14. جدول سجلات الحضور النهائية (`attendance`)

- **Table Name:** `attendance`
- **Purpose:** تخزين سجلات الحضور المعتمدة والنهائية المزامنة في قاعدة البيانات المركزية.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد لسجل الحضور | - |
| `session_id` | UUID | No | No | Yes | جلسة الحضور التابع لها السجل | `sessions(id)` |
| `student_id` | UUID | No | No | Yes | الطالب المحضر | `students(id)` |
| `attendance_state` | VARCHAR(30) | No | No | No | حالة الحضور النهائية (`Present`, `Absent`, `Late`, `Excused`) | - |
| `attendance_method` | VARCHAR(30) | No | No | No | طريقة الحضور المتبعة (`QR`, `Biometric`, `Manual`) | - |
| `marked_at` | TIMESTAMP | No | No | No | تاريخ ووقت تسجيل الحضور | - |

---

## 15. جدول طلبات الحضور المحلية (`attendance_requests`)

- **Table Name:** `attendance_requests`
- **Purpose:** السجل المحلي لطلبات تسجيل الحضور الواردة للخادم المحلي على هاتف المندوب.
- **Primary Key:** `request_id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `request_id` | UUID | No | Yes | No | المعرف الفريد الأحادي لطلب الحضور منعًا للتكرار | - |
| `session_id` | UUID | No | No | Yes | جلسة الحضور المحلية النشطة | `sessions(id)` |
| `student_id` | UUID | No | No | Yes | الطالب صاحب طلب الحضور | `students(id)` |
| `request_state` | VARCHAR(30) | No | No | No | حالة الطلب المحلي (`Received`, `Validating`, `Accepted`, `Rejected`, `QueuedForSync`) | - |
| `nonce` | VARCHAR(100) | No | No | No | الرمز العشوائي الأحادي المستخدم في الطلب | - |
| `timestamp` | BIGINT | No | No | No | الطابع الزمني بالمللي ثانية لصدور الطلب | - |

---

## 16. جدول جلسات رمز الاستجابة السريعة (`qr_sessions`)

- **Table Name:** `qr_sessions`
- **Purpose:** إدارة وتوليد رموز الـ Dynamic QR المتغيرة أثناء الجلسة المفتوحة.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد لسجل الـ QR | - |
| `session_id` | UUID | No | No | Yes | جلسة الحضور المفتوحة | `sessions(id)` |
| `current_nonce` | VARCHAR(100) | No | Yes | No | الرمز الأحادي العشوائي للـ QR المعروض حالياً | - |
| `qr_state` | VARCHAR(30) | No | No | No | حالة الرمز (`Generated`, `Active`, `Expired`, `Invalidated`) | - |
| `valid_until` | TIMESTAMP | No | No | No | تاريخ ووقت نهاية صلاحية الرمز المعروض | - |
| `generated_at` | TIMESTAMP | No | No | No | تاريخ ووقت توليد الرمز | - |

---

## 17. جدول قوالب البصمة الحيوية (`biometric_templates`)

- **Table Name:** `biometric_templates`
- **Purpose:** التخزين الآمن والمشفر لنماذج التحقق الحيوي الخاصة بالطلاب للتحقق المحلي.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد لقالب البصمة | - |
| `student_id` | UUID | No | Yes | Yes | الطالب المالك للبصمة الحيوية | `students(id)` |
| `template_hash` | VARCHAR(255) | No | Yes | No | التجزئة المشفرة لبصمة الطالب | - |
| `encrypted_template_data` | TEXT | No | No | No | بيانات النموذج الحيوي المشفرة وفق ضوابط الأمان | - |
| `created_at` | TIMESTAMP | No | No | No | تاريخ حفظ القالب الحيوي | - |

---

## 18. جدول سجلات المزامنة (`sync_records`)

- **Table Name:** `sync_records`
- **Purpose:** توثيق دفعة المزامنة المنقولة من الخادم المحلي على هاتف المندوب إلى الخادم المركزي NestJS.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد لسجل المزامنة المولد مركزياً | - |
| `session_id` | UUID | No | No | Yes | جلسة الحضور التي تم مزامنة بياناتها | `sessions(id)` |
| `delegate_id` | UUID | No | No | Yes | المندوب الذي نفّذ رفع حزمة المزامنة | `delegates(id)` |
| `sync_state` | VARCHAR(30) | No | No | No | حالة المزامنة (`Idle`, `Preparing`, `Syncing`, `Success`, `Failed`) | - |
| `records_count` | INTEGER | No | No | No | عدد سجلات الحضور المرفوعة في الدفعة | - |
| `synced_at` | TIMESTAMP | No | No | No | تاريخ ووقت نجاح عملية المزامنة | - |

---

## 19. جدول سجلات التدقيق والعمليات (`audit_logs`)

- **Table Name:** `audit_logs`
- **Purpose:** التوثيق الآمن غير القابل للتعديل لكافة العمليات الحساسة والتغييرات الإدارية بالنظام.
- **Primary Key:** `id` (UUID)

### Fields:
| Field Name | Data Type | Nullable | Unique | Foreign Key | Description | Related Table |
|---|---|---|---|---|---|---|
| `id` | UUID | No | Yes | No | المعرف الفريد لسجل التدقيق | - |
| `user_id` | UUID | Yes | No | Yes | المستخدم المنفذ للعملية | `users(id)` |
| `action` | VARCHAR(100) | No | No | No | مسمى العملية الحساسة المُنَفَّذة | - |
| `entity_type` | VARCHAR(50) | No | No | No | نوع الكيان المتأثر (مثل `Attendance`, `Device`) | - |
| `entity_id` | UUID | Yes | No | No | المعرف الفريد للكيان المتأثر | - |
| `payload` | TEXT | Yes | No | No | تفاصيل البيانات والطلب المشفرة أو الهيكلية | - |
| `timestamp` | TIMESTAMP | No | No | No | وقت وتاريخ تسجيل الحدث | - |

---

