const fs = require('fs');
const path = require('path');

const outputDir = path.resolve(__dirname, 'integration/integration_reports/notion_pages');
if (!fs.existsSync(outputDir)) {
  fs.mkdirSync(outputDir, { recursive: true });
}

// ==========================================
// DATA DEFINITIONS FOR ALL 4 MEMBERS
// ==========================================

const rootFilesDocs = [
  {
    num: "01",
    name: "README_FOR_MEMBER.md",
    arabic: "دليل المطور الشامل والمسار الكامل (19 خطوة)",
    purpose: "هو خريطة الطريق الكبرى للمطور؛ يشرح كل مرحلة من لحظة استلام المشروع حتى التسليم النهائي في 19 خطوة مرتبة ومنطقية.",
    when: "أول ملف يفتحه المطور في بداية عمله ويظل يرجع إليه كمرجع رئيسي طوال فترة المشروع.",
    how: "يقرأه بتركيز شديد ويفهم المسار العام والترتيب المنطقي للعمل.",
    destination: "قراءة للمطور فقط (Read-Only) — لا يُرسل للذكاء الاصطناعي.",
    frequency: "يُقرأ في اليوم الأول ويرجع إليه عند بدء كل مرحلة جديدة."
  },
  {
    num: "02",
    name: "QUICK_START.md",
    arabic: "دليل البدء السريع المباشر",
    purpose: "يلخص خطوات التشغيل السريعة اليومية (فتح البيئة، اختيار المهمة، تشغيل البرومبتات الثلاثية، وتوثيق النتائج).",
    when: "عند بدء يوم عمل جديد أو عند الرغبة في تذكر خطوات العمل الروتينية بسرعة ودون إطالة.",
    how: "اتباع الخطوات الست اليومية المحددة فيه.",
    destination: "قراءة للمطور فقط (Read-Only).",
    frequency: "يُقرأ يومياً عند بدء جلسة التطوير."
  },
  {
    num: "03",
    name: "WHAT_TO_READ_FIRST.md",
    arabic: "الترتيب الإلزامي لقراءة وثائق المشروع",
    purpose: "يحدد للمطور بدقة أي الوثائق من `team_package` يقرأها أولاً، وأيها يقرأها ثانياً، ليمنع التشتت والضياع بين الملفات.",
    when: "قبل البدء في أي عمل عملي، وأثناء مرحلة التأسيس الأولى.",
    how: "فتح الروابط والملفات المذكورة فيه بالترتيب المحدد وقراءتها بعناية.",
    destination: "قراءة للمطور فقط (Read-Only).",
    frequency: "يُقرأ مرة واحدة في بداية المشروع."
  },
  {
    num: "04",
    name: "WHAT_TO_COPY.md",
    arabic: "قواعد النسخ وتجهيز مساحة العمل",
    purpose: "يوضح للعضو ما هي الملفات المسموح بنسخها إلى مساحة عمله، وما هي الملفات المحظور نسخها تماماً لمنع كسر المشروع وتلف التبعيات.",
    when: "لحظة استلام الحزمة من قائد المشروع وقبل فتح أي برنامج تطوير.",
    how: "مطابقة المجلدات المنسوخة مع القوائم المسموحة والممنوعة الواردة بالملف.",
    destination: "قراءة للمطور فقط (Read-Only).",
    frequency: "يُقرأ ويُطبق مرة واحدة عند استلام المشروع."
  },
  {
    num: "05",
    name: "WORKSPACE_SETUP.md",
    arabic: "دليل تهيئة بيئة العمل في Antigravity IDE",
    purpose: "يشرح كيفية فتح المجلد الصحيح داخل برنامج Antigravity وضبط إعدادات مساحة العمل وتشغيل البيئة بنجاح.",
    when: "عند تثبيت وتشغيل بيئة التطوير Antigravity IDE.",
    how: "تطبيق خطوات فتح مجلد المشروع وضبط المسارات وتبعيات Flutter.",
    destination: "قراءة للمطور وتطبيق في بيئة التطوير.",
    frequency: "يُطبق في اليوم الأول أو عند إعادة تهيئة البيئة."
  },
  {
    num: "06",
    name: "FOLDER_OWNERSHIP.md",
    arabic: "مصفوفة ملكية المجلدات والحدود المسموحة",
    purpose: "يحدد المجلدات التي يملكها العضو وله حق التعديل فيها باللون الأخضر، والمجلدات المحرمة عليه لمسها باللون الأحمر.",
    when: "قبل تعديل أو إنشاء أي ملف في المشروع.",
    how: "التأكد من أن المسار المستهدف يقع داخل حدوده المصرح بها حصراً وتجنب المسارات المشتركة أو مسارات الزملاء.",
    destination: "قراءة للمطور فقط (Read-Only).",
    frequency: "مرجع دائم يُراجع باستمرار قبل أي عملية تعديل."
  },
  {
    num: "07",
    name: "ANTIGRAVITY_USAGE.md",
    arabic: "دليل استخدام وتوجيه Antigravity IDE",
    purpose: "يشرح كيف تتعامل مع Antigravity IDE، كيف ترسل له برومبت التنفيذ وبرومبت الاختبار، وكيف تراقب مخرجات الكود.",
    when: "عند تنفيذ أي مهمة برمجية أو فحص كود.",
    how: "نسخ محتوى `01_EXECUTE.md` ثم `02_TEST.md` ولصقها في محادثة Antigravity ومتابعة النتائج.",
    destination: "دليل إرشادي للمطور لكيفية التعامل مع Antigravity.",
    frequency: "يُستخدم مع كل مهمة برمجية."
  },
  {
    num: "08",
    name: "CLOUD_REVIEW_USAGE.md",
    arabic: "دليل المراجعة السحابية الخارجية عبر ChatGPT",
    purpose: "يشرح بالتفصيل كيف تفتح محادثة في ChatGPT، كيف ترسل البرومبت الأساسي وبرومبت المهمة، وكيف تطلب تقييم PASS/FAIL.",
    when: "بعد الانتهاء من فحص الكود واجتياز `02_TEST.md` بنجاح داخل Antigravity.",
    how: "فتح نافذة ChatGPT، إرسال `TEAM_CLOUD_BASE_PROMPT.md` متبوعاً بـ `03_CLOUD_REVIEW.md` والكود المكتوب.",
    destination: "دليل إرشادي للمطور لكيفية استخدام ChatGPT.",
    frequency: "يُستخدم مع كل مهمة برمجية بعد اجتياز الاختبار الداخلي."
  },
  {
    num: "09",
    name: "WORKFLOW.md",
    arabic: "دورة العمل القياسية للمهمة (4 خطوات)",
    purpose: "يشرح دورة حياة المهمة الدائرية: (1. التنفيذ Execute ➔ 2. الاختبار Test ➔ 3. المراجعة Cloud Review ➔ 4. الانتقال/التسليم).",
    when: "مرجع سريع لحفظ نظام العمل ومنع القفز العشوائي بين المهام.",
    how: "الالتزام بالترتيب التسلسلي الصارم للمهام دون أي استثناء.",
    destination: "قراءة للمطور فقط (Read-Only).",
    frequency: "حفظ واستيعاب دائم في الذهن."
  },
  {
    num: "10",
    name: "STOP_AND_FAIL_RULES.md",
    arabic: "قواعد التوقف ومعالجة الأخطاء (الطوارئ)",
    purpose: "يوضح ماذا تفعل إذا فشل الاختبار (Test FAIL) أو رفضت المراجعة الكود (Review FAIL)، وكيف تعالج المشكلة جراحياً.",
    when: "عند ظهور أي خطأ أو فشل في الاختبار أو المراجعة السحابية.",
    how: "تطبيق قاعدة التوقف الفوري، استخراج رسالة الخطأ بدقة، وإعطائها لـ Antigravity لإصلاحها دون تخمين.",
    destination: "قراءة وتطبيق للمطور (دليل طوارئ).",
    frequency: "يُفتح فور حدوث أي مشكلة أو خطأ برمجية."
  },
  {
    num: "11",
    name: "DELIVERY_VALIDATION.md",
    arabic: "معايير التحقق والجاهزية للتسليم",
    purpose: "يحدد الشروط والمعايير الصارمة التي يجب استيفاؤها في كل مرحلة لكي تُعتبر جاهزة للتسليم لقائد المشروع.",
    when: "قبل الانتقال من مرحلة لأخرى وقبل تسليم العمل النهائي.",
    how: "مراجعة بنود الجاهزية والتأكد من مطابقة جميع الشروط والاختبارات.",
    destination: "قراءة للمطور وقائمة فحص ذاتي دقيقة.",
    frequency: "يُراجع عند نهاية كل مرحلة وقبل إرسال أي Handoff."
  },
  {
    num: "12",
    name: "CHECKLIST.md",
    arabic: "قائمة التحقق اليومية للمطور",
    purpose: "قائمة فحص سريعة (Checklist) يقوم المطور بالتأشير عليها يومياً للتأكد من إنجاز المهام وعدم نسيان أي خطوة.",
    when: "في نهاية كل جلسة عمل أو بعد إكمال كل مهمة برمجية.",
    how: "قراءة البنود ومطابقتها مع ما تم إنجازه وتوثيقه فعلياً.",
    destination: "أداة فحص يومية للمطور.",
    frequency: "يُستخدم يومياً."
  },
  {
    num: "13",
    name: "FILE_INVENTORY.md",
    arabic: "الفهرس والجرد الكامل لملفات الحزمة",
    purpose: "جدول شامل يسرد كل ملف ومجلد داخل حزمة المطور بالاسم والمسار لضمان عدم فقدان أي ملف أو برومبت.",
    when: "للبحث عن أي ملف أو التأكد من سلامة اكتمال حزمة التسليم.",
    how: "البحث في الجدول عن مسار الملف المطلوب ومطابقته على القرص.",
    destination: "فهرس مرجعي للمطور (Read-Only).",
    frequency: "مرجع دائم عند البحث والاستفسار."
  }
];

const teamPackageFolders = [
  {
    path: "team_package/docs/",
    name: "مجلد الدستور والقوانين والمعمارية",
    purpose: "يحتوي على دستور المشروع `PROJECT_CONSTITUTION.md` وقواعد الكود ومعمارية النظام وأدوار الفريق.",
    access: "قراءة فقط لجميع الأعضاء (Read-Only).",
    usage: "يُقرأ في مرحلة التأسيس الأولى لفهم القوانين العامة وحظر تعديل العقود أو تجاوز الصلاحيات."
  },
  {
    path: "team_package/api_contract/",
    name: "مجلد عقود واجهات برمجة التطبيقات (API Contract)",
    purpose: "يحتوي على `API_SPECIFICATION.md` وفيه تفاصيل كل رابط Endpoint، البيانات المطلوبة (Request)، وشكل الاستجابة (Response).",
    access: "قراءة فقط (Read-Only) — يمنع تعديل أي حرف فيه.",
    usage: "يرجع إليه المطور لمعرفة أسماء ونوع الحقول الدقيقة المتوقعة من الخادم المركزي."
  },
  {
    path: "team_package/database/",
    name: "مجلد قاموس قاعدة البيانات والمخططات",
    purpose: "يحتوي على `database_dictionary.md` وفيه أسماء الجداول والحقول وأنواعها والقيود والعلاقات.",
    access: "قراءة فقط (Read-Only).",
    usage: "مرجع لتطابق أسماء المتغيرات والحقول (مثل snake_case في قاعدة البيانات و camelCase في Dart)."
  },
  {
    path: "team_package/local_protocol/",
    name: "مجلد بروتوكولات القاعة والشبكة المحلية",
    purpose: "يحتوي على بروتوكول الخادم المحلي المدمج، بروتوكول QR الديناميكي مع Nonce، وبروتوكول التحقق الحيوي.",
    access: "قراءة فقط (Read-Only).",
    usage: "المرجع الفني الدقيق لتبادل البيانات دون إنترنت عبر شبكة القاعة المحلية."
  },
  {
    path: "team_package/security/",
    name: "مجلد المواصفات والمعايير الأمنية",
    purpose: "يحتوي على قواعد تشفير التوكنات، حماية الأجهزة، تأمين القوالب الحيوية، وعزل الشبكة المحلية.",
    access: "قراءة فقط (Read-Only).",
    usage: "يضمن التزام المطور بأعلى معايير الأمان وحظر تخزين التوكنات كنص عادي أو إهمال التشفير."
  },
  {
    path: "team_package/integration/",
    name: "مجلد قوالب التسليم والدمج الرسمي",
    purpose: "يحتوي على `HANDOFF_TEMPLATE.md` وهو القالب الرسمي الذي يملؤه المطور عند تسليم أي مرحلة للقائد.",
    access: "قراءة ونسخ القالب (Template).",
    usage: "يستخدمه المطور عند نهاية كل مرحلة لتعبئة تقرير التسليم في مجلد `handoff/`."
  },
  {
    path: "team_package/prompts/shared/",
    name: "مجلد البرومبتات ونظام التصميم المشترك",
    purpose: "يحتوي على `UI_UX_SYSTEM.md` (نظام التصميم الموحد)، `TEAM_AI_BASE_PROMPT.md`، و `TEAM_CLOUD_BASE_PROMPT.md`.",
    access: "قراءة واستخدام مع الـ AI (Read-Only Reference).",
    usage: "مرجع نظام التصميم الموحد ومصدر الـ Base Prompts التي تُرسل للـ AI في كل محادثة مراجعة."
  },
  {
    path: "team_package/shared/",
    name: "مجلد الثوابت والنماذج البرمجية المشتركة",
    purpose: "يحتوي على الرموز اللونية، الثوابت المعمارية، والموديلات المشتركة بين الأنظمة.",
    access: "قراءة فقط (Read-Only).",
    usage: "مرجع لقيم التصميم والثوابت الرسمية المعتمدة في المشروع."
  }
];

