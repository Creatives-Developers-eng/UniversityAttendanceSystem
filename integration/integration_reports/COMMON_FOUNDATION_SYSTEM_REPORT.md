# تقرير نظام التأسيس المشترك والتخصصي للأعضاء (COMMON_FOUNDATION_SYSTEM_REPORT.md)
## نظام الحضور الجامعي الذكي (University Attendance System)

---

## 1. الملخص التنفيذي (Executive Summary)

تم إنشاء وتفعيل **طبقة التأسيس المعماري المشترك والتخصصي (Common Foundation Layer)** لكافة أعضاء الفريق الأربعة قبل بدء أي مهمة برمجية:
- **المبدأ الحاكم:** `COMMON FOUNDATION FIRST -> TASKS SECOND`.
- **الهيكل الموحد:** يحتوي مجلد كل عضو على مجلد `COMMON_FOUNDATION/` مكون من **7 خطوات تأسيسية صارمة**، تليها مهام العضو في مجلد `tasks/`.
- **قاعدة الـ 3 برومبتات:** كل خطوة تأسيس وكل مهمة تتكون حصرياً من 3 ملفات برومبت مستقلة (`01_EXECUTE.md`, `02_TEST.md`, `03_CLOUD_REVIEW.md`).
- **إجمالي ملفات التأسيس المنشأة:** **84 ملف برومبت تأسيسي** (21 ملفاً لكل عضو).
- **إجمالي ملفات البرومبتات في النظام:** **315 ملف برومبت منظم وموثق** (84 تأسيس + 231 مهام).
- **الحالة العامة:** `COMMON FOUNDATION SYSTEM = READY (100% PASS)`.

---

## 2. جدول خطوات التأسيس المعماري المشترك (Common Foundation Steps)

| # | الخطوة التأسيسية | المسار داخل الحقيبة | الهدف والمخرجات | الملفات الثلاثية |
| :-: | :--- | :--- | :--- | :-: |
| **01** | **التعريف الشامل بالمشروع** | `COMMON_FOUNDATION/01_PROJECT_ORIENTATION/` | فهم أهداف النظام ومكوناته والأدوار والحالات الرسمية | EXECUTE, TEST, REVIEW |
| **02** | **المعمارية وحدود الموديلات** | `COMMON_FOUNDATION/02_ARCHITECTURE/` | عزل المجلدات ومنع تغيير الـ API أو لمس مجلدات الزملاء | EXECUTE, TEST, REVIEW |
| **03** | **قواعد الكود والتسميات** | `COMMON_FOUNDATION/03_CODING_RULES/` | التسميات الموحدة، كود Dart/Flutter النظيف، وقواعد الذكاء الاصطناعي | EXECUTE, TEST, REVIEW |
| **04** | **المواصفات الأمنية** | `COMMON_FOUNDATION/04_SECURITY/` | التشفير، التوكنات، حماية البصمات، والـ Logging الآمن | EXECUTE, TEST, REVIEW |
| **05** | **قواعد التكامل والدمج** | `COMMON_FOUNDATION/05_INTEGRATION_RULES/` | دورة التسليم (Handoff)، المراجعة، والدمج الآمن مع القائد | EXECUTE, TEST, REVIEW |
| **06** | **التأسيس الخاص بالمسؤولية** | `COMMON_FOUNDATION/06_MEMBER_SPECIFIC_FOUNDATION/` | تأسيس تخصصي مستقل لكل عضو حسب مسؤوليته ونطاق عمله | EXECUTE, TEST, REVIEW |
| **07** | **بوابة الاعتماد النهائي** | `COMMON_FOUNDATION/07_FOUNDATION_FINAL_GATE/` | اختبار الجاهزية الشامل قبل فتح مجلد المهام التنفيذية | EXECUTE, TEST, REVIEW |

---

## 3. التأسيس الخاص بكل عضو (Member-Specific Foundations)

1. **01 — أواب النزيلي (`01_OWAB_MOBILE`):**
   - **التأسيس التخصصي:** Flutter Mobile Architecture, Material 3, Full RTL, Design Tokens, Typography, 5 Screen States, Zero Emojis, Role Guards, Secure Storage, Offline Cache, Integration Adapters.
   - **شرط UI/UX:** إلزامي قبل أي شاشة في تطبيق الهاتف.
2. **02 — محمد العواضي (`02_MOHAMMED_ALAWADI_BIOMETRIC`):**
   - **التأسيس التخصصي:** Biometric Pipeline, Non-Reversible Template Encryption, BiometricService Interface, Engine Adapter Pattern, Verification vs Attendance Separation, Latency Constraints (<500ms), Student Integration Facade.
3. **03 — محمد العيدروس (`03_MOHAMMED_ALAYDAROUS_LOCAL`):**
   - **التأسيس التخصصي:** Embedded HTTP Server on Mobile, Local IP & Ports, Local Session State Machine, Session Guard, Dynamic QR with HMAC & Nonce, FIFO Attendance Queue, Idempotency by RequestId, Graceful Shutdown, 50-Client Stress Tolerance.
4. **04 — مشعل الحاج (`04_MISHAL_ADMIN_WEB`):**
   - **التأسيس التخصصي:** Flutter Web Architecture, Material 3 Web, RTL, Responsive DataTables, REST API Client with Bearer Token (Zero Direct DB Access), Admin Route Guards, Batch CSV/Excel Import, Audit Logging, UI/UX 5 States.
   - **شرط UI/UX:** إلزامي قبل أي شاشة في لوحة الويب.

---

## 4. ملكية نظام التصميم والرموز المشتركة (Shared Design Tokens Ownership)

- **المالك المعتمد:** **قائد المشروع (PROJECT LEADER)** حصرياً.
- **القاعدة:** يُمنع لأي عضو تعديل أو ابتكار رموز تصميم (`Design Tokens`) جديدة خارج ما ورد في `team_package/prompts/shared/UI_UX_SYSTEM.md` دون موافقة صريحة من قائد المشروع.

---

## 5. تسلسل البدء والعبور (Gate Workflow)

```text
COMMON FOUNDATION (01 -> 02 -> 03 -> 04 -> 05 -> 06)
  ↓
FOUNDATION FINAL GATE (07) ➔ [PASS]
  ↓
MEMBER TASKS (tasks/01_... -> tasks/NN_...)
  ↓
FINAL HANDOFF
```

---

## 6. الجاهزية والقرار النهائي (Verdict)

```text
================================================================================
     COMMON FOUNDATION & TASK PIPELINE STATUS: READY (100% OPERATIONAL)
================================================================================
```
