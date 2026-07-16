import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../models/models.dart';
import '../../../shared/widgets/eco_widgets.dart';
import '../../../shared/widgets/success_overlay.dart';

class ScanDepositScreen extends ConsumerStatefulWidget {
  const ScanDepositScreen({super.key});

  @override
  ConsumerState<ScanDepositScreen> createState() => _ScanDepositScreenState();
}

class _ScanDepositScreenState extends ConsumerState<ScanDepositScreen> {
  bool _useManual = false;
  bool _communicating = false;
  bool _success = false;
  Machine? _selected;
  int _bottles = 0;
  int _points = 0;
  String? _error;

  Future<void> _onMachinePicked(Machine machine) async {
    setState(() {
      _selected = machine;
      _communicating = true;
      _error = null;
    });
    // Simulate machine handshake
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;

    final rng = Random();
    final bottles = 2 + rng.nextInt(6);
    final ptsPer = rng.nextBool()
        ? AppConstants.pointsPerSmallBottle
        : AppConstants.pointsPerLargeBottle;
    final points = bottles * ptsPer;

    try {
      await ref.read(transactionRepositoryProvider).createDeposit(
            machineId: machine.id,
            bottleCount: bottles,
            pointsEarned: points,
          );
      await ref.read(authUserProvider.notifier).refresh();
      ref.invalidate(transactionsProvider);
      ref.invalidate(machinesProvider);
      ref.invalidate(notificationsProvider);
      if (!mounted) return;
      setState(() {
        _bottles = bottles;
        _points = points;
        _communicating = false;
        _success = true;
      });
    } catch (e) {
      setState(() {
        _communicating = false;
        _error = e.toString();
      });
    }
  }

  void _onQrDetect(BarcodeCapture capture) {
    if (_communicating || _success) return;
    final raw = capture.barcodes.firstOrNull?.rawValue;
    if (raw == null) return;
    // Accept any QR; map to machine by id if present, else first active
    final machines = ref.read(machinesProvider).valueOrNull ?? [];
    final match = machines.cast<Machine?>().firstWhere(
          (m) => m!.id == raw || raw.contains(m.id),
          orElse: () => machines.cast<Machine?>().firstWhere(
                (m) => m!.status == MachineStatus.active,
                orElse: () => machines.isNotEmpty ? machines.first : null,
              ),
        );
    if (match != null) _onMachinePicked(match);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.s;

    if (_success) {
      return SuccessOverlay(
        title: s.depositSuccess,
        subtitle: s.bottlesSummary(_bottles, _selected?.name ?? ''),
        pointsDzdLine: s.pointsEarnedDzd(_points),
        pointsEarned: _points,
        buttonLabel: s.home,
        onContinue: () => context.go('/home'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(s.scanToDeposit),
        actions: [
          TextButton(
            onPressed: () => setState(() => _useManual = !_useManual),
            child: Text(_useManual ? s.scan : s.selectMachine),
          ),
        ],
      ),
      body: Stack(
        children: [
          if (_useManual)
            _ManualPicker(
              onPick: _onMachinePicked,
            )
          else
            Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        MobileScanner(onDetect: _onQrDetect),
                        Center(
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.limeHighlight,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          )
                              .animate(
                                onPlay: (c) => c.repeat(reverse: true),
                              )
                              .scale(
                                begin: const Offset(0.96, 0.96),
                                end: const Offset(1.02, 1.02),
                                duration: 1200.ms,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        s.pointAtQr,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        s.pointsEqualsDzd,
                        style: const TextStyle(color: AppColors.goldDark),
                      ),
                      const SizedBox(height: 12),
                      EcoButton(
                        label: s.selectMachine,
                        outlined: true,
                        onPressed: () => setState(() => _useManual = true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          if (_communicating)
            Container(
              color: Colors.black54,
              child: Center(
                child: EcoCard(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 48,
                        height: 48,
                        child: CircularProgressIndicator(
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        s.machineCommunicating,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selected?.name ?? '',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ).animate().fadeIn().scale(),
              ),
            ),
          if (_error != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 24,
              child: Material(
                color: AppColors.error,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(_error!, style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ManualPicker extends ConsumerWidget {
  const _ManualPicker({required this.onPick});
  final ValueChanged<Machine> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.s;
    final async = ref.watch(machinesProvider);
    return async.when(
      loading: () => const LoadingView(),
      error: (e, _) => ErrorStateView(
        title: s.errorOccurred,
        message: e.toString(),
        retryLabel: s.retry,
      ),
      data: (machines) {
        final usable = machines
            .where(
              (m) =>
                  m.status == MachineStatus.active ||
                  m.status == MachineStatus.nearFull,
            )
            .toList();
        if (usable.isEmpty) {
          return EmptyStateView(message: s.emptyState);
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: usable.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final m = usable[i];
            return EcoCard(
              onTap: () => onPick(m),
              child: Row(
                children: [
                  Icon(
                    PhosphorIconsFill.mapPin,
                    color: m.status == MachineStatus.nearFull
                        ? AppColors.warning
                        : AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m.name,
                            style: Theme.of(context).textTheme.titleSmall),
                        Text(
                          '${m.campusLocation} · ${s.percentFull(m.fillLevelPercent)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
