# مصفوفة ملكية المجلدات | FOLDER_OWNERSHIP.md
## نظام الحضور الجامعي الذكي (University Attendance System)

---

## جدول توزيع المسؤوليات والملكية البرمجية (Folder Ownership Matrix):

| العضو المسؤول | المجلدات المملوكة (Can Create / Modify) | الغرض والمسؤولية | المجلدات الممنوعة (Forbidden) |
| :--- | :--- | :--- | :--- |
| **01 — أواب النزيلي** | `mobile_app/lib/app/`<br>`mobile_app/lib/core/`<br>`mobile_app/lib/authentication/`<br>`mobile_app/lib/dashboard/`<br>`mobile_app/lib/student/`<br>`mobile_app/lib/delegate/`<br>`mobile_app/lib/practical_teacher/`<br>`mobile_app/lib/theoretical_teacher/`<br>`mobile_app/lib/shared/`<br>`mobile_app/test/` المقابل | بناء تطبيق الهاتف الشامل، التوجيه، التوثيق، واجهات الطلاب والمندوبين والمدرسين، وإدارة التخزين المحلي والـ Offline Boundaries | `mobile_app/lib/biometric/`<br>`mobile_app/lib/local_server/`<br>`backend/`<br>`admin_web/`<br>`team_package/` |
| **02 — محمد العواضي** | `mobile_app/lib/biometric/`<br>`mobile_app/test/biometric/` | محرك وخدمات البصمة والتحقق الحيوي وقوالب بصمة العين والوجه والمطابقة المحلية | `mobile_app/lib/student/`<br>`mobile_app/lib/local_server/`<br>`backend/`<br>`admin_web/`<br>`team_package/` |
| **03 — محمد العيدروس** | `mobile_app/lib/local_network/`<br>`mobile_app/lib/local_server/`<br>`mobile_app/lib/qr_session/`<br>`mobile_app/lib/attendance_queue/`<br>`mobile_app/test/` المقابل | الخادم المحلي المدمج بهاتف المندوب، بث الـ QR الديناميكي، طابور معالجة الحضور، والتحقق من الطلبات المكررة | `mobile_app/lib/biometric/`<br>`backend/`<br>`admin_web/`<br>`team_package/` |
| **04 — مشعل الحاج** | `admin_web/`<br>`admin_web/lib/`<br>`admin_web/test/` | لوحة تحكم العمادة والإدارة عبر Flutter Web، إدارة الهيكل الأكاديمي، والمستخدمين والتقارير عبر REST API | `backend/`<br>`mobile_app/`<br>`team_package/` |
| **كافة الأعضاء** | **قراءة فقط (READ-ONLY):**<br>`team_package/docs/`<br>`team_package/api_contract/`<br>`team_package/database/`<br>`team_package/security/`<br>`team_package/local_protocol/`<br>`team_package/integration/` | مرجع العقود والقواعد والمعمارية المشتركة | التعديل المباشر ممنوع تماماً ويتم حصرياً عبر قائد المشروع |
