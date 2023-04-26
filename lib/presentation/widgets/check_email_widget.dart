import 'package:flutter/material.dart';

import '../../colors.dart';

class CheckEmailWidget extends StatelessWidget {
  const CheckEmailWidget({
    required this.mailText,
    required this.btnText,
    required this.onPressed,
    super.key,
  });

  final String mailText;
  final String btnText;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          size: 150,
          Icons.mark_email_read,
          color: Colors.white,
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            mailText,
            style: const TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          height: 50,
          width: 150,
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              btnText,
              style: const TextStyle(color: kGreenColor, fontSize: 16),
            ),
          ),
        )
      ],
    );
  }
}
