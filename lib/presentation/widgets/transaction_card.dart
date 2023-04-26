import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../colors.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.constraints,
    required this.transactionName,
    required this.dateAndTime,
    required this.transactionAmount,
    required this.width,
  });

  final Constraints constraints;
  final String transactionName;
  final String dateAndTime;
  final String transactionAmount;
  final dynamic width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
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
                    style: const TextStyle(fontSize: 16, color: kFontBlackC),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    dateAndTime,
                    style: const TextStyle(fontSize: 12, color: kFontBlackC),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                transactionAmount,
                style: const TextStyle(
                    fontSize: 18,
                    color: kFontBlackC,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 6,
          ),
          Divider(
            thickness: 1,
            color: kGrayTextC.withOpacity(0.15),
          ),
        ],
      ),
    );
  }
}