const commonFoundationSteps = [
  {
    num: "01",
    folder: "01_PROJECT_ORIENTATION",
    name: "التعريف الشامل بالنظام وأهدافه",
    goal: "فهم المشكلة الأكاديمية التي يحلها المشروع، مكونات النظام الخمسة (الباك إند، الهاتف، الويب، الخادم المحلي، والبصمة)، وتدفق الحضور الشامل.",
    exec: "يقوم Antigravity باستعراض وثائق المشروع وشرح المعمارية العامة ومطابقة المتطلبات.",
    test: "يقوم Antigravity باختبار استيعاب المطور لأهداف النظام والتأكد من إدراك التدفق العام.",
    review: "يراجع ChatGPT فهم المطور العام للنظام ويصدر قرار [PASS] للتأكد من وضوح الصورة قبل التعمق."
  },
  {
    num: "02",
    folder: "02_ARCHITECTURE",
    name: "المعمارية وعزل الحدود ومصفوفة الملكية",
    goal: "ترسيخ مبدأ عزل المكونات (Modularity)، فهم مصفوفة ملكية المجلدات، وحظر تعديل ملفات الزملاء أو كسر المعمارية.",
    exec: "يقوم Antigravity بفحص هيكل المجلدات وشرح الحدود المسموحة والممنوعة للعضو بدقة.",
    test: "يفحص Antigravity التزام مساحة العمل بمصفوفة الملكية وعدم وجود تعديلات خارج الحدود.",
    review: "يراجع ChatGPT الحدود المعمارية ويصدر [PASS] لضمان عدم حدوث تداخلات بين المطورين."
  },
  {
    num: "03",
    folder: "03_CODING_RULES",
    name: "قواعد الكود النظيف والتسميات والـ AI",
    goal: "إتقان تسميات لغة Dart و Flutter (فئات بـ UpperCamelCase، متغيرات بـ lowerCamelCase، ملفات بـ snake_case)، والتعامل مع الذكاء الاصطناعي كمنفذ منضبط.",
    exec: "يقوم Antigravity بشرح وتطبيق معايير كتابة الكود النظيف وقواعد الـ Linter المعتمدة.",
    test: "يشغل Antigravity فحص التحليل الساكن والتأكد من استيفاء معايير التسمية والهيكلة.",
    review: "يراجع ChatGPT قواعد الكود ويصدر [PASS] لضمان جودة الكود وسهولة صيانته."
  },
  {
    num: "04",
    folder: "04_SECURITY",
    name: "المواصفات الأمنية وحماية البيانات الحساسة",
    goal: "ترسيخ مبادئ الأمان: التخزين المشفر للتوكنات، حظر تضمين كلمات السر في الكود (No Hardcoding)، تأمين البصمة الحيوية، وحماية الشبكة المحلية.",
    exec: "يقوم Antigravity باستعراض سياسات الأمان والتشفير وإعداد بيئة التخزين الآمن.",
    test: "يفحص Antigravity خلو المشروع من أي تسريبات أمنية أو متغيرات حساسة مكشوفة.",
    review: "يراجع ChatGPT الجوانب الأمنية ويصدر [PASS] لضمان سلامة بيانات الطلاب والأساتذة."
  },
  {
    num: "05",
    folder: "05_INTEGRATION_RULES",
    name: "قواعد الدمج والتكامل وفحص الانحدار",
    goal: "تعلم كيفية إعداد تقارير التسليم الرسمية (Handoff)، وفهم كيف يقوم القائد بدمج الكود وإجراء فحص الانحدار (Regression Testing).",
    exec: "يقوم Antigravity بشرح دورة حياة الدمج وكيفية تعبئة قوالب الـ Handoff بدقة.",
    test: "يختبر Antigravity جاهزية المطور لاتباع بروتوكول التسليم وفحص سلامة التوثيق.",
    review: "يراجع ChatGPT استيعاب المطور لدورة التسليم ويصدر قرار [PASS]."
  },
  {
    num: "06",
    folder: "06_MEMBER_SPECIFIC_FOUNDATION",
    name: "التأسيس التخصصي ونظام التصميم (حسب مسؤولية العضو)",
    goal: "استيعاب المتطلبات الفنية الخاصة بالعضو بالتفصيل (مثل: M3 و RTL لأواب ومشعل، أو بروتوكول البصمة للعواضي، أو الخادم المحلي للعيدروس).",
    exec: "يقوم Antigravity بتجهيز البنية التحتية التخصصية للعضو وتطبيق القواعد التقنية الخاصة به.",
    test: "يشغل Antigravity فحصاً متخصصاً للتأكد من مطابقة المتطلبات الخاصة للموديل.",
    review: "يراجع ChatGPT التأسيس التخصصي ويصدر قرار [PASS]."
  },
  {
    num: "07",
    folder: "07_FOUNDATION_FINAL_GATE",
    name: "بوابة الاعتماد النهائي للتأسيس (Strict Gate)",
    goal: "التقييم الشامل والنهائي لكافة خطوات التأسيس الست السابقة، وإصدار إذن العبور الرسمي لفتح مجلد المهام التنفيذية `tasks/`.",
    exec: "يقوم Antigravity بإجراء تدقيق شامل لكافة مخرجات التأسيس وإعداد التقرير النهائي.",
    test: "يشغل Antigravity فحصاً تكاملياً شاملاً للتأسيس والتأكد من خلوه من أي ثغرات أو نواقص.",
    review: "يقوم ChatGPT بمراجعة صارمة ودقيقة ويصدر قرار [PASS] النهائي لفتح مهام العمل."
  }
];

// ==========================================
// MEMBER SPECIFIC DATA
// ==========================================

