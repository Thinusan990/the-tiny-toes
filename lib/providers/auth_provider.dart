import 'package:flutter/material.dart';
import 'package:the_tiny_toes/server/storage_service.dart';

class AuthProvider with ChangeNotifier {
  final _storageService = StorageService();
  String? _username;

  String? get username => _username;

  bool isLoggedIn() => _username != null;

  Future<void> login(String username, String password) async {
    if (username == 'Thinusan' && password == 'password990') {
      _username = username;
      await _storageService.saveUsername(username);
      notifyListeners();
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> checkLogin() async {
    _username = await _storageService.getUsername();
    notifyListeners();
  }

  Future<void> logout() async {
    _username = null;
    await _storageService.clearUsername();
    notifyListeners();
  }
}
