import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/widget/drawer.dart';
import 'package:chat_app/widget/userTile.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  //Auth and chat services
  final AuthServices _authServices = AuthServices();
  final ChatService _chatService = ChatService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Home")),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      drawer: const MyDrawer(),
      body: _buildUserList(),
    );
  }

  //build user list without keeping the logged in user
  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.gerUserStream(),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Text("Error");
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading.....');
        }
        //else return the listview widget which contains chat widget
        return ListView(
          children: snapshot.data!
              .map<Widget>((userData) => _buildUserListItem(userData, context))
              .toList(),
        );
      },
    );
  }

  //Building the individual list title
  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    //display all user expect current user
    if (userData['email'] != _authServices.getCurrentUser()!.email) {
      return UserTile(
          text: userData['email'],
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          receiverEmail: userData['email'],
                          receiverID: userData['uid'],
                        )));
          });
    } else {
      return Container();
    }
  }
}
