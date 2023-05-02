import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      margin: const EdgeInsets.symmetric(vertical: 5),
      height: 65,
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Icon(
                  Icons.currency_rupee,
                ),
                SizedBox(
                  width: width,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transactionName,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      dateAndTime,
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  transactionAmount,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // const SizedBox(
          //   height: 6,
          // ),
          // Divider(
          //   thickness: 1,
          //   color: kGrayTextC.withOpacity(0.15),
          // ),
        ],
      ),
    );
  }
}
