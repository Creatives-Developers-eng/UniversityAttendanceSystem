import 'dart:async';
import 'package:flutter/material.dart';
import '../../shared/tokens/tokens.dart';

/// بطاقة بث رمز الاستجابة السريعة الديناميكي (Dynamic QR Broadcaster Card)
class LiveQrBroadcasterCard extends StatefulWidget {
  final String sessionId;
  final bool isBroadcasting;
  final VoidCallback? onRefreshCode;

  const LiveQrBroadcasterCard({
    super.key,
    required this.sessionId,
    this.isBroadcasting = true,
    this.onRefreshCode,
  });

  @override
  State<LiveQrBroadcasterCard> createState() => _LiveQrBroadcasterCardState();
}

class _LiveQrBroadcasterCardState extends State<LiveQrBroadcasterCard>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  int _secondsLeft = 6;
  int _tokenCounter = 101;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (!widget.isBroadcasting) return;

      setState(() {
        if (_secondsLeft <= 1) {
          _secondsLeft = 6;
          _tokenCounter++;
          _progressController.reset();
          _progressController.forward();
        } else {
          _secondsLeft--;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingLG,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.radiusLG),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // الشريط العلوي للشفرة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.qr_code_2_rounded, color: AppColors.primary, size: 22.0),
                  SizedBox(width: 6.0),
                  Text(
                    'رمز التحضير الديناميكي (Dynamic QR)',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
                decoration: BoxDecoration(
                  color: widget.isBroadcasting
                      ? AppColors.success.withValues(alpha: 0.12)
                      : AppColors.error.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6.0,
                      height: 6.0,
                      decoration: BoxDecoration(
                        color: widget.isBroadcasting ? AppColors.success : AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      widget.isBroadcasting ? 'بث نشط' : 'متوقف مؤقتاً',
                      style: TextStyle(
                        color: widget.isBroadcasting ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.w700,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalLG,
          // حاوية رمز الـ QR المصور
          Container(
            width: 220.0,
            height: 220.0,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.radiusLG),
              border: Border.all(color: AppColors.border, width: 2.0),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 20.0,
                  spreadRadius: 2.0,
                ),
              ],
            ),
            child: widget.isBroadcasting
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      // رسم محاكي لمربعات الـ QR
                      _buildSimulatedQrMatrix(),
                      // شارة الجامعة في المركز
                      Container(
                        width: 44.0,
                        height: 44.0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.0),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 22.0,
                        ),
                      ),
                    ],
                  )
                : const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.pause_circle_filled_rounded, size: 48.0, color: AppColors.warning),
                        SizedBox(height: 8.0),
                        Text(
                          'البث متوقف مؤقتاً',
                          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
          ),
          AppSpacing.gapVerticalLG,
          // مؤشر العد التنازلي لتحديث الشفرة
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: _secondsLeft / 6.0,
                  strokeWidth: 2.5,
                  backgroundColor: AppColors.border,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
              AppSpacing.gapHorizontalSM,
              Text(
                'يتغير الرمز تلقائياً خلال $_secondsLeft ثوانٍ',
                style: const TextStyle(
                  fontSize: 12.0,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 8.0),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.0),
                decoration: BoxDecoration(
                  color: AppColors.border.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppRadius.radiusSM),
                ),
                child: Text(
                  'Nonce: #$_tokenCounter',
                  style: const TextStyle(fontSize: 10.0, fontFamily: 'monospace', fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          AppSpacing.gapVerticalSM,
          const Divider(color: AppColors.border, height: 1.0),
          AppSpacing.gapVerticalSM,
          // تفاصيل الشبكة المحلية
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.router_rounded, size: 14.0, color: AppColors.textSecondary),
                  SizedBox(width: 4.0),
                  Text(
                    'الخادم المحلي: 192.168.43.1:8080',
                    style: TextStyle(fontSize: 11.0, color: AppColors.textSecondary, fontFamily: 'monospace'),
                  ),
                ],
              ),
              Text(
                'الجلسة: ${widget.sessionId.substring(0, widget.sessionId.length > 12 ? 12 : widget.sessionId.length)}',
                style: const TextStyle(fontSize: 10.0, color: AppColors.textSecondary, fontFamily: 'monospace'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSimulatedQrMatrix() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        7,
        (r) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            7,
            (c) {
              final isCorner = (r < 2 && c < 2) || (r < 2 && c > 4) || (r > 4 && c < 2);
              final isCenter = (r >= 2 && r <= 4 && c >= 2 && c <= 4);
              final isBlock = isCorner || ((r + c + _tokenCounter) % 2 == 0 && !isCenter);
              return Container(
                width: 22.0,
                height: 22.0,
                decoration: BoxDecoration(
                  color: isBlock ? AppColors.textPrimary : Colors.transparent,
                  borderRadius: BorderRadius.circular(isCorner ? 4.0 : 2.0),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
