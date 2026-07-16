import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/app_providers.dart';
import '../../../core/utils/extensions.dart';
import '../../../l10n/app_strings.dart';
import '../../../models/models.dart';
import '../../../shared/widgets/eco_widgets.dart';

/// Real OSM map — user location + nearby mock EcoBox markers.
class MachinesMapScreen extends ConsumerStatefulWidget {
  const MachinesMapScreen({super.key});

  @override
  ConsumerState<MachinesMapScreen> createState() => _MachinesMapScreenState();
}

class _MachinesMapScreenState extends ConsumerState<MachinesMapScreen> {
  bool _listMode = false;
  Machine? _selected;
  final _mapController = MapController();

  LatLng? _userLatLng;
  bool _locating = true;
  String? _locationNote;
  bool _seededNearUser = false;

  /// Algiers campus fallback if GPS unavailable.
  static const _fallback = LatLng(36.7130, 3.1840);

  Color _statusColor(MachineStatus s) => switch (s) {
        MachineStatus.active => AppColors.success,
        MachineStatus.nearFull => AppColors.warning,
        MachineStatus.full => AppColors.error,
        MachineStatus.maintenance => AppColors.warmGray,
      };

  @override
  void initState() {
    super.initState();
    _resolveLocation();
  }

  Future<void> _resolveLocation() async {
    setState(() {
      _locating = true;
      _locationNote = null;
    });

    try {
      final serviceOn = await Geolocator.isLocationServiceEnabled();
      if (!serviceOn) {
        _useFallback(ref.s.locationDenied);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _useFallback(ref.s.locationDenied);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );

      if (!mounted) return;
      setState(() {
        _userLatLng = LatLng(pos.latitude, pos.longitude);
        _locating = false;
      });
      await _seedMachinesNearUser(_userLatLng!);
      _mapController.move(_userLatLng!, 15);
    } catch (_) {
      _useFallback(ref.s.locationDenied);
    }
  }

