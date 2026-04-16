import 'package:flutter_test/flutter_test.dart';
import 'package:ps_salon/app_state.dart';
import 'package:ps_salon/main.dart';

void main() {
  testWidgets('App boots', (WidgetTester tester) async {
    await tester.pumpWidget(
      AppStateScope(
        notifier: seedAppState(),
        child: const PSSalonApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1900));
    await tester.pumpAndSettle();
    expect(find.text('PSSalon'), findsWidgets);
  });
}
