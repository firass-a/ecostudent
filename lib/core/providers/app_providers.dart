import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/repositories/mock_repositories.dart';
import '../../data/repositories/repository_interfaces.dart';
import '../../models/models.dart';

// ── Repositories ──────────────────────────────────────────────
final userRepositoryProvider = Provider<UserRepository>(
  (ref) => MockUserRepository(),
);
final machineRepositoryProvider = Provider<MachineRepository>(
  (ref) => MockMachineRepository(),
);
final transactionRepositoryProvider = Provider<TransactionRepository>(
  (ref) => MockTransactionRepository(),
);
final withdrawalRepositoryProvider = Provider<WithdrawalRepository>(
  (ref) => MockWithdrawalRepository(),
);
final referralRepositoryProvider = Provider<ReferralRepository>(
  (ref) => MockReferralRepository(),
);
final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => MockNotificationRepository(),
);

// ── Auth / session ────────────────────────────────────────────
final authUserProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier(ref);
});

class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier(this._ref) : super(const AsyncValue.loading()) {
    _bootstrap();
  }

  final Ref _ref;

  Future<void> _bootstrap() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Only restore session when user explicitly logged in before
      final loggedIn = prefs.getBool('logged_in') == true;
      if (loggedIn) {
        final user = await _ref.read(userRepositoryProvider).getCurrentUser();
        state = AsyncValue.data(user);
      } else {
        await _ref.read(userRepositoryProvider).logout();
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> refresh() async {
    final user = await _ref.read(userRepositoryProvider).getCurrentUser();
    state = AsyncValue.data(user);
  }

  Future<void> login(String studentId, String password) async {
    state = const AsyncValue.loading();
    try {
      final user =
          await _ref.read(userRepositoryProvider).login(studentId, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logged_in', true);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String studentId,
    required String password,
    String? university,
    String? campus,
    String? referralCode,
  }) async {
    state = const AsyncValue.loading();
    try {
      final user = await _ref.read(userRepositoryProvider).signUp(
            firstName: firstName,
            lastName: lastName,
            studentId: studentId,
            password: password,
            university: university,
            campus: campus,
            referralCode: referralCode,
          );
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('logged_in', true);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> updateProfile(User user) async {
    final updated = await _ref.read(userRepositoryProvider).updateUser(user);
    state = AsyncValue.data(updated);
  }

  Future<void> logout() async {
    await _ref.read(userRepositoryProvider).logout();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', false);
    // Re-seed demo user for next login but keep session null
    MockStore.instance.reset();
    await _ref.read(userRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }

  Future<void> deleteAccount() async {
    final user = state.valueOrNull;
    if (user == null) return;
    await _ref.read(userRepositoryProvider).deleteAccount(user.id);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('logged_in', false);
    MockStore.instance.reset();
    await _ref.read(userRepositoryProvider).logout();
    state = const AsyncValue.data(null);
  }
}

// ── Settings ──────────────────────────────────────────────────
class AppSettings {
  const AppSettings({
    this.locale = const Locale('en'),
    this.isDark = false,
    this.notificationsEnabled = true,
    this.onboardingDone = false,
    this.isAdminMode = false,
  });

  final Locale locale;
  final bool isDark;
  final bool notificationsEnabled;
  final bool onboardingDone;
  final bool isAdminMode;

  AppSettings copyWith({
    Locale? locale,
    bool? isDark,
    bool? notificationsEnabled,
    bool? onboardingDone,
    bool? isAdminMode,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
      isDark: isDark ?? this.isDark,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      onboardingDone: onboardingDone ?? this.onboardingDone,
      isAdminMode: isAdminMode ?? this.isAdminMode,
    );
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(const AppSettings()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString('locale') ?? 'en';
    state = AppSettings(
      locale: Locale(lang),
      isDark: prefs.getBool('is_dark') ?? false,
      notificationsEnabled: prefs.getBool('notif') ?? true,
      onboardingDone: prefs.getBool('onboarding_done') ?? false,
      isAdminMode: prefs.getBool('admin_mode') ?? false,
    );
  }

  Future<void> setLocale(Locale locale) async {
    state = state.copyWith(locale: locale);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);
  }

  Future<void> setDark(bool value) async {
    state = state.copyWith(isDark: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_dark', value);
  }

  Future<void> setNotifications(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif', value);
  }

  Future<void> completeOnboarding() async {
    state = state.copyWith(onboardingDone: true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
  }

  Future<void> setAdminMode(bool value) async {
    state = state.copyWith(isAdminMode: value);
    MockStore.instance.isAdminMode = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('admin_mode', value);
  }
}

// ── Data providers ────────────────────────────────────────────
final machinesProvider = FutureProvider.autoDispose<List<Machine>>((ref) {
  return ref.watch(machineRepositoryProvider).getMachines();
});

final transactionsProvider =
    FutureProvider.autoDispose<List<EcoTransaction>>((ref) {
  // Rebuild when auth user changes (points, deposits)
  ref.watch(authUserProvider);
  return ref.watch(transactionRepositoryProvider).getTransactions();
});

final withdrawalsProvider =
    FutureProvider.autoDispose<List<WithdrawalRequest>>((ref) {
  ref.watch(authUserProvider);
  return ref.watch(withdrawalRepositoryProvider).getWithdrawals();
});

final referralsProvider = FutureProvider.autoDispose<List<Referral>>((ref) {
  ref.watch(authUserProvider);
  return ref.watch(referralRepositoryProvider).getReferrals();
});

final notificationsProvider =
    FutureProvider.autoDispose<List<AppNotification>>((ref) {
  ref.watch(authUserProvider);
  return ref.watch(notificationRepositoryProvider).getNotifications();
});

final unreadCountProvider = FutureProvider.autoDispose<int>((ref) {
  ref.watch(notificationsProvider);
  return ref.watch(notificationRepositoryProvider).unreadCount();
});
