import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../colors.dart';
import '../../../widgets/autopay_cards.dart';

class AutopayScreen extends StatefulWidget {
  const AutopayScreen({super.key});

  @override
  State<AutopayScreen> createState() => _AutopayScreenState();
}

class _AutopayScreenState extends State<AutopayScreen> {
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
                                      'Autopay transactions',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: constraints.maxHeight * 0.03,
                                ),
                                map['needAutopay'] == null
                                    ? const Center(
                                        child:
                                            Text('No transactions available'))
                                    : StreamBuilder(
                                        stream: ref
                                            .child(user.uid)
                                            .child('split')
                                            .child('needAutopay')
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

                                            dynamic formatDate(String date) {
                                              final dynamic newDate =
                                                  DateTime.parse(date);
                                              final DateFormat formatter =
                                                  DateFormat(
                                                      'E, d MMMM  hh:mm a');
                                              final dynamic formatted =
                                                  formatter.format(newDate);
                                              return formatted;
                                            }

                                            return Row(
                                              children: [
                                                Expanded(
                                                  child: SizedBox(
                                                    height: orientation ==
                                                            Orientation.portrait
                                                        ? constraints
                                                                .maxHeight *
                                                            0.9
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
                                                          bool isAutopayOn =
                                                              list[index][
                                                                  'isAutopayOn'];

                                                          return AutopayCard(
                                                            constraints:
                                                                constraints,
                                                            dateAndTime:
                                                                formatDate(list[
                                                                        index][
                                                                    'paymentDateTime']),
                                                            transactionAmount:
                                                                isAutopayOn
                                                                    ? '${list[index]['amount']}'
                                                                    : '-${list[index]['amount']}',
                                                            amountColor:
                                                                isAutopayOn
                                                                    ? kGreenColor
                                                                    : Colors
                                                                        .red,
                                                            transactionName:
                                                                list[index]
                                                                    ['name'],
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.05,
                                                            status: isAutopayOn
                                                                ? 'Pending'
                                                                : 'Paid',
                                                            statusColor:
                                                                isAutopayOn
                                                                    ? kGreenColor
                                                                    : Colors
                                                                        .red,
                                                          );
                                                        })),
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