const membersData = [
  {
    id: "01",
    code: "01_OWAB_MOBILE",
    name: "أواب النزيلي",
    role: "Flutter Mobile Developer (تطبيق الهاتف المحمول متعدد الأدوار)",
    workspace: "mobile_app/",
    deliveryDir: "team_delivery/01_OWAB_MOBILE/",
    allowedPaths: [
      "mobile_app/lib/app/",
      "mobile_app/lib/core/",
      "mobile_app/lib/authentication/",
      "mobile_app/lib/student/",
      "mobile_app/lib/delegate/",
      "mobile_app/lib/practical_teacher/",
      "mobile_app/lib/theoretical_teacher/",
      "mobile_app/lib/shared/",
      "mobile_app/test/student/",
      "mobile_app/test/delegate/",
      "mobile_app/test/teacher/",
      "mobile_app/test/core/"
    ],
    forbiddenPaths: [
      "mobile_app/lib/biometric/ (ملك محمد العواضي)",
      "mobile_app/lib/local_server/ (ملك محمد العيدروس)",
      "mobile_app/lib/local_network/ (ملك محمد العيدروس)",
      "mobile_app/lib/qr_session/ (ملك محمد العيدروس)",
      "mobile_app/lib/attendance_queue/ (ملك محمد العيدروس)",
      "admin_web/ (ملك مشعل الحاج)",
      "backend/ (ملك قائد المشروع)",
      "team_package/ (مرجع للقراءة فقط)"
    ],
    tasks: [
      {
        num: "01",
        folder: "01_MOBILE_FOUNDATION",
        name: "البنية التحتية لتطبيق الهاتف وإعداد الواجهات",
        goal: "تأسيس مشروع Flutter، تطبيق Material 3، دعم اللغة العربية والاتجاه RTL بالكامل، شاشة البداية (Splash Screen)، وإعداد مزودي الحالة الأساسية.",
        targetFile: "mobile_app/lib/app/app.dart و mobile_app/lib/core/theme/",
        exec: "توليد ملفات الثيم الرسمي والألوان والخطوط والتهيئة الأساسية للتطبيق.",
        test: "التحقق من إقلاع التطبيق وثبات اتجاه RTL وتحميل الرموز بدون أخطاء.",
        review: "مراجعة مطابقة معايير Material 3 و الـ 5 Screen States و حظر الإيموجي."
      },
      {
        num: "02",
        folder: "02_ROUTING_AND_NAVIGATION",
        name: "نظام التوجيه والملاحة والحراس (Navigation Guards)",
        goal: "بناء مسارات GoRouter مع حراس المصادقة (Auth Guard) وتوجيه المستخدم حسب دوره (طالب، مندوب، أستاذ نظري، أستاذ عملي).",
        targetFile: "mobile_app/lib/core/routing/app_router.dart",
        exec: "بناء خريطة التوجيه وحماية المسارات ومنع الوصول غير المصرح.",
        test: "اختبار انتقال المسارات وإعادة التوجيه إلى تسجيل الدخول عند عدم وجود توكن.",
        review: "مراجعة أمان التوجيه وتوافق تدفق الأدوار المختلفة."
      },
      {
        num: "03",
        folder: "03_API_CLIENT_AND_AUTH",
        name: "عميل الاتصال وتوثيق الهاتف وتخزين التوكن",
        goal: "بناء عميل Dio/Http مع اعتراضات التوكن (Interceptors)، وتجديد التوكن التلقائي، والتخزين المشفر في FlutterSecureStorage.",
        targetFile: "mobile_app/lib/core/network/api_client.dart و mobile_app/lib/authentication/",
        exec: "إنشاء دوال تسجيل الدخول، وحفظ التوكن الآمن، ومعالجة أخطاء الشبكة.",
        test: "فحص إرسال الترويسات (Bearer Token) ومعالجة رمز 401 وتجديد الجلسة.",
        review: "مراجعة التشفير وعدم وجود تسريب للتوكنات في السجلات."
      },
      {
        num: "04",
        folder: "04_STUDENT_DASHBOARD",
        name: "لوحة تحكم الطالب وإحصائيات الحضور",
        goal: "عرض الجدول الدراسي للطالب، نسبة الحضور العامة، تنبيهات الغياب، وبطاقة الجلسة النشطة حالياً في القاعة.",
        targetFile: "mobile_app/lib/student/dashboard/student_dashboard_screen.dart",
        exec: "بناء واجهة لوحة تحكم الطالب بالحالات الخمس (تحميل، فارغ، خطأ، إعادة، نجاح).",
        test: "فحص عرض البيانات وتحديث النسبة واختبار زر إعادة المحاولة.",
        review: "مراجعة الالتزام بتصميم M3 والألوان المعتمدة وتجربة المستخدم."
      },
      {
        num: "05",
        folder: "05_STUDENT_ATTENDANCE_HISTORY",
        name: "سجل حضور الطالب وتفاصيل المواد",
        goal: "عرض تفاصيل حضور وغياب الطالب لكل مادة أكاديمية بشكل مفصل مع شارات الحالة (حاضر، غائب، معذور).",
        targetFile: "mobile_app/lib/student/attendance/student_attendance_history_screen.dart",
        exec: "بناء شاشات سجل الحضور والفلترة حسب المادة والفصل الدراسي.",
        test: "التحقق من الفلترة الدقيقة وحساب النسب بشكل صحيح.",
        review: "مراجعة دقة عرض الحالات والتصميم المتجاوب."
      },
      {
        num: "06",
        folder: "06_STUDENT_JUSTIFICATION",
        name: "تقديم الأعذار والتقارير الطبية للطالب",
        goal: "نموذج رفع عذر الغياب مع إمكانية إرفاق التقرير الطبي ومتابعة حالة قبول أو رفض العذر.",
        targetFile: "mobile_app/lib/student/justification/justification_submission_screen.dart",
        exec: "بناء نموذج تقديم العذر مع التحقق من صحة المدخلات وإرفاق الصور.",
        test: "اختبار رفع البيانات ومعالجة الأخطاء والتحقق من قيود الحقول.",
        review: "مراجعة معايير الأمان ورفع الملفات وواجهة المستخدم."
      },
      {
        num: "07",
        folder: "07_STUDENT_PROFILE",
        name: "الملف الشخصي للطالب وإعدادات الجهاز",
        goal: "عرض البيانات الأكاديمية للطالب، حالة ربط الجهاز، وإعدادات الإشعارات وتسجيل الخروج الآمن.",
        targetFile: "mobile_app/lib/student/profile/student_profile_screen.dart",
        exec: "بناء شاشة الملف الشخصي وتفريغ الذاكرة المؤقتة عند تسجيل الخروج.",
        test: "التحقق من مسح التوكن من التخزين الآمن عند الخروج.",
        review: "مراجعة الإغلاق الآمن للجلسة وحماية البيانات الشخصية."
      },
      {
        num: "08",
        folder: "08_DELEGATE_DASHBOARD",
        name: "لوحة تحكم المندوب ومراقبة القاعة",
        goal: "لوحة المندوب لإدارة الشعبة، عرض بطاقة الجلسة النشطة، وبدء وإيقاف تسجيل الحضور.",
        targetFile: "mobile_app/lib/delegate/dashboard/delegate_dashboard_screen.dart",
        exec: "بناء واجهة لوحة المندوب مع التنبيهات المباشرة وحالة الجلسة.",
        test: "فحص تفاعل أزرار بدء الجلسة وعرض البيانات اللحظية.",
        review: "مراجعة تجربة مستخدم المندوب والتحقق من الصلاحيات."
      },
      {
        num: "09",
        folder: "09_DELEGATE_SESSION_MANAGEMENT",
        name: "إدارة جلسة الحضور وعرض الـ QR للمندوب",
        goal: "شاشة عرض رمز الاستجابة السريعة الديناميكي المتغير وعداد التحديث التلقائي وقائمة الطلاب الحاضرين لحظياً.",
        targetFile: "mobile_app/lib/delegate/session/delegate_session_screen.dart",
        exec: "بناء واجهة عرض الـ QR وربطه ببيانات الجلسة واستقبال تأكيدات الحضور.",
        test: "اختبار تحديث عداد الحضور والتكامل مع واجهة العرض.",
        review: "مراجعة سلاسة التحديث وتجربة المستخدم في القاعة."
      },
      {
        num: "10",
        folder: "10_DELEGATE_MANUAL_ATTENDANCE",
        name: "كشف الحضور اليدوي وحالات الطوارئ",
        goal: "قائمة كشف الحضور اليدوي لتمكين المندوب من تحضير الطلاب استثنائياً في حالات الطوارئ مع توثيق السبب.",
        targetFile: "mobile_app/lib/delegate/manual/delegate_manual_attendance_screen.dart",
        exec: "بناء كشف الأسماء مع إمكانية التبديل السريع وتدوين ملاحظة العذر اليدوي.",
        test: "اختبار إرسال التحضير اليدوي وتحديث الحالة فورياً.",
        review: "مراجعة تدقيق الحالات الاستثنائية وضوابط الحماية."
      },
      {
        num: "11",
        folder: "11_TEACHER_DASHBOARD",
        name: "لوحة تحكم الأستاذ (نظري / عملي)",
        goal: "لوحة تحكم الأستاذ لعرض المقررات المكلف بها، مواعيد المحاضرات، ونسب الحضور الإجمالية لكل شعبة.",
        targetFile: "mobile_app/lib/theoretical_teacher/dashboard/ و mobile_app/lib/practical_teacher/dashboard/",
        exec: "بناء لوحة تحكم الأستاذ مع تصنيف المحاضرات النظرية والمعامل العملية.",
        test: "فحص عرض المقررات وحساب الإحصائيات بدقة.",
        review: "مراجعة تكامل الواجهات وسهولة الوصول للمحاضرات."
      },
      {
        num: "12",
        folder: "12_TEACHER_SESSION_MANAGEMENT",
        name: "إدارة وتفويض الجلسات للأستاذ",
        goal: "تمكين الأستاذ من بدء جلسة الحضور بنفسه أو تفويض مندوب الشعبة لإدارتها داخل القاعة.",
        targetFile: "mobile_app/lib/shared/session/teacher_session_control_screen.dart",
        exec: "بناء واجهة التحكم في الجلسة وتفويض الصلاحيات للمندوب.",
        test: "اختبار إرسال أمر التفويض والتحقق من تغيير حالة الجلسة.",
        review: "مراجعة أمان التفويض وضوابط الجلسات الأكاديمية."
      },
      {
        num: "13",
        folder: "13_TEACHER_REPORTS_AND_APPROVALS",
        name: "مراجعة الأعذار وتقارير الأستاذ",
        goal: "شاشة استعراض أعذار الطلاب المقدمة، واعتمادها أو رفضها مع كتابة الملاحظات، وعرض تقرير الحضور النهائي.",
        targetFile: "mobile_app/lib/shared/reports/teacher_reports_screen.dart",
        exec: "بناء واجهة مراجعة الأعذار وتصدير ملخصات الحضور.",
        test: "اختبار تنفيذ قرار القبول/الرفض وتحديث السجلات فوراً.",
        review: "مراجعة سلاسة اتخاذ القرار وعرض التقارير."
      },
      {
        num: "14",
        folder: "14_HANDOFF",
        name: "المراجعة الشاملة والتسليم النهائي لتطبيق الهاتف",
        goal: "إجراء اختبار انحدار كامل لتطبيق الهاتف، التحقق من خلوه من أي أخطاء، ملء تقرير التسليم، وتسليم الكود للقائد.",
        targetFile: "team_delivery/01_OWAB_MOBILE/handoff/HANDOFF_REPORT.md",
        exec: "تشغيل الفحص الشامل للواجهات والتوجيه وعميل الشبكة وإعداد حزمة التسليم.",
        test: "تشغيل جميع اختبارات الوحدات لضمان نجاحها بنسبة 100%.",
        review: "مراجعة سحابية نهائية وحصول الحزمة على الاعتماد [PASS]."
      }
    ]
  },
  {
    id: "02",
    code: "02_MOHAMMED_ALAWADI_BIOMETRIC",
    name: "محمد العواضي",
    role: "Biometric & Verification Engine Specialist (خبير محرك البصمة والتحقق الحيوي)",
    workspace: "mobile_app/ (داخل مجلدات البصمة الحيوية)",
    deliveryDir: "team_delivery/02_MOHAMMED_ALAWADI_BIOMETRIC/",
    allowedPaths: [
      "mobile_app/lib/biometric/",
      "mobile_app/test/biometric/"
    ],
    forbiddenPaths: [
      "mobile_app/lib/app/ (ملك أواب)",
      "mobile_app/lib/student/ (ملك أواب)",
      "mobile_app/lib/delegate/ (ملك أواب)",
      "mobile_app/lib/teacher/ (ملك أواب)",
      "mobile_app/lib/local_server/ (ملك محمد العيدروس)",
      "admin_web/ (ملك مشعل الحاج)",
      "backend/ (ملك قائد المشروع)",
      "team_package/ (مرجع للقراءة فقط)"
    ],
    tasks: [
      {
        num: "01",
        folder: "01_ENGINE_RESEARCH",
        name: "دراسة وتحديد خوارزميات محرك البصمة",
        goal: "تحليل ومقارنة خوارزميات استخراج معالم الوجه/العين (TFLite/OpenCV/MobileFaceNet)، وضبط حجم القالب الرياضي والمتطلبات.",
        targetFile: "mobile_app/lib/biometric/engine_specs.md",
        exec: "توثيق واختيار معمارية الشبكة العصبية المناسبة للهواتف الذكية.",
        test: "فحص قيود المعالجة ومعدل استهلاك الذاكرة والمعالج.",
        review: "مراجعة علمية ومعمارية لاختيار المحرك واعتماد المعايير."
      },
      {
        num: "02",
        folder: "02_BIOMETRIC_SERVICE_INTERFACE",
        name: "واجهة خدمة البصمة والعقد البرمجي",
        goal: "تعريف الواجهات البرمجية المجردة (Abstract Interface) لخدمات البصمة والنماذج الرياضية للبيانات.",
        targetFile: "mobile_app/lib/biometric/domain/biometric_service.dart",
        exec: "بناء واجهات الالتقاط، استخراج القالب، والمطابقة الرياضية.",
        test: "التحقق من اكتمال العقود وعدم وجود ارتباط وثيق مع طبقة العرض.",
        review: "مراجعة الالتزام بمبدأ عزل المسؤوليات والـ Clean Architecture."
      },
      {
        num: "03",
        folder: "03_CAPTURE_LAYER",
        name: "طبقة التقاط الإطارات ومعالجة الصور",
        goal: "معالجة إطارات الكاميرا المباشرة، تحويل التنسيقات (YUV to RGB)، وضبط التباين وتدوير الصورة.",
        targetFile: "mobile_app/lib/biometric/capture/frame_capture_pipeline.dart",
        exec: "بناء معالج تدفق الإطارات وتجهيزها للمعالجة الرياضية.",
        test: "اختبار سرعة تحويل وتجهيز الإطار في أقل من 30 ميلي ثانية.",
        review: "مراجعة كفاءة الذاكرة وتفادي تسريب الذاكرة (Memory Leaks)."
      },
      {
        num: "04",
        folder: "04_QUALITY_AND_LIVENESS",
        name: "فحص جودة الصورة والتحقق من الحيوية (Liveness)",
        goal: "فحص الإضاءة والوضوح، واكتشاف محاولات التزوير (Anti-Spoofing / Passive Liveness) لمنع استخدام الصور المطبوعة أو شاشات الهواتف.",
        targetFile: "mobile_app/lib/biometric/liveness/liveness_detector.dart",
        exec: "تطبيق خوارزميات كشف الحيوية وتقدير درجة جودة الإطار الملتقط.",
        test: "اختبار رفض الصور الثابتة والشاشات وقبول الوجه الحقيقي الحي.",
        review: "مراجعة معايير الأمان ومقاومة التزوير الحيوي."
      },
      {
        num: "05",
        folder: "05_IRIS_FACE_PROCESSING",
        name: "معالجة وتطبيع ملامح الوجه وقزحية العين",
        goal: "استخراج المعالم الرئيسية (Landmarks)، محاذاة الوجه هندسياً، وقص وتطبيع المنطقة المستهدفة.",
        targetFile: "mobile_app/lib/biometric/processing/feature_aligner.dart",
        exec: "تطبيق خوارزمية محاذاة النقاط وتطبيع القياسات الهندسية.",
        test: "فحص دقة المحاذاة حتى مع ميلان الوجه بزوايا طفيفة.",
        review: "مراجعة الدقة الرياضية لمرحلة المعالجة المسبقة."
      },
      {
        num: "06",
        folder: "06_TEMPLATE_GENERATION",
        name: "توليد القالب الحيوي الرياضي (512-dim Embedding)",
        goal: "استخراج المتجه الرياضي الفريد (Feature Embedding) المشفر الذي يمثل البصمة دون حفظ الصورة الأصلية.",
        targetFile: "mobile_app/lib/biometric/template/template_generator.dart",
        exec: "تمرير الصورة المحاذاة عبر النموذج الرياضي وتوليد المتجه.",
        test: "التحقق من إنتاج متجه بأبعاد دقيقة وثبات الخصائص الرياضية.",
        review: "مراجعة حظر حفظ الصور الخام والالتزام بالمتجهات المشفرة فقط."
      },
      {
        num: "07",
        folder: "07_TEMPLATE_REPOSITORY",
        name: "التخزين المشفر وإدارة القوالب الحيوية",
        goal: "تخزين متجهات البصمة في قاعدة بيانات محلية مشفرة باستخدام خوارزمية AES-256 لحماية خصوصية الطلاب.",
        targetFile: "mobile_app/lib/biometric/storage/secure_template_repository.dart",
        exec: "بناء مستودع التخزين المشفر مع إدارة مفاتيح التشفير المحلية.",
        test: "اختبار حفظ واسترجاع وتشفير وفك تشفير القوالب بأمان تام.",
        review: "مراجعة معايير التشفير والامتثال الصارم لخصوصية البيانات."
      },
      {
        num: "08",
        folder: "08_MATCHING_ALGORITHM",
        name: "خوارزمية المطابقة الرياضية (Cosine Similarity)",
        goal: "تطبيق خوارزمية قياس التشابه الجيبي (Cosine Distance) والمسافة الإقليدية بين القوالب الحيوية بسرعة فائقة.",
        targetFile: "mobile_app/lib/biometric/matching/cosine_matcher.dart",
        exec: "كتابة دالة حساب التشابه الرياضي وتحسينها للأجهزة المحمولة.",
        test: "اختبار مقارنة 100 قالب في أقل من 5 ميلي ثانية بدقة متناهية.",
        review: "مراجعة كفاءة الأداء الرياضي والصحة الحسابية."
      },
      {
        num: "09",
        folder: "09_THRESHOLD_CALIBRATION",
        name: "معايرة عتبات القبول والرفض (Threshold Tuning)",
        goal: "ضبط عتبات التطابق لضمان نسبة قبول خاطئ FAR < 0.001% ونسبة رفض خاطئ FRR < 1% وفق المعايير الأكاديمية.",
        targetFile: "mobile_app/lib/biometric/calibration/threshold_config.dart",
        exec: "برمجة حدود القبول الصارمة ومعالجة الحالات الحدية.",
        test: "تشغيل مصفوفة اختبار المعايرة ومطابقة النتائج الإحصائية.",
        review: "مراجعة نسب الدقة الإحصائية ومطابقتها للمتطلبات."
      },
      {
        num: "10",
        folder: "10_VERIFICATION_FLOW",
        name: "تدفق التحقق الحيوي المباشر (1:1 Verification)",
        goal: "بناء مسار التحقق 1:1 لمطابقة صورة الطالب المباشرة مع قالبه المخزن المسجل في ملفه الشخصي.",
        targetFile: "mobile_app/lib/biometric/flow/one_to_one_verifier.dart",
        exec: "تجميع مسار الالتقاط، الحيوية، استخراج القالب، والمطابقة الفردية.",
        test: "اختبار التدفق الشامل للتحقق وتقديم قرار (MATCH / NO_MATCH).",
        review: "مراجعة سرعة التدفق وتجربة المستخدم وردود الفعل."
      },
      {
        num: "11",
        folder: "11_STUDENT_VERIFICATION_CONTEXT",
        name: "ربط التحقق الحيوي بهوية الطالب والجلسة",
        goal: "ربط نتيجة البصمة بمعرف الطالب وجلسة الحضور وتوليد رمز توثيق مشفر يثبت الحضور الفعلي.",
        targetFile: "mobile_app/lib/biometric/context/verification_context_guard.dart",
        exec: "بناء حارس السياق الأكاديمي والتحقق من صلاحية الجلسة.",
        test: "التحقق من عدم إمكانية استخدام بصمة طالب لحساب طالب آخر.",
        review: "مراجعة الأمان التكاملي ومنع التلاعب بالسياق."
      },
      {
        num: "12",
        folder: "12_IDENTIFICATION_CONTRACT",
        name: "عقد المطابقة الجماعية في القاعة (1:N Identification)",
        goal: "بناء محرك المطابقة السريعة للبحث عن الطالب الحاضر ضمن قائمة طلاب الشعبة المسجلين في القاعة.",
        targetFile: "mobile_app/lib/biometric/identification/one_to_n_identifier.dart",
        exec: "برمجة خوارزمية البحث الموجه السريع في مصفوفة القوالب.",
        test: "اختبار التعرف على الطالب من بين 150 قالباً في أقل من 50 ميلي ثانية.",
        review: "مراجعة قابلية التوسع وكفاءة البحث المتعدد."
      },
      {
        num: "13",
        folder: "13_ENGINE_PLATFORM_ADAPTER",
        name: "مهايئ المنصات والتكامل مع النظام (Native Bridge)",
        goal: "بناء المهايئ الذي يربط بين مكتبات C++/FFI أو محرك المنصة الأصلي وواجهات Flutter Dart.",
        targetFile: "mobile_app/lib/biometric/platform/platform_biometric_adapter.dart",
        exec: "كتابة قنوات الاتصال والـ MethodChannels أو الـ FFI bindings.",
        test: "التحقق من عمل المهايئ واستقبال البيانات دون انقطاع.",
        review: "مراجعة التوافقية وعزل تفاصيل المنصة عن النطاق الرئيسي."
      },
      {
        num: "14",
        folder: "14_PERFORMANCE_AND_ACCURACY",
        name: "فحص الأداء والسرعة والدقة القياسية",
        goal: "قياس زمن الاستجابة الإجمالي (يجب أن يكون أقل من 500 ميلي ثانية من الالتقاط حتى النتيجة) واستهلاك البطارية.",
        targetFile: "mobile_app/test/biometric/performance_benchmark_test.dart",
        exec: "كتابة وتشغيل اختبارات قياس الأداء والأزمنة (Benchmarks).",
        test: "التأكد من تحقيق زمن < 500ms ومعدل دقة يفوق 99.5%.",
        review: "مراجعة تقارير الأداء وتوثيق المقاييس."
      },
      {
        num: "15",
        folder: "15_SECURITY_AND_ARCHITECTURE_AUDIT",
        name: "التدقيق الأمني لمحرك البصمة ومنع التزوير",
        goal: "تدقيق أمان الذاكرة، تنظيف المتغيرات الحساسة بعد المقارنة، ومنع هجمات الحقن والتلاعب بالنتائج.",
        targetFile: "mobile_app/test/biometric/security_audit_test.dart",
        exec: "فحص سلامة إدارة الذاكرة وتصفير المتجهات الحساسة فور الانتهاء.",
        test: "تشغيل اختبارات محاكاة التلاعب والتأكد من متانة الحماية.",
        review: "مراجعة أمنية متقدمة وخلو المحرك من أي ثغرة."
      },
      {
        num: "16",
        folder: "16_INTEGRATION_ADAPTER",
        name: "مهايئ التكامل مع واجهات الهاتف والخادم",
        goal: "توفير مهايئ نظيف وسهل الاستخدام لتمكين واجهات أواب وخادم العيدروس من استدعاء البصمة بدالة واحدة بسيطة.",
        targetFile: "mobile_app/lib/biometric/integration/biometric_facade.dart",
        exec: "بناء واجهة الفاساد (Facade) المبسطة للتكامل.",
        test: "اختبار استدعاء التحقق وتلقي النتيجة عبر الـ Event Stream.",
        review: "مراجعة سهولة الاستخدام ونظافة العقد التكاملي."
      },
      {
        num: "17",
        folder: "17_HANDOFF",
        name: "المراجعة الشاملة والتسليم النهائي لمحرك البصمة",
        goal: "إجراء اختبار انحدار شامل لمحرك البصمة، توثيق كافة مؤشرات الدقة، ملء تقرير التسليم، وتسليمه للقائد.",
        targetFile: "team_delivery/02_MOHAMMED_ALAWADI_BIOMETRIC/handoff/HANDOFF_REPORT.md",
        exec: "تشغيل الفحص الشامل لجميع وحدات المحرك وإعداد حزمة التسليم.",
        test: "تشغيل كافة اختبارات البصمة وضمان نجاحها بنسبة 100%.",
        review: "مراجعة سحابية نهائية وحصول الحزمة على الاعتماد [PASS]."
      }
    ]
  },
  {
    id: "03",
    code: "03_MOHAMMED_ALAYDAROUS_LOCAL",
    name: "محمد العيدروس",
    role: "Local Network, Embedded Server & QR Specialist (خبير الخادم المحلي والـ QR وإدارة الطوابير)",
    workspace: "mobile_app/ (داخل مجلدات الخادم المحلي والـ QR)",
    deliveryDir: "team_delivery/03_MOHAMMED_ALAYDAROUS_LOCAL/",
    allowedPaths: [
      "mobile_app/lib/local_server/",
      "mobile_app/lib/local_network/",
      "mobile_app/lib/qr_session/",
      "mobile_app/lib/attendance_queue/",
      "mobile_app/test/local_server/",
      "mobile_app/test/qr_session/",
      "mobile_app/test/attendance_queue/"
    ],
    forbiddenPaths: [
      "mobile_app/lib/app/ (ملك أواب)",
      "mobile_app/lib/student/ (ملك أواب)",
      "mobile_app/lib/delegate/ (ملك أواب)",
      "mobile_app/lib/biometric/ (ملك محمد العواضي)",
      "admin_web/ (ملك مشعل الحاج)",
      "backend/ (ملك قائد المشروع)",
      "team_package/ (مرجع للقراءة فقط)"
    ],
    tasks: [
      {
        num: "01",
        folder: "01_LOCAL_NETWORK_MANAGER",
        name: "مدير الشبكة المحلية واكتشاف الـ IP والـ Wi-Fi",
        goal: "اكتشاف عنوان الـ IP المحلي للهاتف، مراقبة حالة اتصال الـ Wi-Fi ونقطة الاتصال (Hotspot)، وتوفير واجهة إدارة الشبكة.",
        targetFile: "mobile_app/lib/local_network/network_manager.dart",
        exec: "برمجة مراقب واجهات الشبكة واكتشاف عنوان الـ IP الفعال.",
        test: "اختبار اكتشاف الـ IP في حالات الـ Wi-Fi والـ Hotspot ومعالجة انقطاع الشبكة.",
        review: "مراجعة سلامة فحص الشبكة واستقرار الأداء."
      },
      {
        num: "02",
        folder: "02_PORT_MANAGER",
        name: "مدير المنافذ والربط الديناميكي (Port Manager)",
        goal: "فحص وتحديد المنافذ المتاحة للعمل (Dynamic Port Binding) وتفادي تعارض المنافذ مع تطبيقات أخرى.",
        targetFile: "mobile_app/lib/local_server/port_manager.dart",
        exec: "برمجة مكتشف المنافذ الحرة وآلية حجز المنفذ التلقائي.",
        test: "التحقق من حجز منفذ متاح وإعادة المحاولة في حال انشغال المنفذ.",
        review: "مراجعة معالجة أخطاء المنافذ واستقرار التهيئة."
      },
      {
        num: "03",
        folder: "03_EMBEDDED_HTTP_SERVER",
        name: "الخادم المحلي المدمج في الهاتف (Embedded HTTP Server)",
        goal: "بناء وتشغيل خادم HTTP محلي خفيف الوزن ومستقر مدمج داخل هاتف المندوب/الأستاذ لاستقبال طلبات الحضور دون إنترنت.",
        targetFile: "mobile_app/lib/local_server/embedded_server_core.dart",
        exec: "تهيئة محرك الخادم المحلي ومعالجة الطلبات الواردة.",
        test: "اختبار إقلاع الخادم والاستجابة لطلبات الفحص (Ping/Health Check).",
        review: "مراجعة كفاءة استخدام الموارد واستقرار الخادم في الخلفية."
      },
      {
        num: "04",
        folder: "04_SESSION_LIFECYCLE",
        name: "دورة حياة جلسة الحضور المحلية (State Machine)",
        goal: "إدارة حالات جلسة الحضور المحلية بدقة (قيد التهيئة، نشطة، متوقفة مؤقتاً، مغلقة، وجاهزة للمزامنة).",
        targetFile: "mobile_app/lib/local_server/session_state_machine.dart",
        exec: "برمجة آلة الحالات (State Machine) وحظر العمليات غير المصرح بها في الحالات المغلقة.",
        test: "فحص الانتقال السليم بين الحالات ومنع استقبال الحضور بعد الإغلاق.",
        review: "مراجعة سلامة دورة الحياة والتحكم في الجلسة."
      },
      {
        num: "05",
        folder: "05_SESSION_GUARD",
        name: "حارس الجلسة والتحقق من الصلاحيات (Session Guard)",
        goal: "التحقق من صحة التوكن الصادر للمندوب/الأستاذ وصلاحيته لبدء الجلسة لهذه الشعبة الأكاديمية تحديداً.",
        targetFile: "mobile_app/lib/local_server/guards/session_auth_guard.dart",
        exec: "بناء مرشح التحقق من الصلاحيات ورفض الطلبات غير المصرح بها.",
        test: "اختبار حظر الجلسات غير المصرح بها وتوثيق محاولات الدخول المرفوضة.",
        review: "مراجعة الأمان الصارم للتحكم في الجلسات المحلية."
      },
      {
        num: "06",
        folder: "06_DISCOVERY_PROTOCOL",
        name: "بروتوكول اكتشاف الخادم في القاعة (Service Discovery)",
        goal: "تمكين هواتف الطلاب من اكتشاف خادم القاعة المحلي تلقائياً عبر بروتوكول البث المحلي (Local Broadcast / mDNS).",
        targetFile: "mobile_app/lib/local_network/discovery_service.dart",
        exec: "برمجة خدمة الإعلان والاستكشاف التلقائي لعنوان الخادم.",
        test: "اختبار عثور هاتف الطالب على الخادم في أقل من ثانية واحدة.",
        review: "مراجعة كفاءة بروتوكول الاكتشاف وعدم إغراق الشبكة بالرسائل."
      },
      {
        num: "07",
        folder: "07_DYNAMIC_QR_GENERATOR",
        name: "مولد رمز الاستجابة السريعة الديناميكي (Dynamic QR)",
        goal: "توليد كود QR مشفر يتغير كل 5 ثوانٍ يحتوي على (SessionId, Nonce, Timestamp, TOTP Hash) لمنع تصوير الشاشة وتمرير الكود.",
        targetFile: "mobile_app/lib/qr_session/dynamic_qr_generator.dart",
        exec: "برمجة خوارزمية توليد الـ Nonce وتحديث الكود دورياً كل 5 ثوانٍ.",
        test: "التحقق من تغير الكود بدقة ومزامنة التوقيت ومنع تكرار الـ Nonce.",
        review: "مراجعة الأمان ومقاومة هجمات تصوير الـ QR (Anti-Replay)."
      },
      {
        num: "08",
        folder: "08_QR_CLIENT_SCAN_VERIFY",
        name: "فحص وتفكيك وتدقيق رمز الـ QR من هاتف الطالب",
        goal: "قراءة رمز الـ QR من كاميرا الطالب، فك تشفيره، والتحقق من حداثة التوقيت وصلاحية الـ Nonce قبل إرسال الطلب.",
        targetFile: "mobile_app/lib/qr_session/qr_payload_verifier.dart",
        exec: "بناء محلل الحمولة وتدقيق التوقيع الزمني وصلاحية الرمز.",
        test: "اختبار قبول الرمز الصالح ورفض الأكواد منتهية الصلاحية (> 5s).",
        review: "مراجعة دقة التدقيق وحماية التطبيق من الأكواد المزيفة."
      },
      {
        num: "09",
        folder: "09_STUDENT_LOCAL_CLIENT",
        name: "عميل اتصال الطالب بالخادم المحلي في القاعة",
        goal: "برمجة عميل HTTP خفيف داخل هاتف الطالب يرسل بيانات التحضير والبصمة إلى خادم القاعة المحلي مع المصافحة الآمنة.",
        targetFile: "mobile_app/lib/local_network/student_local_client.dart",
        exec: "بناء عميل الإرسال المحلي مع إعادة المحاولة الذكية عند تعثر الشبكة.",
        test: "اختبار إرسال الطلب واستقبال الرد الفوري في أقل من 100 ميلي ثانية.",
        review: "مراجعة سرعة الاستجابة ومعالجة انقطاع الاتصال المؤقت."
      },
      {
        num: "10",
        folder: "10_ATTENDANCE_PROCESSING_QUEUE",
        name: "طابور معالجة الحضور المتزامن (FIFO Async Queue)",
        goal: "بناء طابور معالجة تسلسلي غير متزامن مع قفل حماية (Mutex Lock) لمعالجة طلبات الطلاب الواردة في نفس اللحظة دون تداخل.",
        targetFile: "mobile_app/lib/attendance_queue/attendance_queue_processor.dart",
        exec: "برمجة طابور الـ FIFO مع إدارة التزامن ومنع تضارب الكتابة.",
        test: "اختبار دخول 50 طلباً دفعة واحدة وتسكينها في الطابور ومعالجتها بالترتيب.",
        review: "مراجعة سلامة التزامن (Thread Safety) وخلو النظام من حالات الـ Race Condition."
      },
      {
        num: "11",
        folder: "11_IDEMPOTENCY_REQUEST_ID",
        name: "منع تكرار التحضير وحماية الـ Idempotency",
        goal: "توليد وفحص معرف الطلب الفريد (Request-Id) لضمان عدم تسجيل حضور الطالب مرتين في نفس الجلسة حتى لو ضغط الزر عدة مرات.",
        targetFile: "mobile_app/lib/attendance_queue/idempotency_guard.dart",
        exec: "برمجة سجل الـ Request-Id المؤقت ورفض الطلبات المكررة فوراً.",
        test: "اختبار إرسال نفس الطلب 5 مرات متتالية والتأكد من تسجيله مرة واحدة فقط.",
        review: "مراجعة حماية النظام من التكرار والازدواجية."
      },
      {
        num: "12",
        folder: "12_LOCAL_AUTHORIZATION",
        name: "التحقق المحلي من قيد الطالب في الشعبة",
        goal: "مطابقة معرف الطالب مع القائمة المحلية لطلاب الشعبة المسجلين للتأكد من أحقيته في حضور هذه المحاضرة.",
        targetFile: "mobile_app/lib/local_server/local_enrollment_matcher.dart",
        exec: "بناء دالة المطابقة السريعة في مصفوفة الطلاب المعتمدة.",
        test: "اختبار قبول الطالب المسجل ورفض الطالب من شعبة أخرى فورياً.",
        review: "مراجعة دقة المطابقة الأكاديمية والسرعة في القاعة."
      },
      {
        num: "13",
        folder: "13_LOCAL_RESPONSE_CONTRACT",
        name: "عقد استجابة الخادم المحلي الموحد (JSON Contract)",
        goal: "توحيد صياغة استجابات الخادم المحلي (Success / Error / Duplicate / ExpiredQR) بتنسيق JSON موحد ومتوافق مع المعايير.",
        targetFile: "mobile_app/lib/local_server/contracts/local_response_payload.dart",
        exec: "بناء نماذج الاستجابة الموحدة ورموز الحالة الخاصة بالقاعة.",
        test: "التحقق من تطابق بنية الاستجابة في كافة الحالات الطبيعية والاستثنائية.",
        review: "مراجعة الالتزام بالعقد البرمجي الموحد للشبكة المحلية."
      },
      {
        num: "14",
        folder: "14_GRACEFUL_SHUTDOWN",
        name: "الإغلاق الآمن للخادم وتفريغ الطابور",
        goal: "إغلاق الخادم المحلي بأمان عند انتهاء الجلسة، تفريغ كافة الطلبات المتبقية في الطابور، وتجهيز الحزمة للمزامنة.",
        targetFile: "mobile_app/lib/local_server/server_shutdown_handler.dart",
        exec: "برمجة مسار الإغلاق المتدرج وحفظ البيانات في التخزين الدائم.",
        test: "اختبار إيقاف الخادم والتأكد من عدم فقدان أي طلب حضور كان في الطابور.",
        review: "مراجعة موثوقية حفظ البيانات وسلامة إنهاء الخدمة."
      },
      {
        num: "15",
        folder: "15_NETWORK_FAILURE_HANDLING",
        name: "معالجة انقطاع الشبكة واستعادة الاتصال",
        goal: "التعامل الذكي مع حالات قطع اتصال الـ Wi-Fi، انطفاء الـ Hotspot، وإعادة إنشاء الاتصال تلقائياً دون فقدان الجلسة.",
        targetFile: "mobile_app/lib/local_network/network_resilience_handler.dart",
        exec: "برمجة معالج التعافي الذاتي من أخطاء الشبكة المؤقتة.",
        test: "محاكاة فصل وإعادة توصيل الشبكة والتحقق من استمرار الجلسة بنجاح.",
        review: "مراجعة متانة النظام وتحمله لظروف القاعات الواقعية."
      },
      {
        num: "16",
        folder: "16_STRESS_50_CLIENTS",
        name: "اختبار الضغط ومعالجة 50 طالباً متزامناً",
        goal: "إجراء اختبار إجهاد يحاكي إرسال 50 طالباً لطلبات حضورهم في غضون ثانيتين والتحقق من معالجتها دون أي انهيار.",
        targetFile: "mobile_app/test/local_server/stress_test_50_clients.dart",
        exec: "كتابة سيناريو الإجهاد المتزامن وتشغيل المحاكاة الواقعية.",
        test: "التأكد من نجاح معالجة كافة الـ 50 طلباً بزمن استجابة متوسط < 1.5 ثانية.",
        review: "مراجعة تقرير الضغط واعتماد كفاءة الخادم المحلي."
      },
      {
        num: "17",
        folder: "17_SECURITY_AND_ARCHITECTURE_AUDIT",
        name: "التدقيق الأمني للشبكة المحلية ومنع التلاعب",
        goal: "فحص أمان الاتصال المحلي، منع هجمات الوسيط (MITM)، حظر هجمات إعادة الإرسال (Replay Attacks)، وتأمين حزم البيانات.",
        targetFile: "mobile_app/test/local_server/security_audit_test.dart",
        exec: "فحص تشفير الحزم وتدقيق صلاحية التوكنات والـ Nonce.",
        test: "تشغيل محاكاة الهجمات الأمنية والتأكد من صدها بنجاح 100%.",
        review: "مراجعة أمنية شاملة وإصدار اعتماد الحماية."
      },
      {
        num: "18",
        folder: "18_HANDOFF",
        name: "المراجعة الشاملة والتسليم النهائي للخادم المحلي والـ QR",
        goal: "إجراء اختبار انحدار كامل لوحدات الخادم المحلي والـ QR والطوابير، ملء تقرير التسليم، وتسليمه للقائد.",
        targetFile: "team_delivery/03_MOHAMMED_ALAYDAROUS_LOCAL/handoff/HANDOFF_REPORT.md",
        exec: "تشغيل الفحص الشامل لجميع المكونات وإعداد حزمة التسليم الرسمية.",
        test: "تشغيل كافة الاختبارات الخاصة بالخادم والطوابير وضمان نجاحها 100%.",
        review: "مراجعة سحابية نهائية وحصول الحزمة على الاعتماد [PASS]."
      }
    ]
  },
  {
    id: "04",
    code: "04_MISHAL_ADMIN_WEB",
    name: "مشعل الحاج",
    role: "Admin Web Developer (مطور لوحة التحكم المركزية للويب)",
    workspace: "admin_web/",
    deliveryDir: "team_delivery/04_MISHAL_ADMIN_WEB/",
    allowedPaths: [
      "admin_web/lib/app/",
      "admin_web/lib/core/",
      "admin_web/lib/features/",
      "admin_web/lib/shared/",
      "admin_web/test/"
    ],
    forbiddenPaths: [
      "mobile_app/ (ملك أواب والعواضي والعيدروس)",
      "backend/ (ملك قائد المشروع)",
      "team_package/ (مرجع للقراءة فقط)"
    ],
    tasks: [
      {
        num: "01",
        folder: "01_WEB_FOUNDATION",
        name: "البنية التحتية لتطبيق الويب ونظام التصميم",
        goal: "تأسيس مشروع Flutter Web، تطبيق Material 3، دعم اللغة العربية والاتجاه RTL بالكامل، ضبط الرموز والألوان والخطوط الرسمية وشبكة العرض المتجاوبة.",
        targetFile: "admin_web/lib/app/app.dart و admin_web/lib/core/theme/",
        exec: "بناء ثيم الويب الرسمي والألوان المتدرجة وتكوين التطبيق.",
        test: "التحقق من إقلاع لوحة الويب وثبات اتجاه RTL وتجاوب العرض.",
        review: "مراجعة الالتزام بنظام التصميم M3 وحظر الإيموجي والألوان المعتمدة."
      },
      {
        num: "02",
        folder: "02_WEB_ARCHITECTURE_NAVIGATION",
        name: "المعمارية وهيكل القوائم والتوجيه للويب",
        goal: "بناء هيكل القوائم الجانبية (Navigation Rail / Sidebar)، الشريط العلوي (Top App Bar)، ونظام التوجيه GoRouter مع دعم الروابط المباشرة وتغيير العناوين.",
        targetFile: "admin_web/lib/core/routing/app_router.dart و admin_web/lib/shared/layout/",
        exec: "بناء الهيكل الرئيسي للوحة التحكم وإدارة مسارات التوجيه.",
        test: "اختبار التنقل السلس بين الأقسام وتحديث شريط العناوين في المتصفح.",
        review: "مراجعة سلاسة التنقل وتجاوب القوائم مع أحجام الشاشات المختلفة."
      },
      {
        num: "03",
        folder: "03_WEB_API_CLIENT",
        name: "عميل الاتصال المركزي بالباك إند للويب",
        goal: "بناء عميل Dio للويب مع اعتراضات التوكن، معالجة CORS، التخزين المؤقت، واعتراض الأخطاء الموحد.",
        targetFile: "admin_web/lib/core/network/web_api_client.dart",
        exec: "برمجة عميل الاتصال وإعداد الترويسات ومعالجة رموز الاستجابة.",
        test: "اختبار إرسال الطلبات وتجديد التوكن ومعالجة انقطاع الاتصال.",
        review: "مراجعة كفاءة معالجة الأخطاء والتخزين الآمن للجلسة."
      },
      {
        num: "04",
        folder: "04_ADMIN_AUTH_GUARD",
        name: "حارس المصادقة وصلاحيات الأدمن وشاشة الدخول",
        goal: "شاشة تسجيل دخول الأدمن، التحقق من اسم المستخدم وكلمة السر، حفظ الجلسة، وحظر الوصول للصفحات الداخلية بدون تصريح.",
        targetFile: "admin_web/lib/features/auth/admin_login_screen.dart",
        exec: "بناء شاشة الدخول مع الحالات الخمس وحماية المسارات الداخلية.",
        test: "فحص حظر الدخول المباشر للروابط وإعادة التوجيه لصفحة تسجيل الدخول.",
        review: "مراجعة أمان الجلسات الإدارية وحماية التوكن."
      },
      {
        num: "05",
        folder: "05_DASHBOARD_METRICS",
        name: "لوحة المؤشرات والإحصائيات الحية (Dashboard KPIs)",
        goal: "لوحة المؤشرات الرئيسية: عدد الطلاب، الأقسام، الأساتذة، الجلسات النشطة حالياً، ورسوم بيانية لنسب الحضور الأسبوعية والشهرية.",
        targetFile: "admin_web/lib/features/dashboard/admin_dashboard_screen.dart",
        exec: "بناء بطاقات الإحصائيات (KPI Cards) والرسوم البيانية التفاعلية.",
        test: "فحص تحميل البيانات وعرض المؤشرات واختبار زر التحديث.",
        review: "مراجعة جمالية العرض واكتمال الحالات الخمس وتجربة المستخدم."
      },
      {
        num: "06",
        folder: "06_DEPARTMENTS_MANAGEMENT",
        name: "إدارة الأقسام الأكاديمية (Departments CRUD)",
        goal: "جدول إدارة الأقسام الأكاديمية: عرض، إضافة قسم جديد، تعديل، تعطيل/تفعيل، والتحقق من صحة المدخلات.",
        targetFile: "admin_web/lib/features/departments/departments_screen.dart",
        exec: "بناء جدول الأقسام ونموذج الإضافة والتعديل مع التحقق من الحقول.",
        test: "اختبار عمليات الـ CRUD والتحقق من منع الأسماء المكررة.",
        review: "مراجعة الالتزام بالعقد البرمجي وجودة الواجهات."
      },
      {
        num: "07",
        folder: "07_ACADEMIC_YEARS_MANAGEMENT",
        name: "إدارة الأعوام الدراسية (Academic Years CRUD)",
        goal: "جدول إدارة الأعوام الدراسية وتعيين العام الدراسي الفعال والتحكم في فترات الدراسة.",
        targetFile: "admin_web/lib/features/academic_years/academic_years_screen.dart",
        exec: "بناء واجهة الأعوام الدراسية وتحديد العام الفعال بالنظام.",
        test: "فحص تعيين عام فعال واحد فقط وتحديث السجلات بنجاح.",
        review: "مراجعة اتساق البيانات وقواعد الأعمال الأكاديمية."
      },
      {
        num: "08",
        folder: "08_SEMESTERS_MANAGEMENT",
        name: "إدارة الفصول الدراسية (Semesters CRUD)",
        goal: "جدول إدارة الفصول الدراسية (فصل أول، ثانٍ، صيفي) وتواريخ البداية والنهاية وربطها بالعام الأكاديمي.",
        targetFile: "admin_web/lib/features/semesters/semesters_screen.dart",
        exec: "بناء واجهة الفصول مع منتقي التواريخ (Date Range Picker).",
        test: "التحقق من صحة التواريخ ومنع تداخل الفصول لنفس العام.",
        review: "مراجعة دقة واجهة اختيار التواريخ والتحقق."
      },
      {
        num: "09",
        folder: "09_COURSES_MANAGEMENT",
        name: "إدارة المقررات الدراسية (Courses CRUD)",
        goal: "جدول المقررات: رمز المقرر، الاسم بالعربي والإنجليزي، الساعات المعتمدة، والقسم الأكاديمي التابع له.",
        targetFile: "admin_web/lib/features/courses/courses_screen.dart",
        exec: "بناء جدول المقررات مع البحث والفلترة حسب القسم.",
        test: "اختبار إضافة مقرر وفحص تفرد رمز المقرر (Course Code).",
        review: "مراجعة سلاسة البحث والفلترة ومطابقة العقود."
      },
      {
        num: "10",
        folder: "10_SECTIONS_MANAGEMENT",
        name: "إدارة الشعب والمجموعات (Sections CRUD)",
        goal: "جدول إدارة الشعب: ربط الشعبة بالمقرر، تحديد نوعها (نظري/عملي)، السعة القصوى، والقاعة المخصصة.",
        targetFile: "admin_web/lib/features/sections/sections_screen.dart",
        exec: "بناء واجهة الشعب وتصنيفها حسب النوع والمقرر.",
        test: "اختبار إضافة الشعبة والتحقق من العلاقات مع المقررات.",
        review: "مراجعة دقة النماذج والتحقق من صحة المدخلات."
      },
      {
        num: "11",
        folder: "11_STUDENTS_MANAGEMENT",
        name: "إدارة بيانات الطلاب (Students Master CRUD)",
        goal: "جدول إدارة الطلاب الشامل: الرقم الأكاديمي، الاسم الكامل، القسم، المستوى، الحالة الأكاديمية، والبحث المتقدم.",
        targetFile: "admin_web/lib/features/students/students_screen.dart",
        exec: "بناء جدول الطلاب مع ترقيم الصفحات (Pagination) والبحث الفوري.",
        test: "اختبار تعديل بيانات الطالب والتحقق من صحة الرقم الأكاديمي.",
        review: "مراجعة أداء الجدول مع كميات البيانات الكبيرة."
      },
      {
        num: "12",
        folder: "12_BATCH_STUDENT_IMPORT",
        name: "الاستيراد الجماعي للطلاب عبر Excel/CSV",
        goal: "نافذة رفع ملفات Excel/CSV، فحص صحة البيانات قبل الاستيراد، عرض الأخطاء إن وجدت، وشريط تقدم الرفع.",
        targetFile: "admin_web/lib/features/students/batch_import_dialog.dart",
        exec: "بناء معالج تحليل الملفات ومعاينة البيانات وشريط التقدم.",
        test: "اختبار رفع ملف به أخطاء والتأكد من إظهار رسائل تصحيحية واضحة.",
        review: "مراجعة معايير فحص الملفات وتجربة المستخدم المميزة."
      },
      {
        num: "13",
        folder: "13_STUDENT_IMAGES_MANAGEMENT",
        name: "إدارة الصور المرجعية للبصمة الحيوية",
        goal: "واجهة استعراض وتحديث الصور المرجعية للطلاب المستخدمة في استخراج القوالب الحيوية مع معاينة الجودة.",
        targetFile: "admin_web/lib/features/students/student_biometric_images_screen.dart",
        exec: "بناء معرض صور الطلاب المرجعية وأداة رفع الصور وتدقيق الأبعاد.",
        test: "اختبار رفع وتحديث الصور والتأكد من قيود الحجم والنوع.",
        review: "مراجعة حماية الخصوصية وعرض الصور الآمن."
      },
      {
        num: "14",
        folder: "14_TEACHERS_MANAGEMENT",
        name: "إدارة أعضاء هيئة التدريس (Teachers CRUD)",
        goal: "جدول إدارة الأساتذة: الاسم، القسم، الدرجة العلمية، البريد الإلكتروني، رقم الهاتف، والحالة الأكاديمية.",
        targetFile: "admin_web/lib/features/teachers/teachers_screen.dart",
        exec: "بناء جدول الأساتذة ونماذج الإضافة والتعديل والفلترة.",
        test: "اختبار إضافة أستاذ والتحقق من صحة البريد الإلكتروني والبيانات.",
        review: "مراجعة جودة النماذج واتساق التصميم."
      },
      {
        num: "15",
        folder: "15_DELEGATES_MANAGEMENT",
        name: "إدارة مناديب الدفع والشعب (Delegates CRUD)",
        goal: "جدول تعيين مناديب الشعب من بين الطلاب، وتحديد صلاحياتهم وفترة تكليفهم وتتبع نشاطهم.",
        targetFile: "admin_web/lib/features/delegates/delegates_screen.dart",
        exec: "بناء واجهة اختيار المندوب من قائمة الطلاب وربطه بالشعبة.",
        test: "اختبار تعيين مندوب والتحقق من قيده الأكاديمي بالشعبة.",
        review: "مراجعة ضوابط تعيين المناديب وأمان الصلاحيات."
      },
      {
        num: "16",
        folder: "16_ACTIVATION_CODES_MANAGEMENT",
        name: "توليد وإدارة أكواد تفعيل الأجهزة",
        goal: "نظام توليد أكواد تفعيل أجهزة الهواتف (Activation Codes) للطلاب والأساتذة مع تحديد فترة الصلاحية وإلغاء التفعيل.",
        targetFile: "admin_web/lib/features/activation_codes/activation_codes_screen.dart",
        exec: "بناء مولد الأكواد وجدول الأكواد الفعالة والمستخدمة والملغاة.",
        test: "اختبار توليد كود جديد وفحص انتهاء الصلاحية وإلغاء الكود.",
        review: "مراجعة أمان الأكواد ومنع التكرار وسهولة النسخ."
      },
      {
        num: "17",
        folder: "17_ENROLLMENTS_MANAGEMENT",
        name: "إدارة تسجيل وقيد الطلاب بالشعب (Enrollments Matrix)",
        goal: "مصفوفة تسجيل الطلاب في الشعب الدراسية: إضافة طالب لشعبة، حذف، والتسجيل الجماعي للشعب.",
        targetFile: "admin_web/lib/features/enrollments/enrollments_screen.dart",
        exec: "بناء مصفوفة القيد مع أدوات النقل السريع والبحث متعدد المعايير.",
        test: "اختبار قيد طالب في شعبة والتحقق من عدم تجاوز السعة القصوى.",
        review: "مراجعة سهولة الاستخدام للمسؤول الأكاديمي."
      },
      {
        num: "18",
        folder: "18_TEACHER_ASSIGNMENTS",
        name: "تكليفات الأساتذة بالمقررات والشعب",
        goal: "واجهة ربط الأساتذة بالمقررات والشعب المخصصة لهم سواء كانت محاضرات نظرية أو معامل تطبيقية.",
        targetFile: "admin_web/lib/features/assignments/teacher_assignments_screen.dart",
        exec: "بناء واجهة التكليفات مع جدول المواعيد وتفادي التعارض.",
        test: "اختبار تكليف أستاذ والتأكد من ظهور المقرر في حسابه.",
        review: "مراجعة اتساق التكليفات الأكاديمية والواجهات."
      },
      {
        num: "19",
        folder: "19_DELEGATE_SECTION_ASSIGNMENTS",
        name: "تعيين المناديب على الشعب الميدانية",
        goal: "لوحة تخصيص المناديب على الشعب الدراسية وإدارة فترة التفويض وتجديد الصلاحيات.",
        targetFile: "admin_web/lib/features/assignments/delegate_assignments_screen.dart",
        exec: "بناء واجهة تعيين وتفويض المناديب الميدانيين.",
        test: "التحقق من ربط المندوب بالشعبة الصحيحة وتحديث حالته.",
        review: "مراجعة الأمان ودقة الربط الأكاديمي."
      },
      {
        num: "20",
        folder: "20_SESSIONS_MONITOR_VIEW",
        name: "مراقبة جلسات الحضور الحية (Live Sessions Monitor)",
        goal: "شاشة المراقبة اللحظية: عرض الجلسات النشطة حالياً في القاعات، أسماء الأساتذة والمناديب، وعدد الطلاب الحاضرين لحظة بلحظة.",
        targetFile: "admin_web/lib/features/sessions/live_sessions_monitor_screen.dart",
        exec: "بناء لوحة المراقبة الحية مع التحديث التلقائي وشارات الحالة الملونة.",
        test: "اختبار استلام تحديثات الجلسات وعرض الحالات فورياً.",
        review: "مراجعة سرعة الاستجابة وتصميم شاشة المراقبة الممتعة."
      },
      {
        num: "21",
        folder: "21_ATTENDANCE_RECORDS_VIEW",
        name: "استعراض وتدقيق سجلات الحضور الشاملة",
        goal: "سجل الحضور التاريخي العام: استعراض كافة حركات الحضور مع فلاتر التاريخ، المادة، الشعبة، الطالب، وطريقة التحضير (بصمة/يدوي).",
        targetFile: "admin_web/lib/features/attendance_records/attendance_records_screen.dart",
        exec: "بناء جدول السجلات المتقدم مع البحث والفلترة المتعددة والتصدير.",
        test: "اختبار فلترة السجلات ومطابقة الأرقام الإجمالية.",
        review: "مراجعة دقة البيانات وسلاسة التصفح والفرز."
      },
      {
        num: "22",
        folder: "22_MANUAL_ATTENDANCE_APPROVALS",
        name: "اعتماد تعديلات الحضور والأعذار الطبية",
        goal: "لوحة مراجعة طلبات تعديل الحضور الاستثنائية والأعذار الطبية المرفوعة من الطلاب مع معاينة التقارير واتخاذ قرار الاعتماد.",
        targetFile: "admin_web/lib/features/approvals/attendance_approvals_screen.dart",
        exec: "بناء واجهة فحص الأعذار ومعاينة المرفقات وأزرار القبول/الرفض.",
        test: "اختبار اعتماد عذر والتأكد من تحديث سجل حضور الطالب فورياً.",
        review: "مراجعة تدفق الاعتماد الأكاديمي وضوابط التوثيق."
      },
      {
        num: "23",
        folder: "23_REPORTS_EXPORT_VIEW",
        name: "توليد وتصدير التقارير الإحصائية (PDF / Excel)",
        goal: "مركز تصدير التقارير: تقارير الحضور والغياب، كشوفات الحرمان، ونسب الحضور للمقررات بتنسيقات PDF منسقة و Excel جاهزة للطباعة.",
        targetFile: "admin_web/lib/features/reports/reports_export_screen.dart",
        exec: "برمجة مولد التقارير وتصدير ملفات Excel و PDF باللغة العربية المنسقة.",
        test: "اختبار تحميل ملف التقرير والتحقق من صحة التنسيق والبيانات.",
        review: "مراجعة دقة التقرير ومظهره المهني الأنيق."
      },
      {
        num: "24",
        folder: "24_AUDIT_LOG_VIEW",
        name: "سجل تدقيق عمليات النظام (System Audit Trail)",
        goal: "شاشة استعراض سجل التدقيق الأمني: توثيق كل عملية تمت على النظام (إضافة، تعديل، حذف، تسجيل دخول) مع هوية الفاعل والتوقيت والـ IP.",
        targetFile: "admin_web/lib/features/audit_logs/audit_logs_screen.dart",
        exec: "بناء جدول سجل التدقيق مع أدوات البحث والفلترة حسب نوع الحدث.",
        test: "التحقق من تسجيل وتوثيق الأحداث بدقة وعدم إمكانية تعديل السجل.",
        review: "مراجعة الامتثال لمعايير التدقيق الأمني والحوكمة."
      },
      {
        num: "25",
        folder: "25_PERMISSIONS_ROLES_UI",
        name: "إدارة الصلاحيات والأدوار الإدارية (RBAC Matrix)",
        goal: "واجهة إدارة الصلاحيات والأدوار (مدير نظام، مسجل عام، عميد، رئيس قسم) وتخصيص صلاحيات الوصول لكل دور.",
        targetFile: "admin_web/lib/features/roles/roles_permissions_screen.dart",
        exec: "بناء مصفوفة الصلاحيات مع مربعات الاختيار التفاعلية.",
        test: "اختبار تعديل صلاحيات دور والتحقق من انعكاسها على القوائم فورياً.",
        review: "مراجعة أمان الصلاحيات وحماية الأدوار الحساسة."
      },
      {
        num: "26",
        folder: "26_PERFORMANCE_SECURITY_AUDIT",
        name: "فحص الأداء والأمان الشامل للوحة الويب",
        goal: "تحسين حجم حزمة الويب (Bundle Optimization)، فحص استهلاك الذاكرة، والتأكد من الحماية ضد ثغرات XSS و CSRF وحماية الروابط.",
        targetFile: "admin_web/test/performance_security_audit_test.dart",
        exec: "تشغيل أدوات تدقيق الأداء وفحص الترويسات الأمنية للويب.",
        test: "التأكد من سرعة تحميل اللوحة < 1.5 ثانية وخلوها من الثغرات.",
        review: "مراجعة معايير الأمان والأداء وإصدار تقرير الفحص."
      },
      {
        num: "27",
        folder: "27_UI_UX_FINAL_AUDIT",
        name: "التدقيق النهائي لتجربة وواجهات المستخدم (UI/UX Audit)",
        goal: "تدقيق شامل لكافة شاشات اللوحة: الالتزام الصارم بـ Material 3، دعم RTL التام، تباين الألوان، الحالات الخمس لكل شاشة، وخلو النظام من أي إيموجي.",
        targetFile: "admin_web/test/ui_ux_final_audit_test.dart",
        exec: "مراجعة كافة الشاشات وضبط الحواشي والخطوط وتناسق المظهر.",
        test: "تشغيل اختبارات فحص واجهة المستخدم والتأكد من الجمالية الفائقة.",
        review: "مراجعة جمالية وإصدار شهادة المطابقة لنظام التصميم."
      },
      {
        num: "28",
        folder: "28_HANDOFF",
        name: "المراجعة الشاملة والتسليم النهائي للوحة الويب",
        goal: "إجراء اختبار انحدار شامل لكافة وحدات وشاشات لوحة الويب، ملء تقرير التسليم، وتسليمه لقائد المشروع.",
        targetFile: "team_delivery/04_MISHAL_ADMIN_WEB/handoff/HANDOFF_REPORT.md",
        exec: "تشغيل الفحص الشامل لجميع المكونات وإعداد حزمة التسليم الرسمية.",
        test: "تشغيل كافة اختبارات لوحة الويب وضمان نجاحها بنسبة 100%.",
        review: "مراجعة سحابية نهائية وحصول الحزمة على الاعتماد [PASS]."
      }
    ]
  }
];

