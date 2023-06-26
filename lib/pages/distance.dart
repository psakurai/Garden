import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden/components/header_widget.dart';
import 'package:garden/pages/ranking.dart';
import 'package:garden/pages/sign_in.dart';
import 'package:garden/utils/styles.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class Distance extends StatefulWidget {
  const Distance({super.key});

  @override
  State<Distance> createState() => _DistanceState();
}

class _DistanceState extends State<Distance> {
  String gold = "";
  List<String> distance = [];
  List<String> speed = [];
  List<String> pace = [];
  String? isExist;
  Future<void> getDistanceData() async {
    User? userFirebase = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('gold')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        gold = documentSnapshot.get('gold').toString();
      } else {
        isExist = null;
      }
      setState(() {
        isExist = "Not null";
      });
    });
  }

  Future<void> getDistanceHistoryData() async {
    User? userFirebase = FirebaseAuth.instance.currentUser;
    final querySnapshot = await FirebaseFirestore.instance
        .collection('distanceHistory')
        .doc(userFirebase!.uid)
        .collection('distance')
        .get();
    int distanceID = querySnapshot.docs.length;
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      FirebaseFirestore.instance
          .collection('distanceHistory')
          .doc(userFirebase.uid)
          .collection('distance')
          .doc(userFirebase.uid + i.toString())
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          distance.add(documentSnapshot.get('distance').toStringAsFixed(3));
          speed.add(documentSnapshot.get('speed').toString());
          pace.add(documentSnapshot.get('pace').toString());

          setState(() {
            isExist = "Not null";
          });
        } else {
          isExist = null;
        }
      });
    }
  }

  @override
  void initState() {
    getDistanceHistoryData();
    //getAllDistance();
    super.initState();
  }

  Widget build(BuildContext context) {
    double headerHeight = 150;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0.0,
          title: const Text('Distance History'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actionsIconTheme: const IconThemeData(color: Colors.white, size: 25),
        ),
        body: isExist == null
            ? const Center(child: Text("Loading"))
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: headerHeight,
                        child: HeaderWidget(
                            headerHeight, false, Icons.password_rounded),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 10),
                        child: Column(
                          children: <Widget>[
                            const Text(
                              "Current Ranking: ",
                              style: const TextStyle(
                                fontSize: 14,
                                //backgroundColor: Colors.green,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 20),
                                  minimumSize: Size.fromHeight(50),
                                  primary: Colors.teal,
                                  onPrimary: Colors.white,
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('See all ranking.'),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Ranking()),
                                  );
                                }),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Distance History",
                              style: const TextStyle(
                                fontSize: 14,
                                //backgroundColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, position) {
                            // return Card(
                            //   color: Colors.grey,
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Container(
                            //       child: Column(
                            //         children: [
                            //           Text(
                            //             'Distance: ${distance[position]} KM',
                            //             style: const TextStyle(
                            //                 fontSize: 20,
                            //                 fontWeight: FontWeight.normal),
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // );
                            if (double.parse(distance[position]) > 10.0) {
                              return ListTile(
                                leading: const Icon(Icons.directions_run,
                                    color: Colors.green, size: 25),
                                title:
                                    Text('Distance: ${distance[position]} KM'),
                                subtitle:
                                    const Text('What an amazing athlete!'),
                              );
                            } else if (double.parse(distance[position]) > 5.0) {
                              return ListTile(
                                leading: const Icon(Icons.directions_run,
                                    color: Colors.green, size: 25),
                                title:
                                    Text('Distance: ${distance[position]} KM'),
                                subtitle: const Text('Amazing achievement!'),
                              );
                            } else if (double.parse(distance[position]) > 3.0) {
                              return ListTile(
                                leading: const Icon(Icons.directions_run,
                                    color: Colors.green, size: 25),
                                title:
                                    Text('Distance: ${distance[position]} KM'),
                                subtitle: const Text('You are doing great!'),
                              );
                            } else {
                              return ListTile(
                                leading: const Icon(Icons.directions_run,
                                    color: Colors.green, size: 25),
                                title:
                                    Text('Distance: ${distance[position]} KM'),
                                subtitle: const Text('Thats a good start!'),
                              );
                            }
                          },
                          separatorBuilder: (context, position) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          itemCount: distance.length,
                        ),
                      ),
                    ],
                  ),
                ),
              ));
  }
}
