import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/widget/drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Home")),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const MyDrawer(),
    );
  }
}
