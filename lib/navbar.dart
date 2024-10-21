import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_tiny_toes/providers/auth_provider.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  Navbar({required this.title});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return AppBar(
      leading: Padding(
        padding: const EdgeInsets.all(1.0),
        child: SizedBox(
          height: 30,
          child: ElevatedButton(
            onPressed: () {
              authProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text('Logout', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
          ),
        ),
      ),
      centerTitle: true,
      title: Text(title, style: TextStyle(fontSize: 20)),
      actions: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                authProvider.username ?? 'Guest',
                style: TextStyle(color: Colors.white),
              ),
            ),
            // Circular avatar
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                backgroundColor: Colors.grey.shade800,
                child: Text(
                  (authProvider.username != null &&
                          authProvider.username!.isNotEmpty)
                      ? authProvider.username![0].toUpperCase()
                      : 'G',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
