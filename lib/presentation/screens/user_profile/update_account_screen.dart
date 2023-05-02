import 'package:budgeto/colors.dart';
import 'package:budgeto/logic/profile_controller.dart';
import 'package:budgeto/presentation/widgets/button.dart';
import 'package:budgeto/presentation/widgets/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'dart:io';
import '../../../logic/flutter_toast.dart';

class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({super.key});

  @override
  State<UpdateAccountScreen> createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  String imageUrl = " ";

  String? dropdownValue = 'Income range';
  final items = [
    'Income range',
    'Less than 200K',
    '200K - 400K',
    '400K - 600K',
    'More than 600K'
  ];
  String? value;

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(value: item, child: Text(item));

  String? checkValid(value) {
    if (value.isEmpty) {
      return 'Please enter correct value';
    }
    return null;
  }

  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

  final user = FirebaseAuth.instance.currentUser!;

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  final fullNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final bankAccountController = TextEditingController();
  final kycController = TextEditingController();
  final ageController = TextEditingController();

  Future update() async {
    setState(() {
      loading = true;
    });
    await ref.child(user.uid).update({
      'fullName': fullNameController.text.toString(),
      'phoneNumber': phoneNumberController.text.toString(),
      'bankAccNumber': bankAccountController.text.toString(),
      'kyc': kycController.text.toString(),
      'age': ageController.text.toString(),
      'incomeRange': dropdownValue,
    }).then((value) {
      Navigator.pop(context);
      // PersistentNavBarNavigator.pushNewScreen(
      //   context,
      //   screen: const BottomNav(),
      //   withNavBar: false, // OPTIONAL VALUE. True by default.
      //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
      // );
      // Navigator.of(context).pop();

      ToastMessage().toastMessage('Updated!', Colors.green);
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      ToastMessage().toastMessage(error.toString(), Colors.red);
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => ProfileController(),
        child: Consumer<ProfileController>(
          builder: (context, provider, child) {
            return LayoutBuilder(
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: constraints.maxHeight * 0.03),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_backspace,
                                        size: 22,
                                      ),
                                    ),
                                    SizedBox(
                                      width: constraints.maxWidth * 0.03,
                                    ),
                                    const Text(
                                      'Update Account',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(height: constraints.maxHeight * 0.03),
                                Center(
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: 120,
                                        width: 130,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 4,
                                                color: Theme.of(context)
                                                    .cardColor),
                                            shape: BoxShape.circle,
                                            color:
                                                Theme.of(context).canvasColor),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: provider.image == null
                                              ? const Icon(
                                                  Icons.person,
                                                  size: 90,
                                                  color: kGrayTextC,
                                                )
                                              : Image.file(
                                                  File(provider.image!.path)
                                                      .absolute),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        right: 3,
                                        child: Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 3,
                                                    color: Theme.of(context)
                                                        .primaryColor),
                                                shape: BoxShape.circle,
                                                color: Theme.of(context)
                                                    .cardColor),
                                            child: GestureDetector(
                                              onTap: () {
                                                provider.pickImage(context);
                                              },
                                              child: const Icon(
                                                Icons.edit,
                                                size: 20,
                                                color: kGrayTextC,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                SBox(constraints),
                                CustomTextField(
                                  hint: 'Full name',
                                  iconName: Icons.person,
                                  controller: fullNameController,
                                  validator: checkValid,
                                ),
                                SBox(constraints),
                                CustomTextField(
                                    hint: 'Phone number',
                                    iconName: Icons.call,
                                    controller: phoneNumberController,
                                    validator: checkValid,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ]),
                                SBox(constraints),
                                CustomTextField(
                                    hint: 'Bank account number',
                                    iconName: Icons.account_balance,
                                    controller: bankAccountController,
                                    validator: checkValid,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ]),
                                SBox(constraints),
                                CustomTextField(
                                    hint: 'KYC number',
                                    iconName: Icons.person,
                                    controller: kycController,
                                    validator: checkValid,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ]),
                                SBox(constraints),
                                CustomTextField(
                                    hint: 'Age',
                                    iconName: Icons.person,
                                    controller: ageController,
                                    validator: checkValid,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly
                                    ]),
                                SBox(constraints),
                                FormField(
                                    builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(5),
                                      prefixIcon: const Icon(
                                          color: kGrayC,
                                          size: 18,
                                          Icons.currency_rupee),
                                      filled: true,
                                      // fillColor: kTextFieldColor,
                                      hoverColor:
                                          Theme.of(context).primaryColor,
                                      focusColor: kTextFieldColor,
                                      focusedBorder: Theme.of(context)
                                          .inputDecorationTheme
                                          .focusedBorder,
                                      enabledBorder: Theme.of(context)
                                          .inputDecorationTheme
                                          .enabledBorder,
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton(
                                        style: const TextStyle(
                                            color: kGrayTextC,
                                            fontSize: 16,
                                            fontFamily: 'Outfit'),
                                        // itemHeight: 2,
                                        icon: const Icon(
                                          Icons.expand_more,
                                          // color: kGrayTextC,
                                        ),
                                        value: dropdownValue,
                                        isExpanded: true,
                                        items:
                                            items.map(buildMenuItem).toList(),
                                        onChanged: (String? newValue) =>
                                            setState(
                                          () {
                                            dropdownValue = newValue;
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                                SizedBox(
                                  height: constraints.maxHeight * 0.05,
                                ),
                                TButton(
                                  constraints: constraints,
                                  btnColor: Theme.of(context).primaryColor,
                                  btnText: 'Continue',
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      update();
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: orientation == Orientation.portrait
                                      ? constraints.maxHeight * 0.04
                                      : constraints.maxHeight * 0.08,
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
            );
          },
        ),
      ),
    );
  }

  SizedBox SBox(BoxConstraints constraints) =>
      SizedBox(height: constraints.maxHeight * 0.015);
}
