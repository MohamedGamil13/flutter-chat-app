import 'package:chat_app/widgets/button.dart';
import 'package:chat_app/widgets/custom_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  String? newPassword;
  String? confirmPassword;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 100),
              Center(
                child: Text("Reset Password", style: TextStyle(fontSize: 35)),
              ),
              SizedBox(height: 100),
              CustomListTile(
                icon: Icons.lock,
                title: "Enter New Password",
                onChanged: (data) {
                  newPassword = data;
                },
              ),
              SizedBox(height: 20),
              CustomListTile(
                icon: Icons.lock,
                title: "Confirm New Password",
                onChanged: (data) {
                  confirmPassword = data;
                },
              ),
              SizedBox(height: 30),
              Mybutton(
                text: "Submit",
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    if (newPassword != confirmPassword) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Passwords do not match")),
                      );
                      return;
                    }
                    try {
                      User? user = FirebaseAuth.instance.currentUser;
                      await user?.updatePassword(newPassword!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Password updated successfully"),
                        ),
                      );
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${e.toString()}")),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