// ==========================================
// GENERATOR FUNCTION FOR NOTION PAGES
// ==========================================

function generateMemberNotionPage(member) {
  let content = `# 📘 الدليل التشغيلي الشامل والمفصل لمنصة Notion
## 👤 العضو: ${member.name} (${member.role})
### 📦 حزمة التسليم: \`${member.code}\`
### 🏢 مساحة العمل البرمجية: \`${member.workspace}\`

---

> [!IMPORTANT]
> **مرحباً بك يا ${member.name.split(' ')[0]} في الفريق الهندسي لمشروع نظام الحضور والغياب الذكي.**
> هذا الدليل تم إعداده خصيصاً لك من أجلك؛ ليشرح لك مسارك البرمجي والتشغيلي خطوة بخطوة ومن الصفر المطلق حتى تسليم عملك بنجاح.
> انسخ هذه الصفحة كاملة إلى صفحتك الخاصة في **Notion** لتكون مرجعك اليومي الدائم في كل لحظة.

---

## 📑 فهرس المحتويات
1. [المعمارية العامة والطبقات الثلاث في جهازك](#-القسم-الأول-المعمارية-العامة-والطبقات-الثلاث-في-جهازك)
2. [الملفات الـ 13 الرئيسية في حزمة تسليمك (شرح تفصيلي)](#-القسم-الثاني-الملفات-الـ-13-الرئيسية-في-حزمتك-شرح-شامل)
3. [مجلدات الحزمة المرجعية المشتركة team_package](#-القسم-الثالث-مجلدات-الحزمة-المرجعية-المشتركة-team_package)
4. [مرحلة التأسيس المشترك COMMON_FOUNDATION (الخطوات الـ 7 الإلزامية)](#-القسم-الرابع-مرحلة-التأسيس-المشترك-common_foundation-الـ-7-خطوات)
5. [دورة العمل القياسية للمهمة (3-Prompt Pipeline Loop)](#-القسم-الخامس-دورة-العمل-القياسية-لكل-مهمة-نظام-البرومبتات-الثلاثي)
6. [المهام البرمجية التنفيذية tasks (${member.tasks.length} مهمة تفصيلية)](#-القسم-السادس-المهام-البرمجية-التنفيذية-tasks-شرح-الـ-${member.tasks.length}-مهمة)
7. [التوثيق السحابي والمراجعة وإجراءات التسليم النهائي](#-القسم-السابع-التوثيق-السحابي-والمراجعة-والتسليم-النهائي)

---

## 🏛️ القسم الأول: المعمارية العامة والطبقات الثلاث في جهازك

عندما تفتح مساحة العمل الخاصة بك على حاسوبك، ستجد ثلاثة مستويات رئيسية يجب أن تفهم الفرق بينها تماماً:

\`\`\`mermaid
graph TD
    A[team_package/ - الحزمة المرجعية المشتركة] -->|قراءة فقط Read-Only| D[المطور: ${member.name}]
    B[${member.deliveryDir} - حزمة التوجيه والتسليم] -->|أدلة وبرومبتات وقوائم فحص| D
    D -->|كتابة وبرمجة واختبار| C[${member.workspace} - مساحة العمل البرمجية]
\`\`\`

### 1. الحزمة المرجعية المشتركة (\`team_package/\`)
- **ما هي؟** هي الدستور والمكتبة العامة للمشروع، تحتوي على مواصفات الـ API، قاموس قاعدة البيانات، المعايير الأمنية، ونظام التصميم المشترك.
- **ماذا تفعل فيها؟** **قراءة فقط (Read-Only)**. لا تعدل ولا تحذف أي ملف بداخلها إطلاقاً.

### 2. حزمة توجيهك وتسليمك (\`${member.deliveryDir}\`)
- **ما هي؟** هي دليلك الإرشادي الخاص الذي أعده لك قائد المشروع، تحتوي على أدلة الاستخدام، برومبتات التأسيس، برومبتات المهام، ومجلدات التسليم والمراجعة.
- **ماذا تفعل فيها؟** تقرأ أدلتها، تنسخ منها البرومبتات لـ Antigravity و ChatGPT، وتوثق فيها تقارير مراجعاتك وتقارير التسليم.

### 3. مساحة عملك البرمجية الفعلية (\`${member.workspace}\`)
- **ما هي؟** المجلد الذي يحتوي على كود Dart و Flutter الحقيقي والاختبارات التابعة له.
- **ماذا تفعل فيها؟** هذا هو المكان الوحيد الذي يقوم فيه Antigravity بكتابة الأكواد، إنشاء الملفات، وبناء الواجهات والاختبارات.

### 🛡️ مصفوفة الصلاحيات وحدود المجلدات الخاصة بك:
- 🟢 **المجلدات المسموح لك العمل والتعديل فيها حصراً:**
${member.allowedPaths.map(p => `  - \`${p}\``).join('\n')}

