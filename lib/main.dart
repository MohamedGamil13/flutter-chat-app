import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/change_password.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/all_chats_page.dart';
import 'package:chat_app/pages/mini_chats_page.dart';
import 'package:chat_app/pages/sign_in.dart';
import 'package:chat_app/theme/themes.dart';
import 'package:chat_app/widgets/custom_logo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MaterialApp(theme: AppTheme.lightTheme, home: SignIn()));
}
