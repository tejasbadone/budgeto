import 'package:budgeto/colors.dart';
import 'package:budgeto/logic/flutter_toast.dart';
import 'package:budgeto/presentation/screens/auth/forgot_password_screen.dart';

import 'package:budgeto/presentation/screens/auth/signup_screen.dart';

import 'package:budgeto/presentation/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:budgeto/presentation/widgets/text_field.dart';
import 'package:flutter/services.dart';

import '../../widgets/bottom_navbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Future login() async {
    setState(() {
      loading = true;
    });
    await _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const BottomNav()));
      ToastMessage().toastMessage('Success!', Colors.green);
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
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return OrientationBuilder(
                builder: (BuildContext context, Orientation orientation) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: constraints.maxHeight * 0.2,
                        ),
                        const Center(
                          child: Text(
                            'Budgeto',
                            style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          height: constraints.maxHeight * 0.2,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 30),

                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(30)),
                                ),
                                // color: Colors.white,
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    // mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          height:
                                              constraints.maxHeight * 0.015),
                                      const Text(
                                        'Log in\nto your account',
                                        style: TextStyle(
                                          fontSize: 30,
                                        ),
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.025,
                                      ),
                                      CustomTextField(
                                        hint: 'Email',
                                        iconName: Icons.alternate_email,
                                        controller: emailController,
                                        obscureText: false,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter Email';
                                          }
                                          return null;
                                        },
                                        keyboardType:
                                            TextInputType.emailAddress,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.025,
                                      ),
                                      CustomTextField(
                                        hint: 'Password',
                                        iconName: Icons.lock,
                                        controller: passwordController,
                                        obscureText: true,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Enter Password';
                                          }
                                          return null;
                                        },
                                        keyboardType:
                                            TextInputType.visiblePassword,
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.025,
                                      ),

                                      // Container(child: TextB,)
                                      TButton(
                                        loading: loading,
                                        constraints: constraints,
                                        btnColor:
                                            Theme.of(context).primaryColor,
                                        btnText: 'Login',
                                        onPressed: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            login();
                                          }
                                        },
                                      ),
                                      SizedBox(
                                        height: constraints.maxHeight * 0.01,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            'New to Budgeto?',
                                            style: TextStyle(
                                                color: kGrayTextC,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400),
                                          ),
                                          TextButton(
                                            child: Text(
                                              'Register',
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 16),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const SignupScreen()));
                                            },
                                          ),
                                        ],
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ForgotPassScreen()));
                                        },
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}
