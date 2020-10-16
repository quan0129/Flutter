import 'dart:ui';

import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        'This is Splash ',
        style: TextStyle(fontSize: 20),
      )),
    );
  }
}
