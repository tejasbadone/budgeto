import 'package:flutter/material.dart';

class TButton extends StatelessWidget {
  const TButton(
      {super.key,
      this.loading = false,
      required this.constraints,
      required this.btnColor,
      required this.btnText,
      required this.onPressed});

  final BoxConstraints constraints;
  final Color btnColor;
  final String btnText;
  final Function() onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: constraints.maxWidth,
      decoration: BoxDecoration(
        color: btnColor,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: loading
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : Text(
                btnText,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
      ),
    );
  }
}
