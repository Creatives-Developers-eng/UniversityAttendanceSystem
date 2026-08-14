# برومبت التأسيس الخاص بالمسؤولية | 01_EXECUTE.md
## مرحلة التأسيس: التأسيس الخاص بالخادم المحلي والـ QR والطوابير (Local Server, QR & Queue Foundation)
### المطور: محمد العيدروس (03_MOHAMMED_ALAYDAROUS_LOCAL) — نظام الحضور الجامعي الذكي

---

> [!IMPORTANT]
> **برومبت التأسيس المتخصص لـ Antigravity IDE**
> انسخ هذا البرومبت لتأسيس البنية المعرفية والتقنية الخاصة بنطاق مسؤوليتك الحصري [mobile_app/lib/local_server/].

---

```text
أنت تعمل كمساعد هندسي متخصص للمطور [محمد العيدروس] المسؤول عن [mobile_app/lib/local_server/].

المرحلة الحالية: التأسيس الخاص بنطاق المسؤولية [التأسيس الخاص بالخادم المحلي والـ QR والطوابير (Local Server, QR & Queue Foundation)].
الهدف: إتقان معمارية الخادم المحلي المدمج، بروتوكول الجلسة، بروتوكول الاستكشاف، توليد الـ QR الديناميكي مع Nonce، طابور المعالجة المحلي، ومنع التكرار بـ RequestId.

الوثائق المرجعية الإلزامية:
- team_package/local_protocol/LOCAL_SERVER_PROTOCOL.md
- team_package/local_protocol/qr_protocol/
- team_package/local_protocol/attendance_protocol/
- team_package/local_protocol/discovery_protocol/

المحاور التخصصية الإلزامية المطلوب دراستها وترسيخها:
- 01 Embedded HTTP Server Architecture on Mobile
- 02 Local Network IP Extraction & Port Management
- 03 Local Session State Machine (CREATED -> STARTING -> RUNNING -> CLOSING -> STOPPED)
- 04 Session Guard & Unauthorized Request Rejection
- 05 Local Discovery Protocol (UDP / mDNS Beacons)
- 06 Dynamic QR Generation with HMAC, Nonce & Sliding Time-Windows
- 07 Attendance Processing Queue & Dedicated Worker Isolation
- 08 Idempotency Architecture by RequestId & Duplicate Cache
- 09 Local Cryptographic Authorization & Device Verification
- 10 Graceful Session Shutdown & Queue Drain
- 11 Network Failure Recovery & Snapshot State
- 12 Concurrency & 50-Client Stress Tolerance

المطلوب منك:
1. شرح وتأصيل هذه المحاور التخصصية بالتفصيل وربطها بملفات العمل في [mobile_app/lib/local_server/].
3. تقديم تقرير استيعاب تخصصي شامل والتوقف لانتظار موافقة المطور.
```