  void _useFallback(String note) {
    if (!mounted) return;
    setState(() {
      _userLatLng = _fallback;
      _locating = false;
      _locationNote = note;
    });
    _seedMachinesNearUser(_fallback);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _mapController.move(_fallback, 14.5);
    });
  }

  /// Place mock EcoBoxes around the user so the map feels local.
  Future<void> _seedMachinesNearUser(LatLng center) async {
    if (_seededNearUser) return;
    _seededNearUser = true;

    final locationLabel = ref.s.nearYou;
    final repo = ref.read(machineRepositoryProvider);
    final existing = await repo.getMachines();
    final rng = math.Random(42);

    // Offsets ~150–600m around the user
    final offsets = <(double, double, String, MachineStatus, int)>[
      (0.0018, 0.0012, 'EcoBox Library', MachineStatus.active, 28),
      (-0.0015, 0.0020, 'EcoBox Cafeteria', MachineStatus.nearFull, 74),
      (0.0022, -0.0010, 'EcoBox Amphi A', MachineStatus.full, 96),
      (-0.0008, -0.0018, 'EcoBox Sports Hall', MachineStatus.active, 41),
      (0.0005, 0.0025, 'EcoBox Faculty Gate', MachineStatus.maintenance, 55),
    ];

    for (var i = 0; i < offsets.length; i++) {
      final (dLat, dLng, name, status, fill) = offsets[i];
      final jitterLat = (rng.nextDouble() - 0.5) * 0.0003;
      final jitterLng = (rng.nextDouble() - 0.5) * 0.0003;
      final lat = center.latitude + dLat + jitterLat;
      final lng = center.longitude + dLng + jitterLng;

      if (i < existing.length) {
        await repo.updateMachine(
          existing[i].copyWith(
            name: name,
            campusLocation: locationLabel,
            latitude: lat,
            longitude: lng,
            status: status,
            fillLevelPercent: fill,
          ),
        );
      } else {
        await repo.addMachine(
          Machine(
            id: 'near_$i',
            name: name,
            campusLocation: locationLabel,
            latitude: lat,
            longitude: lng,
            status: status,
            fillLevelPercent: fill,
            acceptedTypes: const [BottleType.pet, BottleType.hdpe],
            lastEmptiedAt: DateTime.now(),
          ),
        );
      }
    }
    ref.invalidate(machinesProvider);
  }

  void _showDetail(Machine m) {
    setState(() => _selected = m);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _MachineSheet(
        machine: m,
        color: _statusColor(m.status),
        isAdmin: ref.read(settingsProvider).isAdminMode,
        strings: ref.s,
        onUpdate: (updated) async {
          await ref.read(machineRepositoryProvider).updateMachine(updated);
          ref.invalidate(machinesProvider);
          if (ctx.mounted) Navigator.pop(ctx);
        },
      ),
    );
  }

  Future<void> _addMachine() async {
    final center = _userLatLng ?? _fallback;
    final id = const Uuid().v4().substring(0, 4);
    final machine = Machine(
      id: 'm_$id',
      name: 'EcoBox New $id',
      campusLocation: ref.s.nearYou,
      latitude: center.latitude + (math.Random().nextDouble() - 0.5) * 0.004,
      longitude: center.longitude + (math.Random().nextDouble() - 0.5) * 0.004,
      status: MachineStatus.active,
      fillLevelPercent: 10,
      acceptedTypes: const [BottleType.pet, BottleType.hdpe],
      lastEmptiedAt: DateTime.now(),
    );
    await ref.read(machineRepositoryProvider).addMachine(machine);
    ref.invalidate(machinesProvider);
  }

  void _centerOnMe() {
    final target = _userLatLng ?? _fallback;
    _mapController.move(target, 15.5);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.s;
    final isAdmin = ref.watch(settingsProvider).isAdminMode;
    final async = ref.watch(machinesProvider);
    final center = _userLatLng ?? _fallback;

    return Scaffold(
      backgroundColor: AppColors.scaffoldOf(context),
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldOf(context),
        title: Text(s.machinesNearby),
        actions: [
          IconButton(
            tooltip: s.listView,
            icon: Icon(
              _listMode
                  ? PhosphorIconsRegular.mapTrifold
                  : PhosphorIconsRegular.list,
            ),
            onPressed: () => setState(() => _listMode = !_listMode),
          ),
          if (isAdmin)
            IconButton(
              icon: const Icon(PhosphorIconsRegular.plus),
              onPressed: _addMachine,
            ),
        ],
      ),
      body: async.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorStateView(
          title: s.errorOccurred,
          message: e.toString(),
          retryLabel: s.retry,
          onRetry: () => ref.invalidate(machinesProvider),
        ),
        data: (machines) {
          if (_listMode) {
            final sorted = [...machines]
              ..sort((a, b) => a.fillLevelPercent.compareTo(b.fillLevelPercent));
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              itemCount: sorted.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) {
                final m = sorted[i];
                return EcoCard(
                  onTap: () => _showDetail(m),
                  child: Row(
                    children: [
                      SoftIconChip(
                        icon: PhosphorIconsRegular.recycle,
                        size: 40,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.name,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              '${m.campusLocation} · ${m.fillLevelPercent}%',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      StatusChip(
                        label: s.machineStatus(m.status.name),
                        color: _statusColor(m.status),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return Stack(
            children: [
              FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: center,
                  initialZoom: 15,
                  minZoom: 3,
                  maxZoom: 19,
                  interactionOptions: const InteractionOptions(
                    flags: InteractiveFlag.all,
                  ),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.ecostudent.app',
                  ),
                  MarkerLayer(
                    markers: [
                      if (_userLatLng != null)
                        Marker(
                          point: _userLatLng!,
                          width: 44,
                          height: 44,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryGreen,
                                width: 3,
                              ),
                              boxShadow: AppElevation.soft,
                            ),
                            child: const Icon(
                              PhosphorIconsFill.navigationArrow,
                              color: AppColors.primaryGreen,
                              size: 18,
                            ),
                          ),
                        ),
                      ...machines.map((m) {
                        final color = _statusColor(m.status);
                        final selected = _selected?.id == m.id;
                        return Marker(
                          point: LatLng(m.latitude, m.longitude),
                          width: 52,
                          height: 60,
                          child: GestureDetector(
                            onTap: () => _showDetail(m),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selected
                                          ? AppColors.textPrimary
                                          : Colors.white,
                                      width: selected ? 2.5 : 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    PhosphorIconsRegular.recycle,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 2),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5,
                                    vertical: 1,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    boxShadow: AppElevation.soft,
                                  ),
                                  child: Text(
                                    '${m.fillLevelPercent}%',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: color,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
              if (_locating)
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.cardOf(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            s.locating,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (_locationNote != null && !_locating)
                Positioned(
                  top: 12,
                  left: 16,
                  right: 16,
                  child: Material(
                    elevation: 1,
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.primaryGreen.withValues(alpha: 0.2)
                        : AppColors.paleGreen,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      child: Text(
                        _locationNote!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.greenDeep,
                            ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 16,
                bottom: 108,
                child: FloatingActionButton.small(
                  heroTag: 'center_me',
                  backgroundColor: AppColors.scaffoldOf(context),
                  foregroundColor: AppColors.primaryGreen,
                  elevation: 2,
                  onPressed: () {
                    _resolveLocation();
                    _centerOnMe();
                  },
                  tooltip: s.myLocation,
                  child: const Icon(PhosphorIconsRegular.crosshair),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 100,
                child: EcoCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _legend(AppColors.success, s.legendActive),
                      _legend(AppColors.warning, s.legendNearFull),
                      _legend(AppColors.error, s.legendFull),
                      _legend(AppColors.warmGray, s.legendMaintenance),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _legend(Color c, String label) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      );
}

class _MachineSheet extends StatelessWidget {
  const _MachineSheet({
    required this.machine,
    required this.color,
    required this.isAdmin,
    required this.strings,
    required this.onUpdate,
  });

  final Machine machine;
  final Color color;
  final bool isAdmin;
  final AppStrings strings;
  final ValueChanged<Machine> onUpdate;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        bottom: MediaQuery.paddingOf(context).bottom + 12,
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.cardOf(context),
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppElevation.soft,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.cardBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                SoftIconChip(
                  icon: PhosphorIconsRegular.recycle,
                  size: 48,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        machine.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        machine.campusLocation,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                StatusChip(
                  label: strings.machineStatus(machine.status.name),
                  color: color,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strings.fillLevel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${machine.fillLevelPercent}%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: machine.fillLevelPercent / 100,
                minHeight: 8,
                backgroundColor: color.withValues(alpha: 0.12),
                color: color,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              strings.acceptsMaterials(
                machine.acceptedTypes
                    .map((e) => strings.bottleType(e.name))
                    .join(', '),
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 20),
            EcoButton(
              label: strings.navigate,
              icon: PhosphorIconsRegular.navigationArrow,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      strings.openingMaps(
                        '${machine.latitude.toStringAsFixed(4)}, ${machine.longitude.toStringAsFixed(4)}',
                      ),
                    ),
                  ),
                );
              },
            ),
            if (isAdmin) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: MachineStatus.values.map((st) {
                  return ActionChip(
                    label: Text(strings.machineStatus(st.name)),
                    onPressed: () => onUpdate(machine.copyWith(status: st)),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
