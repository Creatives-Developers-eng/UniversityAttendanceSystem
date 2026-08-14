# المرحلة 19: اختبار حدود العمل دون اتصال
## نظام الحضور الجامعي الذكي (University Attendance System) — 01 أواب النزيلي

---

### 1. الهدف من المرحلة (GOAL)
تنفيذ وتحقيق مستهدفات: **المرحلة 19: اختبار حدود العمل دون اتصال** بدقة ونظافة برمجية كاملة.

### 2. الوثائق الواجب قراءتها أولاً (READ BEFORE CODE)
- `team_package/TEAM_START_HERE.md`
- `team_package/prompts/shared/TEAM_AI_BASE_PROMPT.md`
- `team_package/prompts/shared/UI_UX_SYSTEM.md` (إلزامي للواجهات)
- `team_package/docs/PROJECT_ROLES.md` و `SYSTEM_STATES.md`
- `team_package/api_contract/API_SPECIFICATION.md`

### 3. الملفات والمجلدات المسموح العمل بها (FILES ALLOWED)
- `mobile_app/lib/app/`
- `mobile_app/lib/core/`
- `mobile_app/lib/authentication/`
- `mobile_app/lib/dashboard/`
- `mobile_app/lib/student/`
- `mobile_app/lib/delegate/`
- `mobile_app/lib/practical_teacher/`
- `mobile_app/lib/theoretical_teacher/`
- `mobile_app/lib/shared/`
- `mobile_app/test/` المقابل

### 4. الملفات الممنوع لمسها نهائياً (FILES FORBIDDEN)
- `mobile_app/lib/biometric/` (خاص بمحمد العواضي)
- `mobile_app/lib/local_server/` و `local_network/` (خاص بمحمد العيدروس)
- `backend/`, `admin_web/`, `team_package/`

### 5. خطوات التنفيذ (EXECUTION)
- الالتزام بنظام التصميم `UI_UX_SYSTEM.md` ودعم RTL واستخدام Design Tokens.
- توفير الحالات الإلزامية: Loading, Empty, Error, Retry, Success.
- عدم استخدام Emojis كأيقونات.
- عرض خطة العمل والتوقف لطلب موافقة المطور قبل البدء.

### 6. التحقق والمطابقة (VALIDATION)
- مطابقة العقود والمسارات للـ API Contract.
- التحقق الساكن من خلو الكود من أخطاء التحليل (Static Analysis Pass).

### 7. الاختبارات المطلوبة (TEST)
- كتابة وتشغيل اختبارات الوحدة (`Unit Tests`) والتأكد من اجتيازها بنسبة 100%.

### 8. معايير النجاح (SUCCESS CRITERIA)
- اجتياز اختبارات المرحلة (Test = PASS).
- خلو البناء من أي أخطاء (Build = PASS).

### 9. شرط التوقف (STOP CONDITION)
توقف تماماً بعد اكتمال هذه المرحلة. أجرِ المراجعة السحابية (Cloud Review) ولا تنتقل للمرحلة التالية إلا بعد صدور قرار [PASS].
