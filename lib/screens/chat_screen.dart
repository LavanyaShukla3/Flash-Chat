import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';


final firestore  = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'Chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {

  void initState() {
    super.initState();
  }

  final messageController = TextEditingController();
  final auth = FirebaseAuth.instance;
    String messagedText='';
    //User = FireBaeUser

  void getCurrentUser() async{
    await Firebase.initializeApp();
    final user = await auth.currentUser;
    try {
      if (user != null) {
        loggedInUser = user;
      }
    }
    catch(e){
      print(e);
    }
  }

  // void fetchMessages() async {
  // //   QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore.collection('messages').get();
  // //
  // // //   for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in querySnapshot.docs) {
  // // //     Map<String, dynamic> data = documentSnapshot.data();
  // // //     String text = data['text'];
  // // //     String sender = data['sender'];
  // // //
  // // //     print('Text: $text, Sender: $sender');
  // // //   }
  // // // }
  void messagesStream() async{
    await for (var snapshot in firestore.collection('messages').snapshots() ){
      for (var messages in snapshot.docs){
        print(messages.data);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller:messageController,
                      onChanged: (value) {
                        messageController.clear();
                        messagedText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //messagedtext+ loggedinUser.email
                      if (loggedInUser != null) {
                        firestore.collection('messages').add({
                          'text': messagedText,
                          'sender': loggedInUser!.email, // Using '!' to assert that loggedInUser is not null
                        });
                      }

                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
  //reversed coz new messages when added will be displayed on bottom of the lsit
        final messages = snapshot.data!.docs.reversed;
        List<Widget> messageWidgets = [];

        for (var message in messages) {
          final messageData = message.data() as Map<String, dynamic>;
          final messageText = messageData['text'] as String;
          final messagesender = messageData['sender'] as String;

          final currentUser = loggedInUser!.email;
          final messageWidget = messageBubble(
              text: messageText,
              Sender: messagesender,
            isMe: currentUser == messagesender,
          );
          messageWidgets.add(messageWidget);
        }

        if (messageWidgets.isEmpty) {
          return Text("No messages to display");
        }

        return Expanded(
          child: ListView(
            reverse:true,
            children: messageWidgets,
          ),
        );
      },
    );
  }
}


class messageBubble extends StatelessWidget {

  messageBubble({required this.text,required this.Sender,this.isMe});
  final String text;
  final String Sender;
  final bool? isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child:Column(
        crossAxisAlignment: isMe! ? CrossAxisAlignment.end: CrossAxisAlignment.start,
      children:<Widget>[
        Text(
          Sender,
        style: TextStyle(
          fontSize: 10.0,
          color: Colors.grey,
        ),
          ),

      Material(
        elevation: 5.0,
        borderRadius: isMe! ?BorderRadius.only(topLeft:Radius.circular(20.0), bottomRight: Radius.circular(30.0),bottomLeft: Radius.circular(20.0) ):BorderRadius.only(topRight:Radius.circular(20.0), bottomRight: Radius.circular(30.0),topLeft: Radius.circular(20.0) ) ,
        color: isMe!? Colors.lightBlueAccent:Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 7.0),

          child: Text(
              text,
                  style: TextStyle(
              fontSize: 10,
                    color: isMe!?Colors.white : Colors.black ,
          ),
          ),
        ),
      ),
      ]
      )
    );

    ;
  }
}
