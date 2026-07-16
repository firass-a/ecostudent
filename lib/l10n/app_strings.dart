import '../models/withdrawal.dart';

/// Full AR / FR / EN string catalog for EcoStudent.
class AppStrings {
  AppStrings(this.locale);

  final String locale;

  bool get isAr => locale == 'ar';
  bool get isFr => locale == 'fr';

  // ── Brand ─────────────────────────────────────────────────────
  String get appName => 'EcoStudent';
  String get tagline => _t(
    'أعد التدوير · اربح · اسحب',
    'Recyclez · Gagnez · Retirez',
    'Recycle · Earn · Cash out',
  );
  String get splashHeadline => _t(
    'مع EcoStudent حول نفاياتك إلى أرباح',
    'Avec EcoStudent, transformez vos déchets en profits',
    'With EcoStudent, turn your waste into earnings',
  );

  // ── Auth ──────────────────────────────────────────────────────
  String get welcome => _t('مرحباً', 'Bienvenue', 'Welcome');
  String get heyThere => _t('أهلاً بك 👋', 'Salut 👋', 'Hey there 👋');
  String get login => _t('تسجيل الدخول', 'Connexion', 'Log in');
  String get signUp => _t('إنشاء حساب', 'Créer un compte', 'Sign up');
  String get signInSubtitle => _t(
    'سجّل الدخول إلى حسابك الجامعي',
    'Connectez-vous à votre compte campus',
    'Sign in to your campus account',
  );
  String get signUpSubtitle => _t(
    'أنشئ حسابك الطلابي',
    'Créez votre compte étudiant',
    'Create your student account',
  );
  String get noAccount =>
      _t('ليس لديك حساب؟ ', 'Pas de compte ? ', "Don't have an account? ");
  String get email => _t('البريد الإلكتروني', 'E-mail', 'Email');
  String get phone => _t('الهاتف', 'Téléphone', 'Phone');
  String get password => _t('كلمة المرور', 'Mot de passe', 'Password');
  String get fullName => _t('الاسم الكامل', 'Nom complet', 'Full name');
  String get university => _t('الجامعة', 'Université', 'University');
  String get campus => _t('الحرم الجامعي', 'Campus', 'Campus');
  String get forgotPassword =>
      _t('نسيت كلمة المرور؟', 'Mot de passe oublié ?', 'Forgot password?');
  String get passwordUpdated =>
      _t('تم تحديث كلمة المرور', 'Mot de passe mis à jour', 'Password updated');
  String get invalidOtp =>
      _t('رمز التحقق غير صالح', 'Code OTP invalide', 'Invalid OTP');
  String get enterEmailPassword => _t(
    'يرجى إدخال البريد وكلمة المرور',
    'Veuillez saisir e-mail et mot de passe',
    'Please enter email and password',
  );
  String get referralCodeOptional => _t(
    'رمز الإحالة (اختياري)',
    'Code de parrainage (optionnel)',
    'Referral code (optional)',
  );
  String get demoCredentials => _t(
    'تجريبي: amine.benali@usthb.dz · demo1234',
    'Démo : amine.benali@usthb.dz · demo1234',
    'Demo: amine.benali@usthb.dz · demo1234',
  );

  // ── Navigation ────────────────────────────────────────────────
  String get home => _t('الرئيسية', 'Accueil', 'Home');
  String get map => _t('الخريطة', 'Carte', 'Map');
  String get scan => _t('مسح', 'Scanner', 'Scan');
  String get wallet => _t('المحفظة', 'Portefeuille', 'Wallet');
  String get profile => _t('الملف', 'Profil', 'Profile');
  String get history => _t('السجل', 'Historique', 'History');
  String get referral => _t('دعوة صديق', 'Parrainage', 'Invite a friend');
  String get notifications => _t('الإشعارات', 'Notifications', 'Notifications');
  String get settings => _t('الإعدادات', 'Paramètres', 'Settings');

