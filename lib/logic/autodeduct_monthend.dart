import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'flutter_toast.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

final user = FirebaseAuth.instance.currentUser!;

DateTime now = DateTime.now();

class AutodeductMonthend {
  void autodeductMonthend() async {
    const one = Duration(days: 1);
    Timer.periodic(one, (timer) async {
      if (now.day == 1) {
        debugPrint('date 24');
        DatabaseReference autoDeductRef = ref.child(user.uid).child('split');

        DataSnapshot snapshot = await autoDeductRef.get();

        Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;

        int needIncome = map['needAvailableBalance'];
        int expensesIncome = map['expensesAvailableBalance'];
        int savings = map['savings'];

        int updatedSavings = needIncome + expensesIncome + savings;

        autoDeductRef.update({
          'needAvailableBalance': 0,
          'expensesAvailableBalance': 0,
          'savings': updatedSavings,
        });

        final deductFromExpenses = {
          'name': 'Transferred to Savings',
          'amount': expensesIncome,
          'shortDescription': 'Transferred to Savings from expenses',
          'paymentDateTime': now.toString(),
        };
        ref
            .child(user.uid)
            .child('split')
            .child('expensesTransactions')
            .push()
            .set(deductFromExpenses);

        final deductFromNeed = {
          'name': 'Transferred to Savings',
          'amount': needIncome,
          'shortDescription': 'Transferred to Savings from need',
          'paymentDateTime': now.toString(),
        };
        ref
            .child(user.uid)
            .child('split')
            .child('needTransactions')
            .push()
            .set(deductFromNeed)
            .then(
          (value) {
            ToastMessage().toastMessage(
                'Need + Expenses are transferred to Savings', Colors.green);

            debugPrint('reached end of autodeduct');
          },
        ).onError(
          (error, stackTrace) {
            ToastMessage().toastMessage(error.toString(), Colors.red);
          },
        );
      } else {
        debugPrint('not working');
      }
    });
  }
}
