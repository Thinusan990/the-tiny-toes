import 'package:flutter/material.dart';
import 'package:the_tiny_toes/navbar.dart';
import 'package:the_tiny_toes/server/network_service.dart';

class AlbumScreen extends StatefulWidget {
  final int userId;

  AlbumScreen({required this.userId});

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  final NetworkService _networkService = NetworkService();
  List<dynamic> _albums = [];
  String _userName = '';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserAndAlbums();
  }

  void _fetchUserAndAlbums() async {
    try {
      var users = await _networkService.fetchUsers();
      var user = users.firstWhere((user) => user['id'] == widget.userId,
          orElse: () => null);

      if (user != null) {
        setState(() {
          _userName = user['name'] ?? 'Unknown User';
        });
      }

      var albums = await _networkService.fetchAlbums(widget.userId);
      setState(() {
        _albums = albums;
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
      appBar: Navbar(title: 'Albums'),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    ' $_userName',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _albums.length,
                    itemBuilder: (context, index) {
                      var albumTitle = _albums[index]['title'];
                      var firstLetter = albumTitle.isNotEmpty
                          ? albumTitle[0].toUpperCase()
                          : '';
                      var albumId = _albums[index]['id'];

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/gallery',
                            arguments: albumId,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 40,
                                child: Container(
                                  height: 48,
                                  width: MediaQuery.of(context).size.width - 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(24),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 40),
                                  child: Text(
                                    albumTitle,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                backgroundColor: Colors.grey,
                                radius: 24.0,
                                child: Text(
                                  firstLetter,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