- 🔴 **المجلدات المحظورة والممنوع لمسها تماماً (منطقة حمراء):**
${member.forbiddenPaths.map(p => `  - \`${p}\``).join('\n')}

---

## 📂 القسم الثاني: الملفات الـ 13 الرئيسية في حزمتك (شرح شامل)

داخل المجلد الرئيسي لحزمتك \`${member.deliveryDir}\`، توجد 13 وثيقة أساسية مرتبة بالأولوية. فيما يلي شرح كل ملف بالتفصيل الممل:

| الرقم | اسم الملف | الاسم بالعربي | الغرض والوظيفة | متى تفتحه؟ | كيف تستخدمه؟ | الوجهة (AI أم قراءة؟) | التكرار |
|:---|:---|:---|:---|:---|:---|:---|:---|
${rootFilesDocs.map(f => `| **${f.num}** | \`${f.name}\` | ${f.arabic} | ${f.purpose} | ${f.when} | ${f.how} | ${f.destination} | ${f.frequency} |`).join('\n')}

---

## 📚 القسم الثالث: مجلدات الحزمة المرجعية المشتركة \`team_package\`

تتكون الحزمة المشتركة من 8 مجلدات مرجعية رئيسية. إليك بيان كل مجلد ودوره المباشر في عملك:

