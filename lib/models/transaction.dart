import 'package:equatable/equatable.dart';

enum TransactionType { deposit, withdrawal, referralBonus }

enum TransactionStatus { pending, completed, failed }

class EcoTransaction extends Equatable {
  const EcoTransaction({
    required this.id,
    required this.userId,
    this.machineId,
    required this.bottleCount,
    required this.pointsEarned,
    required this.type,
    required this.status,
    required this.createdAt,
    this.note,
  });

  final String id;
  final String userId;
  final String? machineId;
  final int bottleCount;
  final int pointsEarned;
  final TransactionType type;
  final TransactionStatus status;
  final DateTime createdAt;
  final String? note;

  EcoTransaction copyWith({
    String? id,
    String? userId,
    String? machineId,
    int? bottleCount,
    int? pointsEarned,
    TransactionType? type,
    TransactionStatus? status,
    DateTime? createdAt,
    String? note,
  }) {
    return EcoTransaction(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      machineId: machineId ?? this.machineId,
      bottleCount: bottleCount ?? this.bottleCount,
      pointsEarned: pointsEarned ?? this.pointsEarned,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      note: note ?? this.note,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        machineId,
        bottleCount,
        pointsEarned,
        type,
        status,
        createdAt,
        note,
      ];
}
