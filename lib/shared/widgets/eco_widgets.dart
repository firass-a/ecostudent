import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/constants/app_constants.dart';

class EcoButton extends StatefulWidget {
  const EcoButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.outlined = false,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool outlined;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool expand;

  @override
  State<EcoButton> createState() => _EcoButtonState();
}

class _EcoButtonState extends State<EcoButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;
    final bg = widget.backgroundColor ?? AppColors.primaryGreen;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 90),
        child: AnimatedOpacity(
          opacity: enabled ? 1 : 0.45,
          duration: const Duration(milliseconds: 120),
          child: widget.outlined
              ? Container(
                  width: widget.expand ? double.infinity : null,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius:
                        BorderRadius.circular(AppConstants.buttonRadius),
                    border: Border.all(color: AppColors.primaryGreen),
                  ),
                  child: Center(child: _child(context)),
                )
              : Container(
                  width: widget.expand ? double.infinity : null,
                  height: 52,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius:
                        BorderRadius.circular(AppConstants.buttonRadius),
                    boxShadow: AppElevation.button(bg, pressed: _pressed),
                  ),
                  child: Center(child: _child(context, onDark: true)),
                ),
        ),
      ),
    );
  }

  Widget _child(BuildContext context, {bool onDark = false}) {
    if (widget.loading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: onDark ? Colors.white : AppColors.primaryGreen,
        ),
      );
    }
    final color = widget.foregroundColor ??
        (onDark ? Colors.white : AppColors.primaryGreen);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          Icon(widget.icon, color: color, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          widget.label,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
        ),
      ],
    );
  }
}

class EcoCard extends StatelessWidget {
  const EcoCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.onTap,
    this.color,
    this.elevated = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final card = Container(
      padding: padding,
      decoration: AppDecorations.elevatedSurface(
        isDark: isDark,
        color: color ?? (isDark ? AppColors.graphite : AppColors.white),
        elevated: elevated,
      ),
      child: child,
    );
    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        child: card,
      ),
    );
  }
}

class SoftIconChip extends StatelessWidget {
  const SoftIconChip({super.key, required this.icon, this.size = 36});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.primaryGreen.withValues(alpha: 0.2)
            : AppColors.paleGreen,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: isDark ? AppColors.primaryGreen : AppColors.greenDeep,
        size: size * 0.48,
      ),
    );
  }
}

class BadgeStatCard extends StatelessWidget {
  const BadgeStatCard({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.tint,
    this.delay = Duration.zero,
  });

  final IconData icon;
  final String value;
  final String label;
  final TintPair tint;
  final Duration delay;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: AppDecorations.elevatedSurface(
        isDark: isDark,
        color: isDark ? AppColors.graphite : AppColors.cardSurface,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SoftIconChip(icon: icon),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms, delay: delay);
  }
}

class MetallicIconChip extends SoftIconChip {
  const MetallicIconChip({
    super.key,
    required super.icon,
    Color? accent,
    super.size,
  });
}

class MetallicCoinIcon extends StatelessWidget {
  const MetallicCoinIcon({super.key, this.size = 22});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(
      PhosphorIconsRegular.coins,
      color: AppColors.primaryGreen,
      size: size,
    );
  }
}

class CoinChip extends StatelessWidget {
  const CoinChip({
    super.key,
    required this.points,
    this.large = false,
    this.animate = true,
  });

  final int points;
  final bool large;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final sign = points >= 0 ? '+' : '';
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: large ? 12 : 8,
        vertical: large ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.paleGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$sign$points',
        style: TextStyle(
          color: AppColors.greenDeep,
          fontWeight: FontWeight.w700,
          fontSize: large ? 16 : 12,
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class FriendlyIllustration extends StatelessWidget {
  const FriendlyIllustration({
    super.key,
    required this.icon,
    required this.tint,
    this.size = 88,
  });

  final IconData icon;
  final TintPair tint;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SoftIconChip(icon: icon, size: size * 0.65);
  }
}

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.message,
    this.subtitle,
    this.icon,
    this.tint = TintPair.green,
    this.action,
  });

  final String message;
  final String? subtitle;
  final IconData? icon;
  final TintPair tint;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SoftIconChip(
              icon: icon ?? PhosphorIconsRegular.plant,
              size: 52,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    required this.message,
    this.onRetry,
    this.title,
    this.retryLabel,
  });
  final String message;
  final VoidCallback? onRetry;
  final String? title;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    return EmptyStateView(
      message: title ?? message,
      subtitle: title != null ? message : null,
      icon: PhosphorIconsRegular.warningCircle,
      tint: TintPair.coral,
      action: onRetry != null
          ? EcoButton(
              label: retryLabel ?? 'Retry',
              onPressed: onRetry,
              expand: false,
            )
          : null,
    );
  }
}

class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: AppColors.primaryGreen,
            strokeWidth: 2.5,
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}

class PointsBadge extends StatelessWidget {
  const PointsBadge({
    super.key,
    required this.points,
    this.showDzd = true,
    this.large = false,
  });

  final int points;
  final bool showDzd;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$points',
          style: (large
                  ? Theme.of(context).textTheme.displaySmall
                  : Theme.of(context).textTheme.headlineMedium)
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (showDzd)
          Text('= $points DZD', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class GreenGradientBackground extends StatelessWidget {
  const GreenGradientBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: AppColors.primaryGreen, child: child);
}

class SoftPageBackground extends StatelessWidget {
  const SoftPageBackground({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      ColoredBox(color: AppColors.scaffoldOf(context), child: child);
}
