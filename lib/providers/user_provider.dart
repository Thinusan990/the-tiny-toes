import 'package:flutter/material.dart';
import 'package:the_tiny_toes/server/network_service.dart';

class UserProvider with ChangeNotifier {
  final NetworkService _networkService = NetworkService();

  List<dynamic> users = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchUsers() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      users = await _networkService.fetchUsers();
    } catch (e) {
      error = 'Failed to fetch users';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
