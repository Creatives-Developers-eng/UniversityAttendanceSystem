# تقرير التدقيق والتوزيع الشامل لقائد المشروع | LEADER_DISTRIBUTION_MASTER_REPORT.md
## نظام الحضور الجامعي الذكي (University Attendance System)

---

> [!IMPORTANT]
> **دليل وخطة التوزيع والتدقيق المعتمدة لقائد المشروع (Project Leader Master Audit & Distribution Plan)**
> يُعد هذا التقرير المرجع التشغيلي الكامل والتفصيلي لقائد المشروع لإدارة دورة حياة تطوير النظام، وتوزيع الحزم للأعضاء الأربعة، ومراقبة التقدم، ومراجعة التسليمات، وإجراء الدمج الآمن بدون أي انحراف معماري.

---

## 1. الملخص التنفيذي (Executive Summary)

تم إجراء تدقيق شامل ومطابقة تفصيلية لكافة ملفات الحزمة المشتركة (`team_package/`) ونظام البرومبتات (`prompts/`) لجميع أفراد الفريق:
- **الحالة العامة للجاهزية:** `TEAM PROMPT SYSTEM = READY (100% OPERATIONAL)`
- **إجمالي ملفات البرومبتات والتوثيق المنشأة:** **188 ملف Markdown** موزع بدقة واحترافية.
- **توزيع ملفات النظام:**
  - **ملفات قائد المشروع (`leader/`):** 19 ملفاً تشغيلياً وتدقيقياً.
  - **الملفات المشتركة (`shared/`):** 8 ملفات (نظام التصميم، البرومبت الأساسي، حلقات المراجعة، مصفوفة الملكية).
  - **فهرس التشغيل العام (`TEAM_PROMPT_INDEX.md`):** ملف واحد يربط كافة السلاسل التنفيذية.
  - **حقائب الأعضاء الأربعة (`members/`):** 160 ملفاً موزعة على 4 أعضاء.
- **مبدأ العزل المعماري:** `team_package/` نسخة مرجعية للقراءة فقط (`Read-Only Reference`)، ويعمل كل عضو في مساحة عمل (`Workspace`) مستقلة مخصصة لنطاقه الحصري.

---

## 2. نظام برومبتات الفريق الحالي (Current Team Prompt System)

يعتمد النظام على هيكلية ثلاثية الطبقات:
1. **الطبقة المرجعية المشتركة (Shared Foundation):** تحوي الدستور، القاموس، الحالات، قواعد الكود، عقود الـ API، ومخططات DDL، ونظام التصميم الموحد (`UI_UX_SYSTEM.md`).
2. **الطبقة التنفيذية للأعضاء (Member Execution Chains):** سلاسل متتابعة تتكون من أزواج (`*_EXECUTE.md` متبوعاً بـ `*_TEST.md`) تضمن عدم انتقال أي عضو لمرحلة تالية قبل اجتياز الاختبارات والمراجعة السحابية.
3. **طبقة الحوكمة والدمج للقائد (Leader Intake & Governance):** مجموعة برومبتات متخصصة لاستلام المخرجات، وفحص العقود، والتأكد من عدم وجود تعارضات أو تسريب بيانات، ثم الدمج الآمن وفحص الانحدار (`Zero Regression`).

---

## 3. الشجرة الكاملة للحزمة المشتركة (Full team_package Tree)

