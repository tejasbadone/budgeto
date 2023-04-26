import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'flutter_toast.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

final user = FirebaseAuth.instance.currentUser!;

DateTime now = DateTime.now();

class AutoDeductCarFunds {
  void autoDeductCarFunds() async {
    const one = Duration(days: 1);
    Timer.periodic(one, (timer) async {
      if (now.day == 1) {
        DatabaseReference splitRef = ref.child(user.uid).child('split');
        DataSnapshot snapshot = await splitRef.get();
        Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;

        bool isCPenabled = map['isCPenabled'];
        var needAvail = map['needAvailableBalance'];
        var carEmi = map['carEmi'];
        var collectedCarFunds = map['collectedCarFunds'];
        var targetCarFunds = map['targetCarFunds'];

        if (isCPenabled) {
          if (needAvail < carEmi) {
            return ToastMessage().toastMessage(
                'Insufficient balance to deduct Car EMI', Colors.red);
          } else {
            dynamic updatedNeedAvail = needAvail - carEmi;

            final payerData = {
              'needAvailableBalance': updatedNeedAvail,
              'paymentDateTime': now.toIso8601String(),
              'collectedCarFunds': ServerValue.increment(carEmi),
              'needSpendings': ServerValue.increment(carEmi),
            };
            splitRef.update(payerData);

            final payer = {
              'name': 'Car planning EMI',
              'amount': carEmi,
              'paymentDateTime': now.toIso8601String(),
            };
            splitRef.child('needTransactions').push().set(payer);

            String amount = carEmi.toStringAsFixed(0);
            final allTrans = {
              'name': 'Car planning EMI',
              'amount': '- $amount',
              'paymentDateTime': now.toIso8601String(),
            };
            splitRef.child('allTransactions').push().set(allTrans);

            ToastMessage()
                .toastMessage('Car planning EMI deducted!', Colors.green);
          }

          if (targetCarFunds <= collectedCarFunds) {
            isCPenabled = false;
            splitRef.update({
              'isCPenabled': isCPenabled,
            });
          }
        }

        debugPrint('Working autodeduct car planning through seperate class');
      }
    });
  }
}