${teamPackageFolders.map((f, idx) => `
### ${idx + 1}. \`${f.path}\` (${f.name})
- 🎯 **الهدف والمحتوى:** ${f.purpose}
- 🔒 **طبيعة الصلاحية:** ${f.access}
- 💡 **كيف تستفيد منه كـ (${member.name.split(' ')[0]}):** ${f.usage}
`).join('\n')}

---

## 🧱 القسم الرابع: مرحلة التأسيس المشترك \`COMMON_FOUNDATION\` (الـ 7 خطوات)

> [!WARNING]
> **قانون صارم لا يقبل الاستثناء:**
> ممنوع منعاً باتاً فتح مجلد المهام التنفيذية \`tasks/\` أو كتابة أي كود قبل اجتياز جميع خطوات التأسيس الـ 7 بالتسلسل والحصول على اعتماد \`[PASS]\` في الخطوة السابعة!

تجد هذه الخطوات داخل: \`${member.deliveryDir}COMMON_FOUNDATION/\`

\`\`\`mermaid
graph LR
    F1[01_ORIENTATION] --> F2[02_ARCHITECTURE]
    F2 --> F3[03_CODING_RULES]
    F3 --> F4[04_SECURITY]
    F4 --> F5[05_INTEGRATION]
    F5 --> F6[06_SPECIFIC]
    F6 --> F7[07_FINAL_GATE]
    F7 -->|PASS معتمد| Tasks[🔓 فتح مجلد المهام tasks/]
\`\`\`

### تفاصيل خطوات التأسيس السبع:
${commonFoundationSteps.map(s => `
---
### 🔹 الخطوة (${s.num}): \`${s.folder}\` — ${s.name}
- 🎯 **الهدف الأساسي:** ${s.goal}
- 🛠️ **ماذا يفعل برومبت التنفيذ \`01_EXECUTE.md\` في Antigravity؟** ${s.exec}
- 🧪 **ماذا يفعل برومبت الاختبار \`02_TEST.md\` في Antigravity؟** ${s.test}
- ☁️ **ماذا يفعل برومبت المراجعة \`03_CLOUD_REVIEW.md\` في ChatGPT؟** ${s.review}
- 📋 **شرط العبور:** الحصول على تقييم \`[PASS]\` وتوثيق نتيجة المراجعة في \`${member.deliveryDir}reviews/\`.
`).join('\n')}

