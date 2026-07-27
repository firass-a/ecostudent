import '../../models/models.dart';

/// Abstract data access — swap mock for real API later without touching UI.
abstract class UserRepository {
  Future<User?> getCurrentUser();
  Future<User?> login(String studentId, String password);
  Future<User> signUp({
    required String firstName,
    required String lastName,
    required String studentId,
    required String password,
    String? university,
    String? campus,
    String? referralCode,
  });
  Future<User> updateUser(User user);
  Future<void> deleteAccount(String userId);
  Future<void> logout();
  Future<bool> requestPasswordReset(String studentId);
  Future<bool> verifyOtp(String otp);
  Future<void> resetPassword(String newPassword);
}

abstract class MachineRepository {
  Future<List<Machine>> getMachines();
  Future<Machine?> getMachine(String id);
  Future<Machine> addMachine(Machine machine);
  Future<Machine> updateMachine(Machine machine);
}

abstract class TransactionRepository {
  Future<List<EcoTransaction>> getTransactions({
    TransactionType? type,
    String? machineId,
    DateTime? from,
    DateTime? to,
    String? query,
  });
  Future<EcoTransaction?> getTransaction(String id);
  Future<EcoTransaction> createDeposit({
    required String machineId,
    required int bottleCount,
    required int pointsEarned,
  });
  Future<void> deleteTransaction(String id);
  Future<void> reportIssue(String id, String note);
}

abstract class WithdrawalRepository {
  Future<List<WithdrawalRequest>> getWithdrawals();
  Future<WithdrawalRequest> createWithdrawal({
    required int points,
    required WithdrawMethod method,
    required String accountNumber,
  });
  Future<WithdrawalRequest> cancelWithdrawal(String id);
  Future<void> deleteWithdrawal(String id);
}

abstract class ReferralRepository {
  Future<List<Referral>> getReferrals();
  Future<Referral> createReferralInvite(String refereeName);
}

abstract class NotificationRepository {
  Future<List<AppNotification>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<int> unreadCount();
}
