import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'flutter_toast.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

final user = FirebaseAuth.instance.currentUser!;

DateTime now = DateTime.now();

class AutoDeductEmergencyFunds {
  void autoDeductEmergencyFunds() async {
    const one = Duration(days: 1);
    Timer.periodic(one, (timer) async {
      if (now.day == 1) {
        DatabaseReference splitRef = ref.child(user.uid).child('split');

        DataSnapshot snapshot = await splitRef.get();

        Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;

        bool isEFenabled = map['isEFenabled'];
        var needAvail = map['needAvailableBalance'];
        var emiAmount = map['emiAmount'];
        var targetEmergencyFunds = map['targetEmergencyFunds'];
        var collectedEmergencyFunds = map['collectedEmergencyFunds'];

        if (isEFenabled) {
          if (needAvail < emiAmount) {
            return ToastMessage().toastMessage(
                'Insufficient balance to deduct mergency funds EMI',
                Colors.red);
          } else {
            dynamic updatedNeedAvail = needAvail - emiAmount;

            final payerData = {
              'needAvailableBalance': updatedNeedAvail,
              'paymentDateTime': now.toString(),
              'needSpendings': ServerValue.increment(emiAmount),
              'collectedEmergencyFunds': ServerValue.increment(emiAmount),
              'count': 1,
            };
            splitRef.update(payerData);

            final payer = {
              'name': 'Emergency Funds',
              'amount': emiAmount,
              'paymentDateTime': now.toIso8601String(),
            };
            splitRef.child('needTransactions').push().set(payer);

            String amount = emiAmount.toStringAsFixed(0);
            final allTrans = {
              'name': 'Emergency Funds',
              'amount': '- $amount',
              'paymentDateTime': now.toIso8601String(),
            };
            splitRef.child('allTransactions').push().set(allTrans);

            ToastMessage()
                .toastMessage('Emergency funds EMI deducted!', Colors.green);
          }

          if (targetEmergencyFunds <= collectedEmergencyFunds) {
            isEFenabled = false;
            splitRef.update({
              'isEFenabled': isEFenabled,
            });
          }
        }

        debugPrint('Working autodeduct emergency funds through seperate class');
      }
    });
  }
}
