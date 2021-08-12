import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:test_mabiloft/utils.dart';

class ProfileHome extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: buildAppBar(context),
      body: ListView(
        children: [
          PhotoEdit(),
          buildText(),
          buildPadding("FAVORITE MOVIE'S GENRES:"),
          buildChips(),
          buildPadding("MY MOVIES:"),
          buildJson(),
        ],
      ),
    );
  }
}
