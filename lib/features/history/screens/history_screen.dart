import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../models/models.dart';
import '../../../shared/widgets/eco_widgets.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  TransactionType? _filter;
  final _query = TextEditingController();

  @override
  void dispose() {
    _query.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.s;
    final async = ref.watch(transactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      appBar: AppBar(title: Text(s.history)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _query,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: s.search,
                prefixIcon: const Icon(PhosphorIconsFill.magnifyingGlass),
                suffixIcon: _query.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _query.clear();
                          setState(() {});
                        },
                      ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                _FilterChip(
                  label: s.filterAll,
                  selected: _filter == null,
                  onTap: () => setState(() => _filter = null),
                ),
                _FilterChip(
                  label: s.transactionType('deposit'),
                  selected: _filter == TransactionType.deposit,
                  onTap: () =>
                      setState(() => _filter = TransactionType.deposit),
                ),
                _FilterChip(
                  label: s.transactionType('withdrawal'),
                  selected: _filter == TransactionType.withdrawal,
                  onTap: () =>
                      setState(() => _filter = TransactionType.withdrawal),
                ),
                _FilterChip(
                  label: s.transactionType('referralBonus'),
                  selected: _filter == TransactionType.referralBonus,
                  onTap: () =>
                      setState(() => _filter = TransactionType.referralBonus),
                ),
              ],
            ),
          ),
          Expanded(
            child: async.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorStateView(
                title: s.errorOccurred,
                message: e.toString(),
                retryLabel: s.retry,
                onRetry: () => ref.invalidate(transactionsProvider),
              ),
              data: (all) {
                var list = all;
                if (_filter != null) {
                  list = list.where((t) => t.type == _filter).toList();
                }
                final q = _query.text.trim().toLowerCase();
                if (q.isNotEmpty) {
                  list = list
                      .where(
                        (t) =>
                            t.id.toLowerCase().contains(q) ||
                            (t.note?.toLowerCase().contains(q) ?? false) ||
                            (t.machineId?.toLowerCase().contains(q) ?? false),
                      )
                      .toList();
                }
                if (list.isEmpty) {
                  return EmptyStateView(
                    message: s.noBottlesYet,
                    subtitle: s.scanFirstBottle,
                    icon: PhosphorIconsFill.jar,
                    tint: TintPair.green,
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    final tx = list[i];
                    return Dismissible(
                      key: ValueKey(tx.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: AlignmentDirectional.centerEnd,
                        padding: const EdgeInsetsDirectional.only(end: 20),
                        color: AppColors.error,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (_) async {
                        final report = await showDialog<String>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(s.reportIssueTitle),
                            content: Text(s.reportIssueBody),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, 'delete'),
                                child: Text(s.delete),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, 'report'),
                                child: Text(s.report),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: Text(s.cancel),
                              ),
                            ],
                          ),
                        );
                        if (report == 'delete') {
                          await ref
                              .read(transactionRepositoryProvider)
                              .deleteTransaction(tx.id);
                          ref.invalidate(transactionsProvider);
                          return true;
                        }
                        if (report == 'report') {
                          await ref
                              .read(transactionRepositoryProvider)
                              .reportIssue(tx.id, 'User reported issue');
                          ref.invalidate(transactionsProvider);
                        }
                        return false;
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: EcoCard(
                          onTap: () => context.push('/history/${tx.id}'),
                          child: Row(
                            children: [
                              Icon(
                                tx.type == TransactionType.deposit
                                    ? PhosphorIconsFill.recycle
                                    : tx.type == TransactionType.withdrawal
                                        ? PhosphorIconsFill.wallet
                                        : PhosphorIconsFill.gift,
                                color: AppColors.primaryGreen,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.transactionType(tx.type.name),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                    Text(
                                      DateFormat.yMMMd()
                                          .add_jm()
                                          .format(tx.createdAt),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${tx.pointsEarned > 0 ? '+' : ''}${tx.pointsEarned}',
                                style: TextStyle(
                                  color: tx.pointsEarned >= 0
                                      ? AppColors.goldDark
                                      : AppColors.error,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primaryGreen.withValues(alpha: 0.2),
        checkmarkColor: AppColors.primaryGreen,
      ),
    );
  }
}

class TransactionDetailScreen extends ConsumerWidget {
  const TransactionDetailScreen({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.s;
    return FutureBuilder(
      future: ref.read(transactionRepositoryProvider).getTransaction(id),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(body: LoadingView());
        }
        final tx = snap.data;
        if (tx == null) {
          return Scaffold(
            appBar: AppBar(),
            body: EmptyStateView(
              message: s.transactionNotFound,
              icon: PhosphorIconsFill.magnifyingGlass,
              tint: TintPair.sky,
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(tx.id.substring(0, 8))),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: EcoCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _row(s.type, s.transactionType(tx.type.name)),
                  _row(s.status, s.transactionStatus(tx.status.name)),
                  _row(s.bottles, '${tx.bottleCount}'),
                  _row(
                    s.points,
                    s.transactionPointsDetail(tx.pointsEarned),
                  ),
                  if (tx.machineId != null) _row(s.machine, tx.machineId!),
                  _row(s.date, DateFormat.yMMMd().add_jm().format(tx.createdAt)),
                  if (tx.note != null) _row(s.note, tx.note!),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 90,
              child: Text(k, style: const TextStyle(color: AppColors.warmGray)),
            ),
            Expanded(
              child: Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
}
