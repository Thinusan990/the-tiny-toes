import 'package:flutter/material.dart';
import 'package:the_tiny_toes/navbar.dart';

class ViewPhotoScreen extends StatelessWidget {
  final Map<String, dynamic> photo;

  ViewPhotoScreen({required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Navbar(title: 'Gallery'),
      body: Center(
        child: Column(
          children: [
            Image.network(photo['url']),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                photo['title'],
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
