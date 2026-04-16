import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ps_salon/app_state.dart';
import 'package:ps_salon/screens/booking_screen.dart';
import 'package:ps_salon/screens/contact_screen.dart';
import 'package:ps_salon/screens/gallery_screen.dart';
import 'package:ps_salon/screens/home_screen.dart';
import 'package:ps_salon/screens/services_screen.dart';
import 'package:ps_salon/theme.dart';

Future<void> loadAppFonts() async {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await loadAppFonts();
  });

  Future<void> pumpScreen(
    WidgetTester tester,
    Widget child, {
    Size size = const Size(390, 844),
  }) async {
    await tester.binding.setSurfaceSize(size);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    await tester.pumpWidget(
      AppStateScope(
        notifier: seedAppState(),
        child: MaterialApp(
          theme: AppTheme.dark(),
          home: Scaffold(body: child),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('Home screen golden', (tester) async {
    await pumpScreen(
      tester,
      const HomeScreen(
        onBookTap: _noop,
        onServicesTap: _noop,
      ),
    );

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/home.png'),
    );
  });

  testWidgets('Services screen golden', (tester) async {
    await pumpScreen(tester, const ServicesScreen());
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/services.png'),
    );
  });

  testWidgets('Booking screen golden', (tester) async {
    await pumpScreen(tester, const BookingScreen());
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/booking.png'),
    );
  });

  testWidgets('Gallery screen golden', (tester) async {
    await pumpScreen(tester, const GalleryScreen());
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/gallery.png'),
    );
  });

  testWidgets('Contact screen golden', (tester) async {
    await pumpScreen(tester, const ContactScreen());
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/contact.png'),
    );
  });
}

void _noop() {}
