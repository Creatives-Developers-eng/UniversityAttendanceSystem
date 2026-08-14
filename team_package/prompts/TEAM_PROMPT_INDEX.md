# فهرس ودليل تشغيل البرومبتات الشامل | TEAM_PROMPT_INDEX.md
## نظام الحضور الجامعي الذكي (University Attendance System)

---

> [!IMPORTANT]
> **دليل التسلسل والتشغيل لجميع أعضاء الفريق وقائد المشروع**
> يحدد هذا المستند الترتيب الإلزامي لفتح وتشغيل البرومبتات لكل عضو، وكيفية التنسيق بين برومبت التنفيذ (`*_EXECUTE.md`) وبرومبت الاختبار المقابل (`*_TEST.md`) والمراجعة السحابية والتسليم.

---

## 1. خطوات دورة حياة عمل كل مرحلة (Standard Phase Flow)

```text
1. فتح برومبت التنفيذ (*_EXECUTE.md)
   ↓
2. عرض الخطة والتوقف لطلب موافقة المطور
   ↓
3. تنفيذ الكود في نطاق الملفات المسموحة فقط
   ↓
4. فتح وتشغيل برومبت الاختبار المقابل (*_TEST.md)
   ↓
5. تشغيل اختبارات الوحدة وفحص البناء (npm/flutter test & build)
   ↓
6. إجراء المراجعة السحابية عبر CLOUD_REVIEW_PROMPT.md
   ↓
7. إصلاح الملاحظات عبر CLOUD_TO_IDE_REVIEW_LOOP.md
   ↓
8. إعداد تقرير التسليم عبر HANDOFF_TEMPLATE.md
   ↓
9. التوقف التام وانتظار اعتماد قائد المشروع
```

---

## 2. فهرس برومبتات 01 — أواب النزيلي (Flutter Mobile)

- `00_README.md` ➔ قراءة دليل البدء وفهم المسؤوليات
- `WHY_THIS_TECH.md` ➔ قراءة مبررات القرارات التقنية
- `01_ANALYZE_PROJECT.md` ➔ تحليل وقراءة وثائق ومعمارية المشروع
- `02_MOBILE_FOUNDATION_EXECUTE.md` ➔ تأسيس بنية وهيكل التطبيق
- `03_MOBILE_FOUNDATION_TEST.md` ➔ اختبار بنية وهيكل التطبيق
- `04_ACTIVATION_AND_ROLE_ROUTING_EXECUTE.md` ➔ تنفيذ مسار التفعيل والتوجيه
- `05_ACTIVATION_AND_ROLE_ROUTING_TEST.md` ➔ اختبار مسار التفعيل والتوجيه
- `06_LOCAL_STORAGE_EXECUTE.md` ➔ تأسيس التخزين المحلي الآمن
- `07_LOCAL_STORAGE_TEST.md` ➔ اختبار التخزين المحلي
- `08_API_CLIENT_EXECUTE.md` ➔ بناء عميل REST API
- `09_API_CLIENT_TEST.md` ➔ اختبار عميل الـ API وتجديد التوكن
- `10_STUDENT_APP_EXECUTE.md` ➔ بناء واجهات الطالب
- `11_STUDENT_APP_TEST.md` ➔ اختبار واجهات الطالب
- `12_DELEGATE_APP_EXECUTE.md` ➔ بناء واجهات المندوب
- `13_DELEGATE_APP_TEST.md` ➔ اختبار واجهات المندوب
- `14_PRACTICAL_TEACHER_APP_EXECUTE.md` ➔ بناء واجهات الأستاذ العملي
- `15_PRACTICAL_TEACHER_APP_TEST.md` ➔ اختبار واجهات الأستاذ العملي
- `16_THEORETICAL_TEACHER_APP_EXECUTE.md` ➔ بناء واجهات الأستاذ النظري
- `17_THEORETICAL_TEACHER_APP_TEST.md` ➔ اختبار واجهات الأستاذ النظري
- `18_OFFLINE_FIRST_EXECUTE.md` ➔ بناء حدود العمل دون اتصال
- `19_OFFLINE_FIRST_TEST.md` ➔ اختبار العمل دون اتصال
- `20_SYNC_QUEUE_BOUNDARY_EXECUTE.md` ➔ بناء واجهة طابور المزامنة
- `21_SYNC_QUEUE_BOUNDARY_TEST.md` ➔ اختبار واجهة طابور المزامنة
- `22_INTEGRATION_POINTS_EXECUTE.md` ➔ تجهيز نقاط الربط والتكامل
- `23_INTEGRATION_POINTS_TEST.md` ➔ اختبار نقاط الربط والتكامل
- `24_UI_UX_FINAL_AUDIT.md` ➔ التدقيق النهائي للواجهات
- `25_FINAL_MOBILE_AUDIT.md` ➔ التدقيق المعماري الشامل للتطبيق
- `26_HANDOFF.md` ➔ تقرير التسليم النهائي لتطبيق الهاتف

