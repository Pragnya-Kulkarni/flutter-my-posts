import 'package:flutter/material.dart';
import 'package:my_posts/presentation/pages/user_post_initial_page.dart';
import 'package:my_posts/injection_container.dart' as di;

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Posts',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UserPostInitialPage(),
    );
  }
}
