import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../models/models.dart';
import '../../../shared/widgets/eco_widgets.dart';
import '../../../shared/widgets/success_overlay.dart';

class WithdrawScreen extends ConsumerStatefulWidget {
  const WithdrawScreen({super.key});

  @override
  ConsumerState<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends ConsumerState<WithdrawScreen> {
  int _step = 0;
  WithdrawMethod _method = WithdrawMethod.baridiMob;
  double _amount = 200;
  final _account = TextEditingController();
  bool _loading = false;
  bool _done = false;

  @override
  void dispose() {
    _account.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _loading = true);
    try {
      await ref.read(withdrawalRepositoryProvider).createWithdrawal(
            points: _amount.round(),
            method: _method,
            accountNumber: _account.text.trim(),
          );
      await ref.read(authUserProvider.notifier).refresh();
      ref.invalidate(withdrawalsProvider);
      ref.invalidate(transactionsProvider);
      ref.invalidate(notificationsProvider);
      if (!mounted) return;
      setState(() => _done = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.s.localizeError(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.s;
    final user = ref.watch(authUserProvider).valueOrNull;
    final maxPts = (user?.pointsBalance ?? 0).toDouble();
    final cappedMax = maxPts < AppConstants.minWithdrawalDzd
        ? AppConstants.minWithdrawalDzd
        : maxPts;

    if (_done) {
      return SuccessOverlay(
        title: s.withdrawalSubmitted,
        subtitle: s.withdrawalViaDzd(
          _amount.round(),
          s.withdrawMethodLabel(_method),
        ),
        buttonLabel: s.wallet,
        onContinue: () => context.go('/wallet'),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      appBar: AppBar(title: Text(s.cashOut)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Friendly wallet illustration header
            if (_step == 0)
              Center(
                child: Column(
                  children: [
                    const FriendlyIllustration(
                      icon: PhosphorIconsFill.piggyBank,
                      tint: TintPair.gold,
                      size: 80,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.turnPointsToCash,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      s.pointsEqualsDzd,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            if (_step == 0) const SizedBox(height: 20),
            if (_step == 0) ...[
              Text(s.paymentMethod,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 12),
              _MethodCard(
                title: s.baridiMob,
                subtitle: s.baridiMobSubtitle,
                icon: PhosphorIconsFill.deviceMobile,
                selected: _method == WithdrawMethod.baridiMob,
                onTap: () =>
                    setState(() => _method = WithdrawMethod.baridiMob),
              ),
              const SizedBox(height: 10),
              _MethodCard(
                title: s.ccp,
                subtitle: s.ccpSubtitle,
                icon: PhosphorIconsFill.bank,
                selected: _method == WithdrawMethod.ccp,
                onTap: () => setState(() => _method = WithdrawMethod.ccp),
              ),
              const SizedBox(height: 10),
              _MethodCard(
                title: s.flexy,
                subtitle: s.flexySubtitle,
                icon: PhosphorIconsFill.simCard,
                selected: _method == WithdrawMethod.flexy,
                onTap: () => setState(() => _method = WithdrawMethod.flexy),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _account,
                keyboardType: _method == WithdrawMethod.flexy
                    ? TextInputType.phone
                    : TextInputType.number,
                decoration: InputDecoration(
                  labelText: _method == WithdrawMethod.flexy
                      ? s.phone
                      : s.accountNumber,
                ),
              ),
            ],
            if (_step == 1) ...[
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.butterYellow,
                  borderRadius: BorderRadius.circular(AppConstants.cardRadius),
                ),
                child: Column(
                  children: [
                    const Icon(
                      PhosphorIconsFill.coins,
                      color: AppColors.gold,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${_amount.round()} DZD',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    Text(
                      '= ${_amount.round()} ${s.points.toLowerCase()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Slider(
                value: _amount.clamp(
                  AppConstants.minWithdrawalDzd,
                  cappedMax,
                ),
                min: AppConstants.minWithdrawalDzd,
                max: cappedMax,
                divisions: cappedMax > 100
                    ? ((cappedMax - 100) / 50).round().clamp(1, 40)
                    : 1,
                onChanged: maxPts < AppConstants.minWithdrawalDzd
                    ? null
                    : (v) => setState(() => _amount = v),
              ),
              Text(
                s.availablePts(user?.pointsBalance ?? 0),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (_step == 2) ...[
              EcoCard(
                color: AppColors.butterYellow,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ReviewRow(s.method, s.withdrawMethodLabel(_method)),
                    _ReviewRow(s.accountNumber, _account.text),
                    _ReviewRow(s.amount, '${_amount.round()} DZD'),
                    _ReviewRow(s.points, s.negativePts(_amount.round())),
                  ],
                ),
              ),
            ],
            const Spacer(),
            EcoButton(
              label: _step == 2 ? s.confirm : s.continueLabel,
              backgroundColor: AppColors.gold,
              foregroundColor: AppColors.white,
              loading: _loading,
              onPressed: () {
                if (_step == 0 && _account.text.trim().length < 6) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(s.enterValidAccount),
                    ),
                  );
                  return;
                }
                if (_step < 2) {
                  setState(() => _step++);
                } else {
                  _submit();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _MethodCard extends StatelessWidget {
  const _MethodCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return EcoCard(
      onTap: onTap,
      color: selected
          ? (isDark
              ? AppColors.primaryGreen.withValues(alpha: 0.22)
              : AppColors.butterYellow)
          : AppColors.cardOf(context),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: selected
                  ? AppColors.cardOf(context)
                  : (isDark
                      ? AppColors.primaryGreen.withValues(alpha: 0.22)
                      : AppColors.butterYellow),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.gold, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleSmall),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Icon(
            selected
                ? PhosphorIconsFill.checkCircle
                : PhosphorIconsRegular.circle,
            color: selected ? AppColors.gold : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

class _ReviewRow extends StatelessWidget {
  const _ReviewRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
