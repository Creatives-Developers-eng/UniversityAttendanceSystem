# المرحلة 12: بناء بروتوكول الاستكشاف والإعلان المحلي (Local Discovery Protocol)
## نظام الحضور الجامعي الذكي (University Attendance System) — 03 محمد العيدروس

---

### 1. الهدف من المرحلة (GOAL)
تنفيذ وتحقيق مستهدفات: **المرحلة 12: بناء بروتوكول الاستكشاف والإعلان المحلي (Local Discovery Protocol)** بدقة ونظافة برمجية كاملة.

### 2. الوثائق الواجب قراءتها أولاً (READ BEFORE CODE)
- `team_package/TEAM_START_HERE.md`
- `team_package/prompts/shared/TEAM_AI_BASE_PROMPT.md`
- `team_package/local_protocol/LOCAL_SERVER_PROTOCOL.md`
- `team_package/local_protocol/qr_protocol/`
- `team_package/local_protocol/attendance_protocol/`
- `team_package/docs/SYSTEM_STATES.md`

### 3. الملفات والمجلدات المسموح العمل بها (FILES ALLOWED)
- `mobile_app/lib/local_network/`
- `mobile_app/lib/local_server/`
- `mobile_app/lib/qr_session/`
- `mobile_app/lib/attendance_queue/`
- `mobile_app/test/` المقابل

### 4. الملفات الممنوع لمسها نهائياً (FILES FORBIDDEN)
- `mobile_app/lib/biometric/` (خاص بمحمد العواضي)
- `mobile_app/lib/student/` (خاص بأواب)
- `backend/`, `admin_web/`, `team_package/`

### 5. خطوات التنفيذ (EXECUTION)
- بناء الخادم وإدارة الـ IP والمنافذ بدقة.
- توليد رمز QR الآمن مع Nonce وطابع زمني.
- معالجة الـ Idempotency لمنع تكرار طلبات الحضور.
- اختبار سيناريوهات الضغط والتعافي من انقطاع الشبكة.
- عرض خطة العمل والتوقف لطلب موافقة المطور قبل البدء.

### 6. التحقق والمطابقة (VALIDATION)
- مطابقة بروتوكول الخادم المحلي وعقود الاستجابة.

### 7. الاختبارات المطلوبة (TEST)
- كتابة وتشغيل اختبارات الوحدة (`Unit Tests`) والتأكد من اجتيازها بنسبة 100%.

### 8. معايير النجاح (SUCCESS CRITERIA)
- اجتياز اختبارات المرحلة واختبار الضغط (Test = PASS).
- خلو البناء من أي أخطاء (Build = PASS).

### 9. شرط التوقف (STOP CONDITION)
توقف تماماً بعد اكتمال هذه المرحلة. أجرِ المراجعة السحابية (Cloud Review) ولا تنتقل للمرحلة التالية إلا بعد صدور قرار [PASS].
