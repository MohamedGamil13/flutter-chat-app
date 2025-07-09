import 'package:chat_app/helpers/showSnackBar.dart';
import 'package:chat_app/pages/change_password.dart';
import 'package:chat_app/pages/all_chats_page.dart';
import 'package:chat_app/pages/sign_up.dart';
import 'package:chat_app/widgets/button.dart';
import 'package:chat_app/widgets/custom_list_tile.dart';
import 'package:chat_app/widgets/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatelessWidget {
  String? email;
  String? password;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 100),
              Center(child: Text("Sign In", style: TextStyle(fontSize: 35))),
              SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomListTile(
                  icon: Icons.email,
                  title: "Email",
                  onChanged: (data) {
                    email = data;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomListTile(
                  icon: Icons.lock,
                  title: "Password",
                  onChanged: (data) {
                    password = data;
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePassword()),
                    );
                  },
                  child: Text(
                    "Forget password?",
                    style: TextStyle(color: Color(0xFF007BFF)),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Mybutton(
                text: "Sign In",
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    if ((email?.isNotEmpty ?? false) &&
                        (password?.isNotEmpty ?? false)) {
                      BuildContext dialogContext = context;
                      try {
                        showDialog(
                          context: dialogContext,
                          barrierDismissible: false,
                          builder: (_) =>
                              Center(child: CircularProgressIndicator()),
                        );

                        await signIn();

                        Navigator.of(dialogContext).pop();
                        await Future.delayed(Duration(milliseconds: 300));
                        ShowsSnackBar(dialogContext, "Signed in successfully");
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ChatsPage()),
                        );

                        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
                      } on FirebaseAuthException catch (e) {
                        Navigator.of(dialogContext).pop();
                        await Future.delayed(Duration(milliseconds: 300));

                        String message = "An error occurred";
                        if (e.code == 'user-not-found') {
                          message = 'No user found for that email.';
                        } else if (e.code == 'wrong-password') {
                          message = 'Wrong password provided.';
                        } else if (e.code == 'invalid-email') {
                          message = 'Invalid email address.';
                        }

                        ShowsSnackBar(dialogContext, message);
                      }
                    } else {
                      ShowsSnackBar(
                        context,
                        "Please enter both email and password",
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  Expanded(child: Divider(indent: 27, endIndent: 27)),
                  Text("OR"),
                  Expanded(child: Divider(indent: 27, endIndent: 27)),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomLogo(path: 'assets/facebook (1).png'),
                  CustomLogo(path: 'assets/search.png'),
                  CustomLogo(path: 'assets/twitter.png'),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't have an account?",
                    style: TextStyle(fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 18, color: Color(0xFF007BFF)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email ?? '',
      password: password ?? '',
    );
  }
}
