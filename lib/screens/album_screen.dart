import 'package:flutter/material.dart';
import 'package:the_tiny_toes/server/network_service.dart';

class AlbumScreen extends StatefulWidget {
  final int userId;

  AlbumScreen({required this.userId});

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  NetworkService _networkService = NetworkService();
  List<dynamic> _albums = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchAlbums();
  }

  void _fetchAlbums() async {
    try {
      var albums = await _networkService.fetchAlbums(widget.userId);
      setState(() {
        _albums = albums;
        _loading = false;
      });
    } catch (e) {
      // Handle error state
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
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Albums'),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _albums.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_albums[index]['title']),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/gallery',
                arguments: _albums[index]['id'],
              );
            },
          );
        },
      ),
    );
  }
}
