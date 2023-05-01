import 'package:budgeto/colors.dart';
import 'package:budgeto/logic/flutter_toast.dart';
import 'package:budgeto/presentation/screens/auth/login_screen.dart';
import 'package:budgeto/presentation/screens/auth/verify_email_screen.dart';
import 'package:budgeto/presentation/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:budgeto/presentation/widgets/text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
  }

  Future signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text.toString(),
              password: confirmPassController.text.toString())
          .then((value) {
        ref.child(value.user!.uid.toString()).set({
          'uid': value.user!.uid.toString(),
          'email': value.user!.email.toString(),
          'fullName': '',
          'phoneNumber': '',
          'bankAccNumber': '',
          'age': '',
          'kyc': '',
          'incomeRange': '',
          'profilePic': '',
        });

        debugPrint('split working');

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const VerifyEmailScreen()));
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
                        height: constraints.maxHeight * 0.45,
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
                              vertical: 8, horizontal: 30),

                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          // color: Colors.white,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: constraints.maxHeight * 0.015),
                                const Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 28,
                                  ),
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.025,
                                ),
                                CustomTextField(
                                  controller: emailController,
                                  hint: 'Email',
                                  iconName: Icons.alternate_email,
                                  obscureText: false,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.025,
                                ),
                                CustomTextField(
                                  hint: 'Password',
                                  iconName: Icons.lock,
                                  obscureText: true,
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Password';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.025,
                                ),
                                CustomTextField(
                                  hint: 'Confirm Password',
                                  iconName: Icons.lock,
                                  obscureText: true,
                                  controller: confirmPassController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Enter Password';
                                    }
                                    if (value != passwordController.text) {
                                      return 'Password does not match';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.02,
                                ),

                                const Center(
                                  child: Text(
                                    'By signing up you’re agree to our Privacy Policy and Terms and Conditions',
                                    style: TextStyle(
                                        fontSize: 14, color: kGrayTextC),
                                  ),
                                ),

                                SizedBox(
                                  height: constraints.maxHeight * 0.02,
                                ),

                                // Container(child: TextB,)
                                TButton(
                                  loading: loading,
                                  constraints: constraints,
                                  btnColor: Theme.of(context).primaryColor,
                                  btnText: 'Continue',
                                  onPressed: signup,
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.01,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Joined us?',
                                      style: TextStyle(
                                          color: kGrayTextC,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen()));
                                        },
                                        child: Text('Login',
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontSize: 16,
                                            )))
                                  ],
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
