import 'package:budgeto/logic/flutter_toast.dart';
import 'package:budgeto/presentation/screens/auth/check_email_screen.dart';

import 'package:budgeto/presentation/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budgeto/presentation/widgets/text_field.dart';

class ForgotPassScreen extends StatefulWidget {
  const ForgotPassScreen({super.key});

  @override
  State<ForgotPassScreen> createState() => _ForgotPassScreenState();
}

class _ForgotPassScreenState extends State<ForgotPassScreen> {
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  void forgotPassword() {
    setState(() {
      loading = true;
    });
    _auth
        .sendPasswordResetEmail(email: emailController.text.toString())
        .then((value) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const CheckMailScreen()));
      ToastMessage().toastMessage('Password reset email sent!', Colors.green);
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
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: constraints.maxHeight * 0.63,
                        color: Theme.of(context).primaryColor,
                        child: const Center(
                          child: Text(
                            'Budgeto',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: constraints.maxHeight * 0.015),
                                const Text(
                                  'Forgot Password',
                                  style: TextStyle(
                                    fontSize: 28,
                                  ),
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.03,
                                ),
                                Text(
                                  'Enter the email associated with your account and we will send you link to reset the password',
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.03,
                                ),
                                CustomTextField(
                                  hint: 'Email',
                                  iconName: Icons.alternate_email,
                                  controller: emailController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.04,
                                ),

                                // Container(child: TextB,)
                                TButton(
                                    loading: loading,
                                    constraints: constraints,
                                    btnColor: Theme.of(context).primaryColor,
                                    btnText: 'Reset Password',
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        forgotPassword();
                                      }
                                    }),
                                SizedBox(
                                  height: constraints.maxHeight * 0.03,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
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
