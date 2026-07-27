import 'dart:math';

import '../../models/models.dart';

/// Seeds realistic Algerian-campus mock data for the pitch demo.
class MockDataSeeder {
  MockDataSeeder._();

  static const demoUserId = 'user_demo_001';

  static User demoUser() {
    final now = DateTime.now();
    return User(
      id: demoUserId,
      fullName: 'Amine Benali',
      studentId: '202131049012',
      email: 'amine.benali@usthb.dz',
      phone: '0555123456',
      university: 'USTHB',
      campus: 'Campus Bab Ezzouar',
      pointsBalance: 1280,
      totalBottlesRecycled: 186,
      totalCO2SavedKg: 42.5,
      referralCode: 'ECO-AMINE42',
      createdAt: now.subtract(const Duration(days: 75)),
      password: '1234',
    );
  }

  static List<Machine> machines() {
    final now = DateTime.now();
    return [
      // Bab Ezzouar / USTHB
      Machine(
        id: 'm01',
        name: 'EcoBox Bibliothèque Centrale',
        campusLocation: 'Campus Bab Ezzouar',
        latitude: 36.7135,
        longitude: 3.1850,
        status: MachineStatus.active,
        fillLevelPercent: 42,
        acceptedTypes: const [BottleType.pet, BottleType.hdpe],
        lastEmptiedAt: now.subtract(const Duration(days: 2)),
      ),
      Machine(
        id: 'm02',
        name: 'EcoBox Faculté Informatique',
        campusLocation: 'Campus Bab Ezzouar',
        latitude: 36.7148,
        longitude: 3.1865,
        status: MachineStatus.nearFull,
        fillLevelPercent: 78,
        acceptedTypes: const [BottleType.pet],
        lastEmptiedAt: now.subtract(const Duration(days: 5)),
      ),
      Machine(
        id: 'm03',
        name: 'EcoBox Restaurant Universitaire',
        campusLocation: 'Campus Bab Ezzouar',
        latitude: 36.7120,
        longitude: 3.1835,
        status: MachineStatus.active,
        fillLevelPercent: 31,
        acceptedTypes: const [BottleType.pet, BottleType.hdpe],
        lastEmptiedAt: now.subtract(const Duration(days: 1)),
      ),
      Machine(
        id: 'm04',
        name: 'EcoBox Amphi A',
        campusLocation: 'Campus Bab Ezzouar',
        latitude: 36.7155,
        longitude: 3.1840,
        status: MachineStatus.full,
        fillLevelPercent: 96,
        acceptedTypes: const [BottleType.pet],
        lastEmptiedAt: now.subtract(const Duration(days: 8)),
      ),
      Machine(
        id: 'm05',
        name: 'EcoBox Parking Est',
        campusLocation: 'Campus Bab Ezzouar',
        latitude: 36.7110,
        longitude: 3.1875,
        status: MachineStatus.maintenance,
        fillLevelPercent: 55,
        acceptedTypes: const [BottleType.pet, BottleType.hdpe],
        lastEmptiedAt: now.subtract(const Duration(days: 10)),
      ),
      // Ben Aknoun
      Machine(
        id: 'm06',
        name: 'EcoBox Hall Principal',
        campusLocation: 'Campus Ben Aknoun',
        latitude: 36.7550,
        longitude: 3.0200,
        status: MachineStatus.active,
        fillLevelPercent: 22,
        acceptedTypes: const [BottleType.pet, BottleType.hdpe],
        lastEmptiedAt: now.subtract(const Duration(hours: 18)),
      ),
      Machine(
        id: 'm07',
        name: 'EcoBox Cafétéria',
        campusLocation: 'Campus Ben Aknoun',
        latitude: 36.7562,
        longitude: 3.0215,
        status: MachineStatus.active,
        fillLevelPercent: 48,
        acceptedTypes: const [BottleType.pet],
        lastEmptiedAt: now.subtract(const Duration(days: 3)),
      ),
      Machine(
        id: 'm08',
        name: 'EcoBox Résidence A',
        campusLocation: 'Campus Ben Aknoun',
        latitude: 36.7540,
        longitude: 3.0185,
        status: MachineStatus.nearFull,
        fillLevelPercent: 82,
        acceptedTypes: const [BottleType.pet, BottleType.hdpe],
        lastEmptiedAt: now.subtract(const Duration(days: 6)),
      ),
      Machine(
        id: 'm09',
        name: 'EcoBox Stade Universitaire',
        campusLocation: 'Campus Ben Aknoun',
        latitude: 36.7575,
        longitude: 3.0190,
        status: MachineStatus.active,
        fillLevelPercent: 15,
        acceptedTypes: const [BottleType.pet],
        lastEmptiedAt: now.subtract(const Duration(hours: 8)),
      ),
      // Kouba residence
      Machine(
        id: 'm10',
        name: 'EcoBox Entrée Principale',
        campusLocation: 'Résidence Universitaire Kouba',
        latitude: 36.7300,
        longitude: 3.0900,
        status: MachineStatus.active,
        fillLevelPercent: 37,
        acceptedTypes: const [BottleType.pet, BottleType.hdpe],
        lastEmptiedAt: now.subtract(const Duration(days: 1)),
      ),
      Machine(
        id: 'm11',
        name: 'EcoBox Bloc 3',
        campusLocation: 'Résidence Universitaire Kouba',
        latitude: 36.7312,
        longitude: 3.0912,
        status: MachineStatus.active,
        fillLevelPercent: 61,
        acceptedTypes: const [BottleType.pet],
        lastEmptiedAt: now.subtract(const Duration(days: 4)),
      ),
      Machine(
        id: 'm12',
        name: 'EcoBox Salle de Sport',
        campusLocation: 'Résidence Universitaire Kouba',
        latitude: 36.7290,
        longitude: 3.0888,
        status: MachineStatus.nearFull,
        fillLevelPercent: 74,
        acceptedTypes: const [BottleType.pet, BottleType.hdpe],
        lastEmptiedAt: now.subtract(const Duration(days: 5)),
      ),
      Machine(
        id: 'm13',
        name: 'EcoBox Laverie',
        campusLocation: 'Résidence Universitaire Kouba',
        latitude: 36.7320,
        longitude: 3.0895,
        status: MachineStatus.full,
        fillLevelPercent: 91,
        acceptedTypes: const [BottleType.pet],
        lastEmptiedAt: now.subtract(const Duration(days: 9)),
      ),
      Machine(
        id: 'm14',
        name: 'EcoBox Faculté Sciences',
        campusLocation: 'Campus Bab Ezzouar',
        latitude: 36.7130,
        longitude: 3.1820,
        status: MachineStatus.active,
        fillLevelPercent: 28,
        acceptedTypes: const [BottleType.pet, BottleType.hdpe],
        lastEmptiedAt: now.subtract(const Duration(days: 2)),
      ),
      Machine(
        id: 'm15',
        name: 'EcoBox Entrée Sud',
        campusLocation: 'Campus Ben Aknoun',
        latitude: 36.7535,
        longitude: 3.0225,
        status: MachineStatus.maintenance,
        fillLevelPercent: 40,
        acceptedTypes: const [BottleType.pet],
        lastEmptiedAt: now.subtract(const Duration(days: 12)),
      ),
    ];
  }

