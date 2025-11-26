import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  get currentUser => null;

  Future<User?> login(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response.user;
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  Future<User?> register(String email, String password, String name) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      
    );

    if (response.user != null) {
      await _client.from('profiles').insert({
        'id': response.user!.id,
        'email': email,
        'name': name,
        'role': 'kasir',
      });
    }
    return response.user;
  }

  Future<String?> getUserRole() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await _client
          .from('profiles')
          .select('role')
          .eq('id', user.id)
          .single();
      return data['role'] as String?;
    } catch (e) {
      return 'kasir';
    }
  }

  Future<String?> getUserName() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await _client
          .from('profiles')
          .select('name')
          .eq('id', user.id)
          .single();
      return data['name'] as String?;
    } catch (e) {
      return null;
    }
  }
}