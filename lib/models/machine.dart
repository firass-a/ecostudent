import 'package:equatable/equatable.dart';

enum MachineStatus { active, nearFull, full, maintenance }

enum BottleType { pet, hdpe }

class Machine extends Equatable {
  const Machine({
    required this.id,
    required this.name,
    required this.campusLocation,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.fillLevelPercent,
    required this.acceptedTypes,
    required this.lastEmptiedAt,
  });

  final String id;
  final String name;
  final String campusLocation;
  final double latitude;
  final double longitude;
  final MachineStatus status;
  final int fillLevelPercent;
  final List<BottleType> acceptedTypes;
  final DateTime lastEmptiedAt;

  Machine copyWith({
    String? id,
    String? name,
    String? campusLocation,
    double? latitude,
    double? longitude,
    MachineStatus? status,
    int? fillLevelPercent,
    List<BottleType>? acceptedTypes,
    DateTime? lastEmptiedAt,
  }) {
    return Machine(
      id: id ?? this.id,
      name: name ?? this.name,
      campusLocation: campusLocation ?? this.campusLocation,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      status: status ?? this.status,
      fillLevelPercent: fillLevelPercent ?? this.fillLevelPercent,
      acceptedTypes: acceptedTypes ?? this.acceptedTypes,
      lastEmptiedAt: lastEmptiedAt ?? this.lastEmptiedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        campusLocation,
        latitude,
        longitude,
        status,
        fillLevelPercent,
        acceptedTypes,
        lastEmptiedAt,
      ];
}
