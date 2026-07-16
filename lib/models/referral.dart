import 'package:equatable/equatable.dart';

enum ReferralStatus { pending, completed }

class Referral extends Equatable {
  const Referral({
    required this.id,
    required this.referrerId,
    required this.refereeId,
    required this.refereeName,
    required this.bonusPoints,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String referrerId;
  final String refereeId;
  final String refereeName;
  final int bonusPoints;
  final ReferralStatus status;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
        id,
        referrerId,
        refereeId,
        refereeName,
        bonusPoints,
        status,
        createdAt,
      ];
}
