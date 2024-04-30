import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  //get instancd of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //get user stream
  Stream<List<Map<String, dynamic>>> gerUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList(); 
    });
  }
  //send msg

  //get msg
}
