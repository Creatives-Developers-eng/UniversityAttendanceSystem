# حالات النظام وانتقالاتها الرسمية | SYSTEM_STATES.md
## نظام الحضور الجامعي الذكي (University Attendance System)

---

> [!IMPORTANT]
> **قاعدة الالزام بالحالات والتحولات الصارمة (Strict State Transition Enforcement)**
> 
> تعد هذه الوثيقة المرجع الرسمي الحصري لكافة حالات الكائنات وانتقالاتها داخل النظام.
> **يُمنع منعًا باتًا تنفيذ أي انتقال غير مسموح (`Forbidden Transition`) أو تجاوز الحالات الرسمية المعرفة.**

---

## 1. حالات الحساب (Account States)

### 1.1 `PendingActivation`
- **Arabic Meaning:** بانتظار التفعيل
- **Description:** الحالة الأولية للحساب فور إنشائه من قبل العمادة وقبل ربط وتوثيق جهاز المحمول الأول.
- **Entry Condition:** إنشاء حساب جديد للمستخدم في قاعدة البيانات المركزية.
- **Exit Condition:** إدخال رمز تفعيل صالح وإتمام توثيق الجهاز.
- **Allowed Next States:** `Active`, `Deactivated`
- **Forbidden Transitions:** `Suspended` (لا يجوز تعليق حساب لم يتم تفعيله).

### 1.2 `Active`
- **Arabic Meaning:** نشط
- **Description:** الحساب مفعل بالكامل، موثق بجهاز، ويمتلك كافة الصلاحيات المخصصة لدوره.
- **Entry Condition:** نجاح عملية تفعيل الحساب وتوثيق الجهاز.
- **Exit Condition:** تعليق الحساب بقرار إداري، أو إلغاء تفعيله.
- **Allowed Next States:** `Suspended`, `Deactivated`
- **Forbidden Transitions:** `PendingActivation` (لا يمكن العودة لحالة بانتظار التفعيل بعد النشاط).

### 1.3 `Suspended`
- **Arabic Meaning:** معلق / موقوف مؤقتاً
- **Description:** إيقاف مؤقت لصلاحيات الحساب نتيجة إجراء أمني أو إداري مع إمكانية إعادة التنشيط.
- **Entry Condition:** صدور قرار تعليق إداري أو اكتشاف انتهاك أمني موقت.
- **Exit Condition:** رفع التعليق بقرار إداري أو إنهاء الحساب.
- **Allowed Next States:** `Active`, `Deactivated`
- **Forbidden Transitions:** `PendingActivation`

### 1.4 `Deactivated`
- **Arabic Meaning:** معطل / ملغى
- **Description:** الحالة النهائية للحساب الموقوف تمامًا والمحظر من أي نفاذ للنظام.
- **Entry Condition:** إلغاء الحساب نهائيًا أو التخرج/إنهاء الخدمة.
- **Exit Condition:** لا يوجد (حالة نهائية).
- **Allowed Next States:** لا يوجد (`None`).
- **Forbidden Transitions:** `Active`, `PendingActivation`, `Suspended` (حالة نهائية لا يمكن الخروج منها بشكل مباشر).

---

## 2. حالات الجهاز (Device States)

### 2.1 `Unregistered`
- **Arabic Meaning:** غير مسجل
- **Description:** هاتف لم يتم توثيقه أو ربطه بأي حساب مستخدم في قاعدة البيانات.
- **Entry Condition:** تشغيل التطبيق لأول مرة على هاتف جديد.
- **Exit Condition:** إرسال طلب تفعيل ومزامنة بصمة الجهاز.
- **Allowed Next States:** `PendingVerification`
- **Forbidden Transitions:** `Bound` (لا يمكن الربط المباشر دون طلب وتحقق).

### 2.2 `PendingVerification`
- **Arabic Meaning:** بانتظار التحقق
- **Description:** الجهاز قيد التحقق من رمز التفعيل وبصمة الجهاز الرقمية.
- **Entry Condition:** تقديم رمز التفعيل `ActivationCode` من التطبيق.
- **Exit Condition:** تأكيد التحقق المركزي أو فشل التفعيل.
- **Allowed Next States:** `Bound`, `Unregistered`
- **Forbidden Transitions:** `Revoked`

