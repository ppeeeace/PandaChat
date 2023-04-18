import 'package:chat/constants.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
    var email = ModalRoute.of(context)!.settings.arguments;

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('time', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                      return messagesList[index].id == email
                          ? BubbleNormal(
                              text: messagesList[index].text!,
                              isSender: true,
                              tail: true,
                              color: kSecondaryColor,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            )
                          : BubbleNormal(
                              text: messagesList[index].text!,
                              isSender: false,
                              tail: true,
                              color: Colors.grey,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            );
                    },
                  ),
                ),
                MessageBar(
                  onSend: (data) {
                    messages.add({
                      'message': data,
                      'id': email,
                      'time': DateTime.now(),
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
            child: Scaffold(backgroundColor: kPrimaryColor),
          );
        }
      },
    );
  }
}
