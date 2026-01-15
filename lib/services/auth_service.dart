import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  /// REGISTER
  Future<AuthResponse> register({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }

  /// LOGIN
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  /// LOGOUT
  Future<void> logout() async {
    await _client.auth.signOut();
  }

  /// USER AKTIF
  User? get currentUser {
    return _client.auth.currentUser;
  }

  /// CEK SUDAH LOGIN ATAU BELUM
  bool get isLoggedIn {
    return currentUser != null;
  }
}
