# إعداد وتنظيم مساحة العمل | WORKSPACE_SETUP.md
## الهيكل المعتمد لمساحة عمل المطور: مشعل الحاج

---

## الهيكل النموذجي لمجلد العمل:
```text
04_MISHAL_ADMIN_WEB_WORKSPACE/
├── team_package/              # (نسخة مرجعية للقراءة فقط تم استلامها من القائد)
│   ├── docs/
│   ├── api_contract/
│   ├── database/
│   ├── local_protocol/
│   ├── security/
│   └── prompts/shared/
│
├── admin_web/               # (مساحة التطوير البرمجية الفعلية المسموح بالتعديل فيها)
│   ├── lib/
│   └── test/
│
├── reviews/                   # (مجلد حفظ نتائج المراجعات السحابية Cloud Reviews)
├── handoff/                   # (مجلد حفظ تقارير التسليم المكتملة)
└── README.md
```

## تعليمات فتح المشروع في Antigravity:
1. افتح مجلد مساحة عملك الكاملة (`04_MISHAL_ADMIN_WEB_WORKSPACE/`) في Antigravity IDE.
2. تأكد من أن الـ IDE يستطيع قراءة مجلد `team_package/` كمرجع مرئي.
3. تأكد أن التعديلات البرمجية تُنشأ حصرياً داخل `admin_web/`.
