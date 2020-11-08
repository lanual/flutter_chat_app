import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_chat/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messages extends StatelessWidget {
  const Messages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userId = FirebaseAuth.instance.currentUser.uid;

    return Container(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          final chatDocs = snapshot.data.docs;

          return ListView.builder(
            reverse: true,
            itemCount: chatDocs.length,
            itemBuilder: (context, index) {
              return MessageBubble(
                message: chatDocs[index]['text'],
                isMe: chatDocs[index]['userId'] == _userId,
                key: ValueKey(chatDocs[index].id),
                userName: chatDocs[index]['userName'],
                imageUrl: chatDocs[index]['user_image'],
              );
            },
          );
        },
      ),
    );
  }
}
