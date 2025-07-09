import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  final String email;

  ChatPage({super.key, required this.email});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final CollectionReference message = FirebaseFirestore.instance.collection(
    'Messages',
  );

  final ScrollController _controller = ScrollController();
  final TextEditingController controller = TextEditingController();

  late Stream<QuerySnapshot> _messagesStream;

  @override
  void initState() {
    super.initState();
    _messagesStream = message
        .orderBy("CreatedAt", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _messagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messages = snapshot.data!.docs
              .map((doc) => Message.formjson(doc))
              .toList();

          return Scaffold(
            backgroundColor: const Color(0xFF007BFF),
            appBar: AppBar(
              backgroundColor: const Color(0xFF007BFF),
              centerTitle: true,
              title: const Text(
                "Chat",
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            body: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _controller,
                      reverse: true,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final isMe = messages[index].id == widget.email;
                        return isMe
                            ? MessageFriendWidget(text: messages[index])
                            : MessageWidget(text: messages[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    onSubmitted: (data) {
                      if (data.trim().isEmpty) return;
                      message.add({
                        "Message": data.trim(),
                        "CreatedAt": DateTime.now(),
                        "ID": widget.email,
                      });
                      controller.clear();
                      _controller.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    },
                    decoration: InputDecoration(
                      labelText: "Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      suffixIcon: const Icon(
                        Icons.send,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Scaffold(
            backgroundColor: Color(0xFF007BFF),
            body: Center(child: CircularProgressIndicator(color: Colors.white)),
          );
        }
      },
    );
  }
}
