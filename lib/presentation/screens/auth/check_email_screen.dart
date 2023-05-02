import 'package:flutter/material.dart';

class CheckMailScreen extends StatelessWidget {
  const CheckMailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            size: 160,
            Icons.mark_email_read,
            color: Theme.of(context).cardColor,
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'We have sent you a link to\nreset the password!',
              style:
                  TextStyle(fontSize: 20, color: Theme.of(context).cardColor),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      )),
    );
  }
}