```text
team_package/
├── README.md                                  # دليل الحزمة الشامل وقواعد الاستخدام والوصول
├── TEAM_START_HERE.md                         # الدليل الإرشادي الإلزامي للبدء والترتيب الموحد للقراءة (31 نقطة)
├── VERSION.md                                 # سجل الإصدارات وحالات البناء والبيئة والحالة الفنية
│
├── api_contract/                              # عقود الـ REST API الرسمية للنظام
│   ├── API_SPECIFICATION.md                   # العقد الشامل لكافة الـ Endpoints والـ DTOs والـ Roles
│   ├── README.md
│   ├── endpoints/
│   ├── errors/
│   └── models/
│
├── database/                                  # قاموس ومخططات DDL وقواعد البيانات الرسمية
│   ├── database_dictionary.md                 # القاموس التفصيلي للجداول والحقول والقيود
│   ├── erd/
│   ├── migrations/
│   ├── schema/
│   │   ├── 01_init.sql
│   │   ├── 02_tables.sql
│   │   ├── 03_indexes.sql
│   │   └── schema.sql
│   └── seed/
│
├── docs/                                      # الدستور والقوانين الحاكمة والقواعد المعرفية وقواعد الكود
│   ├── AI_DEVELOPMENT_RULES.md                # قواعد استخدام أدوات الذكاء الاصطناعي
│   ├── CODING_RULES.md                        # قواعد الكود النظيف والتسميات
│   ├── INTEGRATION_RULES.md                   # قواعد الدمج والتكامل
│   ├── PROJECT_CONSTITUTION.md                # دستور المشروع والمبادئ الحاكمة
│   ├── PROJECT_GLOSSARY.md                    # قاموس المصطلحات الصارم
│   ├── PROJECT_OVERVIEW.md                    # النظرة العامة على النظام
│   ├── PROJECT_ROLES.md                       # وثيقة الأدوار والصلاحيات الرسمية
│   ├── README.md
│   ├── SYSTEM_ARCHITECTURE.md                 # المعمارية الشاملة للأنظمة المركزية والمحلية
│   ├── SYSTEM_SCOPE.md                        # حدود ونطاق النظام
│   └── SYSTEM_STATES.md                       # وثيقة حالات الكيانات والأنظمة
│
├── integration/                               # أدوات وقوالب التسليم والدمج الرسمية
│   └── handoff/
│       └── HANDOFF_TEMPLATE.md                # القالب الرسمي الإلزامي لتسليم المهام
│
├── local_protocol/                            # بروتوكولات الخادم المحلي والـ QR والتحقق الحيوي والمزامنة
│   ├── LOCAL_SERVER_PROTOCOL.md               # بروتوكول الخادم المحلي بهاتف المندوب
│   ├── README.md
│   ├── attendance_protocol/
│   ├── biometric_protocol/
│   ├── discovery_protocol/
│   ├── qr_protocol/
│   ├── session_protocol/
│   └── synchronization_protocol/
│
├── prompts/                                   # نظام البرومبتات الشامل (188 ملفاً)
│   ├── TEAM_PROMPT_INDEX.md                   # الفهرس العام ودليل التشغيل
│   │
│   ├── shared/                                # 8 ملفات مشتركة
│   │   ├── UI_UX_SYSTEM.md
│   │   ├── TEAM_AI_BASE_PROMPT.md
│   │   ├── CLOUD_REVIEW_PROMPT.md
│   │   ├── CLOUD_TO_IDE_REVIEW_LOOP.md
│   │   ├── FOLDER_OWNERSHIP.md
│   │   ├── HANDOFF_INSTRUCTIONS.md
│   │   ├── COMMON_TEST_PROMPT.md
│   │   └── FINAL_MEMBER_QA_CHECKLIST.md
│   │
│   ├── leader/                                # 19 ملفاً لقائد المشروع
│   │   ├── 00_LEADER_README.md
│   │   ├── 01_DISTRIBUTE_TEAM_PACKAGE.md
│   │   ├── 02_DISTRIBUTE_OWAB.md
│   │   ├── 03_DISTRIBUTE_MOHAMMED_ALAWADI.md
│   │   ├── 04_DISTRIBUTE_MOHAMMED_ALAYDAROUS.md
│   │   ├── 05_DISTRIBUTE_MISHAL.md
│   │   ├── 06_TEAM_PROGRESS_TRACKER.md
│   │   ├── 07_MEMBER_INTAKE_POLICY.md
│   │   ├── 08_INCOMING_REVIEW_MASTER_PROMPT.md
│   │   ├── 09_CONTRACT_COMPATIBILITY_PROMPT.md
│   │   ├── 10_DEPENDENCY_CONFLICT_PROMPT.md
│   │   ├── 11_UI_UX_REVIEW_PROMPT.md
│   │   ├── 12_SECURITY_REVIEW_PROMPT.md
│   │   ├── 13_BUILD_TEST_REVIEW_PROMPT.md
│   │   ├── 14_INTEGRATION_PLAN_PROMPT.md
│   │   ├── 15_MERGE_EXECUTION_PROMPT.md
│   │   ├── 16_REGRESSION_TEST_PROMPT.md
│   │   ├── 17_MEMBER_ACCEPTANCE_PROMPT.md
│   │   └── 18_FINAL_TEAM_INTEGRATION_PROMPT.md
│   │
│   └── members/                               # 160 ملفاً للأعضاء الأربعة
│       ├── 01_OWAB_MOBILE/                    # 28 ملفاً
│       ├── 02_MOHAMMED_ALAWADI_BIOMETRIC/     # 36 ملفاً
│       ├── 03_MOHAMMED_ALAYDAROUS_LOCAL/      # 38 ملفاً
│       └── 04_MISHAL_ADMIN_WEB/               # 58 ملفاً
│
├── security/                                  # سياسات الأمان والتشفير وتوثيق الأجهزة
│   ├── README.md
│   ├── SECURITY_SPECIFICATION.md              # المواصفات الأمنية الشاملة
│   ├── authentication/
│   ├── authorization/
│   ├── cryptography/
│   ├── data_security/
│   └── device_security/
│
└── shared/                                    # الثوابت والنماذج المشتركة المعتمدة
```

---

## 4. التحليل التفصيلي لملفات قائد المشروع (Leader Package Analysis)