---

## 🔄 القسم الخامس: دورة العمل القياسية لكل مهمة (نظام البرومبتات الثلاثي)

لكل مهمة برمجية داخل \`tasks/\`، يوجد مجلد مستقل يحتوي حصراً على 3 ملفات برومبت. هذه هي الدورة التي ستكررها مع كل مهمة:

\`\`\`mermaid
sequenceDiagram
    autonumber
    actor Dev as أنت (${member.name.split(' ')[0]})
    participant IDE as Antigravity IDE
    participant Test as Test Suite (Flutter)
    participant Cloud as ChatGPT (Cloud AI)

    Dev->>IDE: إرسال 01_EXECUTE.md
    IDE-->>Dev: توليد وبناء الكود في مساحة العمل
    Dev->>IDE: إرسال 02_TEST.md
    IDE->>Test: تشغيل الاختبارات وفحص الجودة
    Test-->>IDE: نتيجة الفحص (PASS / FAIL)
    alt إذا فشل الاختبار FAIL
        Dev->>IDE: مراجعة رسالة الخطأ وإصلاحه فوراً
    else إذا نجح الاختبار PASS
        Dev->>Cloud: إرسال Base Prompt + 03_CLOUD_REVIEW.md + الكود
        Cloud-->>Dev: المراجعة الخارجية وقرار (PASS / FAIL)
        Dev->>Dev: توثيق المراجعة في reviews/ والانتقال للمهمة التالية
    end
\`\`\`

### خطوات تشغيل البرومبتات الثلاثية بدقة:
1. **الخطوة 1 — التنفيذ (\`01_EXECUTE.md\`):**
   - افتح نافذة محادثة Antigravity IDE.
   - انسخ محتوى ملف \`01_EXECUTE.md\` الخاص بالمهمة والصقه في المحادثة.
   - يقوم Antigravity بإنشاء وتعديل الأكواد المطلوبة في مسارها الصحيح داخل \`${member.workspace}\`.
2. **الخطوة 2 — الاختبار الداخلي (\`02_TEST.md\`):**
   - بعد انتهاء التنفيذ، انسخ محتوى \`02_TEST.md\` والصقه في Antigravity.
   - يقوم Antigravity بتشغيل اختبارات الـ Unit Tests وفحص الـ Linter والتأكد من خلو الكود من أي عيوب.
   - يجب أن تحصل على نتيجة \`TESTS PASSED\`. إذا ظهر أي خطأ، اطلب من Antigravity إصلاحه حتى ينجح 100%.
3. **الخطوة 3 — المراجعة السحابية الخارجية (\`03_CLOUD_REVIEW.md\`):**
   - افتح متصفحك وادخل على **ChatGPT**.
   - أرسل أولاً ملف: \`team_package/prompts/shared/TEAM_CLOUD_BASE_PROMPT.md\`.
   - ثم أرسل محتوى \`03_CLOUD_REVIEW.md\` مرفقاً معه الكود الذي تم تنفيذه.
   - انتظر تقييم ChatGPT حتى يصدر قرار: \`REVIEW STATUS: [PASS]\`.
   - احفظ نص المراجعة في ملف داخل مجلد: \`${member.deliveryDir}reviews/\`.

---

## 🚀 القسم السادس: المهام البرمجية التنفيذية \`tasks/\` (شرح الـ ${member.tasks.length} مهمة)

فيما يلي الجدول والمخطط التفصيلي لجميع مهامك البرمجية داخل \`${member.deliveryDir}tasks/\` بالترتيب الإلزامي:

${member.tasks.map(t => `
---
### 📌 المهمة (${t.num}): \`${t.folder}\`
#### 🏷️ ${t.name}
- 🎯 **الهدف البرمجي:** ${t.goal}
- 📂 **مسار الملف المستهدف بالكتابة:** \`${t.targetFile}\`
- ⚡ **أمر التنفيذ (\`01_EXECUTE.md\`):** ${t.exec}
- 🧪 **أمر الفحص والاختبار (\`02_TEST.md\`):** ${t.test}
- ☁️ **معايير المراجعة السحابية (\`03_CLOUD_REVIEW.md\`):** ${t.review}
- 🚦 **شرط النجاح والعبور:** نجاح الاختبار الداخلي 100% + اعتماد ChatGPT بعلامة \`[PASS]\` وتوثيق تقرير المراجعة.
`).join('\n')}

