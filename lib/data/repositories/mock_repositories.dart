import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import '../../models/models.dart';
import '../mock/mock_data_seeder.dart';
import 'repository_interfaces.dart';

String _withdrawMethodLabel(WithdrawMethod method) => switch (method) {
      WithdrawMethod.baridiMob => 'BaridiMob',
      WithdrawMethod.ccp => 'CCP',
      WithdrawMethod.flexy => 'Flexy',
    };

/// In-memory mock store — simulates persistence for the pitch prototype.
class MockStore {
  MockStore._() {
    reset();
  }

  static final MockStore instance = MockStore._();

  final _uuid = const Uuid();

  User? currentUser;
  late List<User> users;
  late List<Machine> machines;
  late List<EcoTransaction> transactions;
  late List<WithdrawalRequest> withdrawals;
  late List<Referral> referrals;
  late List<AppNotification> notifications;

  String? pendingOtpEmail;
  bool otpVerified = false;
  bool isAdminMode = false;

  void reset() {
    currentUser = MockDataSeeder.demoUser();
    users = [currentUser!];
    machines = MockDataSeeder.machines();
    transactions = MockDataSeeder.transactions(MockDataSeeder.demoUserId);
    withdrawals = MockDataSeeder.withdrawals(MockDataSeeder.demoUserId);
    referrals = MockDataSeeder.referrals(MockDataSeeder.demoUserId);
    notifications = MockDataSeeder.notifications(MockDataSeeder.demoUserId);
    pendingOtpEmail = null;
    otpVerified = false;
  }

  Future<void> _delay([int ms = 400]) =>
      Future<void>.delayed(Duration(milliseconds: ms));
}

class MockUserRepository implements UserRepository {
  MockUserRepository({MockStore? store}) : _store = store ?? MockStore.instance;
  final MockStore _store;

  @override
  Future<User?> getCurrentUser() async {
    await _store._delay(200);
    return _store.currentUser;
  }

  @override
  Future<User?> login(String studentId, String password) async {
    await _store._delay(700);
    final id = studentId.trim();
    final match = _store.users.cast<User?>().firstWhere(
          (u) => u!.studentId == id && u.password == password,
          orElse: () => null,
        );
    if (match != null) {
      _store.currentUser = match;
      return match;
    }
    // Demo shortcut
    if ((id == '202131049012' || id == 'demo') &&
        (password == '1234' || password == 'demo1234')) {
      _store.currentUser = _store.users.first;
      return _store.currentUser;
    }
    throw Exception('Invalid credentials');
  }

  @override
  Future<User> signUp({
    required String firstName,
    required String lastName,
    required String studentId,
    required String password,
    String? university,
    String? campus,
    String? referralCode,
  }) async {
    await _store._delay(800);
    final id = studentId.trim();
    if (id.isEmpty || password.isEmpty) {
      throw Exception('Invalid credentials');
    }
    if (_store.users.any((u) => u.studentId == id)) {
      throw Exception('Student ID already registered');
    }
    final fullName = '${firstName.trim()} ${lastName.trim()}'.trim();
    final code =
        'ECO-${firstName.trim().toUpperCase()}${DateTime.now().millisecond % 100}';
    final user = User(
      id: _store._uuid.v4(),
      fullName: fullName,
      studentId: id,
      university: university ?? AppConstants.universities.first,
      campus: campus ?? AppConstants.campuses.first,
      pointsBalance: referralCode != null && referralCode.isNotEmpty
          ? AppConstants.referralBonusPoints
          : 0,
      totalBottlesRecycled: 0,
      totalCO2SavedKg: 0,
      referralCode: code,
      createdAt: DateTime.now(),
      password: password,
    );
    _store.users.add(user);
    _store.currentUser = user;

    if (referralCode != null && referralCode.isNotEmpty) {
      final referrer = _store.users.cast<User?>().firstWhere(
            (u) => u!.referralCode == referralCode,
            orElse: () => null,
          );
      if (referrer != null) {
        final updated = referrer.copyWith(
          pointsBalance:
              referrer.pointsBalance + AppConstants.referralBonusPoints,
        );
        final idx = _store.users.indexWhere((u) => u.id == referrer.id);
        _store.users[idx] = updated;
        _store.referrals.insert(
          0,
          Referral(
            id: _store._uuid.v4(),
            referrerId: referrer.id,
            refereeId: user.id,
            refereeName: fullName,
            bonusPoints: AppConstants.referralBonusPoints,
            status: ReferralStatus.completed,
            createdAt: DateTime.now(),
          ),
        );
      }
    }
    return user;
  }

