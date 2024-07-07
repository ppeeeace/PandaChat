import 'package:chat/constants.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    super.key,
    required this.receiverUsername,
    required this.receiverID,
  });
  final String receiverUsername;
  final String receiverID;
  final _controller = ScrollController();
  final ChatService _chatservice = ChatService();
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: Text(receiverUsername),
      ),
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          const SizedBox(height: 6),
          StreamBuilder<QuerySnapshot>(
              stream: _chatservice.getMessages(
                  userID: currentUser!.uid, otherUserID: receiverID),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Message> messagesList = [];
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                    messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
                  }
                  return Expanded(
                    child: ListView.builder(
                      reverse: false,
                      controller: _controller,
                      itemCount: messagesList.length,
                      itemBuilder: (context, index) {
                        final messageSenderUid = messagesList[index].senderUid;

                        if (currentUser != null &&
                            currentUser!.uid == messageSenderUid) {
                          return BubbleNormal(
                            text: messagesList[index].message!,
                            isSender: true,
                            tail: true,
                            color: kSecondaryColor,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          );
                        } else {
                          return BubbleNormal(
                            text: messagesList[index].message!,
                            isSender: false,
                            tail: true,
                            color: Colors.grey,
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return const Expanded(
                    child: Column(children: []),
                  );
                }
              }),
          MessageBar(
            onSend: (data) async {
              if (data.isNotEmpty) {
                await _chatservice.sendMessage(
                    receiverID: receiverID, message: data);
                _controller.animateTo(
                  0,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                );
              }
              ;
            },
            sendButtonColor: kSecondaryColor,
            messageBarColor: kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