---

## 📦 القسم السابع: التوثيق السحابي والمراجعة والتسليم النهائي

### 📝 1. توثيق المراجعات في مجلد \`reviews/\`
لكل مهمة من مهام التأسيس والمهام التنفيذية، أنشئ ملف توثيق داخل مجلد \`${member.deliveryDir}reviews/\` بالاسم:
\`REVIEW_<TASK_NAME>.md\`
وضع فيه:
- اسم المهمة والتاريخ.
- كود المخرجات.
- تقييم ChatGPT الكامل مع علامة \`[PASS]\`.

### 📋 2. تعبئة تقرير التسليم النهائي في \`handoff/\`
عند إكمال جميع المهام الـ ${member.tasks.length} واجتياز كافة الاختبارات:
1. افتح الملف: \`${member.deliveryDir}handoff/HANDOFF_REPORT.md\` (أو انسخ قالب \`team_package/integration/HANDOFF_TEMPLATE.md\`).
2. املأ جميع الحقول بالبيانات الحقيقية:
   - قائمة الملفات التي تم إنشاؤها وتعديلها.
   - نتائج أوامر الاختبارات (Test Runs).
   - توثيق خلو الكود من أي Linter Errors أو Warnings.
   - روابط أو نصوص اعتمادات المراجعة السحابية.
3. وقع التقرير باسمك وتاريخ اليوم.

### 🤝 3. ماذا تسلم لقائد المشروع؟
عندما تنتهي وتصبح جاهزاً، تسلم القائد:
1. **مجلد الكود الخاص بك:** \`${member.workspace}\` كاملاً ومختبراً.
2. **مجلد المراجعات:** \`${member.deliveryDir}reviews/\` محتوياً على كافة اعتمادات الـ PASS.
3. **تقرير التسليم النهائي:** \`${member.deliveryDir}handoff/HANDOFF_REPORT.md\` مكتملاً وموقعاً.

يقوم قائد المشروع بفحص الكود، تشغيل فحص الانحدار الشامل (Regression Test)، ودمجه في الفرع الرئيسي للمشروع!

---

> [!TIP]
> **نصيحة ذهبية:**
> حافظ على هدوئك، ولا تستعجل بالقفز بين المهام. اتبع خطوة بخطوة، وعندما تواجه أي مشكلة غير واضحة، راجع ملف \`10. STOP_AND_FAIL_RULES.md\` واستعن بقائد فريقك فوراً. بالتوفيق يا بطل! 🌟
`;

  return content;
}

// Write files
membersData.forEach(member => {
  const fileName = `${member.id}_PAGE_${member.id === '01' ? 'OWAB' : member.id === '02' ? 'ALAWADI' : member.id === '03' ? 'ALAYDAROUS' : 'MISHAL'}_NOTION_GUIDE.md`;
  const filePath = path.join(outputDir, fileName);
  const content = generateMemberNotionPage(member);
  fs.writeFileSync(filePath, content, 'utf8');
  console.log(`Generated: ${fileName} (${content.length} bytes)`);
});

console.log('All 4 Notion guide pages generated successfully in integration/integration_reports/notion_pages/');
