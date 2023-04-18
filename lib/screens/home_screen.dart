import 'package:chat/components/custom_button.dart';
import 'package:chat/constants.dart';
import 'package:chat/models/user.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/welcome_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({
    super.key,
  });
  static const String id = 'Home Screen';
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: users.orderBy('time').get(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Userr> userList = [];
          for (var i = 0; i < snapshot.data!.docs.length; i++) {
            userList.add(Userr.fromJson(snapshot.data!.docs[i]));
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: kSecondaryColor,
              title: const Text(
                'PandaChat',
              ),
            ),
            backgroundColor: kPrimaryColor,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    text: 'Chat',
                    onTap: () {
                      Navigator.pushNamed(context, ChatScreen.id,
                          arguments: userList[userList.length - 1].email);
                    },
                  ),
                  const SizedBox(
                    height: 36,
                  ),
                  CustomButton(
                    text: 'Log out',
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        userList.removeAt(userList.length - 1);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WelcomeScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
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
