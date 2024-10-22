import 'package:flutter/material.dart';
import 'package:the_tiny_toes/navbar.dart';
import 'package:the_tiny_toes/server/network_service.dart';

class GalleryScreen extends StatefulWidget {
  final int albumId;

  GalleryScreen({required this.albumId});

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  NetworkService _networkService = NetworkService();
  List<dynamic> _photos = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPhotos();
  }

  void _fetchPhotos() async {
    try {
      var photos = await _networkService.fetchPhotos(widget.albumId);
      setState(() {
        _photos = photos;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _loading = false;
      });
      _showErrorDialog(e.toString());
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(), child: Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(title: 'Gallery'),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Adjust the number of columns as necessary
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/viewPhoto',
                      arguments: _photos[index],
                    );
                  },
                  child: Image.network(
                    _photos[index]['thumbnailUrl'],
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
    );
  }
}
