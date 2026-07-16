import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/constants/app_constants.dart';
import 'eco_widgets.dart';
import 'points_ring.dart';

/// Success moment — playful coin bounce, warm cream background.
class SuccessOverlay extends StatelessWidget {
  const SuccessOverlay({
    super.key,
    required this.title,
    this.subtitle,
    this.pointsEarned,
    required this.buttonLabel,
    required this.onContinue,
    this.pointsDzdLine,
  });

  final String title;
  final String? subtitle;
  final int? pointsEarned;
  final String buttonLabel;
  final String? pointsDzdLine;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              FriendlyIllustration(
                    icon: pointsEarned != null
                        ? PhosphorIconsFill.coins
                        : PhosphorIconsFill.checkCircle,
                    tint: pointsEarned != null ? TintPair.gold : TintPair.green,
                    size: 110,
                  )
                  .animate()
                  .scale(
                    begin: const Offset(0.4, 0.4),
                    curve: Curves.elasticOut,
                    duration: 700.ms,
                  )
                  .fadeIn(),
              const SizedBox(height: 28),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ).animate().fadeIn(delay: 150.ms),
              if (pointsEarned != null) ...[
                const SizedBox(height: 20),
                AnimatedPointsCounter(target: pointsEarned!),
                const SizedBox(height: 6),
                Text(
                  pointsDzdLine ?? 'points  ·  = $pointsEarned DZD',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                CoinChip(points: pointsEarned!, large: true),
              ],
              if (subtitle != null) ...[
                const SizedBox(height: 16),
                Text(
                  subtitle!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
              const Spacer(),
              EcoButton(
                label: buttonLabel,
                onPressed: onContinue,
              ).animate().fadeIn(delay: 500.ms),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
