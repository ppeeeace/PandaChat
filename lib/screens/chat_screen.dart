import 'package:chat/constants.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../models/message.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  static const String id = 'Chat Screen';
  final _controller = ScrollController();
  final CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('time', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final currentUser = FirebaseAuth.instance.currentUser;

          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
            appBar: AppBar(
              backgroundColor: kSecondaryColor,
              title: const Text('Ma Boys'),
            ),
            backgroundColor: kPrimaryColor,
            body: Column(
              children: [
                const SizedBox(height: 6),
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      final messageSenderUid = messagesList[index].senderUid;

                      if (currentUser != null &&
                          currentUser.uid == messageSenderUid) {
                        return BubbleNormal(
                          text: messagesList[index].text!,
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
                          text: messagesList[index].text!,
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
                ),
                MessageBar(
                  onSend: (data) {
                    messages.add({
                      'message': data,
                      'time': DateTime.now(),
                      'senderUid': currentUser?.uid,
                    });
                    _controller.animateTo(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn);
                  },
                  sendButtonColor: kSecondaryColor,
                  messageBarColor: kPrimaryColor,
                ),
              ],
            ),
          );
        } else {
          return const ModalProgressHUD(
            inAsyncCall: true,
            color: kPrimaryColor,
            progressIndicator: CircularProgressIndicator(
              color: kSecondaryColor,
            ),
            child: Scaffold(backgroundColor: kPrimaryColor),
          );
        }
      },
    );
  }
}
