# المرحلة 14: بناء إدارة السنوات الدراسية (Academic Years Management)
## نظام الحضور الجامعي الذكي (University Attendance System) — 04 مشعل الحاج

---

### 1. الهدف من المرحلة (GOAL)
تنفيذ وتحقيق مستهدفات: **المرحلة 14: بناء إدارة السنوات الدراسية (Academic Years Management)** بدقة ونظافة برمجية كاملة.

### 2. الوثائق الواجب قراءتها أولاً (READ BEFORE CODE)
- `team_package/TEAM_START_HERE.md`
- `team_package/prompts/shared/TEAM_AI_BASE_PROMPT.md`
- `team_package/prompts/shared/UI_UX_SYSTEM.md` (إلزامي للواجهات)
- `team_package/api_contract/API_SPECIFICATION.md`
- `team_package/docs/PROJECT_ROLES.md` (دور ADMIN)

### 3. الملفات والمجلدات المسموح العمل بها (FILES ALLOWED)
- `admin_web/`
- `admin_web/lib/`
- `admin_web/test/`

### 4. الملفات الممنوع لمسها نهائياً (FILES FORBIDDEN)
- `backend/`, `mobile_app/`, `team_package/`
- الاتصال المباشر بقاعدة بيانات PostgreSQL (كل الاتصال عبر REST API حصراً).

### 5. خطوات التنفيذ (EXECUTION)
- الالتزام بنظام التصميم `UI_UX_SYSTEM.md` ودعم RTL واستخدام Design Tokens.
- توفير الحالات الإلزامية: Loading, Empty, Error, Retry, Success.
- استخدام DataTables متجاوبة مع فرز وبحث وتقسيم صفحات.
- عرض خطة العمل والتوقف لطلب موافقة المطور قبل البدء.

### 6. التحقق والمطابقة (VALIDATION)
- مطابقة العقود والمسارات للـ API Contract.

### 7. الاختبارات المطلوبة (TEST)
- كتابة وتشغيل اختبارات الوحدة (`Unit Tests`) والتأكد من اجتيازها بنسبة 100%.

### 8. معايير النجاح (SUCCESS CRITERIA)
- اجتياز اختبارات المرحلة (Test = PASS).
- خلو البناء من أي أخطاء (Build = PASS).

### 9. شرط التوقف (STOP CONDITION)
توقف تماماً بعد اكتمال هذه المرحلة. أجرِ المراجعة السحابية (Cloud Review) ولا تنتقل للمرحلة التالية إلا بعد صدور قرار [PASS].
