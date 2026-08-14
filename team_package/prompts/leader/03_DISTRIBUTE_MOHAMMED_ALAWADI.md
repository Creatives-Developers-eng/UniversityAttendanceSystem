# دليل تسليم مهمة 02 — محمد العواضي | 03_DISTRIBUTE_MOHAMMED_ALAWADI.md
## نطاق: محرك والتحقق الحيوي (Biometric Verification Engine)

---

## 1. ما يتم نسخه لمحمد العواضي:
- نسخة كاملة من `team_package/`.
- مجلد البرومبتات الخاص به: `team_package/prompts/members/02_MOHAMMED_ALAWADI_BIOMETRIC/`.

## 2. ما يُمنع نسخه:
- واجهات التطبيق الرئسية للطلاب والمدرسين.
- كود الخادم المحلي وقاعدة البيانات المركزية.

## 3. معايير القبول:
- ألا يسجل الحضور مباشرة في قاعدة البيانات.
- توفير `BiometricService` و Adapter للمحرك، وإرجاع الحالات الرسمية: `VERIFIED`, `REJECTED`, `REVIEW`, `LOW_QUALITY`.
