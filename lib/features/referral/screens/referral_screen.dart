import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../models/models.dart';
import '../../../shared/widgets/eco_widgets.dart';

class ReferralScreen extends ConsumerWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.s;
    final user = ref.watch(authUserProvider).valueOrNull;
    final refs = ref.watch(referralsProvider);

    if (user == null) return const Scaffold(body: LoadingView());

    final link = 'https://ecostudent.dz/join/${user.referralCode}';

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      appBar: AppBar(title: Text(s.referral)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          EcoCard(
            color: AppColors.butterYellow,
            child: Column(
              children: [
                Icon(PhosphorIconsFill.gift, size: 48, color: AppColors.gold),
                const SizedBox(height: 12),
                Text(
                  s.inviteFriends,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  s.bothGetBonus,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.warmGray,
                      ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primaryGreen.withValues(alpha: 0.3),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        user.referralCode,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryGreen,
                                ),
                      ),
                      IconButton(
                        icon: const Icon(PhosphorIconsRegular.copy),
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: user.referralCode),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(s.codeCopied)),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Simple QR stand-in
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: CustomPaint(
                    painter: _FakeQrPainter(user.referralCode),
                  ),
                ),
                const SizedBox(height: 16),
                EcoButton(
                  label: s.shareCode,
                  icon: PhosphorIconsBold.shareNetwork,
                  onPressed: () {
                    Share.share(
                      s.shareReferralMessage(
                        user.referralCode,
                        AppConstants.referralBonusPoints,
                        link,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(s.referralHistory,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          refs.when(
            loading: () => const LoadingView(),
            error: (e, _) => ErrorStateView(
              title: s.errorOccurred,
              message: e.toString(),
              retryLabel: s.retry,
            ),
            data: (list) {
              if (list.isEmpty) {
                return EmptyStateView(message: s.emptyState);
              }
              return Column(
                children: list.map((r) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: EcoCard(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                AppColors.primaryGreen.withValues(alpha: 0.15),
                            child: Text(
                              r.refereeName.isNotEmpty
                                  ? r.refereeName[0]
                                  : '?',
                              style: const TextStyle(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  r.refereeName == 'Invited — pending signup'
                                      ? s.invitedPendingSignup
                                      : r.refereeName,
                                    style:
                                        Theme.of(context).textTheme.titleSmall),
                                Text(
                                  r.status == ReferralStatus.completed
                                      ? s.bonusPts(r.bonusPoints)
                                      : s.referralStatus('pending'),
                                  style: TextStyle(
                                    color: r.status == ReferralStatus.completed
                                        ? AppColors.goldDark
                                        : AppColors.warmGray,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StatusChip(
                            label: s.referralStatus(r.status.name),
                            color: r.status == ReferralStatus.completed
                                ? AppColors.success
                                : AppColors.warning,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FakeQrPainter extends CustomPainter {
  _FakeQrPainter(this.seed);
  final String seed;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black87;
    final cell = size.width / 11;
    final hash = seed.codeUnits.fold(0, (a, b) => a + b);
    for (var y = 0; y < 11; y++) {
      for (var x = 0; x < 11; x++) {
        final on = ((x * 7 + y * 13 + hash) % 5) != 0;
        final finder = (x < 3 && y < 3) ||
            (x > 7 && y < 3) ||
            (x < 3 && y > 7);
        if (on || finder) {
          canvas.drawRect(
            Rect.fromLTWH(x * cell + 1, y * cell + 1, cell - 2, cell - 2),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FakeQrPainter oldDelegate) =>
      oldDelegate.seed != seed;
}
