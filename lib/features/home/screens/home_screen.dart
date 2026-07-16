import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../l10n/app_strings.dart';
import '../../../models/models.dart';
import '../../../shared/widgets/eco_widgets.dart';

/// EcoStudent Home — same layout/sections, v5 white + green stylesheet.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.s;
    final userAsync = ref.watch(authUserProvider);
    final txAsync = ref.watch(transactionsProvider);
    final unread = ref.watch(unreadCountProvider).valueOrNull ?? 0;

    return userAsync.when(
      loading: () => const Scaffold(body: LoadingView()),
      error: (e, _) => Scaffold(
        body: ErrorStateView(
          title: s.errorOccurred,
          message: e.toString(),
          retryLabel: s.retry,
          onRetry: () => ref.invalidate(authUserProvider),
        ),
      ),
      data: (user) {
        if (user == null) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldOf(context),
            body: EmptyStateView(
              message: s.login,
              subtitle: s.signInToEarn,
              action: EcoButton(
                label: s.login,
                onPressed: () => context.go('/login'),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.scaffoldOf(context),
          appBar: AppBar(
            backgroundColor: AppColors.scaffoldOf(context),
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 72,
            centerTitle: false,
            titleSpacing: 8,
            leadingWidth: 64,
            leading: Padding(
              padding: const EdgeInsetsDirectional.only(start: 16),
              child: CircleAvatar(
                backgroundColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? AppColors.primaryGreen.withValues(alpha: 0.22)
                        : AppColors.paleGreen,
                child: Text(
                  user.fullName.trim().isNotEmpty
                      ? user.fullName.trim()[0].toUpperCase()
                      : 'E',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.primaryGreen
                        : AppColors.greenDeep,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.welcome,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                ),
                Text(
                  user.fullName.trim().isNotEmpty
                      ? user.fullName.split(' ').first
                      : s.appName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: s.notifications,
                onPressed: () => context.push('/notifications'),
                icon: Badge(
                  isLabelVisible: unread > 0,
                  smallSize: 8,
                  backgroundColor: AppColors.error,
                  child: const Icon(
                    PhosphorIconsRegular.bell,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Balance card — same fields, solid green (no gradients/sheen)
                      _BalanceCard(
                        points: user.pointsBalance,
                        label: s.availableBalance,
                        rateLabel: s.pointsEqualsDzd,
                        dzdLabel: s.pointsDzd(user.pointsBalance),
                        goalLabel: s.goalPts(2000),
                      ).animate().fadeIn(duration: 350.ms),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: EcoButton(
                              label: s.scanToDeposit,
                              icon: PhosphorIconsRegular.recycle,
                              onPressed: () => context.push('/scan'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: EcoButton(
                              label: s.cashOut,
                              outlined: true,
                              icon: PhosphorIconsRegular.wallet,
                              onPressed: () => context.push('/withdraw'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Same 3 existing stats
                    Row(
                      children: [
                        Expanded(
                          child: BadgeStatCard(
                            icon: PhosphorIconsRegular.recycle,
                            value: '${user.totalBottlesRecycled}',
                            label: s.bottlesRecycled,
                            tint: TintPair.green,
                            delay: 60.ms,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: BadgeStatCard(
                            icon: PhosphorIconsRegular.cloud,
                            value:
                                '${user.totalCO2SavedKg.toStringAsFixed(1)} kg',
                            label: s.co2Saved,
                            tint: TintPair.green,
                            delay: 100.ms,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: BadgeStatCard(
                            icon: PhosphorIconsRegular.medal,
                            value: '#12',
                            label: s.campusRank,
                            tint: TintPair.green,
                            delay: 140.ms,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Weekly chart — same card
                    EcoCard(
                      color: AppColors.surfaceOf(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SoftIconChip(
                                icon: PhosphorIconsRegular.chartBar,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.thisWeek,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  Text(
                                    s.pointsFromDeposits,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 110,
                            child: _WeeklyChart(
                              transactions: txAsync.valueOrNull ?? [],
                              weekdayLabels: s.weekdayShort,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          s.recentActivity,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        TextButton(
                          onPressed: () => context.push('/history'),
                          child: Text(
                            s.history,
                            style: const TextStyle(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    txAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                      ),
                      error: (e, _) => Text(e.toString()),
                      data: (txs) {
                        if (txs.isEmpty) {
                          return EmptyStateView(
                            message: s.noActivityYet,
                            subtitle: s.scanFirstToEarn,
                            icon: PhosphorIconsRegular.jar,
                          );
                        }
                        return Column(
                          children: txs
                              .take(5)
                              .map((tx) => _ActivityRow(tx: tx, s: s))
                              .toList(),
                        );
                      },
                    ),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Same balance content as before — solid green, soft shadow (no sheen/texture).
class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.points,
    required this.label,
    required this.rateLabel,
    required this.dzdLabel,
    required this.goalLabel,
  });

  final int points;
  final String label;
  final String rateLabel;
  final String dzdLabel;
  final String goalLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(AppConstants.cardRadius),
        boxShadow: AppElevation.walletCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  PhosphorIconsRegular.coins,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                          ),
                    ),
                    Text(
                      rateLabel,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: points),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) => Text(
              NumberFormat('#,###').format(value),
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            dzdLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (points / 2000).clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor: Colors.white.withValues(alpha: 0.25),
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            goalLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.75),
                  fontSize: 10,
                ),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.tx, required this.s});
  final EcoTransaction tx;
  final AppStrings s;

  @override
  Widget build(BuildContext context) {
    final isDeposit = tx.type == TransactionType.deposit;
    final isBonus = tx.type == TransactionType.referralBonus;
    final icon = isDeposit
        ? PhosphorIconsRegular.recycle
        : isBonus
            ? PhosphorIconsRegular.gift
            : PhosphorIconsRegular.wallet;

    return InkWell(
      onTap: () => context.push('/history/${tx.id}'),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SoftIconChip(icon: icon, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isDeposit
                        ? s.bottlesRecycledCount(tx.bottleCount)
                        : s.transactionType(tx.type.name),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    DateFormat.MMMd().add_jm().format(tx.createdAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Text(
              tx.pointsEarned >= 0
                  ? '+${tx.pointsEarned}'
                  : s.negativePts(tx.pointsEarned.abs()),
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: tx.pointsEarned >= 0
                        ? AppColors.primaryGreen
                        : AppColors.error,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({
    required this.transactions,
    required this.weekdayLabels,
  });
  final List<EcoTransaction> transactions;
  final List<String> weekdayLabels;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = List.generate(7, (i) {
      final day = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: 6 - i));
      final pts = transactions
          .where(
            (t) =>
                t.type == TransactionType.deposit &&
                t.createdAt.year == day.year &&
                t.createdAt.month == day.month &&
                t.createdAt.day == day.day,
          )
          .fold<int>(0, (a, t) => a + t.pointsEarned);
      return pts.toDouble();
    });
    final maxY = (days.reduce((a, b) => a > b ? a : b) + 20).clamp(40, 500);

    return BarChart(
      BarChartData(
        maxY: maxY.toDouble(),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (v, _) {
                final i = v.toInt();
                if (i < 0 || i >= weekdayLabels.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    weekdayLabels[i],
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: List.generate(
          7,
          (i) => BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: days[i] == 0 ? 3 : days[i],
                width: 12,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
                color: AppColors.primaryGreen.withValues(
                  alpha: days[i] == 0 ? 0.25 : 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
