import 'package:flutter/material.dart';

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
        Icon(
          size: 150,
          Icons.mark_email_read,
          color: Theme.of(context).cardColor,
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            mailText,
            style: TextStyle(fontSize: 18, color: Theme.of(context).cardColor),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          height: 50,
          width: 150,
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              btnText,
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16),
            ),
          ),
        )
      ],
    );
  }
}