---

## 3. فهرس برومبتات 02 — محمد العواضي (Biometric Engine)

- `00_README.md` ➔ قراءة دليل البدء والمسؤوليات
- `WHY_THIS_TECH.md` ➔ مبررات القرارات التقنية
- `01_ANALYZE_PROJECT.md` ➔ تحليل وثائق ومحددات البصمة
- `02_ENGINE_RESEARCH_EXECUTE.md` ➔ دراسة المحركات وبصمة العين
- `03_ENGINE_RESEARCH_TEST.md` ➔ اختبار وتقييم دراسة المحركات
- `04_BIOMETRIC_SERVICE_EXECUTE.md` ➔ تصميم خدمة BiometricService
- `05_BIOMETRIC_SERVICE_TEST.md` ➔ اختبار خدمة BiometricService
- `06_CAPTURE_EXECUTE.md` ➔ بناء طبقة التقاط الصورة
- `07_CAPTURE_TEST.md` ➔ اختبار التقاط الصورة
- `08_QUALITY_CHECK_EXECUTE.md` ➔ فحص الجودة والإضاءة
- `09_QUALITY_CHECK_TEST.md` ➔ اختبار فحص الجودة
- `10_EYE_IRIS_PROCESSING_EXECUTE.md` ➔ معالجة واستخراج معالم العين والوجه
- `11_EYE_IRIS_PROCESSING_TEST.md` ➔ اختبار استخراج المعالم
- `12_TEMPLATE_GENERATION_EXECUTE.md` ➔ توليد القالب الحيوي المشفر
- `13_TEMPLATE_GENERATION_TEST.md` ➔ اختبار توليد القوالب
- `14_TEMPLATE_REPOSITORY_EXECUTE.md` ➔ مستودع القوالب الحيوية
- `15_TEMPLATE_REPOSITORY_TEST.md` ➔ اختبار مستودع القوالب
- `16_COMPARE_EXECUTE.md` ➔ خوارزمية المطابقة والمقارنة
- `17_COMPARE_TEST.md` ➔ اختبار خوارزمية المطابقة
- `18_THRESHOLD_EXECUTE.md` ➔ ضبط عتبات القبول والرفض
- `19_THRESHOLD_TEST.md` ➔ اختبار معايرة العتبات
- `20_VERIFY_EXECUTE.md` ➔ بناء تدفق التحقق الشامل
- `21_VERIFY_TEST.md` ➔ اختبار تدفق التحقق
- `22_STUDENT_VERIFICATION_EXECUTE.md` ➔ ربط التحقق بهوية الطالب
- `23_STUDENT_VERIFICATION_TEST.md` ➔ اختبار التحقق المرتبط بالطالب
- `24_IDENTIFICATION_CONTRACT_EXECUTE.md` ➔ ضبط عقد النتائج الرسمية
- `25_IDENTIFICATION_CONTRACT_TEST.md` ➔ اختبار عقد النتائج
- `26_ENGINE_ADAPTER_EXECUTE.md` ➔ محول المحرك والمنصة
- `27_ENGINE_ADAPTER_TEST.md` ➔ اختبار محول المحرك
- `28_PERFORMANCE_TEST.md` ➔ اختبار الأداء وسرعة الاستجابة
- `29_ACCURACY_TEST.md` ➔ اختبار الدقة ومعدلات FAR/FRR
- `30_SECURITY_AUDIT.md` ➔ التدقيق الأمني للقوالب
- `31_ARCHITECTURE_AUDIT.md` ➔ التدقيق المعماري وعزل المحرك
- `32_INTEGRATION_ADAPTER_EXECUTE.md` ➔ بناء محول التكامل مع تطبيق الطالب
- `33_INTEGRATION_ADAPTER_TEST.md` ➔ اختبار محول التكامل
- `34_HANDOFF.md` ➔ تقرير التسليم النهائي لمحرك البصمة

