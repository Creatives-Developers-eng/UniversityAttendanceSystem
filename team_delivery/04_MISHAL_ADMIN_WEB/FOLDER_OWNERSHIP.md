# مصفوفة ملكية المجلدات الخاصة بك | FOLDER_OWNERSHIP.md
## المطور: مشعل الحاج

---

### المجلدات المملوكة لك حصرياً (Can Create / Modify):
- `admin_web/`
- `admin_web/lib/`
- `admin_web/test/`

### المجلدات الممنوعة تماماً (Forbidden):
- `backend/ (مركزي)`
- `mobile_app/ (خاص بأواب وزملائه)`
- `team_package/ (مرجع قراءة فقط)`
- `الاتصال المباشر بقاعدة بيانات PostgreSQL (كل الاتصال عبر REST API فقط)`

### المجلدات المرجعية للقراءة فقط (Read-Only Reference):
- `team_package/docs/`
- `team_package/api_contract/`
- `team_package/database/`
- `team_package/local_protocol/`
- `team_package/security/`
- `team_package/prompts/shared/`
