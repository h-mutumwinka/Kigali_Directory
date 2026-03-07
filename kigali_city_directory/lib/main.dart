import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart' as auth;
import 'providers/place_provider.dart';
import 'providers/booking_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/auth_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Skip Firebase initialization for web demo
  // Uncomment below for production with real Firebase
  /*
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint('✅ Firebase initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization failed: $e');
    debugPrint('App will work in offline mode');
  }
  */

  runApp(const KigaliDirectoryApp());
}

// Custom dark blue color
const Color darkBlue = Color(0xFF0D1B2A); // Very dark blue
const Color mediumDarkBlue = Color(0xFF1B263B); // Medium dark blue

class KigaliDirectoryApp extends StatelessWidget {
  const KigaliDirectoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => auth.AuthProvider()),
        ChangeNotifierProvider(create: (_) => PlaceProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Kigali Directory",
            theme: themeProvider.currentTheme,
            home: const AuthWrapper(), // Shows login screen first
          );
        },
      ),
    );
  }
}