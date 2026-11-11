
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';
import 'screens/auth/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

  runApp(const SkillTrackApp());
}

class SkillTrackApp extends StatelessWidget {
  const SkillTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SkillTrack',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF7655D9),
        scaffoldBackgroundColor: const Color(0xFFF5F1FF),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF7655D9),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7655D9),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(14),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}