| اسم الملف (English Name) | المعنى بالعربية | الغرض الوظيفي (Purpose) | متى يُستخدم؟ | من يستخدمه؟ | ما قبله؟ | ما بعده؟ |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `00_LEADER_README.md` | دليل قائد المشروع | تقديم خارطة الطريق ومسؤوليات القائد | عند بدء إدارة الفريق | قائد المشروع | استلام المشروع | `01_DISTRIBUTE_TEAM_PACKAGE` |
| `01_DISTRIBUTE_TEAM_PACKAGE.md` | توزيع الحزمة المشتركة | شرح تجهيز ونسخ `team_package` كمرجع | قبل توزيع مهام الأعضاء | قائد المشروع | `00_LEADER_README` | ملفات التوزيع الخاصة بالأعضاء |
| `02_DISTRIBUTE_OWAB.md` | توزيع مهمة أواب | تحديد ما ينسخ وما يحظر لأواب النزيلي | عند تسليم مهمة Mobile | قائد المشروع | `01_DISTRIBUTE_TEAM_PACKAGE` | بدء أواب في `01_ANALYZE` |
| `03_DISTRIBUTE_MOHAMMED_ALAWADI.md` | توزيع مهمة محمد العواضي | تحديد نطاق ومخرجات محرك البصمة | عند تسليم مهمة البصمة | قائد المشروع | `01_DISTRIBUTE_TEAM_PACKAGE` | بدء العواضي في `01_ANALYZE` |
| `04_DISTRIBUTE_MOHAMMED_ALAYDAROUS.md` | توزيع مهمة محمد العيدروس | تحديد نطاق الخادم المحلي والـ QR | عند تسليم مهمة Local Server | قائد المشروع | `01_DISTRIBUTE_TEAM_PACKAGE` | بدء العيدروس في `01_ANALYZE` |
| `05_DISTRIBUTE_MISHAL.md` | توزيع مهمة مشعل الحاج | تحديد نطاق لوحة تحكم الويب | عند تسليم مهمة Admin Web | قائد المشروع | `01_DISTRIBUTE_TEAM_PACKAGE` | بدء مشعل في `01_ANALYZE` |
| `06_TEAM_PROGRESS_TRACKER.md` | متتبع تقدم الفريق | جدول متابعة حالات مراحل الأعضاء | طوال فترة التطوير | قائد المشروع | أي تغيير في حالة مرحلة | تحديث الحالة إلى `ACCEPTED` |
| `07_MEMBER_INTAKE_POLICY.md` | سياسة استلام المخرجات | شروط قبول تقارير التسليم | عند إشعار العضو بالاكتمال | قائد المشروع | استلام تقرير Handoff | `08_INCOMING_REVIEW_MASTER` |
| `08_INCOMING_REVIEW_MASTER_PROMPT.md` | البرومبت الرئيسي للاستلام | إجراء فحص جراحي بوضع القراءة فقط | عند فحص مخرجات مرحلة | مساعد القائد (AI) | `07_MEMBER_INTAKE_POLICY` | برومبتات التدقيق المتخصصة |
| `09_CONTRACT_COMPATIBILITY_PROMPT.md` | فحص توافق العقود | التأكد من عدم حدوث Contract Drift | أثناء فحص الاستلام | مساعد القائد (AI) | `08_INCOMING_REVIEW_MASTER` | `10_DEPENDENCY_CONFLICT` |
| `10_DEPENDENCY_CONFLICT_PROMPT.md` | فحص تعارض التبعيات | التأكد من عدم وجود حزم غير مصرح بها | أثناء فحص الاستلام | مساعد القائد (AI) | `09_CONTRACT_COMPATIBILITY` | `11_UI_UX_REVIEW` |
| `11_UI_UX_REVIEW_PROMPT.md` | مراجعة واجهات المستخدم | التحقق من RTL والرموز والحالات الخمس | أثناء فحص شاشات الواجهات | مساعد القائد (AI) | `10_DEPENDENCY_CONFLICT` | `12_SECURITY_REVIEW` |
| `12_SECURITY_REVIEW_PROMPT.md` | المراجعة الأمنية | التأكد من خلو الكود من Secrets | أثناء فحص الاستلام | مساعد القائد (AI) | `11_UI_UX_REVIEW` | `13_BUILD_TEST_REVIEW` |
| `13_BUILD_TEST_REVIEW_PROMPT.md` | مراجعة البناء والاختبارات | التحقق من 100% نجاح الاختبارات | أثناء فحص الاستلام | مساعد القائد (AI) | `12_SECURITY_REVIEW` | `14_INTEGRATION_PLAN` |
| `14_INTEGRATION_PLAN_PROMPT.md` | إعداد خطة الدمج | رسم خريطة الدمج الجراحية | بعد صدور قرار PASS للمرحلة | مساعد القائد (AI) | `13_BUILD_TEST_REVIEW` | `15_MERGE_EXECUTION` |
| `15_MERGE_EXECUTION_PROMPT.md` | تنفيذ الدمج الآمن | نقل وتحديث الملفات المعتمدة فقط | بعد موافقة القائد الصريحة | مساعد القائد (AI) | `14_INTEGRATION_PLAN` | `16_REGRESSION_TEST` |
| `16_REGRESSION_TEST_PROMPT.md` | فحص الانحدار بعد الدمج | تشغيل الاختبارات الشاملة للنظام | فور انتهاء عملية الدمج | مساعد القائد (AI) | `15_MERGE_EXECUTION` | `17_MEMBER_ACCEPTANCE` |
| `17_MEMBER_ACCEPTANCE_PROMPT.md` | اعتماد المرحلة رسمياً | تحديث الحالة لـ ACCEPTED وإشعار العضو | بعد نجاح فحص الانحدار | قائد المشروع | `16_REGRESSION_TEST` | الانتقال للمرحلة التالية |
| `18_FINAL_TEAM_INTEGRATION_PROMPT.md` | التكامل النهائي الشامل | فحص تدفقات النظام الشاملة E2E | بعد انتهاء كافة الأعضاء | قائد المشروع | اكتمال جميع المراحل | الإطلاق والاعتماد النهائي |