### 2.3 `Bound`
- **Arabic Meaning:** مرتبط وموثق
- **Description:** الجهاز مرتبط رسمياً بحساب مستخدم محدد ومصرح له بإجراء العمليات.
- **Entry Condition:** نجاح التحقق المركزي وإصدار شهادة/توثيق الجهاز.
- **Exit Condition:** إلغاء توثيق الجهاز من قبل المستخدم أو العمادة.
- **Allowed Next States:** `Revoked`
- **Forbidden Transitions:** `PendingVerification`, `Unregistered` (يجب إلغاء التوثيق أولاً).

### 2.4 `Revoked`
- **Arabic Meaning:** ملغى التوثيق
- **Description:** تم سحب توثيق الجهاز ومنعه من الاتصال بالنظام أو استضافة الجلسات.
- **Entry Condition:** طلب إعادة ضبط الجهاز أو فقدان الهاتف أو قرار أمني.
- **Exit Condition:** إعادة إعادة تسجيل الجهاز كجهاز جديد.
- **Allowed Next States:** `Unregistered`
- **Forbidden Transitions:** `Bound` (يتطلب إعادة تسجيل كاملة من البداية).

---

## 3. حالات رمز التفعيل (Activation Code States)

### 3.1 `Generated`
- **Arabic Meaning:** مولَّد
- **Description:** رمز تفعيل تم إنشاؤه في النظام وبانتظار التوصيل للمستخدم.
- **Entry Condition:** طلب توليد رمز تفعيل من العمادة.
- **Exit Condition:** إرسال الرمز أو انتهاء زمن صلاحيته.
- **Allowed Next States:** `Sent`, `Expired`, `Invalidated`
- **Forbidden Transitions:** `Used` (لا يمكن استخدامه قبل إرساله وتسليمه).

### 3.2 `Sent`
- **Arabic Meaning:** مرسل
- **Description:** الرمز تم إرساله للمستخدم وهو صالح للاستخدام فوراً.
- **Entry Condition:** نجاح عملية إرسال الرمز.
- **Exit Condition:** إدخال الرمز في التطبيق أو انتهاء مهلته.
- **Allowed Next States:** `Used`, `Expired`, `Invalidated`
- **Forbidden Transitions:** `Generated`

### 3.3 `Used`
- **Arabic Meaning:** مستخَدَم
- **Description:** تم استهلاك الرمز بنجاح لتوثيق جهاز.
- **Entry Condition:** مطابقة الرمز وإتمام تفعيل الجهاز بنجاح.
- **Exit Condition:** لا يوجد (حالة مغلقة).
- **Allowed Next States:** لا يوجد (`None`).
- **Forbidden Transitions:** `Sent`, `Generated`, `Expired`, `Invalidated` (الرمز المستهلك لا يعاد استخدامه).

### 3.4 `Expired`
- **Arabic Meaning:** منتهي الصلاحية
- **Description:** انقضت المهلة الزمنية المحددة لاستخدام الرمز دون استهلاكه.
- **Entry Condition:** تجاوز النافذة الزمنية المسموحة للصلاحية.
- **Exit Condition:** لا يوجد.
- **Allowed Next States:** لا يوجد (`None`).
- **Forbidden Transitions:** `Used` (لا يجوز قبول رمز منتهي الصلاحية).

### 3.5 `Invalidated`
- **Arabic Meaning:** ملغى / غير صالح
- **Description:** إلغاء الرمز يدوياً أو آلياً بسبب توليد رمز جديد أو إجراء أمني.
- **Entry Condition:** طلب رمز تفعيل جديد أو إلغاء من الأدمن.
- **Exit Condition:** لا يوجد.
- **Allowed Next States:** لا يوجد (`None`).
- **Forbidden Transitions:** `Used`, `Sent`

---

## 4. حالات جلسة الحضور (Session States)

تلتزم حالات الجلسة بـ **دورة الحياة الرسمية للمشروع** حصراً:

```
[Created] ──> [Opened] ──> [Active] ──> [Closing] ──> [Closed] ──> [Synced]
```

