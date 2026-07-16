import 'package:equatable/equatable.dart';

enum WithdrawMethod { baridiMob, ccp, flexy }

enum WithdrawalStatus { pending, processing, completed, rejected }

class WithdrawalRequest extends Equatable {
  const WithdrawalRequest({
    required this.id,
    required this.userId,
    required this.pointsRedeemed,
    required this.amountDzd,
    required this.method,
    required this.accountNumber,
    required this.status,
    required this.requestedAt,
    this.processedAt,
  });

  final String id;
  final String userId;
  final int pointsRedeemed;
  final double amountDzd;
  final WithdrawMethod method;
  final String accountNumber;
  final WithdrawalStatus status;
  final DateTime requestedAt;
  final DateTime? processedAt;

  WithdrawalRequest copyWith({
    String? id,
    String? userId,
    int? pointsRedeemed,
    double? amountDzd,
    WithdrawMethod? method,
    String? accountNumber,
    WithdrawalStatus? status,
    DateTime? requestedAt,
    DateTime? processedAt,
  }) {
    return WithdrawalRequest(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pointsRedeemed: pointsRedeemed ?? this.pointsRedeemed,
      amountDzd: amountDzd ?? this.amountDzd,
      method: method ?? this.method,
      accountNumber: accountNumber ?? this.accountNumber,
      status: status ?? this.status,
      requestedAt: requestedAt ?? this.requestedAt,
      processedAt: processedAt ?? this.processedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        pointsRedeemed,
        amountDzd,
        method,
        accountNumber,
        status,
        requestedAt,
        processedAt,
      ];
}
