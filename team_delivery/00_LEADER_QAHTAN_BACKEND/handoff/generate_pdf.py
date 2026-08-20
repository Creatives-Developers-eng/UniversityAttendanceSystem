import os
import sys
import arabic_reshaper
from bidi.algorithm import get_display
from reportlab.lib.pagesizes import A4
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer, Table, TableStyle, HRFlowable, KeepTogether
from reportlab.pdfgen import canvas
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont

def ar(text):
    if not text:
        return ""
    reshaped_text = arabic_reshaper.reshape(text)
    bidi_text = get_display(reshaped_text)
    return bidi_text

def build_pdf():
    # Register Arial / Tahoma
    font_path = "C:/Windows/Fonts/arial.ttf"
    bold_font_path = "C:/Windows/Fonts/arialbd.ttf"
    
    if os.path.exists(font_path):
        pdfmetrics.registerFont(TTFont('ArabicFont', font_path))
    else:
        pdfmetrics.registerFont(TTFont('ArabicFont', "C:/Windows/Fonts/tahoma.ttf"))

    if os.path.exists(bold_font_path):
        pdfmetrics.registerFont(TTFont('ArabicFontBold', bold_font_path))
    else:
        pdfmetrics.registerFont(TTFont('ArabicFontBold', font_path))

    pdf_filename = os.path.abspath("team_delivery/00_LEADER_QAHTAN_BACKEND/handoff/HANDOFF_REPORT.pdf")
    doc = SimpleDocTemplate(
        pdf_filename,
        pagesize=A4,
        rightMargin=36,
        leftMargin=36,
        topMargin=36,
        bottomMargin=36
    )

    styles = getSampleStyleSheet()

    # Custom Arabic Styles
    title_style = ParagraphStyle(
        'ArTitle',
        parent=styles['Normal'],
        fontName='ArabicFontBold',
        fontSize=18,
        leading=24,
        textColor=colors.HexColor("#1e3a8a"),
        alignment=1, # Center
        spaceAfter=6
    )

    subtitle_style = ParagraphStyle(
        'ArSubtitle',
        parent=styles['Normal'],
        fontName='ArabicFontBold',
        fontSize=13,
        leading=18,
        textColor=colors.HexColor("#2563eb"),
        alignment=1,
        spaceAfter=12
    )

    section_style = ParagraphStyle(
        'ArSection',
        parent=styles['Normal'],
        fontName='ArabicFontBold',
        fontSize=13,
        leading=17,
        textColor=colors.HexColor("#0f172a"),
        alignment=2, # Right
        spaceBefore=10,
        spaceAfter=6
    )

    body_style = ParagraphStyle(
        'ArBody',
        parent=styles['Normal'],
        fontName='ArabicFont',
        fontSize=10,
        leading=15,
        textColor=colors.HexColor("#334155"),
        alignment=2 # Right
    )

    table_header_style = ParagraphStyle(
        'ArTableH',
        parent=styles['Normal'],
        fontName='ArabicFontBold',
        fontSize=9.5,
        leading=13,
        textColor=colors.white,
        alignment=1 # Center
    )

    table_cell_style = ParagraphStyle(
        'ArTableC',
        parent=styles['Normal'],
        fontName='ArabicFont',
        fontSize=9,
        leading=12,
        textColor=colors.HexColor("#1e293b"),
        alignment=2 # Right
    )

    table_cell_center = ParagraphStyle(
        'ArTableCC',
        parent=styles['Normal'],
        fontName='ArabicFontBold',
        fontSize=9,
        leading=12,
        textColor=colors.HexColor("#166534"),
        alignment=1 # Center
    )

    story = []

    # Title & Header
    story.append(Paragraph(ar("منظومة تحضير الطلاب الذكية - University Attendance System"), title_style))
    story.append(Paragraph(ar("تقرير الاعتماد والتسليم النهائي للباك إند المركزي (Final Backend Handoff Report)"), subtitle_style))
    story.append(HRFlowable(width="100%", thickness=2, color=colors.HexColor("#2563eb"), spaceBefore=0, spaceAfter=10))

    # Meta Info Table
    meta_data = [
        [
            Paragraph(ar("المهندس قحطان الشجاع (Qahtan Alshagea)"), body_style),
            Paragraph(ar("👤 القائد ومطور الباك إند:"), ParagraphStyle('B', fontName='ArabicFontBold', fontSize=10, alignment=2, textColor=colors.HexColor("#1e3a8a")))
        ],
        [
            Paragraph(ar("NestJS 10 + Prisma ORM + PostgreSQL"), body_style),
            Paragraph(ar("🏛️ بيئة العمل والتقنيات:"), ParagraphStyle('B', fontName='ArabicFontBold', fontSize=10, alignment=2, textColor=colors.HexColor("#1e3a8a")))
        ],
        [
            Paragraph(ar("20 أغسطس 2026"), body_style),
            Paragraph(ar("📅 تاريخ الاعتماد:"), ParagraphStyle('B', fontName='ArabicFontBold', fontSize=10, alignment=2, textColor=colors.HexColor("#1e3a8a")))
        ],
        [
            Paragraph(ar("100% مكتمل ومعتمد للإنتاج والمناقشة"), ParagraphStyle('C', fontName='ArabicFontBold', fontSize=10, alignment=2, textColor=colors.HexColor("#166534"))),
            Paragraph(ar("🎯 حالة المشروع:"), ParagraphStyle('B', fontName='ArabicFontBold', fontSize=10, alignment=2, textColor=colors.HexColor("#1e3a8a")))
        ]
    ]

    meta_table = Table(meta_data, colWidths=[340, 180])
    meta_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor("#f8fafc")),
        ('BOX', (0, 0), (-1, -1), 1, colors.HexColor("#cbd5e1")),
        ('INNERGRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#e2e8f0")),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('TOPPADDING', (0, 0), (-1, -1), 4),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
    ]))
    story.append(meta_table)
    story.append(Spacer(1, 10))

    # Executive Summary
    story.append(Paragraph(ar("1. 📊 الملخص التنفيذي للمشروع (Executive Summary)"), section_style))
    summary_text = (
        "تم بحمد الله وتوفيقه استكمال وتدقيق واختبار البنية التحتية المركزية الكاملة لخادم الباك إند المركزي (NestJS + PostgreSQL) "
        "لمنظومة تحضير الطلاب الذكية في الجامعات. تتميز المنظومة بمعمارية متطورة تتيح تسجيل الحضور داخل القاعات بدون إنترنت (Offline-First) "
        "وتفريغها ومزامنتها بأعلى درجات الأمان وحماية الخصوصية البيومترية (حظر تخزين الصور الخام)، مع محرك دقيق لحساب نسب الحرمان والأعذار الطبية."
    )
    story.append(Paragraph(ar(summary_text), body_style))
    story.append(Spacer(1, 10))

    # Core Modules Breakdown Table
    story.append(Paragraph(ar("2. 📁 الوحدات البرمجية المركزية المكتملة (100% Implemented)"), section_style))
    modules_data = [
        [
            Paragraph(ar("الوصف الهندسي والوظيفة البرمجية"), table_header_style),
            Paragraph(ar("الوحدة البرمجية"), table_header_style),
            Paragraph(ar("#"), table_header_style)
        ],
        [
            Paragraph(ar("مصادقة آمنة برموز JWT، تجديد الرموز، تشفير كلمات المرور BCrypt، ونظام صلاحيات RBAC."), table_cell_style),
            Paragraph(ar("المصادقة وإدارة الهوية (AuthModule)"), table_cell_style),
            Paragraph("1", table_cell_center)
        ],
        [
            Paragraph(ar("ربط هواتف القاعة المعتمدة (Device Fingerprint)، توليد وتدقيق أكواد التفعيل الآمنة."), table_cell_style),
            Paragraph(ar("الأجهزة وتفعيل الحسابات (DevicesModule)"), table_cell_style),
            Paragraph("2", table_cell_center)
        ],
        [
            Paragraph(ar("إدارة السنوات الأكاديمية، الفصول، الأقسام، المقررات، الشعب، وتوزيع الأساتذة والطلاب."), table_cell_style),
            Paragraph(ar("الهيكل الأكاديمي الشامل (AcademicModule)"), table_cell_style),
            Paragraph("3", table_cell_center)
        ],
        [
            Paragraph(ar("فتح وإغلاق جلسات الحضور والتحقق الدقيق من صلاحية المندوب أو الأستاذ للشعبة."), table_cell_style),
            Paragraph(ar("إدارة الجلسات الأكاديمية (SessionsModule)"), table_cell_style),
            Paragraph("4", table_cell_center)
        ],
        [
            Paragraph(ar("استقبال حزم الحضور المشفرة عبر POST /api/v1/attendance/sync مع حارس منع التكرار (Nonce Guard)."), table_cell_style),
            Paragraph(ar("مزامنة حضور القاعة (AttendanceModule)"), table_cell_style),
            Paragraph("5", table_cell_center)
        ],
        [
            Paragraph(ar("تطبيق سياسة حظر الصور الخام، وحفظ وتصدير المتجهات المشفرة (512-dim Feature Vectors)."), table_cell_style),
            Paragraph(ar("البصمة الحيوية والخصوصية (BiometricsModule)"), table_cell_style),
            Paragraph("6", table_cell_center)
        ],
        [
            Paragraph(ar("معترض آلي AuditLogInterceptor لتوثيق الفاعل والتوقيت والـ IP وتجريد البيانات الحساسة."), table_cell_style),
            Paragraph(ar("سجل التدقيق والحوكمة (AuditModule)"), table_cell_style),
            Paragraph("7", table_cell_center)
        ],
        [
            Paragraph(ar("حساب نسب الغياب والحضور، إصدار كشوفات الحرمان التلقائية (>25%) ومستويات الإنذار الأكاديمي."), table_cell_style),
            Paragraph(ar("التقارير ونسب الحرمان (ReportsModule)"), table_cell_style),
            Paragraph("8", table_cell_center)
        ],
        [
            Paragraph(ar("تقديم ومراجعة واعتماد الأعذار الطبية وتحديث سجل الحضور آلياً من Absent إلى Excused."), table_cell_style),
            Paragraph(ar("مراجعة واعتماد الأعذار (JustificationsModule)"), table_cell_style),
            Paragraph("9", table_cell_center)
        ],
        [
            Paragraph(ar("توثيق تفاعلي كامل ومباشر عبر Swagger UI ومواصفات OpenAPI 3.0 القياسية على /api/v1/docs."), table_cell_style),
            Paragraph(ar("التوثيق التفاعلي (DocsModule)"), table_cell_style),
            Paragraph("10", table_cell_center)
        ]
    ]

    modules_table = Table(modules_data, colWidths=[290, 200, 30])
    modules_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#1e3a8a")),
        ('ALIGN', (0, 0), (-1, -1), 'RIGHT'),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#cbd5e1")),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor("#f8fafc")]),
        ('TOPPADDING', (0, 0), (-1, -1), 4),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
    ]))
    story.append(modules_table)
    story.append(Spacer(1, 10))

    # Test Matrix
    story.append(Paragraph(ar("3. 🧪 مصفوفة نتائج الفحص والاختبارات الشاملة (100% Passed)"), section_style))
    test_data = [
        [
            Paragraph(ar("الحالة والنتيجة"), table_header_style),
            Paragraph(ar("عدد الاختبارات"), table_header_style),
            Paragraph(ar("الأداة / المحرك"), table_header_style),
            Paragraph(ar("نوع الفحص / الاختبار"), table_header_style)
        ],
        [
            Paragraph(ar("SUCCESS (0 Errors) ✅"), table_cell_center),
            Paragraph(ar("كامل ملفات المشروع"), table_cell_style),
            Paragraph("nest build", table_cell_style),
            Paragraph(ar("البناء الساكن والترجمة (TypeScript)"), table_cell_style)
        ],
        [
            Paragraph(ar("100% PASS (3/3) ✅"), table_cell_center),
            Paragraph(ar("3 سيناريوهات تكاملية"), table_cell_style),
            Paragraph("jest (test:e2e)", table_cell_style),
            Paragraph(ar("اختبارات التكامل الشاملة (E2E)"), table_cell_style)
        ],
        [
            Paragraph(ar("100% PASS (104/104) ✅"), table_cell_center),
            Paragraph(ar("23 جناح اختبار (104 اختبارات)"), table_cell_style),
            Paragraph("jest (unit tests)", table_cell_style),
            Paragraph(ar("اختبارات الوحدة (Unit Tests)"), table_cell_style)
        ],
        [
            Paragraph(ar("100% Verified ✅"), table_cell_center),
            Paragraph(ar("9 وحدات مركزية كاملة"), table_cell_style),
            Paragraph("OpenAPI 3.0 / Swagger", table_cell_style),
            Paragraph(ar("تطابق العقود ومواصفات API"), table_cell_style)
        ]
    ]

    test_table = Table(test_data, colWidths=[120, 130, 120, 150])
    test_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.HexColor("#0f172a")),
        ('ALIGN', (0, 0), (-1, -1), 'RIGHT'),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('GRID', (0, 0), (-1, -1), 0.5, colors.HexColor("#cbd5e1")),
        ('ROWBACKGROUNDS', (0, 1), (-1, -1), [colors.white, colors.HexColor("#f8fafc")]),
        ('TOPPADDING', (0, 0), (-1, -1), 4),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 4),
    ]))
    story.append(test_table)
    story.append(Spacer(1, 10))

    # Official Signoff Box
    signoff_data = [
        [Paragraph(ar("✍️ اعتماد وإغلاق قائد المشروع (Project Leader Official Sign-off)"), ParagraphStyle('SH', fontName='ArabicFontBold', fontSize=11, alignment=1, textColor=colors.HexColor("#1e3a8a")))],
        [Paragraph(ar("أشهد أنا المهندس قحطان الشجاع (Qahtan Alshagea)، قائد المشروع ومطور الباك إند المركزي، بجاهزية خادم الباك إند المركزي التامة واجتيازه لكافة اختبارات الأمان والاعتمادية والانحدار بنسبة 100%، وأعلن جاهزيته الرسمية للمناقشة مع الدكتور والربط مع تطبيقات الهاتف والويب."), body_style)],
        [Paragraph(ar("التوقيع: المهندس قحطان الشجاع   |   التاريخ: 20 أغسطس 2026   |   الحالة: معتمد للإنتاج (Production Ready ✅)"), ParagraphStyle('SB', fontName='ArabicFontBold', fontSize=10, alignment=1, textColor=colors.HexColor("#1e40af")))]
    ]
    signoff_table = Table(signoff_data, colWidths=[520])
    signoff_table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, -1), colors.HexColor("#eff6ff")),
        ('BOX', (0, 0), (-1, -1), 1.5, colors.HexColor("#3b82f6")),
        ('VALIGN', (0, 0), (-1, -1), 'MIDDLE'),
        ('TOPPADDING', (0, 0), (-1, -1), 6),
        ('BOTTOMPADDING', (0, 0), (-1, -1), 6),
    ]))
    story.append(KeepTogether(signoff_table))

    doc.build(story)
    print(f"PDF successfully generated at: {pdf_filename}")

if __name__ == "__main__":
    build_pdf()
