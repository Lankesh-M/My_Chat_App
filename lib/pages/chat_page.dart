// // import 'dart:html';
// // import 'dart:js';

// import 'package:chat_app/services/auth/auth_services.dart';
// import 'package:chat_app/services/chat/chat_service.dart';
// import 'package:chat_app/widget/InputField.dart';
// import 'package:chat_app/widget/chat_bubble.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

// class ChatPage extends StatefulWidget {
//   const ChatPage(
//       {super.key, required this.receiverEmail, required this.receiverID});

//   final String receiverEmail;
//   final String receiverID;

//   @override
//   State<ChatPage> createState() => _ChatPageState();
// }

// class _ChatPageState extends State<ChatPage> {
//   //text controller
//   final TextEditingController _messageController = TextEditingController();

//   //chat and outh services
//   final ChatService _chatService = ChatService();

//   final AuthServices _authServices = AuthServices();

//   //To fix scroll - TextField Focus
//   FocusNode myFocusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();

//     //add listener to focusnode
//     myFocusNode.addListener(() {
//       if (myFocusNode.hasFocus) {
//         //cause delay so that keyborad has time to show up
//         //then automatically the remainning space will be calculated,
//         //then scroll down
//         Future.delayed(
//           const Duration(milliseconds: 500),
//           () => scrollDown(),
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     myFocusNode.dispose();
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   //scroll Controller
//   final ScrollController _scrollController = ScrollController();

//   // void scrollDown() {
//   //   _scrollController.animateTo(_scrollController.position.maxScrollExtent,
//   //       duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);
//   // }
//   void scrollDown() {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(seconds: 1),
//           curve: Curves.fastOutSlowIn,
//         );
//       }
//     });
//   }

//   //send message
//   void sendMessage() async {
//     if (_messageController.text.isNotEmpty) {
//       await _chatService.sendMessage(
//           widget.receiverID, _messageController.text);
//       _messageController.clear();
//       scrollDown(); //from chatgpt
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.receiverEmail),
//       ),
//       body: Column(
//         children: [
//           Expanded(child: _buildMessageList()),
//           _buildUserInput(),
//         ],
//         //user input
//       ),
//     );
//   }

//   //build Message List
//   Widget _buildMessageList() {
//     String senderID = _authServices.getCurrentUser()!.uid;
//     return StreamBuilder(
//         stream: _chatService.getMessage(senderID, widget.receiverID),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Text("Error");
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: Text("Loading... "));
//           }

//           return ListView(
//             controller: _scrollController,
//             children: snapshot.data!.docs
//                 .map((doc) => _buildMessageItem(doc))
//                 .toList(),
//           );
//         });
//   }

//   //build message item
//   Widget _buildMessageItem(DocumentSnapshot doc) {
//     Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//     // print(data);

//     //is current user
//     bool isCurrentUser =
//         data['senderID'] == _authServices.getCurrentUser()!.uid;
//     // print(data['senderID']); //why this is null? lets find it out... The problem was {senderEmail: t57SUOmCcKdHgRiapvEnFa1Poob2, timestamp: Timestamp(seconds=1719383224, nanoseconds=507000000), message: hii, senderId:
// // QWK7EdbXSfOcEK64khAywCJYGDt2, receiverID: t57SUOmCcKdHgRiapvEnFa1Poob2} senderId != senderID..... Its changed by changing the models/message.dart
//     // print(_authServices.getCurrentUser()!.uid);
//     //align right if the message is sent by current user
//     var alignment =
//         isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

//     return Column(
//       // crossAxisAlignment: Still its working so it doesn't need crossAxisAlignment
//       //     isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//       children: [
//         Container(
//             padding: EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
//             alignment: alignment,
//             child: ChatBubble(
//                 message: data['message'], isCurrentUser: isCurrentUser)),
//       ],
//     );
//   }

//   //build user input
//   Widget _buildUserInput() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 10),
//       child: Row(
//         children: [
//           Expanded(
//             child: FormContainerWidget(
//                 focusNode: myFocusNode,
//                 controller: _messageController,
//                 hintText: "Enga type pannavum..."),
//           ),

//           //To Send Message
//           Container(
//             decoration: BoxDecoration(
//                 color: Colors.blue, borderRadius: BorderRadius.circular(15)),
//             margin: EdgeInsets.only(left: 10),
//             child: IconButton(
//                 onPressed: sendMessage,
//                 icon: const Icon(
//                   Icons.send_rounded,
//                   color: Colors.white,
//                 )),
//           )
//         ],
//       ),
//     );
//   }
// }
import 'package:chat_app/services/auth/auth_services.dart';
import 'package:chat_app/services/chat/chat_service.dart';
import 'package:chat_app/widget/InputField.dart';
import 'package:chat_app/widget/chat_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});

  final String receiverEmail;
  final String receiverID;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthServices _authServices = AuthServices();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
        );
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
      scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authServices.getCurrentUser()!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getMessage(senderID, widget.receiverID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading..."));
        }
        if (!snapshot.hasData) {
          return const Text("No messages");
        }

        WidgetsBinding.instance.addPostFrameCallback((_) => scrollDown());

        return ListView(
          controller: _scrollController,
          children:
              snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    bool isCurrentUser =
        data['senderID'] == _authServices.getCurrentUser()!.uid;
    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      padding: const EdgeInsets.all(5),
      alignment: alignment,
      child: ChatBubble(message: data['message'], isCurrentUser: isCurrentUser),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 10),
      child: Row(
        children: [
          Expanded(
            child: FormContainerWidget(
              focusNode: _focusNode,
              controller: _messageController,
              hintText: "Enga type pannavum...",
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(15)),
            margin: const EdgeInsets.only(left: 10),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
