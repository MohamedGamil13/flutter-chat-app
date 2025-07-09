import 'package:chat_app/pages/mini_chats_page.dart';
import 'package:chat_app/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
    final usersCollection = FirebaseFirestore.instance.collection('Users');

    return Scaffold(
      backgroundColor: const Color(0xff4622fe),
      body: StreamBuilder(
        stream: usersCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // استبعاد المستخدم الحالي
            final usersList = snapshot.data!.docs
                .where((doc) => doc['email'] != currentUserEmail)
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList();

            return Stack(
              children: [
                CustomAppBar(users: usersList),
                const Padding(
                  padding: EdgeInsets.only(top: 280),
                  child: Chats(),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error loading users"));
          } else {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
        },
      ),
    );
  }
}
