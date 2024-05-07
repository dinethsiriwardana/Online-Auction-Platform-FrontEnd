import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:html' show window;

import 'package:online_auction_platform/presentation/landing_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Online Auction Platform',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LandinPage(),
        );
      },
    );
  }
}