  @override
  Future<User> updateUser(User user) async {
    await _store._delay(500);
    final idx = _store.users.indexWhere((u) => u.id == user.id);
    if (idx >= 0) _store.users[idx] = user;
    if (_store.currentUser?.id == user.id) _store.currentUser = user;
    return user;
  }

  @override
  Future<void> deleteAccount(String userId) async {
    await _store._delay(600);
    _store.users.removeWhere((u) => u.id == userId);
    if (_store.currentUser?.id == userId) _store.currentUser = null;
  }

  @override
  Future<void> logout() async {
    await _store._delay(200);
    _store.currentUser = null;
  }

  @override
  Future<bool> requestPasswordReset(String studentId) async {
    await _store._delay(600);
    _store.pendingOtpEmail = studentId.trim();
    _store.otpVerified = false;
    return true;
  }

  @override
  Future<bool> verifyOtp(String otp) async {
    await _store._delay(500);
    // Mock: any 4+ digit OTP works; "1234" is the demo code
    if (otp.length >= 4) {
      _store.otpVerified = true;
      return true;
    }
    return false;
  }

  @override
  Future<void> resetPassword(String newPassword) async {
    await _store._delay(500);
    if (!_store.otpVerified || _store.pendingOtpEmail == null) {
      throw Exception('OTP not verified');
    }
    final key = _store.pendingOtpEmail!;
    final idx = _store.users.indexWhere(
      (u) => u.studentId == key || u.email == key || u.phone == key,
    );
    if (idx >= 0) {
      _store.users[idx] = _store.users[idx].copyWith(password: newPassword);
    }
    _store.pendingOtpEmail = null;
    _store.otpVerified = false;
  }
}

class MockMachineRepository implements MachineRepository {
  MockMachineRepository({MockStore? store})
      : _store = store ?? MockStore.instance;
  final MockStore _store;

  @override
  Future<List<Machine>> getMachines() async {
    await _store._delay(350);
    return List.unmodifiable(_store.machines);
  }

