// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class SafeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext safe) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/safetext.JPG'),
          fit: BoxFit.cover,
        ),
      ),
    ));
  }
}
