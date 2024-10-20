import 'package:flutter/material.dart';
import 'package:the_tiny_toes/server/network_service.dart';

class PhotoProvider with ChangeNotifier {
  List<dynamic> _photos = [];
  bool _isLoading = false;

  List<dynamic> get photos => _photos;
  bool get isLoading => _isLoading;

  final NetworkService _networkService = NetworkService();

  Future<void> fetchPhotos(int albumId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _photos = await _networkService.fetchPhotos(albumId);
    } catch (e) {
      throw Exception('Error fetching photos');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
