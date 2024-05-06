import 'dart:html';
import 'dart:html' show window;

import 'package:flutter/material.dart';
import 'package:online_auction_platform/presentation/auth/register_screen/register_screen.dart';

class LandinPage extends StatefulWidget {
  const LandinPage({super.key});

  @override
  State<LandinPage> createState() => _LandinPageState();
}

// window.localStorage["csrf"] = "jwt";
// print(window.localStorage["csrf"]);

class _LandinPageState extends State<LandinPage> {
  @override
  Widget build(BuildContext context) {
    if (window.localStorage["login"] == null) {
      //Load Login Screen
      return RegisterScreen();
    } else {
      //Load Home Screen
    }
    return const Placeholder();
  }
}
