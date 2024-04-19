import 'package:chat_app/auth/auth_services.dart';
import 'package:chat_app/auth/login_or_register.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  void _logout() {
    final _auth = AuthServices();
    _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ChatApp"),
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
      ),
    );
  }
}
