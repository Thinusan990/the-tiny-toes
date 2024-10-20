import 'package:flutter/material.dart';
import 'package:the_tiny_toes/server/network_service.dart';

class AlbumProvider with ChangeNotifier {
  List<dynamic> _albums = [];
  bool _isLoading = false;

  List<dynamic> get albums => _albums;
  bool get isLoading => _isLoading;

  final NetworkService _networkService = NetworkService();

  Future<void> fetchAlbums(int userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _albums = await _networkService.fetchAlbums(userId);
    } catch (e) {
      throw Exception('Error fetching albums');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
