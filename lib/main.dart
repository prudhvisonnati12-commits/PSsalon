import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_state.dart';
import 'firebase_options.dart';
import 'theme.dart';
import 'screens/home_screen.dart';
import 'screens/services_screen.dart';
import 'screens/booking_screen.dart';
import 'screens/gallery_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/splash_screen.dart';

const int kInitialTab = int.fromEnvironment('START_TAB', defaultValue: 0);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    AppStateScope(
      notifier: seedAppState(),
      child: const PSSalonApp(),
    ),
  );
}

class PSSalonApp extends StatelessWidget {
  const PSSalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PSSalon',
      theme: AppTheme.dark(),
      home: const SplashScreen(),
      routes: {
        '/home': (_) => const RootScaffold(initialIndex: kInitialTab),
      },
    );
  }
}

class RootScaffold extends StatefulWidget {
  final int initialIndex;

  const RootScaffold({super.key, this.initialIndex = 0});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, 4);
  }

  void _setIndex(int value) {
    setState(() => _index = value);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onBookTap: () => _setIndex(2),
        onServicesTap: () => _setIndex(1),
      ),
      const ServicesScreen(),
      const BookingScreen(),
      const GalleryScreen(),
      const ContactScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _setIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.content_cut), label: 'Services'),
          NavigationDestination(icon: Icon(Icons.event_available), label: 'Book'),
          NavigationDestination(icon: Icon(Icons.photo_library_outlined), label: 'Gallery'),
          NavigationDestination(icon: Icon(Icons.location_on_outlined), label: 'Contact'),
        ],
      ),
    );
  }
}
