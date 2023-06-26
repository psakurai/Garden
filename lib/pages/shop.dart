import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:garden/components/header_widget.dart';
import 'package:garden/pages/sign_in.dart';
import 'package:garden/utils/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../services/database.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  String gold = "";
  List<String> seedName = [];
  List<String> seedPrice = [];
  List<String> seedStatus = [];
  String? isExist;
  Future<void> getGoldData() async {
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

  Future<void> getSeedData() async {
    User? userFirebase = FirebaseAuth.instance.currentUser;
    seedName.clear();
    seedPrice.clear();
    seedStatus.clear();
    for (int i = 0; i < 3; i++) {
      FirebaseFirestore.instance
          .collection('seed')
          .doc(userFirebase!.uid)
          .collection('whichseed')
          .doc(userFirebase!.uid + i.toString())
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          seedName.add(documentSnapshot.get('seed_name').toString());
          seedPrice.add(documentSnapshot.get('seed_price').toString());
          seedStatus.add(documentSnapshot.get('seed_status').toString());
        } else {
          isExist = null;
        }
        setState(() {
          isExist = "Not null";
        });
      });
    }
  }

  Future<void> buySeed() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var userFirebase = _auth.currentUser;

    await DatabaseService(uid: userFirebase!.uid).updateLevelData();
  }

  Future<void> _dialogBuilder(BuildContext context, position) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Do you want to buy ${seedName[position]} for ${seedPrice[position]} ?'),
          content: const Text(
            'The seed will then be placed inside\n'
            'the garden.\n',
          ),
          actions: <Widget>[
            TextButton(
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
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              height: 7,
            ),
            TextButton(
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
              child: const Text('Yes'),
              onPressed: () async {
                User? userFirebase = FirebaseAuth.instance.currentUser;
                FirebaseFirestore.instance
                    .collection('seed')
                    .doc(userFirebase!.uid)
                    .collection('whichseed')
                    .doc(userFirebase.uid + position.toString())
                    .get()
                    .then((DocumentSnapshot documentSnapshot) async {
                  String currentStatus =
                      documentSnapshot.get('seed_status').toString();
                  if (currentStatus == '0') {
                    if (int.parse(gold) > int.parse(seedPrice[position])) {
                      setState(() {
                        isExist = null;
                      });
                      final FirebaseAuth _auth = FirebaseAuth.instance;
                      var userFirebase = _auth.currentUser;
                      gold = (int.parse(gold) - int.parse(seedPrice[position]))
                          .toString();
                      await DatabaseService(uid: userFirebase!.uid)
                          .updateSeedStatusData(
                              position.toInt(), int.parse(gold));

                      getSeedData();
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    } else {
                      Navigator.of(context).pop();
                      Fluttertoast.showToast(
                          msg: "You don't have enough gold to buy this seed.",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          fontSize: 20.0,
                          backgroundColor: Colors.red.withOpacity(0.8),
                          textColor: Colors.white);
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "You have bought this seed.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        fontSize: 20.0,
                        backgroundColor: Colors.red.withOpacity(0.8),
                        textColor: Colors.white);
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getGoldData();
    getSeedData();
    //getAllDistance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double headerHeight = 150;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0.0,
          title: const Text('Shop'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actionsIconTheme: const IconThemeData(color: Colors.white, size: 25),
        ),
        body: isExist == null
            ? const Center(child: Text("Loading"))
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: headerHeight,
                      child: HeaderWidget(
                          headerHeight, false, Icons.password_rounded),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              children: [
                                Card(
                                  child: SizedBox(
                                    width: 170,
                                    height: 70,
                                    child: ListTile(
                                      leading: const Icon(Icons.album,
                                          color: Colors.yellow, size: 25),
                                      title: const Text("In-game Coin"),
                                      subtitle: Text(gold),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12.0,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 1000,
                            child: ListView.separated(
                              itemBuilder: (context, position) {
                                if (seedStatus[position] == "0") {
                                  return ListTile(
                                    leading: const Icon(Icons.album,
                                        color: Colors.red, size: 25),
                                    title: Text('${seedName[position]}'),
                                    subtitle: Text('${seedPrice[position]}'),
                                    trailing: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.teal,
                                        onPrimary: Colors.white,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text('   Buy   '),
                                      onPressed: () {
                                        if (seedStatus[position] == "0") {
                                          var which = position;
                                          _dialogBuilder(context, which);
                                        }
                                      },
                                    ),
                                  );
                                } else {
                                  return ListTile(
                                    leading: const Icon(Icons.album,
                                        color: Colors.green, size: 25),
                                    title: Text('${seedName[position]}'),
                                    subtitle: Text('${seedPrice[position]}'),
                                    trailing: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.teal,
                                        onPrimary: Colors.white,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text('Bought'),
                                      onPressed: () {
                                        Fluttertoast.showToast(
                                            msg: "You have bought this seed.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            fontSize: 20.0,
                                            backgroundColor:
                                                Colors.red.withOpacity(0.8),
                                            textColor: Colors.white);
                                      },
                                    ),
                                  );
                                }
                              },
                              separatorBuilder: (context, position) {
                                return const SizedBox(
                                  height: 10,
                                );
                              },
                              itemCount: seedName.length,
                            ),
                          ),
                        ])),
                  ],
                ),
              ));
  }
}