  @override
  Future<Machine?> getMachine(String id) async {
    await _store._delay(200);
    try {
      return _store.machines.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Machine> addMachine(Machine machine) async {
    await _store._delay(500);
    _store.machines.add(machine);
    return machine;
  }

  @override
  Future<Machine> updateMachine(Machine machine) async {
    await _store._delay(400);
    final idx = _store.machines.indexWhere((m) => m.id == machine.id);
    if (idx >= 0) _store.machines[idx] = machine;
    return machine;
  }
}

class MockTransactionRepository implements TransactionRepository {
  MockTransactionRepository({MockStore? store})
      : _store = store ?? MockStore.instance;
  final MockStore _store;

  @override
  Future<List<EcoTransaction>> getTransactions({
    TransactionType? type,
    String? machineId,
    DateTime? from,
    DateTime? to,
    String? query,
  }) async {
    await _store._delay(350);
    var list = _store.transactions
        .where((t) => t.userId == _store.currentUser?.id)
        .toList();
    if (type != null) list = list.where((t) => t.type == type).toList();
    if (machineId != null) {
      list = list.where((t) => t.machineId == machineId).toList();
    }
    if (from != null) {
      list = list.where((t) => !t.createdAt.isBefore(from)).toList();
    }
    if (to != null) {
      list = list.where((t) => !t.createdAt.isAfter(to)).toList();
    }
    if (query != null && query.isNotEmpty) {
      final q = query.toLowerCase();
      list = list
          .where(
            (t) =>
                t.id.toLowerCase().contains(q) ||
                (t.note?.toLowerCase().contains(q) ?? false) ||
                (t.machineId?.toLowerCase().contains(q) ?? false),
          )
          .toList();
    }
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<EcoTransaction?> getTransaction(String id) async {
    await _store._delay(200);
    try {
      return _store.transactions.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<EcoTransaction> createDeposit({
    required String machineId,
    required int bottleCount,
    required int pointsEarned,
  }) async {
    await _store._delay(900);
    final user = _store.currentUser;
    if (user == null) throw Exception('Not logged in');

    final tx = EcoTransaction(
      id: _store._uuid.v4(),
      userId: user.id,
      machineId: machineId,
      bottleCount: bottleCount,
      pointsEarned: pointsEarned,
      type: TransactionType.deposit,
      status: TransactionStatus.completed,
      createdAt: DateTime.now(),
    );
    _store.transactions.insert(0, tx);

    final co2 = bottleCount * 0.23;
    final updated = user.copyWith(
      pointsBalance: user.pointsBalance + pointsEarned,
      totalBottlesRecycled: user.totalBottlesRecycled + bottleCount,
      totalCO2SavedKg: user.totalCO2SavedKg + co2,
    );
    final uIdx = _store.users.indexWhere((u) => u.id == user.id);
    if (uIdx >= 0) _store.users[uIdx] = updated;
    _store.currentUser = updated;

    // bump machine fill
    final mIdx = _store.machines.indexWhere((m) => m.id == machineId);
    if (mIdx >= 0) {
      final m = _store.machines[mIdx];
      final fill = (m.fillLevelPercent + bottleCount * 2).clamp(0, 100);
      var status = m.status;
      if (fill >= 90) {
        status = MachineStatus.full;
      } else if (fill >= 70) {
        status = MachineStatus.nearFull;
      }
      _store.machines[mIdx] = m.copyWith(
        fillLevelPercent: fill,
        status: status == MachineStatus.maintenance ? m.status : status,
      );
    }

    _store.notifications.insert(
      0,
      AppNotification(
        id: _store._uuid.v4(),
        userId: user.id,
        title: 'Deposit successful!',
        body: 'You earned +$pointsEarned points ($bottleCount bottles).',
        type: NotificationType.reward,
        read: false,
        createdAt: DateTime.now(),
      ),
    );

    return tx;
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await _store._delay(300);
    _store.transactions.removeWhere((t) => t.id == id);
  }

  @override
  Future<void> reportIssue(String id, String note) async {
    await _store._delay(400);
    final idx = _store.transactions.indexWhere((t) => t.id == id);
    if (idx >= 0) {
      _store.transactions[idx] =
          _store.transactions[idx].copyWith(note: 'Issue: $note');
    }
  }
}

class MockWithdrawalRepository implements WithdrawalRepository {
  MockWithdrawalRepository({MockStore? store})
      : _store = store ?? MockStore.instance;
  final MockStore _store;

  @override
  Future<List<WithdrawalRequest>> getWithdrawals() async {
    await _store._delay(350);
    return _store.withdrawals
        .where((w) => w.userId == _store.currentUser?.id)
        .toList()
      ..sort((a, b) => b.requestedAt.compareTo(a.requestedAt));
  }

  @override
  Future<WithdrawalRequest> createWithdrawal({
    required int points,
    required WithdrawMethod method,
    required String accountNumber,
  }) async {
    await _store._delay(800);
    final user = _store.currentUser;
    if (user == null) throw Exception('Not logged in');
    if (points > user.pointsBalance) throw Exception('Insufficient points');
    if (points < AppConstants.minWithdrawalDzd) {
      throw Exception('Minimum withdrawal is ${AppConstants.minWithdrawalDzd} DZD');
    }

    final wd = WithdrawalRequest(
      id: _store._uuid.v4(),
      userId: user.id,
      pointsRedeemed: points,
      amountDzd: points * AppConstants.pointsToDzd,
      method: method,
      accountNumber: accountNumber,
      status: WithdrawalStatus.pending,
      requestedAt: DateTime.now(),
    );
    _store.withdrawals.insert(0, wd);

    final updated =
        user.copyWith(pointsBalance: user.pointsBalance - points);
    final uIdx = _store.users.indexWhere((u) => u.id == user.id);
    if (uIdx >= 0) _store.users[uIdx] = updated;
    _store.currentUser = updated;

    _store.transactions.insert(
      0,
      EcoTransaction(
        id: _store._uuid.v4(),
        userId: user.id,
        bottleCount: 0,
        pointsEarned: -points,
        type: TransactionType.withdrawal,
        status: TransactionStatus.pending,
        createdAt: DateTime.now(),
        note: _withdrawMethodLabel(method),
      ),
    );

    _store.notifications.insert(
      0,
      AppNotification(
        id: _store._uuid.v4(),
        userId: user.id,
        title: 'Withdrawal submitted',
        body: '$points DZD via ${_withdrawMethodLabel(method)} is pending.',
        type: NotificationType.system,
        read: false,
        createdAt: DateTime.now(),
      ),
    );

    return wd;
  }

  @override
  Future<WithdrawalRequest> cancelWithdrawal(String id) async {
    await _store._delay(500);
    final idx = _store.withdrawals.indexWhere((w) => w.id == id);
    if (idx < 0) throw Exception('Not found');
    final wd = _store.withdrawals[idx];
    if (wd.status != WithdrawalStatus.pending) {
      throw Exception('Only pending withdrawals can be cancelled');
    }
    final cancelled = wd.copyWith(status: WithdrawalStatus.rejected);
    _store.withdrawals[idx] = cancelled;

    final user = _store.currentUser;
    if (user != null && user.id == wd.userId) {
      final refunded =
          user.copyWith(pointsBalance: user.pointsBalance + wd.pointsRedeemed);
      final uIdx = _store.users.indexWhere((u) => u.id == user.id);
      if (uIdx >= 0) _store.users[uIdx] = refunded;
      _store.currentUser = refunded;
    }
    return cancelled;
  }

  @override
  Future<void> deleteWithdrawal(String id) async {
    await _store._delay(300);
    _store.withdrawals.removeWhere((w) => w.id == id);
  }
}

class MockReferralRepository implements ReferralRepository {
  MockReferralRepository({MockStore? store})
      : _store = store ?? MockStore.instance;
  final MockStore _store;

  @override
  Future<List<Referral>> getReferrals() async {
    await _store._delay(300);
    return _store.referrals
        .where((r) => r.referrerId == _store.currentUser?.id)
        .toList();
  }

  @override
  Future<Referral> createReferralInvite(String refereeName) async {
    await _store._delay(400);
    final user = _store.currentUser;
    if (user == null) throw Exception('Not logged in');
    final ref = Referral(
      id: _store._uuid.v4(),
      referrerId: user.id,
      refereeId: 'pending_${_store._uuid.v4().substring(0, 8)}',
      refereeName: refereeName,
      bonusPoints: AppConstants.referralBonusPoints,
      status: ReferralStatus.pending,
      createdAt: DateTime.now(),
    );
    _store.referrals.insert(0, ref);
    return ref;
  }
}

class MockNotificationRepository implements NotificationRepository {
  MockNotificationRepository({MockStore? store})
      : _store = store ?? MockStore.instance;
  final MockStore _store;

  @override
  Future<List<AppNotification>> getNotifications() async {
    await _store._delay(300);
    return _store.notifications
        .where((n) => n.userId == _store.currentUser?.id)
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<void> markAsRead(String id) async {
    await _store._delay(150);
    final idx = _store.notifications.indexWhere((n) => n.id == id);
    if (idx >= 0) {
      _store.notifications[idx] =
          _store.notifications[idx].copyWith(read: true);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    await _store._delay(200);
    _store.notifications = _store.notifications
        .map((n) => n.userId == _store.currentUser?.id ? n.copyWith(read: true) : n)
        .toList();
  }

  @override
  Future<void> deleteNotification(String id) async {
    await _store._delay(200);
    _store.notifications.removeWhere((n) => n.id == id);
  }

  @override
  Future<int> unreadCount() async {
    return _store.notifications
        .where((n) => n.userId == _store.currentUser?.id && !n.read)
        .length;
  }
}
