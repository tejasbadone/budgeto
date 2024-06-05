import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../../../colors.dart';
import 'need_payers_pay_screen.dart';

class PayersScreen extends StatefulWidget {
  const PayersScreen({super.key});

  @override
  State<PayersScreen> createState() => _PayersScreenState();
}

class _PayersScreenState extends State<PayersScreen> {
  // bool isAutopayOn;

  DatabaseReference ref = FirebaseDatabase.instance.ref().child('Users');

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: ref.child(user.uid.toString()).child('split').onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Map<dynamic, dynamic> map = snapshot.data.snapshot.value;
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
                            child: Column(
                              children: [
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
                                      'Payers',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.01,
                                ),
                                map['needPayers'] == null
                                    ? const Center(
                                        child: Text('No payers available'),
                                      )
                                    : StreamBuilder(
                                        stream: ref
                                            .child(user.uid)
                                            .child('split')
                                            .child('needPayers')
                                            .onValue,
                                        builder: (context,
                                            AsyncSnapshot<DatabaseEvent>
                                                snapshot) {
                                          if (!snapshot.hasData) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else {
                                            Map<dynamic, dynamic> map = snapshot
                                                .data!
                                                .snapshot
                                                .value as dynamic;
                                            List<dynamic> list = [];
                                            list.clear();
                                            list = map.values.toList();
                                            list.sort((a, b) =>
                                                b['paymentDateTime'].compareTo(
                                                    a['paymentDateTime']));

                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    height: orientation ==
                                                            Orientation.portrait
                                                        ? constraints
                                                                .maxHeight *
                                                            0.88
                                                        : constraints
                                                                .maxHeight *
                                                            0.75,
                                                    child: ListView.builder(
                                                      itemCount: snapshot
                                                          .data!
                                                          .snapshot
                                                          .children
                                                          .length,
                                                      itemBuilder:
                                                          ((context, index) {
                                                        return Card(
                                                          shape:
                                                              const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        12.0)),
                                                          ),
                                                          elevation: 0,
                                                          child: ListTile(
                                                            onTap: () {
                                                              Navigator
                                                                  .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          NeedPayersPayScreen(
                                                                    name: list[
                                                                            index]
                                                                        [
                                                                        'name'],
                                                                    accountNumber:
                                                                        list[index]
                                                                            [
                                                                            'accountNumber'],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            leading: const Icon(
                                                              Icons.person,
                                                              size: 35,
                                                            ),
                                                            title: Text(
                                                              list[index]
                                                                  ['name'],
                                                              style:
                                                                  const TextStyle(),
                                                            ),
                                                            subtitle: Text(
                                                                list[index][
                                                                    'accountNumber'],
                                                                style:
                                                                    const TextStyle()),
                                                          ),
                                                        );
                                                      }),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        }),
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
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: kGreenColor,
              ),
            );
          }
        });
  }
}
