
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_tiny_toes/providers/auth_provider.dart';
import 'package:the_tiny_toes/screens/album_screen.dart';
import 'package:the_tiny_toes/screens/gallery_screen.dart';
import 'package:the_tiny_toes/screens/login_screen.dart';
import 'package:the_tiny_toes/screens/photo_view_screen.dart';
import 'package:the_tiny_toes/screens/users_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Tiny Toes',
      initialRoute: '/',
      routes: {
        '/': (ctx) => Consumer<AuthProvider>(
          builder: (context, authProvider, _) {
            return authProvider.isLoggedIn() ? UsersScreen() : LoginScreen();
          },
        ),
        '/login': (ctx) => LoginScreen(),
        '/users': (ctx) => UsersScreen(),
        '/albums': (ctx) {
          final userId = ModalRoute.of(ctx)!.settings.arguments as int;
          return AlbumScreen(userId: userId);
        },
        '/gallery': (ctx) {
          final albumId = ModalRoute.of(ctx)!.settings.arguments as int;
          return GalleryScreen(albumId: albumId);
        },
        '/viewPhoto': (ctx) {
          final photo = ModalRoute.of(ctx)!.settings.arguments as Map<String, dynamic>;
          return ViewPhotoScreen(photo: photo);
        },
      },
    );
  }
}
