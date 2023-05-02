import 'package:flutter/material.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.constraints,
    required this.amount,
  });

  final dynamic constraints;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        height: constraints,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
      ),
      const Positioned(
        left: 35,
        top: 35,
        child: Text(
          'Available Balance',
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      const Positioned(
        left: 25,
        bottom: 55,
        child: Icon(
          Icons.currency_rupee,
          color: Colors.white,
          size: 55,
        ),
      ),
      Positioned(
        left: 85,
        bottom: 50,
        child: Text(
          amount,
          style: const TextStyle(
              fontSize: 56, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      Positioned(
        right: 20,
        bottom: 15,
        child: Text(
          'Budgeto',
          style: TextStyle(
              fontSize: 22,
              color: Colors.white.withOpacity(0.4),
              fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }
}
