import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garden/utils/styles.dart';

class Ranking extends StatefulWidget {
  const Ranking({super.key});

  @override
  RankingState createState() => RankingState();
}

class RankingState extends State<Ranking> {
  final ref = FirebaseFirestore.instance.collection("totaldistance");
  Color? colorstatus;
  String currentUsername = "";

  Future<void> getCurrentUser() async {
    User? userFirebase = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('user')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        currentUsername = documentSnapshot.get('username').toString();
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    getCurrentUser();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Ranking',
        ),
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    if (currentUsername ==
                        snapshot.data!.docs[index]['username']) {
                      colorstatus = Colors.green;
                    } else {
                      colorstatus = Colors.white;
                    }
                    return Container(
                      padding: EdgeInsets.only(top: 2),
                      child: Card(
                        color: colorstatus,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Column(
                              children: [
                                // Image.network(snapshot.data!.docs[index]['image']),
                                Text(
                                  (index + 1).toString(),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    //backgroundColor: Colors.green,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.docs[index]['distance']
                                          .toStringAsFixed(3) +
                                      " KM",
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(snapshot.data!.docs[index]['username']),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const CircularProgressIndicator();
            }
          }),

      // StreamBuilder(
      //     stream: FirebaseFirestore.instance
      //         .collection('distanceHistory')
      //         .snapshots(),
      //     builder:
      //         (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //       if (!snapshot.hasData) {
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       }

      //       return ListView(
      //         children: snapshot.data.documents.map((document) {
      //           var url = document['url'];

      //           return Center(
      //             child: Container(
      //               width: MediaQuery.of(context).size.width / 1.2,
      //               child: Column(
      //                 children: <Widget>[
      //                   Padding(
      //                     padding: EdgeInsets.only(
      //                       top: 20,
      //                       bottom: 5,
      //                     ),
      //                     child: Text(document['distance'],
      //                         style: GoogleFonts.quicksand(
      //                             fontStyle: FontStyle.normal)),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           );
      //         }).toList(),
      //       );
      //     }),
    );
  }
}
