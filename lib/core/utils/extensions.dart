import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_providers.dart';
import '../../l10n/app_strings.dart';

extension StringsX on WidgetRef {
  AppStrings get s => AppStrings(watch(settingsProvider).locale.languageCode);
}

extension StringsContext on BuildContext {
  AppStrings strings(WidgetRef ref) =>
      AppStrings(ref.watch(settingsProvider).locale.languageCode);
}