  // ── Actions ───────────────────────────────────────────────────
  String get continueLabel => _t('متابعة', 'Continuer', 'Continue');
  String get confirm => _t('تأكيد', 'Confirmer', 'Confirm');
  String get cancel => _t('إلغاء', 'Annuler', 'Cancel');
  String get save => _t('حفظ', 'Enregistrer', 'Save');
  String get delete => _t('حذف', 'Supprimer', 'Delete');
  String get logout => _t('تسجيل الخروج', 'Déconnexion', 'Log out');
  String get report => _t('إبلاغ', 'Signaler', 'Report');
  String get retry => _t('إعادة المحاولة', 'Réessayer', 'Try again');
  String get search => _t('بحث…', 'Rechercher…', 'Search…');
  String get markAllRead =>
      _t('تحديد الكل كمقروء', 'Tout marquer comme lu', 'Mark all read');
  String get gallery => _t('المعرض', 'Galerie', 'Gallery');
  String get camera => _t('الكاميرا', 'Caméra', 'Camera');

  // ── Points & money ────────────────────────────────────────────
  String get points => _t('نقاط', 'Points', 'Points');
  String get cashOut => _t('سحب الأموال', 'Retirer', 'Cash out');
  String get pointsEqualsDzd =>
      _t('1 نقطة = 1 دج', '1 point = 1 DZD', '1 point = 1 DZD');
  String get availableBalance =>
      _t('الرصيد المتاح', 'Solde disponible', 'Available balance');
  String get baridiMob => 'BaridiMob';
  String get ccp => 'CCP';
  String get flexy => 'Flexy';
  String get amount => _t('المبلغ', 'Montant', 'Amount');
  String get accountNumber =>
      _t('رقم الحساب / RIP', 'N° de compte / RIP', 'Account / RIP number');
  String get paymentMethod =>
      _t('طريقة الدفع', 'Mode de paiement', 'Payment method');
  String get baridiMobSubtitle => _t(
    'محفظة بريد الجزائر',
    'Portefeuille mobile Algérie Poste',
    'Algérie Poste mobile wallet',
  );
  String get ccpSubtitle =>
      _t('حساب الشيك البريدي', 'Compte Chèque Postal', 'Compte Chèque Postal');
  String get flexySubtitle => _t(
    'شحن رصيد Flexy',
    'Recharge crédit Flexy',
    'Flexy mobile top-up',
  );
  String get turnPointsToCash => _t(
    'حوّل نقاطك إلى نقود!',
    'Convertissez vos points en argent !',
    'Turn points into cash!',
  );
  String availablePts(int n) =>
      _t('المتاح: $n نقطة', 'Disponible : $n pts', 'Available: $n pts');
  String pointsDzd(int n) =>
      _t('$n نقطة · $n دج', '$n pts · $n DZD', '$n points · $n DZD');
  String ptsApproxDzd(int n) =>
      _t('نقطة ≈ $n دج', 'pts ≈ $n DZD', 'pts ≈ $n DZD');
  String pointsEarnedDzd(int n) =>
      _t('نقاط · = $n دج', 'points · = $n DZD', 'points · = $n DZD');
  String goalPts(int n) =>
      _t('الهدف: $n نقطة', 'Objectif : $n pts', 'Goal: $n pts');
  String negativePts(int n) => '-$n ${_t('نقطة', 'pts', 'pts')}';
  String bonusPts(int n) => _t('+$n نقطة', '+$n pts', '+$n pts');
  String percentFull(int n) => _t('$n% ممتلئة', '$n% pleine', '$n% full');
  String transactionPointsDetail(int pts) => _t(
    '${pts > 0 ? '+' : ''}$pts (= ${pts.abs()} دج)',
    '${pts > 0 ? '+' : ''}$pts (= ${pts.abs()} DZD)',
    '${pts > 0 ? '+' : ''}$pts (= ${pts.abs()} DZD)',
  );
  String withdrawalViaDzd(int amount, String method) => _t(
    '$amount دج عبر $method',
    '$amount DZD via $method',
    '$amount DZD via $method',
  );

  // ── Eco stats ─────────────────────────────────────────────────
  String get bottlesRecycled =>
      _t('زجاجات معاد تدويرها', 'Bouteilles recyclées', 'Bottles recycled');
  String get co2Saved => _t('CO₂ موفر', 'CO₂ économisé', 'CO₂ saved');
  String get campusRank => _t('ترتيب الحرم', 'Rang campus', 'Campus rank');
  String get recentActivity =>
      _t('النشاط الأخير', 'Activité récente', 'Recent activity');
  String get thisWeek => _t('هذا الأسبوع', 'Cette semaine', 'This week');
  String get pointsFromDeposits =>
      _t('نقاط من الإيداعات', 'Points des dépôts', 'Points from deposits');

