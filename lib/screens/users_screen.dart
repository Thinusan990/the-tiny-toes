import 'package:flutter/material.dart';
import 'package:the_tiny_toes/navbar.dart';
import 'package:the_tiny_toes/server/network_service.dart';

class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  NetworkService _networkService = NetworkService();
  List<dynamic> _users = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    try {
      var users = await _networkService.fetchUsers();
      setState(() {
        _users = users;
        _loading = false;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(title: 'Users', showBackButton: false),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(_users[index]['name']),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/albums',
                              arguments: _users[index]['id'],
                            );
                          },
                        ),
                        if (index != _users.length - 1)
                          Divider(
                            color: Colors.grey,
                            thickness: 1,
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
    );
  }
}
