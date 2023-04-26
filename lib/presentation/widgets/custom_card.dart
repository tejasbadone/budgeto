import 'package:flutter/material.dart';

import '../../colors.dart';

class CustomCard extends StatelessWidget {
  const CustomCard(
      {super.key,
      required this.orientation,
      required this.verHeight,
      required this.horiHeight,
      required this.horiWidth,
      required this.verWidth,
      required this.cardTitle,
      required this.cardBalance});

  final Orientation orientation;
  final dynamic verHeight;
  final dynamic verWidth;
  final dynamic horiHeight;
  final dynamic horiWidth;
  final String cardTitle;
  final String cardBalance;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: orientation == Orientation.portrait ? verHeight : horiHeight,
      width: orientation == Orientation.portrait ? verWidth : horiWidth,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: kCardColor,
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cardTitle,
                style: const TextStyle(
                    fontSize: 22,
                    color: kGreenColor,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.currency_rupee,
                    size: 25,
                    color: kFontBlackC,
                  ),
                  SizedBox(
                    height: 35,
                    child: Text(
                      cardBalance,
                      style: const TextStyle(
                          fontSize: 24,
                          color: kFontBlackC,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
