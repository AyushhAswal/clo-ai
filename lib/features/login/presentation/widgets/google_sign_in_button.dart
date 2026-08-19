import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 54.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _GoogleLogoIcon(),
                SizedBox(width: 10.w),
                Flexible(
                  child: Text(
                    'Sign In with Google',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleLogoIcon extends StatelessWidget {
  const _GoogleLogoIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22.r,
      height: 22.r,
      child: const CustomPainterWidget(),
    );
  }
}

class CustomPainterWidget extends StatelessWidget {
  const CustomPainterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _GoogleLogoPainter());
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double cx = size.width / 2;
    final double cy = size.height / 2;
    final double radius = size.width / 2;

    final Paint redPaint = Paint()..color = const Color(0xFFEA4335);
    final Paint yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    final Paint greenPaint = Paint()..color = const Color(0xFF34A853);
    final Paint bluePaint = Paint()..color = const Color(0xFF4285F4);

    final Rect rect = Rect.fromCircle(center: Offset(cx, cy), radius: radius);

    // Blue Bar
    canvas.drawArc(rect, -0.4, 1.2, true, bluePaint);
    // Green Arc
    canvas.drawArc(rect, 0.8, 1.3, true, greenPaint);
    // Yellow Arc
    canvas.drawArc(rect, 2.1, 0.9, true, yellowPaint);
    // Red Arc
    canvas.drawArc(rect, 3.0, 1.3, true, redPaint);

    // Inner Cutout
    final Paint cutoutPaint = Paint()..color = const Color(0xFF09090C);
    canvas.drawCircle(Offset(cx, cy), radius * 0.55, cutoutPaint);

    // Blue Center Bar
    final Rect blueBarRect = Rect.fromLTWH(
      cx,
      cy - radius * 0.22,
      radius * 0.9,
      radius * 0.44,
    );
    canvas.drawRect(blueBarRect, bluePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
