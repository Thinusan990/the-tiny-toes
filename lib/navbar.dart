import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_tiny_toes/providers/auth_provider.dart';

class Navbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;

  Navbar({required this.title, this.showBackButton = false});

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);

    return AppBar(
      elevation: 0,
      centerTitle: false, // Center title is false to control layout
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Distribute space evenly
        children: [
          // Back button
          if (showBackButton) // Only show back button if it's true
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.pop(context); // Navigate to the previous page
              },
            ),
          // Title

          // Logout button
          SizedBox(
            height: 40,
            child: OutlinedButton(
              onPressed: () {
                authProvider.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: Text(
                'LOGOUT',
                style: TextStyle(
                  color: Colors.red, // Red text color for visibility
                  fontSize: 10,
                  fontWeight: FontWeight.bold, // Bold text
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red, width: 2.0),
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                backgroundColor: Colors.white,
                minimumSize: Size(80, 40), // Ensure button size fits text
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center, // Center the title
              style: TextStyle(fontSize: 20),
            ),
          ),
          // User name and avatar
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                Text(
                  authProvider.username ?? 'Guest',
                  style: TextStyle(color: Colors.black),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(
                      Icons.person_4_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(4.0),
        child: Container(
          color: Colors.grey,
          height: 2.0,
        ),
      ),
    );
  }
}
