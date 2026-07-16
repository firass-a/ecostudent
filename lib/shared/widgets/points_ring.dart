import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/constants/app_constants.dart';

/// Points display with soft ring + coin icon + count-up animation.
class PointsRing extends StatelessWidget {
  const PointsRing({
    super.key,
    required this.points,
    this.maxPoints = 2000,
    this.size = 180,
    this.subtitle,
    this.dzdLine,
  });

  final int points;
  final int maxPoints;
  final double size;
  final String? subtitle;
  final String? dzdLine;

  @override
  Widget build(BuildContext context) {
    final progress = (points / maxPoints).clamp(0.0, 1.0);
    return SizedBox(
      width: size,
      height: size,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: progress),
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return CustomPaint(
            painter: _RingPainter(
              progress: value,
              trackColor: AppColors.butterYellow,
              progressColor: AppColors.gold,
            ),
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                PhosphorIconsFill.coins,
                color: AppColors.gold,
                size: 24,
              ),
              const SizedBox(height: 4),
              TweenAnimationBuilder<int>(
                tween: IntTween(begin: 0, end: points),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => Text(
                  '$value',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              Text(
                dzdLine ?? 'pts ≈ $points DZD',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.goldDark,
                        fontWeight: FontWeight.w600,
                      ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final track = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

/// Count-up with bounce pulse on the final number.
class AnimatedPointsCounter extends StatefulWidget {
  const AnimatedPointsCounter({
    super.key,
    required this.target,
    this.prefix = '+',
    this.style,
  });

  final int target;
  final String prefix;
  final TextStyle? style;

  @override
  State<AnimatedPointsCounter> createState() => _AnimatedPointsCounterState();
}

class _AnimatedPointsCounterState extends State<AnimatedPointsCounter> {
  bool _done = false;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: widget.target),
      duration: const Duration(milliseconds: 1200),
      curve: Curves.easeOutCubic,
      onEnd: () => setState(() => _done = true),
      builder: (context, value, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIconsFill.coins,
              color: AppColors.gold,
              size: 32,
            ),
            const SizedBox(width: 8),
            AnimatedScale(
              scale: _done && value == widget.target ? 1.08 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.elasticOut,
              child: Text(
                '${widget.prefix}$value',
                style: widget.style ??
                    Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.goldDark,
                          fontWeight: FontWeight.w800,
                        ),
              ),
            ),
          ],
        ).animate().fadeIn();
      },
    );
  }
}