---

## 5. تحليل الملفات المشتركة وقواعد القراءة (Shared Prompts Analysis)

| اسم الملف | الغرض والوظيفة | من يجب أن يقرأه؟ | صفة الاستخدام |
| :--- | :--- | :--- | :--- |
| **`UI_UX_SYSTEM.md`** | نظام التصميم الموحد (M3, RTL, Tokens, 5 States, No Emojis) | مطورو الواجهات (أواب النزيلي + مشعل الحاج) | إلزامي قبل أي شاشة |
| **`TEAM_AI_BASE_PROMPT.md`** | التوجيه الأساسي لـ Antigravity لفرض دورة العمل ومنع الخروج عن العقود | **كافة أعضاء الفريق الأربعة** | إلزامي في بداية كل جلسة AI |
| **`CLOUD_REVIEW_PROMPT.md`** | برومبت المراجعة المستقلة عبر ChatGPT بعد انتهاء كل مرحلة | **كافة أعضاء الفريق الأربعة** | بعد كل تنفيذ واختبار |
| **`CLOUD_TO_IDE_REVIEW_LOOP.md`**| توضيح خطوات حلقة المراجعة والتحليل والإصلاح الجراحي | **كافة أعضاء الفريق الأربعة** | عند وجود ملاحظات مراجعة |
| **`FOLDER_OWNERSHIP.md`** | مصفوفة الملكية البرمجية وعزل المجلدات المسموحة والممنوعة | **كافة أعضاء الفريق وقائد المشروع** | مرجع الحدود والمسؤوليات |
| **`HANDOFF_INSTRUCTIONS.md`** | تعليمات وشروط تعبئة تقرير التسليم الرسمي | **كافة أعضاء الفريق** | عند تسليم أي مرحلة |
| **`COMMON_TEST_PROMPT.md`** | برومبت تشغيل الفحص الساكن واختبارات الوحدة وفحص البناء | **كافة أعضاء الفريق** | أثناء تنفيذ مراحل الاختبار |
| **`FINAL_MEMBER_QA_CHECKLIST.md`**| قائمة التحقق الـ 13 الإلزامية لجودة المخرجات قبل التسليم | **كافة أعضاء الفريق وقائد المشروع** | قبل إرسال تقرير Handoff |

---

## 6. الخريطة الرسمية للمطورين الأربعة (Member Mapping)

---

### خريطة المطور 01: أواب النزيلي (Flutter Mobile Application)
- **المهمة الرسمية:** بناء وتطوير تطبيق الهاتف الشامل (Flutter Mobile) بجميع واجهاته وتدفقاته.
- **الهدف:** توفير واجهة هاتف فائقة السلاسة تدعم الطلاب والمندوبين والأساتذة بدون اتصال بالإنترنت في القاعات.
- **التقنيات المستخدمة:** Flutter, Dart, Material 3, Dio (مع Interceptors), FlutterSecureStorage.
- **مبررات الاختيار:** كود موحد عالي الأداء يدعم RTL و 60fps ويوفر تشفيراً محلياً للتوكنات عبر KeyStore/Keychain.
- **ما سيبنيه:** هيكل التطبيق (App Shell)، التوجيه بحسب الدور (Role Routing)، شاشات الطالب، شاشات المندوب، شاشات الأستاذ العملي والنظري، طبقة التخزين المحلي والـ Offline-first boundaries، وواجهة طابور المزامنة (Interface Boundary).
- **ما يُمنع بناؤه:** محرك البصمة الحيوية، الخادم المحلي المدمج، توليد الـ QR، قواعد بيانات PostgreSQL، ولوحة تحكم الويب.
- **المجلدات المسموحة:** `mobile_app/lib/app/`, `core/`, `authentication/`, `dashboard/`, `student/`, `delegate/`, `practical_teacher/`, `theoretical_teacher/`, `shared/` واختباراتها المقابلة.
- **المجلدات الممنوعة:** `mobile_app/lib/biometric/`, `mobile_app/lib/local_server/`, `backend/`, `admin_web/`, `team_package/`.
- **أول برومبت:** `01_ANALYZE_PROJECT.md` | **آخر برومبت:** `26_HANDOFF.md`.

