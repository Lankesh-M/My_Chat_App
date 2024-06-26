// import 'dart:html';
// import 'dart:js';

import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/widget/InputField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.receiverEmail, required this.receiverID});
  final String receiverEmail;
  final String receiverID;
  //text controller
  final TextEditingController _messageController = TextEditingController();

  //chat and outh services
  final ChatService _chatService = ChatService();
  final AuthServices _authServices = AuthServices();

  //send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
        //user input
      ),
    );
  }

  //build Message List
  Widget _buildMessageList() {
    String senderID = _authServices.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessage(senderID, receiverID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading... ");
          }

          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildMessageItem(doc))
                .toList(),
          );
        });
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print(data);

    //is current user
    bool isCurrentUser =
        data['senderID'] == _authServices.getCurrentUser()!.uid;
    // print(data['senderID']); //why this is null? lets find it out... The problem was {senderEmail: t57SUOmCcKdHgRiapvEnFa1Poob2, timestamp: Timestamp(seconds=1719383224, nanoseconds=507000000), message: hii, senderId:
// QWK7EdbXSfOcEK64khAywCJYGDt2, receiverID: t57SUOmCcKdHgRiapvEnFa1Poob2} senderId != senderID..... Its changed by changing the models/message.dart
    // print(_authServices.getCurrentUser()!.uid);
    //align right if the message is sent by current user
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Column(
      // crossAxisAlignment: Still its working so it doesn't need crossAxisAlignment
      //     isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(alignment: alignment, child: Text(data["message"])),
      ],
    );
  }

  //build user input
  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: FormContainerWidget(
              controller: _messageController,
              hintText: "Enga type pannavum..."),
        ),

        //To Send Message
        IconButton(onPressed: sendMessage, icon: const Icon(Icons.arrow_upward))
      ],
    );
  }
}