// return Padding(
                                //   padding: const EdgeInsets.all(0.0),
                                //   child: Card(
                                //     color: Colors.green,
                                //     elevation: 16,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(10),
                                //     ),
                                //     child: Wrap(
                                //       children: [
                                //         Container(
                                //           width:
                                //               MediaQuery.of(context).size.width,
                                //           decoration: const BoxDecoration(
                                //               color: Colors.white,
                                //               borderRadius: BorderRadius.only(
                                //                   bottomRight:
                                //                       Radius.circular(10),
                                //                   topRight:
                                //                       Radius.circular(10))),
                                //           margin: EdgeInsets.only(left: 10),
                                //           padding: const EdgeInsets.symmetric(
                                //               horizontal: 16, vertical: 10),
                                //           child: Column(
                                //             crossAxisAlignment:
                                //                 CrossAxisAlignment.start,
                                //             children: [
                                //               Text(
                                //                 'List Item $position ${seedName[position]} ${seedPrice[position]}  ',
                                //                 style: const TextStyle(
                                //                     fontSize: 24),
                                //               ),
                                //               Row(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment
                                //                         .spaceBetween,
                                //                 children: [
                                //                   Expanded(
                                //                       child: ElevatedButton(
                                //                           style: ElevatedButton
                                //                               .styleFrom(
                                //                             textStyle:
                                //                                 const TextStyle(
                                //                                     fontSize:
                                //                                         20),
                                //                             minimumSize:
                                //                                 Size.fromHeight(
                                //                                     50),
                                //                           ),
                                //                           onPressed: () {
                                //                             if (seedStatus[
                                //                                     position] ==
                                //                                 "0") {
                                //                               _dialogBuilder(
                                //                                   context,
                                //                                   position);
                                //                             }
                                //                           },
                                //                           child: Container(
                                //                               decoration: BoxDecoration(
                                //                                   borderRadius:
                                //                                       BorderRadius
                                //                                           .circular(
                                //                                               5)),
                                //                               padding:
                                //                                   EdgeInsets
                                //                                       .all(8),
                                //                               child: const Text(
                                //                                   "Buy",
                                //                                   style: TextStyle(
                                //                                       fontSize:
                                //                                           24)))))
                                //                 ],
                                //               ),
                                //             ],
                                //           ),
                                //         )
                                //       ],
                                //     ),
                                //   ),
                                // );

            // SafeArea(
            //     child: Padding(
            //       padding:
            //           EdgeInsets.only(left: medium, top: 50, right: medium),
            //       child: Column(
            //         children: <Widget>[
            //           Card(
            //             margin: EdgeInsets.all(10),
            //             color: Colors.green[100],
            //             shadowColor: Colors.blueGrey,
            //             elevation: 10,
            //             child: Column(
            //               mainAxisSize: MainAxisSize.min,
            //               children: <Widget>[
            //                 const ListTile(
            //                   leading: Icon(Icons.album,
            //                       color: Colors.cyan, size: 45),
            //                   title: Text(
            //                     "Let's Talk About Love",
            //                     style: TextStyle(fontSize: 20),
            //                   ),
            //                   subtitle: Text('Modern Talking Album'),
            //                 ),
            //               ],
            //             ),
            //           ),
            //           Card(
            //             child: Align(
            //               alignment: Alignment.centerLeft,
            //               child: Text(
            //                 'Shop',
            //                 textAlign: TextAlign.left,
            //                 style: const TextStyle(
            //                   fontSize: 30,
            //                   fontWeight: FontWeight.bold,
            //                   //backgroundColor: Colors.green,
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Card(
            //             child: Align(
            //               alignment: Alignment.centerLeft,
            //               child: Padding(
            //                 padding: const EdgeInsets.all(16.0),
            //                 child: Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   children: [
            //                     Align(
            //                       alignment: Alignment.centerLeft,
            //                       child: Text(
            //                         'In-game coin',
            //                         textAlign: TextAlign.left,
            //                         style: const TextStyle(
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.normal,
            //                           //backgroundColor: Colors.green,
            //                         ),
            //                       ),
            //                     ),
            //                     Row(
            //                       children: [
            //                         Icon(Icons.album),
            //                         SizedBox(width: small),
            //                         Text('${gold} Coin'),
            //                       ],
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           ),
            //           Expanded(
            //             child: ListView.separated(
            //               itemBuilder: (context, position) {
            //                 // return Card(
            //                 //   child: Padding(
            //                 //     padding: const EdgeInsets.all(15.0),
            //                 //     child: Text(
            //                 //       'List Item $position ${seedName[position]} ${seedPrice[position]}  ',
            //                 //     ),
            //                 //   ),
            //                 // );
            //                 return Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Card(
            //                     color: Colors.green,
            //                     elevation: 16,
            //                     shape: RoundedRectangleBorder(
            //                       borderRadius: BorderRadius.circular(10),
            //                     ),
            //                     child: Wrap(
            //                       children: [
            //                         Container(
            //                           width: MediaQuery.of(context).size.width,
            //                           decoration: const BoxDecoration(
            //                               color: Colors.white,
            //                               borderRadius: BorderRadius.only(
            //                                   bottomRight: Radius.circular(10),
            //                                   topRight: Radius.circular(10))),
            //                           margin: EdgeInsets.only(left: 10),
            //                           padding: const EdgeInsets.symmetric(
            //                               horizontal: 16, vertical: 10),
            //                           child: Column(
            //                             crossAxisAlignment:
            //                                 CrossAxisAlignment.start,
            //                             children: [
            //                               Text(
            //                                 'List Item $position ${seedName[position]} ${seedPrice[position]}  ',
            //                                 style:
            //                                     const TextStyle(fontSize: 24),
            //                               ),
            //                               Row(
            //                                 mainAxisAlignment:
            //                                     MainAxisAlignment.spaceBetween,
            //                                 children: [
            //                                   Expanded(
            //                                       child: ElevatedButton(
            //                                           style: ElevatedButton
            //                                               .styleFrom(
            //                                             textStyle:
            //                                                 const TextStyle(
            //                                                     fontSize: 20),
            //                                             minimumSize:
            //                                                 Size.fromHeight(50),
            //                                           ),
            //                                           onPressed: () {
            //                                             if (seedStatus[
            //                                                     position] ==
            //                                                 "0") {
            //                                               _dialogBuilder(
            //                                                   context,
            //                                                   position);
            //                                             }
            //                                           },
            //                                           child: Container(
            //                                               decoration: BoxDecoration(
            //                                                   borderRadius:
            //                                                       BorderRadius
            //                                                           .circular(
            //                                                               5)),
            //                                               padding:
            //                                                   EdgeInsets.all(8),
            //                                               child: const Text(
            //                                                   "Buy",
            //                                                   style: TextStyle(
            //                                                       fontSize:
            //                                                           24)))))
            //                                 ],
            //                               ),
            //                             ],
            //                           ),
            //                         )
            //                       ],
            //                     ),
            //                   ),
            //                 );
            //               },
            //               separatorBuilder: (context, position) {
            //                 return Card(
            //                   color: Colors.grey,
            //                   child: Padding(
            //                     padding: const EdgeInsets.all(5.0),
            //                     child: Text(
            //                       'Separator $position',
            //                       style: TextStyle(color: Colors.white),
            //                     ),
            //                   ),
            //                 );
            //               },
            //               itemCount: seedName.length,
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ));
