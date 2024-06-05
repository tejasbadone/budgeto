import 'dart:async';
import 'package:budgeto/logic/flutter_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

final user = FirebaseAuth.instance.currentUser!;

class Autopay {
  Future autoPay() async {
    const oneMinute = Duration(minutes: 1);
    Timer.periodic(oneMinute, (timer) async {
      DatabaseReference autopayRef =
          ref.child(user.uid).child('split').child('needAutopay');
      DatabaseReference autopayBalanceRef = ref.child(user.uid).child('split');
      DatabaseReference transactionRef =
          ref.child(user.uid).child('split').child('needTransactions');

      DataSnapshot availableBalanceSnapshot = (await autopayBalanceRef
          .child('needAvailableBalance')
          .get()) as dynamic;

      var availableBalance = (availableBalanceSnapshot.value) as dynamic;

      DataSnapshot snapshot = await autopayRef.get();

      Map<dynamic, dynamic> payerList = snapshot.value as Map<dynamic, dynamic>;

      DateTime now = DateTime.now();

      debugPrint('working every minute through new autopay class');

      payerList.forEach((key, value) async {
        bool isAutopayOn = value['isAutopayOn'];
        DateTime autoPayDate = DateTime.parse(value['paymentDateTime']);
        if (isAutopayOn && now.isAfter(autoPayDate)) {
          var amount = value['amount'];
          if (amount <= availableBalance) {
            availableBalance -= amount;

            autopayBalanceRef.update({
              'needAvailableBalance': availableBalance,
              'needSpendings': ServerValue.increment(amount),
            });

            autopayRef.child(key).update({
              'isAutopayOn': false,
            });

            final payerData = {
              'name': value['name'],
              'amount': value['amount'],
              'accountNumber': value['accountNumber'],
              'phoneNumber': value['phoneNumber'],
              'shortDescription': value['shortDescription'],
              'isAutopayOn': false,
              'paymentDateTime': value['paymentDateTime'],
            };

            await transactionRef.push().set(payerData);

            // adding transaction to allTransactions
            final payeeData = {...payerData};
            final allTransactionPayer = {
              ...payeeData,
              'amount': '- ${value['amount']}'
            };
            await autopayBalanceRef
                .child('allTransactions')
                .push()
                .set(allTransactionPayer);

            ToastMessage().toastMessage(
                'Pending autopay payments are paid!', Colors.green);
          }
        }
      });
    });
  }
}
