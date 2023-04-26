import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../colors.dart';

class AutopayCard extends StatelessWidget {
  const AutopayCard(
      {super.key,
      required this.constraints,
      required this.transactionName,
      required this.dateAndTime,
      required this.transactionAmount,
      required this.width,
      required this.status,
      required this.amountColor,
      required this.statusColor});

  final Constraints constraints;
  final String transactionName;
  final String dateAndTime;
  final Color amountColor;
  final String status;
  final Color statusColor;
  final String transactionAmount;
  final dynamic width;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          width: double.maxFinite,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.currency_rupee,
                    color: kFontBlackC,
                  ),
                  SizedBox(
                    width: width,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transactionName,
                        style:
                            const TextStyle(fontSize: 16, color: kFontBlackC),
                      ),
                      Text(
                        dateAndTime,
                        style:
                            const TextStyle(fontSize: 12, color: kFontBlackC),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    transactionAmount,
                    style: TextStyle(
                        fontSize: 18,
                        color: amountColor,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.15,
                  ),
                  Text(
                    status,
                    style: TextStyle(
                        fontSize: 18,
                        color: statusColor,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Divider(
                thickness: 1,
                color: kGrayTextC.withOpacity(0.15),
              ),
            ],
          ),
        );
      },
    );
  }
}