---

## 4. فهرس برومبتات 03 — محمد العيدروس (Local Server & QR)

- `00_README.md` ➔ قراءة دليل البدء والمسؤوليات
- `WHY_THIS_TECH.md` ➔ مبررات القرارات التقنية
- `01_ANALYZE_PROJECT.md` ➔ تحليل وثائق الخادم المحلي والـ QR
- `02_LOCAL_NETWORK_EXECUTE.md` ➔ إدارة الشبكة المحلية واستخراج IP
- `03_LOCAL_NETWORK_TEST.md` ➔ اختبار إدارة الشبكة
- `04_PORT_MANAGER_EXECUTE.md` ➔ إدارة وحجز المنافذ
- `05_PORT_MANAGER_TEST.md` ➔ اختبار إدارة المنافذ
- `06_LOCAL_SERVER_EXECUTE.md` ➔ بناء الخادم المحلي المدمج
- `07_LOCAL_SERVER_TEST.md` ➔ اختبار الخادم المحلي
- `08_LOCAL_SESSION_EXECUTE.md` ➔ دورة حياة الجلسة المحلية
- `09_LOCAL_SESSION_TEST.md` ➔ اختبار دورة حياة الجلسة
- `10_SESSION_GUARD_EXECUTE.md` ➔ حماية وحراسة الجلسة
- `11_SESSION_GUARD_TEST.md` ➔ اختبار حراسة الجلسة
- `12_DISCOVERY_EXECUTE.md` ➔ بروتوكول الاستكشاف والإعلان المحلي
- `13_DISCOVERY_TEST.md` ➔ اختبار الاستكشاف المحلي
- `14_QR_GENERATOR_EXECUTE.md` ➔ توليد رمز QR مع Nonce
- `15_QR_GENERATOR_TEST.md` ➔ اختبار توليد رمز QR
- `16_QR_CLIENT_SCAN_EXECUTE.md` ➔ مسح وفحص صلاحية رمز QR
- `17_QR_CLIENT_SCAN_TEST.md` ➔ اختبار فحص رمز QR
- `18_LOCAL_CLIENT_EXECUTE.md` ➔ بناء عميل الطالب للاتصال المحلي
- `19_LOCAL_CLIENT_TEST.md` ➔ اختبار عميل الطالب المحلي
- `20_ATTENDANCE_QUEUE_EXECUTE.md` ➔ بناء طابور معالجة الحضور المحلي
- `21_ATTENDANCE_QUEUE_TEST.md` ➔ اختبار طابور معالجة الحضور
- `22_IDEMPOTENCY_EXECUTE.md` ➔ معالجة ومنع التكرار عبر RequestId
- `23_IDEMPOTENCY_TEST.md` ➔ اختبار منع التكرار
- `24_LOCAL_AUTHORIZATION_EXECUTE.md` ➔ التحقق والتخويل المحلي
- `25_LOCAL_AUTHORIZATION_TEST.md` ➔ اختبار التخويل المحلي
- `26_RESPONSE_CONTRACT_EXECUTE.md` ➔ ضبط عقود الاستجابة المحلية
- `27_RESPONSE_CONTRACT_TEST.md` ➔ اختبار عقود الاستجابة
- `28_SESSION_SHUTDOWN_EXECUTE.md` ➔ الإغلاق الآمن للجلسة
- `29_SESSION_SHUTDOWN_TEST.md` ➔ اختبار الإغلاق الآمن
- `30_NETWORK_FAILURE_EXECUTE.md` ➔ معالجة انقطاع الشبكة
- `31_NETWORK_FAILURE_TEST.md` ➔ اختبار انقطاع الشبكة
- `32_STRESS_50_CLIENTS_TEST.md` ➔ اختبار الضغط لـ 50 عميلاً متزامناً
- `33_QR_SECURITY_TEST.md` ➔ اختبار أمان الـ QR ومقاومة التمرير
- `34_SECURITY_AUDIT.md` ➔ التدقيق الأمني للاتصال المحلي
- `35_ARCHITECTURE_AUDIT.md` ➔ التدقيق المعماري وعزل الطوابير
- `36_HANDOFF.md` ➔ تقرير التسليم النهائي للخادم المحلي

