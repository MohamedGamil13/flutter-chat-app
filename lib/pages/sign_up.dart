import 'dart:io';
import 'package:chat_app/helpers/showSnackBar.dart';
import 'package:chat_app/widgets/button.dart';
import 'package:chat_app/widgets/custom_list_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String? name;
  String? email;
  String? password;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Center(
                child: Text("Sign Up", style: TextStyle(fontSize: 35)),
              ),
              const SizedBox(height: 30),
              const SizedBox(height: 30),

              CustomListTile(
                icon: Icons.person,
                title: "Full Name",
                onChanged: (data) {
                  name = data;
                },
              ),
              const SizedBox(height: 16),

              CustomListTile(
                icon: Icons.email,
                title: "Email Id",
                onChanged: (data) {
                  email = data;
                },
              ),
              const SizedBox(height: 16),

              CustomListTile(
                icon: Icons.lock,
                title: "Password",
                onChanged: (data) {
                  password = data;
                },
              ),
              const SizedBox(height: 50),

              Mybutton(
                text: "Sign Up",
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if ((email?.isNotEmpty ?? false) &&
                        (password?.isNotEmpty ?? false) &&
                        (name?.isNotEmpty ?? false)) {
                      try {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) =>
                              const Center(child: CircularProgressIndicator()),
                        );

                        await signUp();

                        Navigator.of(context).pop();
                        ShowsSnackBar(context, "User created successfully");
                      } on FirebaseAuthException catch (e) {
                        Navigator.of(context).pop();

                        String message = "An error occurred";
                        if (e.code == 'email-already-in-use') {
                          message = 'This email is already in use.';
                        } else if (e.code == 'weak-password') {
                          message = 'The password is too weak.';
                        } else if (e.code == 'invalid-email') {
                          message = 'Invalid email address.';
                        }

                        ShowsSnackBar(context, message);
                      }
                    } else {
                      ShowsSnackBar(context, "Please fill all fields");
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

  Future<void> signUp() async {
    final credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(credential.user!.uid)
        .set({"name": name, "email": email});
  }
}