### 4.1 `Created`
- **Arabic Meaning:** أنشئت
- **Description:** السجل الأولي للجلسة تم إنشاؤه مسبقاً في جدول الجلسات دون أن تبدأ الجلسة فعلياً.
- **Entry Condition:** جدول المحاضرة الأكاديمي أو تفويض الأستاذ للمندوب.
- **Exit Condition:** بدء فتح الجلسة من قبل المندوب أو الأستاذ.
- **Allowed Next States:** `Opened`, `Closed` (في حال إلغاء المحاضرة).
- **Forbidden Transitions:** `Active`, `Closing`, `Synced` (يجب المرور بـ Opened أولاً).

### 4.2 `Opened`
- **Arabic Meaning:** فُتحت
- **Description:** تم إطلاق الخادم المحلي `LocalServer` على هاتف المندوب وتجهيز البنية التحتية للجلسة.
- **Entry Condition:** تشغيل المندوب للـ LocalServer بنجاح واستعداده لبث الـ QR.
- **Exit Condition:** بدء بث أول رمز QR واستقبال الطلبات.
- **Allowed Next States:** `Active`, `Closing`
- **Forbidden Transitions:** `Synced`, `Created`

### 4.3 `Active`
- **Arabic Meaning:** نشطة / استقبال الطلبات
- **Description:** الجلسة في أوج نشاطها، بث الـ Dynamic QR مستمر، واستقبال طلبات الحضور جارٍ في الطابور المحلي.
- **Entry Condition:** بدء استقبال طلبات الحضور وبث الـ QR.
- **Exit Condition:** انتهاء الوقت المخصص للجلسة أو إيقاف الاستقبال من قبل المندوب/الأستاذ.
- **Allowed Next States:** `Closing`
- **Forbidden Transitions:** `Synced`, `Created`, `Opened`

### 4.4 `Closing`
- **Arabic Meaning:** قيد الإغلاق
- **Description:** إيقاف بث الـ QR ومنع استقبال طلبات جديدة، مع إكمال معالجة الطلبات المتبقية في الطابور المحلي.
- **Entry Condition:** الضغط على زر إنهاء الجلسة أو انتهاء العداد الزمني للجلسة.
- **Exit Condition:** فراغ الطابور المحلي وتأكيد مراجعة السجلات.
- **Allowed Next States:** `Closed`
- **Forbidden Transitions:** `Active` (لا يمكن إعادة تنشيط الجلسة وهي قيد الإغلاق)، `Synced`

### 4.5 `Closed`
- **Arabic Meaning:** مغلقة
- **Description:** الجلسة مغلقة محلياً بالكامل، وحفظت كافة البيانات محلياً بانتظار بدء عملية المزامنة المركزية.
- **Entry Condition:** اكتمال إغلاق الخادم المحلي وحفظ ملفات الجلسة محلياً.
- **Exit Condition:** إطلاق ونجاح عملية المزامنة المركزية.
- **Allowed Next States:** `Synced`
- **Forbidden Transitions:** `Active`, `Opened`, `Created`

### 4.6 `Synced`
- **Arabic Meaning:** مُزامنة
- **Description:** الحالة النهائية للجلسة بعد رفع وتأكيد جميع سجلات الحضور في قاعدة البيانات المركزية `PostgreSQL`.
- **Entry Condition:** نجاح المزامنة واستلام تأكيد المركز برقم `SyncRecord`.
- **Exit Condition:** لا يوجد (حالة مكتملة ونهائية).
- **Allowed Next States:** لا يوجد (`None`).
- **Forbidden Transitions:** أي حالة سابقة.

---

## 5. حالات طلب الحضور المحلي (Attendance Request States)

### 5.1 `Received`
- **Arabic Meaning:** مُستلَم في الطابور
- **Description:** وصل طلب الحضور `AttendanceRequest` إلى الخادم المحلي وأُدرج في الطابور.
- **Entry Condition:** استقبال المعاملة عبر اتصال HTTP المحلي.
- **Exit Condition:** بدء سحب الطلب بواسطة الـ Worker للمعالجة.
- **Allowed Next States:** `Validating`
- **Forbidden Transitions:** `Accepted`, `Rejected`, `QueuedForSync` (يجب فحص الطلب أولاً).

### 5.2 `Validating`
- **Arabic Meaning:** قيد التحقق
- **Description:** فحص مطابقة `RequestId`, `Nonce`, صلاحية الـ QR, والتحقق الحيوي.
- **Entry Condition:** سحب الطلب بواسطة الـ Worker.
- **Exit Condition:** اكتمال نتائج التحقق.
- **Allowed Next States:** `Accepted`, `Rejected`
- **Forbidden Transitions:** `Received`

