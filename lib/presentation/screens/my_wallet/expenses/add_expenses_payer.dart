import 'package:budgeto/presentation/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../logic/flutter_toast.dart';
import '../../../widgets/text_field.dart';

class AddExpensesPayer extends StatefulWidget {
  const AddExpensesPayer({super.key});

  @override
  State<AddExpensesPayer> createState() => _AddExpensesPayerState();
}

class _AddExpensesPayerState extends State<AddExpensesPayer> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

  final user = FirebaseAuth.instance.currentUser!;

  DateTime now = DateTime.now();

  final _formKey = GlobalKey<FormState>();

// Controllers for texfields
  final nameController = TextEditingController();
  final amountController = TextEditingController();
  final accountNumberController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final shortDescriptionController = TextEditingController();

// Validators for form fields
  String? _validateFormField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

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

  void _addAndPay() async {
    if (_formKey.currentState!.validate()) {
      DatabaseReference needIncomeRef = ref.child(user.uid).child('split');

      DataSnapshot snapshot = (await needIncomeRef
          .child('expensesAvailableBalance')
          .get()) as dynamic;

      var currentExpensesAvail = (snapshot.value) as dynamic;

      if (double.parse(amountController.text) > currentExpensesAvail) {
        ToastMessage().toastMessage('Insufficient Balance', Colors.red);
      } else {
        // Check if payer already exists
        DataSnapshot payerSnapshot = await needIncomeRef
            .child('expensesPayers')
            .orderByChild('accountNumber')
            .equalTo(accountNumberController.text)
            .get() as dynamic;

        final payerData = {
          'name': nameController.text,
          'amount': double.parse(amountController.text),
          'accountNumber': accountNumberController.text,
          'phoneNumber': phoneNumberController.text,
          'shortDescription': shortDescriptionController.text,
          'paymentDateTime': now.toIso8601String(),
        };

        if (payerSnapshot.value == null) {
          ref
              .child(user.uid)
              .child('split')
              .child('expensesPayers')
              .push()
              .set(payerData);
        }

        var updatedExpensesAvail =
            currentExpensesAvail - double.parse(amountController.text);

        await ref.child(user.uid).child('split').update({
          'expensesSpendings':
              ServerValue.increment(double.parse(amountController.text)),
          'expensesAvailableBalance': updatedExpensesAvail,
        });

        ref
            .child(user.uid)
            .child('split')
            .child('expensesTransactions')
            .push()
            .set(payerData);

        final payeeData = {...payerData};
        final allTransactionPayer = {
          ...payeeData,
          'amount': '- ${amountController.text}'
        };
        ref
            .child(user.uid)
            .child('split')
            .child('allTransactions')
            .push()
            .set(allTransactionPayer);

        Navigator.pop(context);
        ToastMessage().toastMessage('Paid!', Colors.green);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          SizedBox(
                            height: constraints.maxHeight * 0.03,
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
                                'Account Pay',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.03,
                          ),
                          CustomTextField(
                            hint: 'Full name',
                            iconName: Icons.person,
                            controller: nameController,
                            validator: _validateFormField,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomTextField(
                              hint: 'Amount',
                              iconName: Icons.currency_rupee,
                              controller: amountController,
                              validator: _validateNumber,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomTextField(
                              hint: 'Account number',
                              iconName: Icons.account_balance,
                              controller: accountNumberController,
                              validator: _validateNumber,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomTextField(
                              hint: 'Phone number',
                              iconName: Icons.call,
                              controller: phoneNumberController,
                              validator: _validateNumber,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ]),
                          SizedBox(
                            height: constraints.maxHeight * 0.02,
                          ),
                          CustomTextField(
                            hint: 'Short description',
                            iconName: Icons.subject,
                            controller: shortDescriptionController,
                            validator: null,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                          TButton(
                              constraints: constraints,
                              btnColor: Theme.of(context).primaryColor,
                              btnText: 'Pay Now',
                              onPressed: _addAndPay),
                          SizedBox(
                            height: constraints.maxHeight * 0.04,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
