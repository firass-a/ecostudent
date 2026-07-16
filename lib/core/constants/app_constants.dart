import 'package:flutter/material.dart';

/// EcoStudent design tokens v5 — white + single green accent (stylesheet only).

class AppColors {
  AppColors._();

  static const Color white = Color(0xFFFFFFFF);
  static const Color pageBg = white;
  static const Color cardSurface = Color(0xFFFAFAFA);
  static const Color cream = white;
  static const Color offWhite = white;
  static const Color lightSurface = cardSurface;
  static const Color sageLight = white;

  static const Color charcoal = Color(0xFF121212);
  static const Color graphite = Color(0xFF1E1E1E);
  static const Color slate = Color(0xFF2A2A2A);
  static const Color darkSurface = charcoal;
  static const Color darkCard = graphite;

  static const Color primaryGreen = Color(0xFF43A047);
  static const Color greenEmerald = primaryGreen;
  static const Color greenDeep = Color(0xFF2E7D32);
  static const Color midGreen = primaryGreen;
  static const Color deepGreen = textPrimary;
  static const Color paleGreen = Color(0xFFE7F5E9);
  static const Color mintTint = paleGreen;
  static const Color limeHighlight = paleGreen;

  // Legacy names → quiet green system (no gold/pastel)
  static const Color gold = primaryGreen;
  static const Color goldMid = primaryGreen;
  static const Color goldDark = greenDeep;
  static const Color butterYellow = paleGreen;
  static const Color skyBlue = primaryGreen;
  static const Color skyBlueTint = paleGreen;
  static const Color coral = Color(0xFFE57373);
  static const Color coralTint = Color(0xFFFFEBEE);

  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF8B8B8B);
  static const Color warmGray = textSecondary;
  static const Color warmGrayText = textSecondary;
  static const Color textOnDark = white;
  static const Color textMutedOnDark = Color(0xFFB0B0B0);

  static const Color cardBorder = Color(0xFFEEEEEE);
  static const Color cardBorderDark = Color(0xFF333333);
  static const Color dividerDark = Color(0xFF333333);

  static const Color success = primaryGreen;
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFE53935);
  static const Color info = primaryGreen;

  static const LinearGradient walletCardGradient = LinearGradient(
    colors: [primaryGreen, primaryGreen],
  );
  static const LinearGradient primaryCtaGradient = LinearGradient(
    colors: [primaryGreen, primaryGreen],
  );
  static const LinearGradient goldGradient = LinearGradient(
    colors: [primaryGreen, primaryGreen],
  );
  static const LinearGradient goldIconGradient = LinearGradient(
    colors: [primaryGreen, greenDeep],
  );
  static const LinearGradient heroGradient = walletCardGradient;
  static const LinearGradient primaryGradient = primaryCtaGradient;
  static const LinearGradient pageGradient = LinearGradient(
    colors: [white, white],
  );
  static const LinearGradient pageGradientDark = LinearGradient(
    colors: [charcoal, charcoal],
  );
  static const LinearGradient headerGradient = pageGradient;
  static const LinearGradient softGreenGradient = primaryCtaGradient;

  static Color scaffoldOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? charcoal : white;

  static Color cardOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? graphite : white;

  static Color surfaceOf(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? slate : cardSurface;
}

class AppElevation {
  AppElevation._();

  static List<BoxShadow> card(bool isDark) => [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
          blurRadius: 12,
          offset: const Offset(0, 3),
        ),
      ];

  static List<BoxShadow> soft = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 3),
    ),
  ];

  static List<BoxShadow> walletCard = [
    BoxShadow(
      color: AppColors.primaryGreen.withValues(alpha: 0.22),
      blurRadius: 14,
      offset: const Offset(0, 5),
    ),
  ];

  static List<BoxShadow> button(Color base, {bool pressed = false}) => [
        BoxShadow(
          color: base.withValues(alpha: pressed ? 0.1 : 0.2),
          blurRadius: pressed ? 4 : 10,
          offset: Offset(0, pressed ? 1 : 4),
        ),
      ];

  static List<BoxShadow> iconChip(Color accent) => soft;
}

class AppDecorations {
  AppDecorations._();

  static BoxDecoration elevatedSurface({
    required bool isDark,
    Color? color,
    double radius = AppConstants.cardRadius,
    bool elevated = true,
  }) {
    return BoxDecoration(
      color: color ?? (isDark ? AppColors.graphite : AppColors.white),
      borderRadius: BorderRadius.circular(radius),
      boxShadow: elevated ? AppElevation.card(isDark) : null,
    );
  }
}

class AppConstants {
  AppConstants._();

  static const double pointsToDzd = 1.0;
  static const int pointsPerSmallBottle = 5;
  static const int pointsPerLargeBottle = 10;
  static const double minWithdrawalDzd = 100;
  static const int referralBonusPoints = 50;

  static const double cardRadius = 16;
  static const double buttonRadius = 14;
  static const double chipRadius = 12;
  static const double spacing = 8;

  static const List<String> universities = [
    'Université d\'Alger 1',
    'Université d\'Alger 2',
    'USTHB',
    'École Nationale Polytechnique',
    'Université de Constantine 1',
    'Université d\'Oran 1',
    'Université de Blida 1',
    'ESI Alger',
  ];

  static const List<String> campuses = [
    'Campus Bab Ezzouar',
    'Campus Ben Aknoun',
    'Campus El Harrach',
    'Résidence Universitaire Kouba',
    'Campus Constantine Mentouri',
    'Campus Oran Es-Sénia',
  ];
}

class TintPair {
  const TintPair(this.solid, this.tint);
  final Color solid;
  final Color tint;

  static const green = TintPair(AppColors.primaryGreen, AppColors.paleGreen);
  static const gold = TintPair(AppColors.primaryGreen, AppColors.paleGreen);
  static const sky = TintPair(AppColors.primaryGreen, AppColors.paleGreen);
  static const coral = TintPair(AppColors.coral, AppColors.coralTint);
}
