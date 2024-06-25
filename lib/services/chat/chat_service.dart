import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //get instancd of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //get user stream
  Stream<List<Map<String, dynamic>>> gerUserStream() {
    //email id and password
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  //send msg
  Future<void> sendMessage(String receiverID, message) async {
    //get cur user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentEmailID = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create an new message
    Message newMessage = Message(
        senderID: currentEmailID,
        senderEmail: currentEmailID,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    //construct chat room id for the two user(Sorted )
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatroomID = ids.join('<--->');

    //add new message to data base
    await _firestore
        .collection('Chat_Rooms')
        .doc(chatroomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //get msg
  Stream<QuerySnapshot> getMessage(String UserID, otherUserID) {
    List<String> ids = [UserID, otherUserID];
    ids.sort();
    String chatroomID = ids.join('<--->');

    return _firestore
        .collection('Chat_Rooms')
        .doc(chatroomID)
        .collection('messages')
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
