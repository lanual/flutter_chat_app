import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat/widgets/chat/messages.dart';
import 'package:flutter_chat/widgets/chat/new_messages.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen({Key key}) : super(key: key);

  @override
  _ChatScreen createState() => _ChatScreen();
}

class _ChatScreen extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    try {
      /*Only for IOs */
      final fbm = FirebaseMessaging();
      fbm.requestNotificationPermissions();
      fbm.configure(onMessage: (msg) {
        print("********* onMessage");
        print(msg);
        return;
      }, onLaunch: (msg) {
        print("********* onLaunch");
        print(msg);
        return;
      }, onResume: (msg) {
        print("********* onResume");
        print(msg);
        return;
      });
      fbm.subscribeToTopic('chat');
    } catch (e) {
      print("*********** Exceprion");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButton(
            underline: Container(),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 6),
                      Text('Log Out'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (value) {
              if (value == 'logout') FirebaseAuth.instance.signOut();
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _firestore.collection('chat/').add({'text': 'This is a test'});
        },
        child: Icon(Icons.add),
      ), */
    );
  }
}
