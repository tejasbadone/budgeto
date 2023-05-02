import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
          child: Container(
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12)),
            width: double.maxFinite,
            height: 65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
