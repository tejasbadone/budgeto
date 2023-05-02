import 'package:budgeto/presentation/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../colors.dart';
import '../../../logic/flutter_toast.dart';
import '../../widgets/text_field.dart';

class EmergencyPlanningScreen extends StatefulWidget {
  const EmergencyPlanningScreen({super.key});

  @override
  State<EmergencyPlanningScreen> createState() =>
      _EmergencyPlanningScreenState();
}

class _EmergencyPlanningScreenState extends State<EmergencyPlanningScreen> {
  final multiplierController = TextEditingController();
  final amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  final user = FirebaseAuth.instance.currentUser!;

  var now = DateTime.now();

// Validator for numeber realted textfields
  String? _validateNumber(dynamic value) {
    final double? amount =
        double.tryParse(value) == null ? 6 : double.tryParse(value!);
    if (amount! <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  String? _validateEMI(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    final double? amount = double.tryParse(value);
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    return null;
  }

  void activateEmergencyFunds() async {
    DatabaseReference splitRef = ref.child(user.uid).child('split');

    DataSnapshot snapshot = await splitRef.get();

    Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;

    var expenses = map['expenses'];
    var count = map['count'];
    var needAvail = map['needAvailableBalance'];

    double expensesMultiplier = double.tryParse(multiplierController.text) ?? 6;
    dynamic emiAmount = double.tryParse(amountController.text);

    if (emiAmount > needAvail) {
      return ToastMessage().toastMessage(
          'Insufficient balance to collect emergency funds!', Colors.red);
    } else {
      double targetEmergencyFunds = ((expenses / count) * expensesMultiplier);

      if (emiAmount > targetEmergencyFunds) {
        return ToastMessage()
            .toastMessage('EMI is greater than target amount', Colors.red);
      } else {
        double updatedNeedAvail = needAvail - emiAmount;

        final payerData = {
          'needAvailableBalance': updatedNeedAvail,
          'count': ServerValue.increment(1),
          'needSpendings': ServerValue.increment(emiAmount),
          'targetEmergencyFunds': targetEmergencyFunds,
          'collectedEmergencyFunds': emiAmount,
          'emiAmount': emiAmount,
          'isEFenabled': true,
          'expensesMultiplier': expensesMultiplier,
        };
        splitRef.update(payerData);

        final needTransac = {
          'name': 'Emergency Funds',
          'amount': emiAmount,
          'paymentDateTime': now.toIso8601String(),
        };
        splitRef.child('needTransactions').push().set(needTransac);

        String amount = emiAmount.toStringAsFixed(0);
        final allTransaction = {
          'name': 'Emergency Funds',
          'amount': '- $amount',
          'paymentDateTime': now.toIso8601String(),
        };
        splitRef.child('allTransactions').push().set(allTransaction);

        ToastMessage().toastMessage('Activated!', Colors.green);

        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(Icons.keyboard_backspace),
                              ),
                              SizedBox(
                                width: constraints.maxWidth * 0.03,
                              ),
                              const Text(
                                'Emergency funds plan',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          const Text(
                            'Emergency funds are taken from need category funds at start of every month. By default emergency funds are 6 times of expenses category funds, but you can change it according to your plan',
                            style: TextStyle(color: kGrayTextC, fontSize: 16),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          const Text(
                            'Enter multiple of expenses',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomTextField(
                              hint: '* 6',
                              iconName: Icons.calculate,
                              controller: multiplierController,
                              validator: _validateNumber,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          const Text(
                            'Enter the EMI amount',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomTextField(
                              hint: '2000',
                              iconName: Icons.calculate,
                              controller: amountController,
                              validator: _validateEMI,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          TButton(
                              constraints: constraints,
                              btnColor: Theme.of(context).primaryColor,
                              btnText: 'Activate',
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  activateEmergencyFunds();
                                }
                              }),
                          SizedBox(
                            height: orientation == Orientation.portrait
                                ? constraints.maxHeight * 0.08
                                : constraints.maxHeight * 0.1,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
