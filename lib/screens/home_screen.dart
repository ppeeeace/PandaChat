import 'package:chat/constants.dart';
import 'package:chat/screens/chat_screen.dart';
import 'package:chat/screens/welcome_screen.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/widgets/user_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  static const String id = 'Home Screen';
  final ChatService _chatservice = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: const Text('PandaChat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              if (context.mounted) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
      backgroundColor: kPrimaryColor,
      body: StreamBuilder(
        stream: _chatservice.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Column(
              children: [],
            );
          }
          return ListView(
            children: snapshot.data!.map((userData) {
              if (userData['email'] != _auth.currentUser!.email) {
                return UserTile(
                  username: userData['username'],
                  email: userData['email'],
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          receiverUsername: userData['username'],
                          receiverID: userData['uid'],
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            }).toList(),
          );
        },
      ),
    );
  }
}