---

### خريطة المطور 02: محمد العواضي (Biometric Verification Engine)
- **المهمة الرسمية:** تصميم وبناء محرك التحقق الحيوي (`BiometricService`) واستخراج ومطابقة قوالب بصمة العين والوجه.
- **الهدف:** التحقق الدقيق من شخصية الطالب محلياً على هاتفه لمنع انتحال الشخصية دون إرسال صور خام للخادم.
- **التقنيات المستخدمة:** Biometric Engine Layer, Feature Extraction Algorithms, Secure Template Repository, Adapter Pattern.
- **مبررات الاختيار:** عزل محرك المعالجة الحيوية خلف واجهة `BiometricService` لتمكين الترقية والصيانة دون كسر واجهات التطبيق، واستخراج متجهات ميزات مشفرة لا يمكن عكسها لحماية خصوصية الطلاب.
- **ما سيبنيه:** واجهة `BiometricService`، طبقة التقاط الصورة وفحص جودتها وإضاءتها، معالجة معالم العين/الوجه، توليد القالب المشفر (`BiometricTemplate`) ومطابقته محلياً، ضبط عتبات القبول والرفض، ومحول التكامل مع تطبيق الطالب.
- **ما يُمنع بناؤه:** تسجيل الحضور في قاعدة البيانات المركزية، الخادم المحلي، الـ QR، والمزامنة المركزية.
- **حالات الإرجاع الرسمية:** `VERIFIED`, `REJECTED`, `REVIEW`, `LOW_QUALITY`, `ENGINE_ERROR`.
- **المجلدات المسموحة:** `mobile_app/lib/biometric/` واختباراتها في `mobile_app/test/biometric/`.
- **المجلدات الممنوعة:** `mobile_app/lib/student/`, `mobile_app/lib/local_server/`, `backend/`, `admin_web/`, `team_package/`.
- **أول برومبت:** `01_ANALYZE_PROJECT.md` | **آخر برومبت:** `34_HANDOFF.md`.

---

### خريطة المطور 03: محمد العيدروس (Local Server, QR & Attendance Queue)
- **المهمة الرسمية:** بناء الخادم المحلي المدمج بهاتف المندوب، بث الـ QR الديناميكي، وإدارة طابور معالجة الحضور المحلي.
- **الهدف:** تمكين تسجيل الحضور محلياً بالقاعات في وضع عدم الاتصال (Offline Mode) واستقبال طلبات الطلاب ومعالجتها بسرعة وأمان عاليين.
- **التقنيات المستخدمة:** Embedded HTTP/WebSocket Server, Dynamic QR with HMAC & Nonce, In-Memory Queue with Worker Isolation, Idempotency Cache by RequestId.
- **مبررات الاختيار:** تمكين هاتف المندوب من استضافة جلسة الحضور محلياً، واستخدام رمز QR متغير دورياً مع Nonce وطابع زمني لمنع تصوير الشاشة وتمرير الرمز (Replay Attack Prevention).
- **ما سيبنيه:** إدارة الشبكة والمنافذ، الخادم المحلي المدمج، حراسة دورة حياة الجلسة (`CREATED → STARTING → RUNNING → CLOSING → STOPPED`)، بروتوكول الاستكشاف المحلي، توليد ومسح الـ QR الديناميكي، عميل الطالب المحلي، طابور المعالجة المحلي، معالجة منع التكرار (`Idempotency`)، ومعالجة انقطاع الشبكة والإغلاق الآمن.
- **ما يُمنع بناؤه:** محرك البصمة، المزامنة المركزية، لوحة الويب، وقاعدة البيانات المركزية.
- **المجلدات المسموحة:** `mobile_app/lib/local_network/`, `local_server/`, `qr_session/`, `attendance_queue/` واختباراتها المقابلة.
- **المجلدات الممنوعة:** `mobile_app/lib/biometric/`, `mobile_app/lib/student/`, `backend/`, `admin_web/`, `team_package/`.
- **أول برومبت:** `01_ANALYZE_PROJECT.md` | **آخر برومبت:** `36_HANDOFF.md`.

---

