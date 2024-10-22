import 'package:flutter/material.dart';
import 'package:the_tiny_toes/navbar.dart';
import 'package:the_tiny_toes/server/network_service.dart';

class ViewPhotoScreen extends StatefulWidget {
  final Map<String, dynamic> photo;

  ViewPhotoScreen({required this.photo});

  @override
  _ViewPhotoScreenState createState() => _ViewPhotoScreenState();
}

class _ViewPhotoScreenState extends State<ViewPhotoScreen> {
  final NetworkService _networkService = NetworkService();
  String _albumTitle = '';
  String _artistName = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlbumAndArtist();
  }

  void _fetchAlbumAndArtist() async {
    try {
      // Fetch the album data
      var albums = await _networkService.fetchAlbums(widget.photo['albumId']);
      var album = albums.firstWhere(
          (album) => album['id'] == widget.photo['albumId'],
          orElse: () => null);

      if (album != null) {
        setState(() {
          _albumTitle = album['title'] ?? 'Unknown Album';
        });

        // Fetch the artist (user) data based on the album's userId
        var users = await _networkService.fetchUsers();
        var artist = users.firstWhere((user) => user['id'] == album['userId'],
            orElse: () => null);

        if (artist != null) {
          setState(() {
            _artistName = artist['name'] ?? 'Unknown Artist';
          });
        }
      }

      setState(() {
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
          : Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      widget.photo['title'],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Image.network(widget.photo['url']),
                  SizedBox(height: 8.0),
                  Text(
                    'Artist: $_artistName',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Album: $_albumTitle',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
    );
  }
}
