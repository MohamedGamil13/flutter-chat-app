import 'package:chat_app/widgets/userprofile.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final List<Map<String, dynamic>> users;

  const CustomAppBar({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(color: Color(0xff4622fe)),
        height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Chats",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                "Favorite Contact",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              height: 100,
              padding: const EdgeInsets.only(left: 10),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return UserProfile(
                    imageUrl:
                        user['image'] ??
                        'https://cdn-icons-png.flaticon.com/512/9131/9131529.png',
                    name: user['name'] ?? 'No Name',
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