### خريطة المطور 04: مشعل الحاج (Admin Flutter Web Dashboard)
- **المهمة الرسمية:** بناء لوحة التحكم الإدارية المركزية للعمادة عبر Flutter Web.
- **الهدف:** إدارة الهياكل الأكاديمية (الأقسام، السنوات، الفصول، المواد، الشعب، التسجيلات)، إدارة الحسابات، توليد رموز التفعيل، ومتابعة سجلات التدقيق والتقارير الإحصائية.
- **التقنيات المستخدمة:** Flutter Web, Material 3 (RTL), REST API Client with JWT Bearer, Responsive Grid & DataTables.
- **مبررات الاختيار:** توحيد لغة التطوير مع الهاتف، وتقديم لوحة ويب متجاوبة واحترافية تعتمد بنسبة 100% على الـ REST API لضمان الأمان وفصل الصلاحيات.
- **ما سيبنيه:** هيكل لوحة الويب، شاشات تسجيل الدخول، لوحة الإحصائيات، شاشات إدارة الهياكل الأكاديمية، استيراد الطلاب بالدفعات (CSV/Excel)، إدارة الكادر التدريسي والمناديب وتكليفاتهم، شاشات استعراض الجلسات وسجلات الحضور واعتماد التحضير اليدوي، استخراج التقارير، واستعراض سجلات التدقيق والأمان.
- **ما يُمنع بناؤه:** الاتصال المباشر بقاعدة بيانات PostgreSQL (كل العمليات تمر عبر REST API فقط)، كود تطبيقات الهاتف، والخادم المحلي.
- **المجلدات المسموحة:** `admin_web/`, `admin_web/lib/`, `admin_web/test/`.
- **المجلدات الممنوعة:** `backend/`, `mobile_app/`, `team_package/`.
- **أول برومبت:** `01_ANALYZE_PROJECT.md` | **آخر برومبت:** `56_HANDOFF.md`.

---

## 7. الهيكل المقترح لمساحة عمل كل عضو (Recommended Member Workspace Structure)

يجب على كل عضو إنشاء مساحة عمل مستقلة على جهازه المحلي بالشكل التالي:

```text
MEMBER_WORKSPACE/
├── team_package/              # (نسخة مرجعية للقراءة فقط تم استلامها من القائد)
│   ├── docs/
│   ├── api_contract/
│   ├── database/
│   ├── local_protocol/
│   ├── security/
│   └── prompts/shared/
│
├── workspace_source/          # (مجلد العمل الفعلي المسموح بالتعديل فيه)
│   └── mobile_app/ (أو admin_web/ لمشعل)
│
├── handoff/                   # (مجلد حفظ تقارير التسليم المكتملة)
│   └── PHASE_XX_HANDOFF_REPORT.md
│
└── README.md                  # دليل مساحة عمل المطور
```

---

## 8. سلاسل التنفيذ والاختبار والمراجعة (Execution, Test & Review Chains)

### السلسلة التنفيذية النموذجية لكل مرحلة:
```text
1. تشغيل برومبت التنفيذ (*_EXECUTE.md)
   ↓
2. عرض الخطة والتوقف لطلب موافقة المطور البشري
   ↓
3. تنفيذ الكود في نطاق الملفات المسموحة حصراً
   ↓
4. تشغيل برومبت الاختبار المقابل (*_TEST.md)
   ↓
5. تشغيل اختبارات الوحدة وفحص البناء والتأكد من (Test = PASS & Build = PASS)
   ↓
6. إرسال الكود للمراجعة السحابية عبر (CLOUD_REVIEW_PROMPT.md)
   ↓
7. في حال وجود ملاحظات: تطبيق حلقة الإصلاح (CLOUD_TO_IDE_REVIEW_LOOP.md) وإعادة الاختبار
   ↓
8. إعداد وتعبئة تقرير التسليم عبر (HANDOFF_TEMPLATE.md)
   ↓
9. إشعار قائد المشروع والتوقف التام لانتظار المراجعة والاعتماد
```

---

## 9. قواعد تقييم النجاح والفشل (PASS / FAIL Rules)

| الحالة | المعيار والشرط | الإجراء المطلوب من العضو |
| :--- | :--- | :--- |
| **`PASS`** | - نجاح البناء (Build = 0 Errors).<br>- اجتياز 100% من اختبارات الوحدة.<br>- صدور تقييم `PASS` من المراجعة السحابية.<br>- مطابقة تامة لقاموس التسميات وعقود الـ API والـ UI/UX. | تعبئة تقرير التسليم `HANDOFF_TEMPLATE.md` وإرساله للقائد لطلب الاعتماد. |
| **`FAIL`** | - فشل أمر البناء أو وجود أخطاء في الـ Types/Linting.<br>- فشل أي اختبار وحدة.<br>- صدور ملاحظات `CRITICAL` أو `BLOCKER` من المراجعة السحابية.<br>- محاولة لمس ملفات خارج نطاق الملكية. | **التوقف عن التقدم!** تطبيق حلقة الإصلاح الجراحية `CLOUD_TO_IDE_REVIEW_LOOP.md` وإعادة الاختبار حتى الوصول لـ `PASS`. وفي حال وجود تعارض في العقود، التوقف فوراً ومخاطبة قائد المشروع. |

---

## 10. بروتوكول استلام ومراجعة ودمج مخرجات الأعضاء (Leader Intake & Merge Flow)