  // ── Deposit / scan ────────────────────────────────────────────
  String get scanToDeposit =>
      _t('امسح للإيداع', 'Scanner pour déposer', 'Scan to deposit');
  String get selectMachine =>
      _t('اختر آلة', 'Choisir une machine', 'Select a machine');
  String get pointAtQr => _t(
    'وجّه الكاميرا نحو رمز QR للآلة',
    'Pointez vers le QR de la machine',
    'Point at the machine QR code',
  );
  String get machineCommunicating => _t(
    'جاري الاتصال بالآلة…',
    'Communication avec la machine…',
    'Machine communicating…',
  );
  String get depositSuccess =>
      _t('تم الإيداع بنجاح!', 'Dépôt réussi !', 'Deposit successful!');
  String bottlesSummary(int count, String machine) => _t(
    '$count زجاجة · $machine',
    '$count bouteilles · $machine',
    '$count bottles · $machine',
  );
  String bottlesRecycledCount(int n) => _t(
    '$n زجاجة معاد تدويرها',
    '$n bouteilles recyclées',
    '$n bottles recycled',
  );

  // ── Withdrawal ─────────────────────────────────────────────────
  String get withdrawalSubmitted =>
      _t('تم إرسال طلب السحب', 'Retrait soumis', 'Withdrawal submitted');
  String get withdrawals => _t('عمليات السحب', 'Retraits', 'Withdrawals');
  String get review => _t('مراجعة', 'Vérifier', 'Review');
  String get method => _t('الطريقة', 'Méthode', 'Method');
  String get enterValidAccount => _t(
    'أدخل رقم حساب صالح',
    'Entrez un numéro de compte valide',
    'Enter a valid account number',
  );
  String get noWithdrawalsYet => _t(
    'لا توجد عمليات سحب بعد',
    'Aucun retrait pour le moment',
    'No withdrawals yet',
  );
  String get cashOutWhenReady => _t(
    'اسحب نقاطك عندما تكون جاهزاً!',
    'Retirez vos points quand vous voulez !',
    'Cash out your points when you\'re ready!',
  );

  // ── History ───────────────────────────────────────────────────
  String get filterAll => _t('الكل', 'Tout', 'All');
  String get noBottlesYet => _t(
    'لم تُعد تدوير أي زجاجة بعد',
    'Aucune bouteille recyclée',
    'No bottles recycled yet',
  );
  String get scanFirstBottle => _t(
    'امسح أول زجاجة لبدء كسب النقاط!',
    'Scannez votre première bouteille !',
    'Scan your first one to start earning points!',
  );
  String get noActivityYet =>
      _t('لا يوجد نشاط بعد', 'Aucune activité', 'No activity yet');
  String get scanFirstToEarn => _t(
    'امسح أول زجاجة لبدء الكسب!',
    'Scannez pour commencer à gagner !',
    'Scan your first bottle to start earning!',
  );
  String get transactionNotFound => _t(
    'المعاملة غير موجودة',
    'Transaction introuvable',
    'Transaction not found',
  );
  String get reportIssueTitle =>
      _t('الإبلاغ عن مشكلة؟', 'Signaler un problème ?', 'Report issue?');
  String get reportIssueBody => _t(
    'السحب للحذف محلياً. أو أبلغ عن مشكلة.',
    'Glisser pour supprimer. Ou signaler.',
    'Swipe deletes locally. Or report an issue.',
  );
  String get type => _t('النوع', 'Type', 'Type');
  String get status => _t('الحالة', 'Statut', 'Status');
  String get bottles => _t('الزجاجات', 'Bouteilles', 'Bottles');
  String get date => _t('التاريخ', 'Date', 'Date');
  String get note => _t('ملاحظة', 'Note', 'Note');
  String get machine => _t('الآلة', 'Machine', 'Machine');

