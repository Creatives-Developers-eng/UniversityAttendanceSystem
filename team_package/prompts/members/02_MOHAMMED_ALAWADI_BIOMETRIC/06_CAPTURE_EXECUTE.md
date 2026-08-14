# المرحلة 06: بناء طبقة التقاط الصورة الحيوية (Biometric Capture Layer)
## نظام الحضور الجامعي الذكي (University Attendance System) — 02 محمد العواضي

---

### 1. الهدف من المرحلة (GOAL)
تنفيذ وتحقيق مستهدفات: **المرحلة 06: بناء طبقة التقاط الصورة الحيوية (Biometric Capture Layer)** بدقة ونظافة برمجية كاملة.

### 2. الوثائق الواجب قراءتها أولاً (READ BEFORE CODE)
- `team_package/TEAM_START_HERE.md`
- `team_package/prompts/shared/TEAM_AI_BASE_PROMPT.md`
- `team_package/local_protocol/biometric_protocol/`
- `team_package/security/data_security/`
- `team_package/docs/SYSTEM_STATES.md`

### 3. الملفات والمجلدات المسموح العمل بها (FILES ALLOWED)
- `mobile_app/lib/biometric/`
- `mobile_app/test/biometric/`

### 4. الملفات الممنوع لمسها نهائياً (FILES FORBIDDEN)
- `mobile_app/lib/student/` و `mobile_app/lib/delegate/`
- `mobile_app/lib/local_server/` (خاص بمحمد العيدروس)
- `backend/`, `admin_web/`, `team_package/`

### 5. خطوات التنفيذ (EXECUTION)
- بناء الخدمة بنمط `BiometricService` المعزول.
- إرجاع حالات النتائج الرسمية المعتمدة حصراً.
- عدم تسجيل الحضور في قاعدة البيانات المركزية.
- عرض خطة العمل والتوقف لطلب موافقة المطور قبل البدء.

### 6. التحقق والمطابقة (VALIDATION)
- مطابقة بروتوكول البصمة الحيوية `biometric_protocol`.
- التأكد من أمان القوالب الحيوية وتشفيرها.

### 7. الاختبارات المطلوبة (TEST)
- كتابة وتشغيل اختبارات الوحدة (`Unit Tests`) والتأكد من اجتيازها بنسبة 100%.

### 8. معايير النجاح (SUCCESS CRITERIA)
- اجتياز اختبارات المرحلة (Test = PASS).
- خلو البناء من أي أخطاء (Build = PASS).

### 9. شرط التوقف (STOP CONDITION)
توقف تماماً بعد اكتمال هذه المرحلة. أجرِ المراجعة السحابية (Cloud Review) ولا تنتقل للمرحلة التالية إلا بعد صدور قرار [PASS].