  /// ~35 deposits + withdrawals + referral bonuses over ~60 days.
  static List<EcoTransaction> transactions(String userId) {
    final rng = Random(42);
    final now = DateTime.now();
    final machineIds = machines().map((m) => m.id).toList();
    final list = <EcoTransaction>[];

    for (var i = 0; i < 32; i++) {
      final daysAgo = rng.nextInt(60);
      final bottles = 1 + rng.nextInt(8);
      final pts = bottles * (rng.nextBool() ? 5 : 8);
      list.add(
        EcoTransaction(
          id: 'tx_dep_${i.toString().padLeft(3, '0')}',
          userId: userId,
          machineId: machineIds[rng.nextInt(machineIds.length)],
          bottleCount: bottles,
          pointsEarned: pts,
          type: TransactionType.deposit,
          status: TransactionStatus.completed,
          createdAt: now.subtract(Duration(days: daysAgo, hours: rng.nextInt(12))),
        ),
      );
    }

    // Withdrawals (negative points stored as absolute redeemed)
    for (var i = 0; i < 4; i++) {
      list.add(
        EcoTransaction(
          id: 'tx_wd_${i.toString().padLeft(3, '0')}',
          userId: userId,
          bottleCount: 0,
          pointsEarned: -(200 + i * 150),
          type: TransactionType.withdrawal,
          status: i == 0 ? TransactionStatus.pending : TransactionStatus.completed,
          createdAt: now.subtract(Duration(days: 5 + i * 12)),
          note: i == 0 ? 'BaridiMob pending' : 'CCP completed',
        ),
      );
    }

    list.add(
      EcoTransaction(
        id: 'tx_ref_001',
        userId: userId,
        bottleCount: 0,
        pointsEarned: 50,
        type: TransactionType.referralBonus,
        status: TransactionStatus.completed,
        createdAt: now.subtract(const Duration(days: 20)),
        note: 'Bonus — Sara joined',
      ),
    );
    list.add(
      EcoTransaction(
        id: 'tx_ref_002',
        userId: userId,
        bottleCount: 0,
        pointsEarned: 50,
        type: TransactionType.referralBonus,
        status: TransactionStatus.completed,
        createdAt: now.subtract(const Duration(days: 45)),
        note: 'Bonus — Yacine joined',
      ),
    );

    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  static List<WithdrawalRequest> withdrawals(String userId) {
    final now = DateTime.now();
    return [
      WithdrawalRequest(
        id: 'wd_001',
        userId: userId,
        pointsRedeemed: 200,
        amountDzd: 200,
        method: WithdrawMethod.baridiMob,
        accountNumber: '007999990001',
        status: WithdrawalStatus.pending,
        requestedAt: now.subtract(const Duration(days: 1)),
      ),
      WithdrawalRequest(
        id: 'wd_002',
        userId: userId,
        pointsRedeemed: 350,
        amountDzd: 350,
        method: WithdrawMethod.ccp,
        accountNumber: '001234567890',
        status: WithdrawalStatus.completed,
        requestedAt: now.subtract(const Duration(days: 17)),
        processedAt: now.subtract(const Duration(days: 15)),
      ),
      WithdrawalRequest(
        id: 'wd_003',
        userId: userId,
        pointsRedeemed: 500,
        amountDzd: 500,
        method: WithdrawMethod.baridiMob,
        accountNumber: '007999990001',
        status: WithdrawalStatus.completed,
        requestedAt: now.subtract(const Duration(days: 40)),
        processedAt: now.subtract(const Duration(days: 38)),
      ),
      WithdrawalRequest(
        id: 'wd_004',
        userId: userId,
        pointsRedeemed: 150,
        amountDzd: 150,
        method: WithdrawMethod.ccp,
        accountNumber: '001234567890',
        status: WithdrawalStatus.rejected,
        requestedAt: now.subtract(const Duration(days: 55)),
        processedAt: now.subtract(const Duration(days: 54)),
      ),
    ];
  }

  static List<Referral> referrals(String userId) {
    final now = DateTime.now();
    return [
      Referral(
        id: 'ref_001',
        referrerId: userId,
        refereeId: 'user_sara',
        refereeName: 'Sara Mansouri',
        bonusPoints: 50,
        status: ReferralStatus.completed,
        createdAt: now.subtract(const Duration(days: 20)),
      ),
      Referral(
        id: 'ref_002',
        referrerId: userId,
        refereeId: 'user_yacine',
        refereeName: 'Yacine Khelifi',
        bonusPoints: 50,
        status: ReferralStatus.completed,
        createdAt: now.subtract(const Duration(days: 45)),
      ),
      Referral(
        id: 'ref_003',
        referrerId: userId,
        refereeId: 'user_pending',
        refereeName: 'Invited — pending signup',
        bonusPoints: 50,
        status: ReferralStatus.pending,
        createdAt: now.subtract(const Duration(days: 3)),
      ),
    ];
  }

  static List<AppNotification> notifications(String userId) {
    final now = DateTime.now();
    return [
      AppNotification(
        id: 'n01',
        userId: userId,
        title: 'Deposit successful!',
        body: 'You earned +40 points at EcoBox Bibliothèque Centrale.',
        type: NotificationType.reward,
        read: false,
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: 'n02',
        userId: userId,
        title: 'Withdrawal processing',
        body: 'Your BaridiMob cash-out of 200 DZD is being processed.',
        type: NotificationType.system,
        read: false,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      AppNotification(
        id: 'n03',
        userId: userId,
        title: 'Referral bonus 🎉',
        body: 'Sara joined with your code. +50 points credited!',
        type: NotificationType.reward,
        read: true,
        createdAt: now.subtract(const Duration(days: 20)),
      ),
      AppNotification(
        id: 'n04',
        userId: userId,
        title: 'Double points weekend',
        body: 'Deposit this weekend and earn 2× points on every bottle.',
        type: NotificationType.promo,
        read: true,
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      AppNotification(
        id: 'n05',
        userId: userId,
        title: 'Machine nearby is full',
        body: 'EcoBox Amphi A is full. Try Faculté Informatique instead.',
        type: NotificationType.system,
        read: true,
        createdAt: now.subtract(const Duration(days: 6)),
      ),
    ];
  }
}