  // ── Map ───────────────────────────────────────────────────────
  String get machinesNearby =>
      _t('آلات قريبة', 'Machines à proximité', 'Nearby machines');
  String get listView => _t('قائمة', 'Liste', 'List');
  String get myLocation =>
      _t('موقعي', 'Ma position', 'My location');
  String get nearYou => _t('بالقرب منك', 'Près de vous', 'Near you');
  String get locating =>
      _t('جاري تحديد الموقع…', 'Localisation…', 'Finding your location…');
  String get locationDenied => _t(
        'تم رفض إذن الموقع — عرض الحرم الجامعي',
        'Localisation refusée — campus affiché',
        'Location denied — showing campus',
      );
  String get navigate => _t('توجيه', 'Itinéraire', 'Navigate');
  String get fillLevel =>
      _t('مستوى الامتلاء', 'Niveau de remplissage', 'Fill level');
  String fillLevelPercent(int n) => '$fillLevel: $n%';
  String acceptsMaterials(String types) =>
      _t('يقبل: $types', 'Accepte : $types', 'Accepts: $types');
  String openingMaps(String coords) => _t(
    'فتح الخرائط → $coords',
    'Ouverture maps → $coords',
    'Opening maps → $coords',
  );
  String get legendActive => _t('نشطة', 'Active', 'Active');
  String get legendNearFull => _t('شبه ممتلئة', 'Presque pleine', 'Near full');
  String get legendFull => _t('ممتلئة', 'Pleine', 'Full');
  String get legendMaintenance => _t('صيانة', 'Maintenance', 'Maint.');

  // ── Referral ──────────────────────────────────────────────────
  String get inviteFriends =>
      _t('ادعُ أصدقاءك', 'Invitez vos amis', 'Invite your friends');
  String get bothGetBonus => _t(
    'كلاكما يحصل على 50 نقطة',
    'Vous gagnez tous les deux 50 points',
    'You both get 50 points',
  );
  String get shareCode => _t('مشاركة الرمز', 'Partager le code', 'Share code');
  String get referralHistory =>
      _t('سجل الإحالات', 'Historique parrainage', 'Referral history');
  String get codeCopied => _t('تم نسخ الرمز', 'Code copié', 'Code copied');
  String shareReferralMessage(String code, int bonus, String link) => _t(
    'انضم إلى EcoStudent برمزي $code ونحصل كلانا على $bonus نقطة!\n$link',
    'Rejoignez EcoStudent avec $code, $bonus points chacun !\n$link',
    'Join EcoStudent with my code $code and we both get $bonus points!\n$link',
  );

  // ── Profile & settings ──────────────────────────────────────────
  String get editProfile =>
      _t('تعديل الملف', 'Modifier le profil', 'Edit profile');
  String get deleteAccount =>
      _t('حذف الحساب', 'Supprimer le compte', 'Delete account');
  String get language => _t('اللغة', 'Langue', 'Language');
  String get darkMode => _t('الوضع الداكن', 'Mode sombre', 'Dark mode');
  String get adminMode =>
      _t('وضع الشريك / المسؤول', 'Mode partenaire', 'Partner / Admin mode');
  String get adminModeSubtitle => _t(
    'تعديل الآلات على الخريطة',
    'Modifier les machines sur la carte',
    'Edit machines on the map',
  );
  String get deleteAccountBody => _t(
    'سيُحذف حساب EcoStudent نهائياً.',
    'Votre compte EcoStudent sera supprimé.',
    'This permanently removes your EcoStudent account.',
  );
  String get signInToEarn => _t(
    'سجّل الدخول لبدء كسب النقاط!',
    'Connectez-vous pour gagner des points !',
    'Sign in to start earning points!',
  );

  // ── Onboarding ────────────────────────────────────────────────
  String get next => _t('التالي', 'Suivant', 'Next');
  String get getStarted => _t('ابدأ الآن', 'Commencer', 'Get started');
  String get skip => _t('تخطي', 'Passer', 'Skip');
  String get onboarding1Title => splashHeadline;
  String get onboarding1Body => _t(
    'أدخل زجاجاتك البلاستيكية في آلات EcoStudent داخل الحرم الجامعي.',
    'Déposez vos bouteilles dans les machines EcoStudent du campus.',
    'Drop plastic bottles into EcoStudent machines on campus.',
  );
  String get onboarding2Title =>
      _t('اجمع النقاط', 'Collectez des points', 'Collect points');
  String get onboarding2Body => _t(
    'كل زجاجة تمنحك نقاطاً. 1 نقطة = 1 دينار جزائري.',
    'Chaque bouteille rapporte des points. 1 point = 1 DZD.',
    'Every bottle earns points. 1 point = 1 DZD.',
  );
  String get onboarding3Title =>
      _t('اسحب أموالك', 'Retirez votre argent', 'Cash out');
  String get onboarding3Body => _t(
    'حوّل نقاطك إلى نقود عبر BaridiMob أو CCP أو Flexy.',
    'Convertissez vos points via BaridiMob, CCP ou Flexy.',
    'Convert points to cash via BaridiMob, CCP, or Flexy.',
  );

