import 'package:flutter/material.dart';

import '../../colors.dart';

class CardAlt extends StatelessWidget {
  const CardAlt(
      {super.key,
      required this.orientation,
      required this.constraints,
      required this.title,
      required this.iconName,
      required this.verHeight,
      required this.verWidth,
      required this.horiHeight,
      required this.horiWidth,
      this.fontColor = kFontBlackC,
      this.iconColor = kGreenColor,
      this.backColor = kCardColor});

  final Orientation orientation;
  final BoxConstraints constraints;
  final String title;
  final IconData iconName;
  final dynamic verHeight;
  final dynamic verWidth;
  final dynamic horiHeight;
  final dynamic horiWidth;
  final dynamic backColor;
  final dynamic fontColor;
  final dynamic iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: orientation == Orientation.portrait ? verHeight : horiHeight,
      width: orientation == Orientation.portrait ? verWidth : horiWidth,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            title,
            style: TextStyle(
                color: fontColor, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.01,
          ),
          Icon(
            iconName,
            color: iconColor,
            size: 45,
          )
        ]),
      ),
    );
  }
}
