import 'package:budgeto/colors.dart';

import 'package:flutter/material.dart';

class CheckMailScreen extends StatelessWidget {
  const CheckMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: kGreenColor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            size: 160,
            Icons.mark_email_read,
            color: Colors.white,
          ),
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'We have sent you a link to\nreset the password!',
              style: TextStyle(color: Colors.white, fontSize: 20),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    );
  }
}