  // ── States ────────────────────────────────────────────────────
  String get emptyState => _t(
    'لا توجد بيانات بعد',
    'Aucune donnée pour le moment',
    'Nothing here yet',
  );
  String get tryAgain => retry;
  String get loading => _t('جارٍ التحميل…', 'Chargement…', 'Loading…');
  String get errorOccurred =>
      _t('حدث خطأ', 'Une erreur est survenue', 'Something went wrong');
  String get otpHint => _t(
    'أدخل الرمز (جرّب 1234)',
    'Entrez le code (essayez 1234)',
    'Enter code (try 1234)',
  );

  // ── Errors (mock / API messages) ─────────────────────────────
  String get invalidCredentials => _t(
    'بيانات الدخول غير صحيحة',
    'Identifiants invalides',
    'Invalid credentials',
  );
  String get notLoggedIn =>
      _t('غير مسجل الدخول', 'Non connecté', 'Not logged in');
  String get insufficientPoints =>
      _t('نقاط غير كافية', 'Points insuffisants', 'Insufficient points');
  String minimumWithdrawal(int n) => _t(
    'الحد الأدنى للسحب $n دج',
    'Retrait minimum : $n DZD',
    'Minimum withdrawal is $n DZD',
  );
  String get notFound => _t('غير موجود', 'Introuvable', 'Not found');
  String get onlyPendingCancel => _t(
    'يمكن إلغاء الطلبات المعلقة فقط',
    'Seuls les retraits en attente peuvent être annulés',
    'Only pending withdrawals can be cancelled',
  );
  String get invitedPendingSignup => _t(
    'مدعو — في انتظار التسجيل',
    'Invité — inscription en attente',
    'Invited — pending signup',
  );

  String localizeError(String raw) {
    final msg = raw.replaceFirst('Exception: ', '');
    if (msg == 'Invalid credentials') return invalidCredentials;
    if (msg == 'Not logged in') return notLoggedIn;
    if (msg == 'Insufficient points') return insufficientPoints;
    if (msg.startsWith('Minimum withdrawal is ')) {
      final n = int.tryParse(msg.replaceAll(RegExp(r'[^0-9]'), ''));
      if (n != null) return minimumWithdrawal(n);
    }
    if (msg == 'Not found') return notFound;
    if (msg == 'Only pending withdrawals can be cancelled')
      return onlyPendingCancel;
    if (msg == invalidOtp) return invalidOtp;
    return msg;
  }

  // ── Notifications (seed + dynamic) ────────────────────────────
  String seedNotificationTitle(String id) => switch (id) {
    'n01' => depositSuccess,
    'n02' => _t(
      'جاري معالجة السحب',
      'Retrait en cours',
      'Withdrawal processing',
    ),
    'n03' => _t('مكافأة إحالة 🎉', 'Bonus parrainage 🎉', 'Referral bonus 🎉'),
    'n04' => _t(
      'نقاط مضاعفة نهاية الأسبوع',
      'Points doubles ce week-end',
      'Double points weekend',
    ),
    'n05' => _t(
      'آلة قريبة ممتلئة',
      'Machine proche pleine',
      'Machine nearby is full',
    ),
    _ => '',
  };

  String seedNotificationBody(String id) => switch (id) {
    'n01' => _t(
      'ربحت +40 نقطة في EcoBox Bibliothèque Centrale.',
      'Vous avez gagné +40 points à EcoBox Bibliothèque Centrale.',
      'You earned +40 points at EcoBox Bibliothèque Centrale.',
    ),
    'n02' => _t(
      'سحبك عبر BaridiMob بقيمة 200 دج قيد المعالجة.',
      'Votre retrait BaridiMob de 200 DZD est en cours.',
      'Your BaridiMob cash-out of 200 DZD is being processed.',
    ),
    'n03' => _t(
      'انضمت سارة برمزك. +50 نقطة مُضافة!',
      'Sara a rejoint avec votre code. +50 points crédités !',
      'Sara joined with your code. +50 points credited!',
    ),
    'n04' => _t(
      'أودع هذا الأسبوع واربح نقاطاً مضاعفة على كل زجاجة.',
      'Déposez ce week-end et gagnez 2× points par bouteille.',
      'Deposit this weekend and earn 2× points on every bottle.',
    ),
    'n05' => _t(
      'EcoBox Amphi A ممتلئة. جرّب Faculté Informatique.',
      'EcoBox Amphi A est pleine. Essayez Faculté Informatique.',
      'EcoBox Amphi A is full. Try Faculté Informatique instead.',
    ),
    _ => '',
  };