---

## 5. فهرس برومبتات 04 — مشعل الحاج (Admin Flutter Web)

- `00_README.md` ➔ قراءة دليل البدء والمسؤوليات
- `WHY_THIS_TECH.md` ➔ مبررات القرارات التقنية
- `01_ANALYZE_PROJECT.md` ➔ تحليل وثائق وعقود لوحة التحكم
- `02_WEB_FOUNDATION_EXECUTE.md` ➔ تأسيس هيكل تطبيق الويب
- `03_WEB_FOUNDATION_TEST.md` ➔ اختبار هيكل تطبيق الويب
- `04_WEB_ARCHITECTURE_EXECUTE.md` ➔ بناء المعمارية والطبقات للويب
- `05_WEB_ARCHITECTURE_TEST.md` ➔ اختبار المعمارية والطبقات
- `06_API_CLIENT_EXECUTE.md` ➔ عميل REST API المخصص للويب
- `07_API_CLIENT_TEST.md` ➔ اختبار عميل الـ API للويب
- `08_ADMIN_AUTH_EXECUTE.md` ➔ شاشات تسجيل دخول المشرف
- `09_ADMIN_AUTH_TEST.md` ➔ اختبار تسجيل دخول المشرف
- `10_DASHBOARD_EXECUTE.md` ➔ بناء لوحة الإحصائيات الرئيسية
- `11_DASHBOARD_TEST.md` ➔ اختبار لوحة الإحصائيات
- `12_DEPARTMENTS_EXECUTE.md` ➔ إدارة الأقسام الأكاديمية
- `13_DEPARTMENTS_TEST.md` ➔ اختبار إدارة الأقسام
- `14_ACADEMIC_YEARS_EXECUTE.md` ➔ إدارة السنوات الدراسية
- `15_ACADEMIC_YEARS_TEST.md` ➔ اختبار إدارة السنوات الدراسية
- `16_SEMESTERS_EXECUTE.md` ➔ إدارة الفصول الدراسية
- `17_SEMESTERS_TEST.md` ➔ اختبار إدارة الفصول الدراسية
- `18_COURSES_EXECUTE.md` ➔ إدارة المقررات الدراسية
- `19_COURSES_TEST.md` ➔ اختبار إدارة المقررات
- `20_SECTIONS_EXECUTE.md` ➔ إدارة الشعب الدراسية
- `21_SECTIONS_TEST.md` ➔ اختبار إدارة الشعب
- `22_STUDENTS_EXECUTE.md` ➔ إدارة حسابات الطلاب
- `23_STUDENTS_TEST.md` ➔ اختبار إدارة الطلاب
- `24_STUDENT_IMPORT_EXECUTE.md` ➔ استيراد الطلاب بالدفعات (CSV/Excel)
- `25_STUDENT_IMPORT_TEST.md` ➔ اختبار استيراد الطلاب
- `26_STUDENT_IMAGES_EXECUTE.md` ➔ إدارة ورفع صور الطلاب
- `27_STUDENT_IMAGES_TEST.md` ➔ اختبار إدارة صور الطلاب
- `28_TEACHERS_EXECUTE.md` ➔ إدارة الكادر التدريسي
- `29_TEACHERS_TEST.md` ➔ اختبار إدارة المدرسين
- `30_DELEGATES_EXECUTE.md` ➔ إدارة المناديب وتعيينهم
- `31_DELEGATES_TEST.md` ➔ اختبار إدارة المناديب
- `32_ACTIVATION_CODES_EXECUTE.md` ➔ إدارة وتوليد رموز التفعيل
- `33_ACTIVATION_CODES_TEST.md` ➔ اختبار إدارة رموز التفعيل
- `34_ENROLLMENTS_EXECUTE.md` ➔ إدارة تسجيل الطلاب بالشعب
- `35_ENROLLMENTS_TEST.md` ➔ اختبار إدارة التسجيلات
- `36_TEACHER_ASSIGNMENTS_EXECUTE.md` ➔ إدارة تكليفات الأساتذة
- `37_TEACHER_ASSIGNMENTS_TEST.md` ➔ اختبار إدارة التكليفات
- `38_DELEGATE_ASSIGNMENTS_EXECUTE.md` ➔ إدارة تعيين المناديب للشعب
- `39_DELEGATE_ASSIGNMENTS_TEST.md` ➔ اختبار تعيين المناديب للشعب
- `40_SESSIONS_VIEW_EXECUTE.md` ➔ واجهة مراقبة واستعراض الجلسات
- `41_SESSIONS_VIEW_TEST.md` ➔ اختبار استعراض الجلسات
- `42_ATTENDANCE_VIEW_EXECUTE.md` ➔ استعراض سجلات الحضور
- `43_ATTENDANCE_VIEW_TEST.md` ➔ اختبار استعراض سجلات الحضور
- `44_MANUAL_ATTENDANCE_VIEW_EXECUTE.md` ➔ واجهة اعتماد التحضير اليدوي
- `45_MANUAL_ATTENDANCE_VIEW_TEST.md` ➔ اختبار اعتماد التحضير اليدوي
- `46_REPORTS_EXECUTE.md` ➔ استخراج وتصدير التقارير
- `47_REPORTS_TEST.md` ➔ اختبار استخراج التقارير
- `48_AUDIT_LOG_EXECUTE.md` ➔ واجهة سجلات التدقيق والأمان
- `49_AUDIT_LOG_TEST.md` ➔ اختبار استعراض سجلات التدقيق
- `50_PERMISSION_UI_EXECUTE.md` ➔ واجهة إدارة الصلاحيات والأدوار
- `51_PERMISSION_UI_TEST.md` ➔ اختبار واجهة الصلاحيات
- `52_PERFORMANCE_AUDIT.md` ➔ تدقيق الأداء وسرعة تحميل الجداول
- `53_SECURITY_AUDIT.md` ➔ التدقيق الأمني للوحة التحكم
- `54_UI_UX_FINAL_AUDIT.md` ➔ التدقيق النهائي لمطابقة UI_UX_SYSTEM.md
- `55_FINAL_ADMIN_WEB_AUDIT.md` ➔ التدقيق الشامل للوحة الويب
- `56_HANDOFF.md` ➔ تقرير التسليم النهائي للوحة التحكم

---

## 6. برومبتات قائد المشروع (Leader Management Prompts)
توجد داخل مجلد `team_package/prompts/leader/` وتتضمن 19 برومبت لإدارة التوزيع، الاستلام، المراجعة، الدمج، وفحص الانحدار.
