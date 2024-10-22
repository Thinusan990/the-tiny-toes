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
  final NetworkService _networkService = NetworkService();
  List<dynamic> _photos = [];
  String _albumTitle = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlbumAndPhotos();
  }

  void _fetchAlbumAndPhotos() async {
    try {
      var albums = await _networkService.fetchAlbums(widget.albumId);
      var album = albums.firstWhere((album) => album['id'] == widget.albumId,
          orElse: () => null);

      if (album != null) {
        setState(() {
          _albumTitle = album['title'] ?? 'Unknown Album';
        });
      }

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
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(
                    child: Text(
                      _albumTitle,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    padding: EdgeInsets.all(10.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: 0.7,
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
                        child: Column(
                          children: [
                            Image.network(
                              _photos[index]['thumbnailUrl'],
                              fit: BoxFit.cover,
                              height: 120,
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              _photos[index]['title'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
