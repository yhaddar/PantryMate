import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  const AuthRepository(this._client);

  final SupabaseClient _client;

  Future<AuthResponse> register({
    required String email,
    required String password,
  }) {
    return _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) {
    return _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> sendPasswordReset(String email, {required String redirectTo}) {
    return _client.auth.resetPasswordForEmail(email, redirectTo: redirectTo);
  }

  Future<void> signOut() => _client.auth.signOut();
}
