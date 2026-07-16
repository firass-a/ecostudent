import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../models/models.dart';
import '../../../shared/widgets/eco_widgets.dart';
import '../../../shared/widgets/points_ring.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.s;
    final user = ref.watch(authUserProvider).valueOrNull;
    final withdrawals = ref.watch(withdrawalsProvider);

    if (user == null) return const Scaffold(body: LoadingView());

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      appBar: AppBar(
        title: Text(s.wallet),
        actions: [
          IconButton(
            icon: const Icon(PhosphorIconsFill.clockCounterClockwise),
            onPressed: () => context.push('/history'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Gold balance card
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: AppColors.butterYellow,
              borderRadius: BorderRadius.circular(AppConstants.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        PhosphorIconsFill.piggyBank,
                        color: AppColors.gold,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      s.availableBalance,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                PointsRing(
                  points: user.pointsBalance,
                  subtitle: s.pointsEqualsDzd,
                  dzdLine: s.ptsApproxDzd(user.pointsBalance),
                  size: 150,
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.05),
          const SizedBox(height: 16),
          EcoButton(
            label: s.cashOut,
            backgroundColor: AppColors.gold,
            foregroundColor: AppColors.white,
            icon: PhosphorIconsFill.wallet,
            onPressed: () => context.push('/withdraw'),
          ),
          const SizedBox(height: 28),
          Text(
            s.withdrawals,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          withdrawals.when(
            loading: () => const LoadingView(),
            error: (e, _) => ErrorStateView(
              title: s.errorOccurred,
              message: e.toString(),
              retryLabel: s.retry,
            ),
            data: (list) {
              if (list.isEmpty) {
                return EmptyStateView(
                  message: s.noWithdrawalsYet,
                  subtitle: s.cashOutWhenReady,
                  icon: PhosphorIconsFill.piggyBank,
                  tint: TintPair.gold,
                );
              }
              return Column(
                children: list.map((w) => _WithdrawalTile(w: w)).toList(),
              );
            },
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _WithdrawalTile extends ConsumerWidget {
  const _WithdrawalTile({required this.w});
  final WithdrawalRequest w;

  Color get _color => switch (w.status) {
        WithdrawalStatus.pending => AppColors.gold,
        WithdrawalStatus.processing => AppColors.skyBlue,
        WithdrawalStatus.completed => AppColors.primaryGreen,
        WithdrawalStatus.rejected => AppColors.coral,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.s;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: EcoCard(
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.butterYellow,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                PhosphorIconsFill.coins,
                color: AppColors.gold,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${w.amountDzd.toStringAsFixed(0)} DZD',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    '${s.withdrawMethodLabel(w.method)} · ${DateFormat.yMMMd().format(w.requestedAt)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            StatusChip(label: s.withdrawalStatus(w.status.name), color: _color),
            if (w.status == WithdrawalStatus.pending)
              IconButton(
                tooltip: s.cancel,
                icon: const Icon(PhosphorIconsFill.xCircle, color: AppColors.coral),
                onPressed: () async {
                  await ref
                      .read(withdrawalRepositoryProvider)
                      .cancelWithdrawal(w.id);
                  await ref.read(authUserProvider.notifier).refresh();
                  ref.invalidate(withdrawalsProvider);
                  ref.invalidate(transactionsProvider);
                },
              ),
          ],
        ),
      ),
    );
  }
}