  String notificationDepositBody(int points, int bottles) => _t(
    'ربحت +$points نقطة ($bottles زجاجات).',
    'Vous avez gagné +$points points ($bottles bouteilles).',
    'You earned +$points points ($bottles bottles).',
  );

  String notificationWithdrawalBody(int points, String method) => _t(
    '$points دج عبر $method قيد الانتظار.',
    '$points DZD via $method en attente.',
    '$points DZD via $method is pending.',
  );

  ({String title, String body}) localizedNotification(
    String id,
    String title,
    String body,
  ) {
    final seedTitle = seedNotificationTitle(id);
    if (seedTitle.isNotEmpty) {
      return (title: seedTitle, body: seedNotificationBody(id));
    }
    if (title == 'Deposit successful!') {
      final match = RegExp(
        r'\+(\d+) points \((\d+) bottles\)',
      ).firstMatch(body);
      if (match != null) {
        return (
          title: depositSuccess,
          body: notificationDepositBody(
            int.parse(match.group(1)!),
            int.parse(match.group(2)!),
          ),
        );
      }
    }
    if (title == 'Withdrawal submitted') {
      final match = RegExp(r'(\d+) DZD via (BaridiMob|CCP|Flexy)').firstMatch(body);
      if (match != null) {
        final method = match.group(2)!;
        return (
          title: withdrawalSubmitted,
          body: notificationWithdrawalBody(int.parse(match.group(1)!), method),
        );
      }
    }
    return (title: title, body: body);
  }

  // ── Enum labels ───────────────────────────────────────────────
  String withdrawMethodLabel(WithdrawMethod method) => switch (method) {
    WithdrawMethod.baridiMob => baridiMob,
    WithdrawMethod.ccp => ccp,
    WithdrawMethod.flexy => flexy,
  };

  String transactionType(String type) => switch (type) {
    'deposit' => _t('إيداع', 'Dépôt', 'Deposit'),
    'withdrawal' => _t('سحب', 'Retrait', 'Withdrawal'),
    'referralBonus' => _t('مكافأة إحالة', 'Bonus parrainage', 'Referral bonus'),
    _ => type,
  };

  String transactionStatus(String status) => switch (status) {
    'pending' => _t('قيد الانتظار', 'En attente', 'Pending'),
    'completed' => _t('مكتمل', 'Terminé', 'Completed'),
    'failed' => _t('فشل', 'Échoué', 'Failed'),
    _ => status,
  };

  String withdrawalStatus(String status) => switch (status) {
    'pending' => _t('قيد الانتظار', 'En attente', 'Pending'),
    'processing' => _t('قيد المعالجة', 'En cours', 'Processing'),
    'completed' => _t('مكتمل', 'Terminé', 'Completed'),
    'rejected' => _t('مرفوض', 'Rejeté', 'Rejected'),
    _ => status,
  };

  String machineStatus(String status) => switch (status) {
    'active' => legendActive,
    'nearFull' => legendNearFull,
    'full' => legendFull,
    'maintenance' => _t('صيانة', 'Maintenance', 'Maintenance'),
    _ => status,
  };

  String referralStatus(String status) => switch (status) {
    'pending' => _t('قيد الانتظار', 'En attente', 'Pending'),
    'completed' => _t('مكتمل', 'Terminé', 'Completed'),
    _ => status,
  };

  String bottleType(String type) => switch (type.toUpperCase()) {
    'PET' => 'PET',
    'HDPE' => 'HDPE',
    _ => type.toUpperCase(),
  };

  // ── Weekday labels (chart) ────────────────────────────────────
  List<String> get weekdayShort => isAr
      ? ['ن', 'ث', 'ر', 'خ', 'ج', 'س', 'ح']
      : isFr
      ? ['L', 'M', 'M', 'J', 'V', 'S', 'D']
      : ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  String _t(String ar, String fr, String en) {
    if (isAr) return ar;
    if (isFr) return fr;
    return en;
  }
}
