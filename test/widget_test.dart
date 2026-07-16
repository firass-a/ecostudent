import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:eco_student/main.dart';

void main() {
  testWidgets('EcoStudent app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: EcoStudentApp()));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.text('EcoStudent'), findsWidgets);
  });
}