عندما يعلن أحد الأعضاء اكتمال مرحلته ويرسل تقرير التسليم (`HANDOFF_TEMPLATE.md`):

```text
الخطوة 1: يفتح القائد ملف (07_MEMBER_INTAKE_POLICY.md) للتحقق من اكتمال متطلبات التسليم.
  ↓
الخطوة 2: يشغل القائد برومبت (08_INCOMING_REVIEW_MASTER_PROMPT.md) في وضع القراءة فقط (READ ONLY).
  ↓
الخطوة 3: تشغيل برومبتات الفحص المتخصصة بالتتابع:
          - (09_CONTRACT_COMPATIBILITY_PROMPT.md) ➔ فحص العقود
          - (10_DEPENDENCY_CONFLICT_PROMPT.md)    ➔ فحص التبعيات
          - (11_UI_UX_REVIEW_PROMPT.md)           ➔ فحص الواجهات و RTL
          - (12_SECURITY_REVIEW_PROMPT.md)        ➔ فحص الأمان والـ Secrets
          - (13_BUILD_TEST_REVIEW_PROMPT.md)      ➔ فحص البناء والاختبارات
  ↓
الخطوة 4: في حال ظهور أي خلل ➔ رفض التسليم وإعادة التقرير للعضو مع تعليمات الإصلاح الدقيقة.
  ↓
الخطوة 5: في حال صدور تقييم PASS ➔ تشغيل برومبت (14_INTEGRATION_PLAN_PROMPT.md) لإعداد خطة الدمج.
  ↓
الخطوة 6: يوافق القائد صراحة ➔ تشغيل برومبت (15_MERGE_EXECUTION_PROMPT.md) لتنفيذ الدمج الآمن.
  ↓
الخطوة 7: فور انتهاء الدمج ➔ تشغيل برومبت (16_REGRESSION_TEST_PROMPT.md) لفحص الانحدار الشامل.
  ↓
الخطوة 8: تشغيل برومبت (17_MEMBER_ACCEPTANCE_PROMPT.md) لتحديث حالة العضو لـ ACCEPTED وإشعاره بالانتقال للمرحلة التالية.
```

---

## 11. جدول متابعة حالة الفريق (Team Status Tracker)

| اسم العضو | نطاق المسؤولية | الحزمة المسلمة | المرحلة الحالية | البرومبت القادم | حالة الاختبار | حالة المراجعة السحابية | حالة الاستلام والدمج |
| :--- | :--- | :--- | :-: | :-: | :-: | :-: | :-: |
| **01 — أواب النزيلي** | Flutter Mobile Application | `01_OWAB_MOBILE/` | Phase 01 | `01_ANALYZE_PROJECT.md` | `NOT_STARTED` | `NOT_STARTED` | `NOT_STARTED` |
| **02 — محمد العواضي** | Biometric Verification Engine | `02_MOHAMMED_ALAWADI_BIOMETRIC/` | Phase 01 | `01_ANALYZE_PROJECT.md` | `NOT_STARTED` | `NOT_STARTED` | `NOT_STARTED` |
| **03 — محمد العيدروس**| Local Server, QR & Queue | `03_MOHAMMED_ALAYDAROUS_LOCAL/` | Phase 01 | `01_ANALYZE_PROJECT.md` | `NOT_STARTED` | `NOT_STARTED` | `NOT_STARTED` |
| **04 — مشعل الحاج** | Admin Flutter Web Dashboard | `04_MISHAL_ADMIN_WEB/` | Phase 01 | `01_ANALYZE_PROJECT.md` | `NOT_STARTED` | `NOT_STARTED` | `NOT_STARTED` |

---

## 12. تدقيق التعارضات والنواقص (Conflicts & Missing Items Audit)

### نتيجة فحص التعارضات (Conflicts Audit):
- **تداخل نطاقات الأعضاء:** `0 Conflicts` (كل عضو يملك مجلدات واضحة ومعزولة تماماً).
- **تعارضات العقود وقاعدة البيانات:** `0 Conflicts` (الجميع يلتزم بـ `API_SPECIFICATION.md` و `database_dictionary.md`).
- **تعارضات واجهات المستخدم:** `0 Conflicts` (الجميع يلتزم بـ `UI_UX_SYSTEM.md`).

### نتيجة فحص النواقص (Missing Items Audit):
- **اكتمال سلاسل البرومبتات:** `100% Complete` (كل ملف `*_EXECUTE.md` يقابله ملف `*_TEST.md` مباشر).
- **اكتمال ملفات التوجيه والتعريف:** `100% Complete` (جميع الأعضاء يملكون `00_README.md` و `WHY_THIS_TECH.md` و `HANDOFF.md`).
- **اكتمال أدلة قائد المشروع:** `100% Complete` (19 برومبت تغطي دورة حياة القيادة بالكامل).

---

