# 🚀 برومبت التنفيذ: وحدة إدارة الجلسات الأكاديمية (Sessions Module)
## 👤 القائد: قحطان الشجاع (Qahtan Alshagea)
### 🏛️ المسؤولية: تطوير الباك إند المركزي

### 🎯 الهدف البرمجي:
بناء مسارات فتح جلسة حضور (Start Session)، إغلاق الجلسة (Close Session)، والتحقق من صلاحية المندوب أو الأستاذ لبدء الجلسة للشعبة المحددة.

### 📂 المسار المستهدف بالكتابة:
`backend/src/sessions/ (controller, service, module, dtos)`

### ⚡ التعليمات لـ Antigravity IDE:
1. بناء وحدة الجلسات مع الـ Endpoints (POST /api/sessions/start, POST /api/sessions/close, GET /api/sessions/active) مع التحقق من الصلاحيات وربطها بالشعب الأكاديمية.
2. الالتزام الصارم بمعمارية NestJS الرسمية وقواعد Prisma المعتمدة.
3. التحقق من تطابق المدخلات والمخرجات مع عقود `team_package/api_contract/`.
