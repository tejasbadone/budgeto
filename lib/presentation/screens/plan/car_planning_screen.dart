import 'package:budgeto/presentation/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../colors.dart';
import '../../../logic/flutter_toast.dart';
import '../../widgets/text_field.dart';

class CarPlanningScreen extends StatefulWidget {
  const CarPlanningScreen({super.key});

  @override
  State<CarPlanningScreen> createState() => _CarPlanningScreenState();
}

class _CarPlanningScreenState extends State<CarPlanningScreen> {
  final _formKey = GlobalKey<FormState>();

  bool isAutoPayOn = false;
  final carAmountController = TextEditingController();
  final targetPercentageController = TextEditingController();
  final carEmiAmount = TextEditingController();

  final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  final user = FirebaseAuth.instance.currentUser!;

  var now = DateTime.now();

  String? _validateNumber(String? value) {
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

  void activateCarPlan() async {
    DatabaseReference splitRef = ref.child(user.uid).child('split');
    DataSnapshot snapshot = await splitRef.get();
    Map<dynamic, dynamic> map = snapshot.value as Map<dynamic, dynamic>;
    dynamic needAvailable = map['needAvailableBalance'];

    dynamic carAmount = double.tryParse(carAmountController.text);
    dynamic targetSplit =
        double.tryParse(targetPercentageController.text) ?? 20;
    dynamic carEmi = double.tryParse(carEmiAmount.text);

    // calculating 20% of car amount ie Target amount
    dynamic carTargetPercentage = (targetSplit > 0) ? targetSplit / 100.0 : 0.2;
    dynamic carTargetAmount = (carAmount * carTargetPercentage);

    if (needAvailable < carEmi) {
      return ToastMessage().toastMessage('Insufficient balance', Colors.red);
    } else {
      if (carEmi > carTargetAmount) {
        return ToastMessage()
            .toastMessage('EMI is greater than target amount', Colors.red);
      } else {
        dynamic updatedNeedAvail = needAvailable - carEmi;

        final payerData = {
          'needAvailableBalance': updatedNeedAvail,
          'targetCarFunds': carTargetAmount,
          'collectedCarFunds': carEmi,
          'carEmi': carEmi,
          'isCPenabled': true,
          'needSpendings': ServerValue.increment(carEmi),
        };
        splitRef.update(payerData);

        final payer = {
          'name': 'Car Planning EMI',
          'amount': carEmi,
          'paymentDateTime': now.toIso8601String(),
        };
        splitRef.child('needTransactions').push().set(payer);

        String amount = carEmi.toStringAsFixed(0);
        final allTransacPayer = {
          'name': 'Car Planning EMI',
          'amount': '- $amount',
          'paymentDateTime': now.toIso8601String(),
        };
        splitRef.child('allTransactions').push().set(allTransacPayer);

        ToastMessage().toastMessage('Activated!', Colors.green);

        // ignore: use_build_context_synchronously
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
                            height: constraints.maxHeight * 0.01,
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
                                'Car plan',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.01,
                          ),
                          const Text(
                            'Car planning funds are taken from need category funds at start of every month. By default 20% of original car price is the target amount and 10% is the EMI every month. however you can change the both according to your plan',
                            style: TextStyle(color: kGrayTextC, fontSize: 16),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          const Text(
                            'Enter price of the car',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomTextField(
                            hint: '8,00,000',
                            iconName: Icons.currency_rupee,
                            controller: carAmountController,
                            validator: _validateNumber,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          const Text(
                            'Enter the percentage to get target amount',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomTextField(
                              hint: '20%',
                              iconName: Icons.calculate,
                              controller: targetPercentageController,
                              validator: null,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          const Text(
                            'Enter EMI amount',
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
                            controller: carEmiAmount,
                            validator: _validateNumber,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          TButton(
                            constraints: constraints,
                            btnColor: Theme.of(context).primaryColor,
                            btnText: 'Activate',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                activateCarPlan();
                              }
                            },
                          ),
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
