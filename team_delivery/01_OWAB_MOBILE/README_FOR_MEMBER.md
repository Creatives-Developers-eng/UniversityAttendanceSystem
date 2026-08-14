# دليل التشغيل والتسليم الرسمي الشامل | أواب النزيلي (01_OWAB_MOBILE)
## نظام الحضور الجامعي الذكي (University Attendance System)

---

> [!IMPORTANT]
> **التسلسل الإلزامي لتشغيل وتطوير المشروع (Foundation First Architecture)**
> يُمنع منعاً باتاً البدء في أي مهمة برمجية داخل مجلد `tasks/` قبل اجتياز كافة مراحل التأسيس المشترك والتخصصي داخل مجلد `COMMON_FOUNDATION/` والحصول على قرار **[PASS]** في بوابة الاعتماد النهائي (`07_FOUNDATION_FINAL_GATE/`).

---

## 1. ما تستلمه من قائد المشروع (What You Receive):
1. نسخة مرجعية للقراءة فقط من `team_package/`.
2. مجلد حقيبة التسليم والتشغيل الخاصة بك: `team_delivery/01_OWAB_MOBILE/`.
3. مجلد العمل المسموح لك بالتطوير فيه: `mobile_app/`.

---

## 2. هيكلية حقيبتك الرسمية (Package Structure):
```text
01_OWAB_MOBILE/
├── README_FOR_MEMBER.md                       # دليل التشغيل الشامل الحالي
├── QUICK_START.md                             # دليل البدء السريع المحدث
├── WHAT_TO_COPY.md                            # ما يجب نسخه لمساحة العمل
├── WHAT_TO_READ_FIRST.md                      # الترتيب الإلزامي لقراءة الوثائق
├── WORKSPACE_SETUP.md                         # إعداد وهيكلية مساحة العمل
├── FOLDER_OWNERSHIP.md                        # مصفوفة الملكية البرمجية
├── ANTIGRAVITY_USAGE.md                       # دليل استخدام وتوجيه Antigravity
├── CLOUD_REVIEW_USAGE.md                      # دليل إجراء المراجعات السحابية
├── WORKFLOW.md                                # دورة العمل القياسية للتطوير
├── STOP_AND_FAIL_RULES.md                     # قواعد التوقف والتعامل مع الأخطاء
├── HANDOFF_INSTRUCTIONS.md                    # تعليمات وإرشادات التسليم
├── CHECKLIST.md                               # قائمة التحقق اليومية
├── FILE_INVENTORY.md                          # فهرس وجرد ملفات الحقيبة
│
├── COMMON_FOUNDATION/                         # (مرحلة التأسيس الإلزامية أولاً - 7 خطوات)
│   ├── 01_PROJECT_ORIENTATION/                # التعريف الشامل بالمشروع ومكوناته
│   ├── 02_ARCHITECTURE/                       # المعمارية الشاملة وحدود الموديلات والملكية
│   ├── 03_CODING_RULES/                       # قواعد الكود والتسميات واستخدام الذكاء الاصطناعي
│   ├── 04_SECURITY/                           # المواصفات الأمنية وحماية البيانات الحساسة
│   ├── 05_INTEGRATION_RULES/                  # قواعد التكامل والدمج وفحص الانحدار
│   ├── 06_MEMBER_SPECIFIC_FOUNDATION/         # التأسيس الخاص بنطاق مسؤوليتك
│   └── 07_FOUNDATION_FINAL_GATE/              # بوابة الاعتماد واختبار الجاهزية النهائي
│
├── tasks/                                     # (مجلد المهام التنفيذية - يُفتح فقط بعد اجتياز التأسيس)
│
├── reviews/                                   # مجلد حفظ تقارير المراجعة السحابية
└── handoff/                                   # مجلد حفظ تقارير التسليم
```

---

## 3. قاعدة الـ 3 برومبتات لكل مرحلة ومهمة (3-Prompt Rule):
كل خطوة تأسيس وكل مهمة تحتوي حصرياً على 3 ملفات برومبت:
1. `01_EXECUTE.md` ➔ يُنسخ ويُنفذ في **Antigravity IDE**.
2. `02_TEST.md` ➔ يُنسخ ويُفحص في **Antigravity IDE نفسه**.
3. `03_CLOUD_REVIEW.md` ➔ يُنسخ ويُراجع عبر **ChatGPT / Cloud AI** (بعد تزويده بـ `TEAM_CLOUD_BASE_PROMPT.md`).

---

## 4. المجلدات المسموحة والمحظورة:
- **المجلد المصرح لك بالتعديل فيه:** `mobile_app/`
- **المجلدات الممنوعة:** `backend/`, مجلدات زملائك، ومجلد `team_package/` (قراءة فقط).
- **مالك نظام التصميم المشترك (Design Tokens Owner):** **قائد المشروع (PROJECT LEADER)** حصرياً.

