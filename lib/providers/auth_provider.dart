import 'package:flutter/material.dart';
import 'package:kasir/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoggedIn = false;
  bool _isLoading = true;
  String? _role;
  String? _name;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get role => _role;
  String? get name => _name;

  AuthProvider() {
    checkAuthState();
  }

  Future<void> checkAuthState() async {
    _isLoading = true;
    notifyListeners();

    final user = _authService.currentUser;
    if (user != null) {
      _isLoggedIn = true;
      _role = await _authService.getUserRole();
      _name = await _authService.getUserName();
    } else {
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final user = await _authService.login(email, password);
    if (user != null) {
      _isLoggedIn = true;
      _role = await _authService.getUserRole();
      _name = await _authService.getUserName();
      notifyListeners();
    }
  }

  Future<void> register(String email, String password, String name) async {
    final user = await _authService.register(email, password, name);
    if (user != null) {
      _isLoggedIn = true;
      _role = 'kasir';
      _name = name;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    _role = null;
    _name = null;
    notifyListeners();
  }
}