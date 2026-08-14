# برومبت التنفيذ البرمجي | 01_EXECUTE.md
## المهمة: بناء واجهات الأستاذ النظري (Theoretical Teacher UI)
### نظام الحضور الجامعي الذكي (University Attendance System)

---

> [!IMPORTANT]
> **برومبت التنفيذ المباشر لـ Antigravity IDE**
> انسخ هذا البرومبت بالكامل وضعه في محادثة Antigravity IDE داخل مساحة عملك لبدء تنفيذ المهمة.

---

```text
أنت تعمل كمطور برمجيات مسؤول عن [تطبيق الهاتف الذكي الشامل (Flutter Mobile) بجميع واجهاته وتدفقاته وتخزينه المحلي] في مشروع نظام الحضور الجامعي الذكي.

==================================================
1. سياق وبيانات المهمة (TASK CONTEXT)
==================================================
- اسم العضو المطور: أواب النزيلي
- المهمة الحالية: بناء واجهات الأستاذ النظري (Theoretical Teacher UI)
- الهدف الأساسي: بناء واجهات أستاذ المحاضرات النظرية لمتابعة نسب الغياب واستعراض تقارير الحرمان

==================================================
2. الوثائق الواجب قراءتها أولاً (READ FIRST)
==================================================
- team_package/TEAM_START_HERE.md
- team_package/prompts/shared/TEAM_AI_BASE_PROMPT.md
- team_package/prompts/shared/UI_UX_SYSTEM.md (إلزامي للواجهات)
- team_package/docs/PROJECT_CONSTITUTION.md
- team_package/docs/PROJECT_GLOSSARY.md
- team_package/docs/PROJECT_ROLES.md
- team_package/docs/SYSTEM_STATES.md
- team_package/docs/SYSTEM_ARCHITECTURE.md
- team_package/prompts/shared/UI_UX_SYSTEM.md (إلزامي للواجهات)
- team_package/api_contract/API_SPECIFICATION.md

==================================================
3. مصفوفة الملفات المسموحة والممنوعة (OWNERSHIP)
==================================================
الملفات والمجلدات المسموح لك بالإنشاء والتعديل فيها حصرياً:
- mobile_app/lib/app/
- mobile_app/lib/core/
- mobile_app/lib/authentication/
- mobile_app/lib/dashboard/
- mobile_app/lib/student/
- mobile_app/lib/delegate/
- mobile_app/lib/practical_teacher/
- mobile_app/lib/theoretical_teacher/
- mobile_app/lib/shared/
- mobile_app/test/

الملفات والمجلدات المحظورة تماماً:
- mobile_app/lib/biometric/ (خاص بمحمد العواضي)
- mobile_app/lib/local_server/ (خاص بمحمد العيدروس)
- mobile_app/lib/local_network/ (خاص بمحمد العيدروس)
- backend/ (مركزي)
- admin_web/ (خاص بمشعل)
- team_package/ (مرجع قراءة فقط)

==================================================
4. التغييرات المطلوبة بالتفصيل (EXACT CHANGES)
==================================================
- بناء شاشات المواد النظرية، تقارير الحضور الإحصائية، وقوائم الطلاب المعرضين للحرمان
- البنية المطلوبة للملفات: mobile_app/lib/theoretical_teacher/ (theoretical_dashboard_view.dart, theory_reports_view.dart)

==================================================
5. التقنيات وقواعد التسميات والمعايير (STANDARDS)
==================================================
- التقنيات المستخدمة: Charts (fl_chart), Statistics Cards
- مبرر اختيار التقنيات: إظهار مؤشرات الحضور البيانية ونسب الغياب بوضوح للأستاذ
- قواعد التسميات المعتمدة: TheoreticalDashboardView, AttendancePieChart
- معايير الواجهات: الالتزام بـ Material 3، دعم RTL، استخدام الرموز اللونية (Tokens)، توفير الحالات الخمس (Loading, Empty, Error, Retry, Success)، وحظر تام للـ Emojis كأيقونات.
- الأمان: منع تسريب أي مفاتيح أو بيانات حساسة، والالتزام بسياسات التشفير.
- العقود: الالتزام الصارم بـ API_SPECIFICATION.md و database_dictionary.md دون أي انحراف.

==================================================
6. ما يقع خارج نطاق المهمة صراحة (EXPLICIT OUT-OF-SCOPE)
==================================================
- ممنوع بناء أي منطق يخص الباك إند المركزي أو قواعد بيانات PostgreSQL المركزية.
- ممنوع تعديل ملفات تخص زملاءك في الفريق.
- ممنوع إضافة حزم أو مكتبات خارجية دون توثيق مبررها الصريح.

==================================================
7. التحقق وتقرير التنفيذ المطلوب (REQUIRED VALIDATION & REPORT)
==================================================
- اعرض خطة التنفيذ التفصيلية وتوقف لانتظار موافقتي الصريحة قبل كتابة الكود.
- بعد التنفيذ: اعرض ملخصاً بكافة الملفات المنشأة والمعدلة، وأكد نجاح الفحص الساكن والتوافق المعماري.

==================================================
8. شرط التوقف (STOP CONDITION)
==================================================
توقف تماماً بعد الانتهاء من كتابة وتوثيق كود هذه المهمة وانتظر تشغيل برومبت الاختبار (02_TEST.md).
```