### 5.3 `Accepted`
- **Arabic Meaning:** مقبول محلياً
- **Description:** اجتاز الطلب كود الأمان ومُنع التكرار وأُثبت حضور الطالب محلياً.
- **Entry Condition:** نجاح جميع شروط التحقق الصارمة.
- **Exit Condition:** تجهيز الطلب للإدراج في دفعة المزامنة.
- **Allowed Next States:** `QueuedForSync`
- **Forbidden Transitions:** `Rejected`, `Received`

### 5.4 `Rejected`
- **Arabic Meaning:** مرفوض محلياً
- **Description:** رفض الطلب بسبب تكرار `RequestId` أو تكرار حضور الطالب أو خطأ بالرمز.
- **Entry Condition:** فشل أحد شروط التحقق الأمني أو التنظيمي.
- **Exit Condition:** لا يوجد (حالة مرفوضة محلياً وتسجل كخطأ/محاولة).
- **Allowed Next States:** لا يوجد (`None`).
- **Forbidden Transitions:** `Accepted`, `QueuedForSync`

### 5.5 `QueuedForSync`
- **Arabic Meaning:** مُدرَج في طابور المزامنة
- **Description:** الطلب مقبول ومحفوظ محلياً وجاهز للنقل إلى الخادم المركزي.
- **Entry Condition:** قبول الطلب محلياً وإغلاق الجلسة.
- **Exit Condition:** إتمام نقل وتأكيد المزامنة.
- **Allowed Next States:** لا يوجد (`Final Local State`).
- **Forbidden Transitions:** `Rejected`, `Validating`

---

## 6. حالات سجل الحضور النهائي (Attendance States)

### 6.1 `Present`
- **Arabic Meaning:** حاضر
- **Description:** إثبات حضور الطالب في الجلسة بنجاح عبر QR أو التحقق الحيوي أو التحضير اليدوي.
- **Entry Condition:** قبول طلب الحضور وتأكيد المزامنة أو إدخال يدوي من الأستاذ.
- **Exit Condition:** تعديل استثنائي من الأستاذ النظري بعذر أو خطأ.
- **Allowed Next States:** `Absent`, `Excused`, `Late`
- **Forbidden Transitions:** لا يوجد بحظر مطلق (قابلة للتعديل بحس الصلاحيات والمراجعة).

### 6.2 `Absent`
- **Arabic Meaning:** غائب
- **Description:** عدم تسجيل حضور الطالب في الجلسة المغلقة والمزامنة.
- **Entry Condition:** إغلاق ومزامنة الجلسة دون وجود طلب حضور مقبول للطالب.
- **Exit Condition:** إقدام الأستاذ المعني على تصحيح الحالة يدويًا أو تقديم عذر مقبول.
- **Allowed Next States:** `Present`, `Excused`, `Late`
- **Forbidden Transitions:** تغيير تلقائي دون إجراء إداري/استاذ.

### 6.3 `Late`
- **Arabic Meaning:** متأخر
- **Description:** تسديد حضور الطالب بعد انقضاء النافذة الزمنية القياسية وقبل إغلاق الجلسة.
- **Entry Condition:** تسجيل طلب الحضور في فترة السماح الخاصة بالتأخير.
- **Exit Condition:** تعديل حالة الحضور من قبل الأستاذ.
- **Allowed Next States:** `Present`, `Absent`, `Excused`
- **Forbidden Transitions:** لا يوجد.

### 6.4 `Excused`
- **Arabic Meaning:** معذور / عذر مقبول
- **Description:** إعفاء الطالب من احتساب الغياب بناءً على عذر رسمياً معتمد من العمادة/الأستاذ.
- **Entry Condition:** موافقة الأستاذ النظري أو العمادة على طلب العذر.
- **Exit Condition:** إلغاء العذر بقرار إداري.
- **Allowed Next States:** `Absent`, `Present`
- **Forbidden Transitions:** تحويل تلقائي آلي.

---

## 7. حالات المزامنة (Synchronization States)

