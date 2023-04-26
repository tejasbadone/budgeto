import 'package:budgeto/presentation/screens/plan/emergency_planning_screen.dart';

import 'package:budgeto/presentation/widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../colors.dart';

import '../../widgets/null_error_message_widget.dart';
import 'add_new_plan_screen.dart';
import 'car_planning_screen.dart';

class PlanningScreeen extends StatefulWidget {
  const PlanningScreeen({super.key});

  @override
  State<PlanningScreeen> createState() => _PlanningScreeenState();
}

class _PlanningScreeenState extends State<PlanningScreeen> {
  final DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');
  final user = FirebaseAuth.instance.currentUser!;

  bool isAutoPayOn = false;
  bool isCPenabled = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: ref.child(user.uid.toString()).child('split').onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.snapshot.value == null) {
              return const NullErrorMessage(
                message: 'Something went wrong!',
              );
            } else {
              Map<dynamic, dynamic> map = snapshot.data.snapshot.value;

              bool isEFenabled = map['isEFenabled'];
              bool isCPenabled = map['isCPenabled'];
              dynamic targetEmergencyFunds = map['targetEmergencyFunds'];
              dynamic collectedEmergencyFunds = map['collectedEmergencyFunds'];
              dynamic targetCarFunds = map['targetCarFunds'];
              dynamic collectedCarFunds = map['collectedCarFunds'];

              return Scaffold(
                body: SafeArea(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return OrientationBuilder(
                        builder:
                            (BuildContext context, Orientation orientation) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  const Text(
                                    'Planning',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),
                                  const Text(
                                    'Default plans',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),
                                  isEFenabled == false
                                      ? Container(
                                          height: orientation ==
                                                  Orientation.portrait
                                              ? constraints.maxHeight * 0.08
                                              : constraints.maxHeight * 0.2,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12))),
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const EmergencyPlanningScreen()));
                                              },
                                              child: const Text(
                                                'Emergency Funds',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        )
                                      : planningCard(
                                          map,
                                          'Emergency Funds',
                                          map['targetEmergencyFunds']
                                              .toStringAsFixed(0),
                                          map['collectedEmergencyFunds']
                                              .toStringAsFixed(0),
                                          targetEmergencyFunds,
                                          collectedEmergencyFunds),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),
                                  isCPenabled == false
                                      ? Container(
                                          height: orientation ==
                                                  Orientation.portrait
                                              ? constraints.maxHeight * 0.08
                                              : constraints.maxHeight * 0.2,
                                          width: double.maxFinite,
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12))),
                                          child: TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const CarPlanningScreen()));
                                              },
                                              child: const Text(
                                                'Car Plan',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        )
                                      : planningCard(
                                          map,
                                          'Car Plan',
                                          map['targetCarFunds']
                                              .toStringAsFixed(0),
                                          map['collectedCarFunds']
                                              .toStringAsFixed(0),
                                          targetCarFunds,
                                          collectedCarFunds),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.03,
                                  ),
                                  const Text(
                                    'Add plans',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  SizedBox(
                                    height: constraints.maxHeight * 0.02,
                                  ),
                                  TButton(
                                      constraints: constraints,
                                      btnColor: Theme.of(context).primaryColor,
                                      btnText: '+ Add new plan',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AddNewPlanScreen()));
                                      }),
                                  SizedBox(
                                    height: orientation == Orientation.portrait
                                        ? constraints.maxHeight * 0.06
                                        : constraints.maxHeight * 0.1,
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
        });
  }

  Stack planningCard(Map<dynamic, dynamic> map, textName, targetFunds,
      collectedFunds, comparetargetFunds, comparecollectedFunds) {
    return Stack(children: [
      Container(
        height: 320,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
      ),
      Positioned(
        left: 35,
        top: 25,
        child: Text(
          textName,
          style: const TextStyle(
              fontSize: 30, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
      const Positioned(
        left: 35,
        top: 80,
        child: Text(
          'Target Amount',
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ),
      const Positioned(
        left: 25,
        top: 115,
        child: Icon(
          Icons.currency_rupee,
          color: Colors.white,
          size: 55,
        ),
      ),
      Positioned(
        left: 85,
        top: 105,
        child: Text(
          targetFunds,
          style: const TextStyle(
              fontSize: 56, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      Positioned(
        right: 20,
        bottom: 15,
        child: Text(
          'Budgeto',
          style: TextStyle(
              fontSize: 22,
              color: Colors.white.withOpacity(0.4),
              fontWeight: FontWeight.bold),
        ),
      ),
      const Positioned(
        left: 35,
        bottom: 110,
        child: Text(
          'Colllected Funds',
          style: TextStyle(
              fontSize: 22, color: Colors.white, fontWeight: FontWeight.w400),
        ),
      ),
      const Positioned(
        left: 25,
        bottom: 50,
        child: Icon(
          Icons.currency_rupee,
          color: Colors.white,
          size: 55,
        ),
      ),
      Positioned(
        left: 85,
        bottom: 45,
        child: Text(
          collectedFunds,
          style: const TextStyle(
              fontSize: 56, color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      if (comparetargetFunds <= comparecollectedFunds)
        const Positioned(
          top: 30,
          right: 25,
          child: Icon(
            Icons.check_circle,
            size: 90,
            color: Colors.white,
          ),
        ),
    ]);
  }
}

// 