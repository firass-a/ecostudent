import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.fullName,
    required this.studentId,
    this.email = '',
    this.phone = '',
    required this.university,
    required this.campus,
    this.avatarUrl,
    required this.pointsBalance,
    required this.totalBottlesRecycled,
    required this.totalCO2SavedKg,
    required this.referralCode,
    required this.createdAt,
    this.password = '1234',
  });

  final String id;
  final String fullName;
  /// University student registration number (رقم التسجيل).
  final String studentId;
  final String email;
  final String phone;
  final String university;
  final String campus;
  final String? avatarUrl;
  final int pointsBalance;
  final int totalBottlesRecycled;
  final double totalCO2SavedKg;
  final String referralCode;
  final DateTime createdAt;
  /// Secret number / PIN (الرقم السري).
  final String password;

  double get balanceDzd => pointsBalance.toDouble(); // 1 pt = 1 DZD

  String get firstName {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    return parts.isEmpty ? '' : parts.first;
  }

  String get lastName {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.length < 2) return '';
    return parts.sublist(1).join(' ');
  }

  User copyWith({
    String? id,
    String? fullName,
    String? studentId,
    String? email,
    String? phone,
    String? university,
    String? campus,
    String? avatarUrl,
    int? pointsBalance,
    int? totalBottlesRecycled,
    double? totalCO2SavedKg,
    String? referralCode,
    DateTime? createdAt,
    String? password,
    bool clearAvatar = false,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      university: university ?? this.university,
      campus: campus ?? this.campus,
      avatarUrl: clearAvatar ? null : (avatarUrl ?? this.avatarUrl),
      pointsBalance: pointsBalance ?? this.pointsBalance,
      totalBottlesRecycled: totalBottlesRecycled ?? this.totalBottlesRecycled,
      totalCO2SavedKg: totalCO2SavedKg ?? this.totalCO2SavedKg,
      referralCode: referralCode ?? this.referralCode,
      createdAt: createdAt ?? this.createdAt,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'studentId': studentId,
        'email': email,
        'phone': phone,
        'university': university,
        'campus': campus,
        'avatarUrl': avatarUrl,
        'pointsBalance': pointsBalance,
        'totalBottlesRecycled': totalBottlesRecycled,
        'totalCO2SavedKg': totalCO2SavedKg,
        'referralCode': referralCode,
        'createdAt': createdAt.toIso8601String(),
        'password': password,
      };

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        studentId: json['studentId'] as String? ??
            json['email'] as String? ??
            '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        university: json['university'] as String,
        campus: json['campus'] as String,
        avatarUrl: json['avatarUrl'] as String?,
        pointsBalance: json['pointsBalance'] as int,
        totalBottlesRecycled: json['totalBottlesRecycled'] as int,
        totalCO2SavedKg: (json['totalCO2SavedKg'] as num).toDouble(),
        referralCode: json['referralCode'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        password: json['password'] as String? ?? '1234',
      );

  @override
  List<Object?> get props => [
        id,
        fullName,
        studentId,
        email,
        phone,
        university,
        campus,
        avatarUrl,
        pointsBalance,
        totalBottlesRecycled,
        totalCO2SavedKg,
        referralCode,
        createdAt,
      ];
}