## 13. تعليمات قائد المشروع العملية للتوزيع الفوري (WHAT THE LEADER SHOULD DO NOW)

اتبّع هذه الخطوات العملية العشر بالتتابع لتسليم الحزم وبدء عمل الفريق:

### الخطوة 1: تجهيز الحزمة المرجعية المشتركة (`team_package/`)
- افتح مجلد `team_package/` في المشروع الرئيسي.
- تأكد من احتوائه على مجلدات: `docs/`, `api_contract/`, `database/`, `local_protocol/`, `security/`, `prompts/shared/`.
- انسخ هذا المجلد كما هو لتزويده لكل عضو كنسخة للقراءة فقط (`Read-Only Reference`).

### الخطوة 2: توزيع حزمة 01 — أواب النزيلي (Flutter Mobile)
- افتح واقرأ: `team_package/prompts/leader/02_DISTRIBUTE_OWAB.md`.
- زوّد أواب بـ:
  1. نسخة من `team_package/`.
  2. مجلد البرومبتات الخاص به: `team_package/prompts/members/01_OWAB_MOBILE/`.
- وجّه أواب لفتح ملف: `00_README.md` ثم البدء ببرومبت: `01_ANALYZE_PROJECT.md`.

### الخطوة 3: توزيع حزمة 02 — محمد العواضي (Biometric Verification)
- افتح واقرأ: `team_package/prompts/leader/03_DISTRIBUTE_MOHAMMED_ALAWADI.md`.
- زوّد محمد العواضي بـ:
  1. نسخة من `team_package/`.
  2. مجلد البرومبتات الخاص به: `team_package/prompts/members/02_MOHAMMED_ALAWADI_BIOMETRIC/`.
- وجّه العواضي لفتح ملف: `00_README.md` ثم البدء ببرومبت: `01_ANALYZE_PROJECT.md`.

### الخطوة 4: توزيع حزمة 03 — محمد العيدروس (Local Server, QR & Queue)
- افتح واقرأ: `team_package/prompts/leader/04_DISTRIBUTE_MOHAMMED_ALAYDAROUS.md`.
- زوّد محمد العيدروس بـ:
  1. نسخة من `team_package/`.
  2. مجلد البرومبتات الخاص به: `team_package/prompts/members/03_MOHAMMED_ALAYDAROUS_LOCAL/`.
- وجّه العيدروس لفتح ملف: `00_README.md` ثم البدء ببرومبت: `01_ANALYZE_PROJECT.md`.

### الخطوة 5: توزيع حزمة 04 — مشعل الحاج (Admin Flutter Web)
- افتح واقرأ: `team_package/prompts/leader/05_DISTRIBUTE_MISHAL.md`.
- زوّد مشعل بـ:
  1. نسخة من `team_package/`.
  2. مجلد البرومبتات الخاص به: `team_package/prompts/members/04_MISHAL_ADMIN_WEB/`.
- وجّه مشعل لفتح ملف: `00_README.md` ثم البدء ببرومبت: `01_ANALYZE_PROJECT.md`.

### الخطوة 6: متابعة وتحديث جدول تقدم الفريق
- افتح ملف: `team_package/prompts/leader/06_TEAM_PROGRESS_TRACKER.md`.
- حدّث حالة كل عضو يبدأ في مرحلته إلى `IN_PROGRESS`.

### الخطوة 7: استلام تقرير المرحلة المكتملة
- عندما يبلغك أي عضو باكتمال مرحلته ويرسل تقرير التسليم (`HANDOFF_TEMPLATE.md`):
- افتح ملف: `team_package/prompts/leader/07_MEMBER_INTAKE_POLICY.md` للتأكد من استيفاء الشروط.

### الخطوة 8: تشغيل التدقيق والفحص الشامل
- شغل برومبت: `team_package/prompts/leader/08_INCOMING_REVIEW_MASTER_PROMPT.md` في Antigravity.
- اتبع برومبتات التدقيق الفرعية (`09` إلى `13`) للتحقق من العقود والأمان والبناء.

### الخطوة 9: التعامل مع نتائج الفحص (PASS / FAIL)
- **في حالة `FAIL`:** أعد التقرير للعضو مع قائمة الملاحظات الدقيقة لإصلاحها عبر حلقة `CLOUD_TO_IDE_REVIEW_LOOP.md`.
- **في حالة `PASS`:** انتقل للخطوة 10 لتنفيذ الدمج.

### الخطوة 10: تنفيذ الدمج وفحص الانحدار والاعتماد
- شغل برومبت: `14_INTEGRATION_PLAN_PROMPT.md` ثم `15_MERGE_EXECUTION_PROMPT.md` لدمج الكود المعتمد.
- شغل برومبت: `16_REGRESSION_TEST_PROMPT.md` للتأكد من سلامة النظام الشامل.
- شغل برومبت: `17_MEMBER_ACCEPTANCE_PROMPT.md` لاعتماد المرحلة وتوجيه العضو للمرحلة التالية.
