import 'dart:html';
import 'dart:html' show window;

import 'package:flutter/material.dart';
import 'package:online_auction_platform/presentation/auth/login_screen/login_screen.dart';
import 'package:online_auction_platform/presentation/auth/register_screen/register_screen.dart';
import 'package:online_auction_platform/presentation/bid/add_bid_screen.dart';
import 'package:online_auction_platform/presentation/home/home_page.dart';

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
    if (window.localStorage["token"] != null) {
      //Load Login Screen
      return LoginScreen();
    } else {
      // return Scaffold(body: AddBidScreen());
      return HomePage();
    }
  }
}
