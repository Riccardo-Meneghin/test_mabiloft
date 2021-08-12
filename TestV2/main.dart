import 'package:flutter/material.dart';
import 'package:test_mabiloft/profile_home.dart';

void main() {
  runApp(ProfileOverview());
}

class ProfileOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Winston'),
      home: ProfileHome(),
    );
  }
}
