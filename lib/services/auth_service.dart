
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  // Register
  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    await supabase.auth.signUp(
      email: email,
      password: password,
      data: {'name': name},
    );
  }

  // Login
  Future<void> login(
    String email,
    String password,
  ) async {
    await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
