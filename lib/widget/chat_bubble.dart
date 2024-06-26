import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: isCurrentUser ? Colors.green : Colors.blue,
          borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
      child: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