### 7.1 `Idle`
- **Arabic Meaning:** خامل / بانتظار البدأ
- **Description:** لا توجد عمليات مزامنة جارية حالياً.
- **Entry Condition:** الحالة الافتراضية للنظام قبل بدء المزامنة.
- **Exit Condition:** الضغط على زر المزامنة أو توفر اتصال بالشبكة المركزية.
- **Allowed Next States:** `Preparing`
- **Forbidden Transitions:** `Syncing`, `Success`

### 7.2 `Preparing`
- **Arabic Meaning:** قيد تجهيز الحزمة
- **Description:** تجميع وتشفير حزمة سجلات الحضور المحلية وتجهيز الـ DTO.
- **Entry Condition:** بدء عملية المزامنة من التطبيق.
- **Exit Condition:** اكتمال تجهيز الحزمة والبدء بالإرسال عبر REST API.
- **Allowed Next States:** `Syncing`, `Failed`
- **Forbidden Transitions:** `Success`

### 7.3 `Syncing`
- **Arabic Meaning:** قيد النقل إلى الخادم
- **Description:** إرسال البيانات عبر الشبكة وانتظار رد الخادم المركزي NestJS.
- **Entry Condition:** إرسال طلب الـ HTTP REST API.
- **Exit Condition:** استلام استجابة الخادم المركزي.
- **Allowed Next States:** `Success`, `Failed`
- **Forbidden Transitions:** `Idle`, `Preparing`

### 7.4 `Success`
- **Arabic Meaning:** مكتملة بنجاح
- **Description:** نجاح نقل وحفظ كافة السجلات في PostgreSQL واستلام المعرف `SyncRecord`.
- **Entry Condition:** استلام كود HTTP 200/201 وتأكيد الحفظ.
- **Exit Condition:** العودة للحالة الخاملة.
- **Allowed Next States:** `Idle`
- **Forbidden Transitions:** `Failed`, `Syncing`

### 7.5 `Failed`
- **Arabic Meaning:** فاشلة
- **Description:** تعثر النقل بسبب انقطاع الشبكة، خطأ في التوثيق، أو رفض الخادم.
- **Entry Condition:** استلام كود خطأ أو انقطاع الاتصال.
- **Exit Condition:** إعادة محاولة المزامنة.
- **Allowed Next States:** `Preparing`, `Idle`
- **Forbidden Transitions:** `Success`

---

## 8. حالات رمز الـ QR الديناميكي (QR States)

### 8.1 `Generated`
- **Arabic Meaning:** مولَّد حديثاً
- **Description:** تم توليد شفرة الـ QR في الخادم المحلي مع `Nonce` وزمن صلاحية جديد.
- **Entry Condition:** استدعاء خوارزمية توليد الـ QR الديناميكي.
- **Exit Condition:** عرض الرمز على الشاشة لبدء صلاحية المسح.
- **Allowed Next States:** `Active`
- **Forbidden Transitions:** `Expired`, `Used`

### 8.2 `Active`
- **Arabic Meaning:** نشط وصالح للمسح
- **Description:** الرمز معروض وصالح حالياً لمسحه من هواتف الطلاب.
- **Entry Condition:** عرض الرمز وضبط العداد الزمني للصلاحية.
- **Exit Condition:** انتهاء المهلة الزمنية للرمز (مثلاً 5-10 ثوانٍ) أو إغلاق الجلسة.
- **Allowed Next States:** `Expired`, `Invalidated`
- **Forbidden Transitions:** `Generated`

### 8.3 `Expired`
- **Arabic Meaning:** منتهي الصلاحية
- **Description:** انقضت المهلة الزمنية المحددة للشفرة المعروضة وتطلب توليد شفرة جديدة.
- **Entry Condition:** انتهاء العداد الزمني لصلاحية الرمز الحالية.
- **Exit Condition:** استبداله بالرمز الجديد المولّد.
- **Allowed Next States:** لا يوجد (`Replaced by New QR`).
- **Forbidden Transitions:** `Active` (لا يمكن إعادة تنشيط رمز منتهي الصلاحية).

### 8.4 `Invalidated`
- **Arabic Meaning:** ملغى / غير صالح
- **Description:** إلغاء صلاحية الرمز فوراً بسبب إغلاق الجلسة أو إعادة الضغط على زر التحديث.
- **Entry Condition:** إيقاف الجلسة أو إلغاء أمني.
- **Exit Condition:** لا يوجد.
- **Allowed Next States:** لا يوجد (`None`).
- **Forbidden Transitions:** `Active`

---