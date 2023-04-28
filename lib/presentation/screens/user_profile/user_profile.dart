import 'package:budgeto/budgeto_themes.dart';
import 'package:budgeto/colors.dart';
import 'package:budgeto/presentation/screens/auth/forgot_password_screen.dart';
import 'package:budgeto/presentation/screens/user_profile/update_account_screen.dart';
import 'package:budgeto/presentation/widgets/profile_tab.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import '../../widgets/button.dart';
import '../../widgets/null_error_message_widget.dart';
import '../auth/login_screen.dart';
import 'package:flutter_switch/flutter_switch.dart';

class UserProfileScreeen extends StatefulWidget {
  const UserProfileScreeen({super.key});

  @override
  State<UserProfileScreeen> createState() => _UserProfileScreeenState();
}

class _UserProfileScreeenState extends State<UserProfileScreeen> {
  final ref = FirebaseDatabase.instance.ref('Users');

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref.child(user.uid.toString()).onValue,
      builder: ((context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.snapshot.value == null ||
              snapshot.data.snapshot.value == "") {
            return SafeArea(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        NullErrorMessage(
                          message: 'Something went wrong!',
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          } else {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
            return Scaffold(
              body: SafeArea(
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return OrientationBuilder(
                      builder: (BuildContext context, Orientation orientation) {
                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(
                                  height: constraints.maxHeight * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Profile',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      const UpdateAccountScreen())));
                                        },
                                        icon: const Icon(Icons.edit))
                                  ],
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height:
                                          orientation == Orientation.portrait
                                              ? constraints.maxHeight * 0.2
                                              : constraints.maxHeight * 0.4,
                                      width: orientation == Orientation.portrait
                                          ? constraints.maxHeight * 0.2
                                          : constraints.maxHeight * 0.4,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 4,
                                              color:
                                                  Theme.of(context).cardColor),
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).canvasColor),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: map['profilePic'].toString() ==
                                                ""
                                            ? const Icon(
                                                Icons.person,
                                                size: 90,
                                                color: kGrayTextC,
                                              )
                                            : Image.network(
                                                map['profilePic'].toString(),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.03,
                                ),
                                ProfileTab(
                                    constraints: constraints,
                                    title: 'Full Name',
                                    iconName: Icons.person,
                                    titleValue: map['fullName']),
                                ProfileTab(
                                    constraints: constraints,
                                    title: 'Phone number',
                                    iconName: Icons.call,
                                    titleValue: map['phoneNumber']),
                                ProfileTab(
                                    constraints: constraints,
                                    title: 'Bank account number',
                                    iconName: Icons.account_balance,
                                    titleValue: map['bankAccNumber']),
                                ProfileTab(
                                    constraints: constraints,
                                    title: 'KYC number',
                                    iconName: Icons.person,
                                    titleValue: map['kyc']),
                                ProfileTab(
                                    constraints: constraints,
                                    title: 'Age',
                                    iconName: Icons.person,
                                    titleValue: map['age']),
                                ProfileTab(
                                    constraints: constraints,
                                    title: 'Income Range',
                                    iconName: Icons.currency_rupee,
                                    titleValue: map['incomeRange']),
                                SizedBox(
                                  height: constraints.maxHeight * 0.01,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      'Dark Mode',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    const Spacer(),
                                    themeSwitch(context)
                                  ],
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.04,
                                ),
                                TButton(
                                  constraints: constraints,
                                  btnColor: Theme.of(context).primaryColor,
                                  btnText: 'Sign out',
                                  onPressed: () {
                                    FirebaseAuth.instance.signOut();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  },
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.03,
                                ),
                                TButton(
                                  constraints: constraints,
                                  btnColor: Theme.of(context).primaryColor,
                                  btnText: 'Reset Password',
                                  onPressed: () {
                                    PersistentNavBarNavigator.pushNewScreen(
                                      context,
                                      screen: const ForgotPassScreen(),
                                      withNavBar:
                                          false, // OPTIONAL VALUE. True by default.
                                    );
                                  },
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.06,
                                ),
                              ],
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
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: kGreenColor,
            ),
          );
        }
      }),
    );
  }

  FlutterSwitch themeSwitch(BuildContext context) {
    final switchThemeIns = Provider.of<ThemeSwitch>(context);
    return FlutterSwitch(
      width: 50,
      height: 30,
      padding: 0,
      activeToggleColor: kDarkCardC,
      inactiveToggleColor: Theme.of(context).primaryColor,
      activeSwitchBorder: Border.all(
        color: kDarkGreenBackC,
        width: 4,
      ),
      inactiveSwitchBorder: Border.all(
        color: kTextFieldBorderC,
        width: 4,
      ),
      activeColor: kDarkGreenColor,
      inactiveColor: kTextFieldColor,
      activeIcon: Icon(
        Icons.nightlight_round,
        color: Theme.of(context).primaryColor,
      ),
      inactiveIcon: const Icon(
        Icons.wb_sunny,
        color: kTextFieldColor,
      ),
      value: switchThemeIns.isDarkMode,
      onToggle: (value) {
        final provider = Provider.of<ThemeSwitch>(context, listen: false);
        provider.switchTheme(value);
      },
    );
  }
}
