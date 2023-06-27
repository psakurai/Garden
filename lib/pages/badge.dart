import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garden/components/imagedialog.dart';
import 'package:garden/utils/styles.dart';

class PlayerBadge extends StatefulWidget {
  const PlayerBadge({super.key});

  @override
  PlayerBadgeState createState() => PlayerBadgeState();
}

class PlayerBadgeState extends State<PlayerBadge> {
  String currentUsername = "";

  String? isExist;
  List<String> missionName = [];
  List<String> missionDescription = [];
  List<String> missionStatus = [];

  List<String> image = [];

  Future<void> getMissionData() async {
    missionName.clear();
    missionDescription.clear();
    missionStatus.clear();
    User? userFirebase = FirebaseAuth.instance.currentUser;
    for (int i = 0; i < 3; i++) {
      FirebaseFirestore.instance
          .collection('seed')
          .doc(userFirebase!.uid)
          .collection('whichseed')
          .doc(userFirebase!.uid + i.toString())
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          missionName.add(documentSnapshot.get('seed_name').toString());
          missionDescription.add(documentSnapshot.get('seed_price').toString());
          missionStatus.add(documentSnapshot.get('seed_status').toString());
        } else {
          isExist = null;
        }
        setState(() {
          isExist = "Not null";
        });
      });
    }

    CollectionReference<Map<String, dynamic>>;
  }

  Future<void> _getImageUrls() async {
    for (int i = 0; i < 2; i++) {
      image.add('assets/images/B' + i.toString() + '.png');
    }
  }

  late CollectionReference<Map<String, dynamic>> ref;
  @override
  void initState() {
    super.initState();
    User? userFirebase = FirebaseAuth.instance.currentUser;
    ref = FirebaseFirestore.instance
        .collection('mission')
        .doc(userFirebase!.uid)
        .collection('whichmission');
    getMissionData();
    _getImageUrls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Badge',
        ),
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data!.docs[index]['mission_status'] == 1) {
                      return ListTile(
                        leading: const Icon(Icons.album,
                            color: Colors.green, size: 25),
                        title: Text(
                          snapshot.data!.docs[index]['mission_name'],
                        ),
                        subtitle: Text(
                          snapshot.data!.docs[index]['mission_description'],
                        ),
                        tileColor: Colors.green[100],
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            onPrimary: Colors.white,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('View Badge'),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    // ignore: prefer_interpolation_to_compose_strings
                                    //ImageDialog(images[index]))
                                    ImageDialog(image[index]));
                          },
                        ),
                      );
                    }
                    // return Container(
                    //   padding: EdgeInsets.only(top: 2),
                    //   child: Card(
                    //     color: colorstatus,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: Container(
                    //         child: Column(
                    //           children: [
                    //             Text(
                    //               snapshot.data!.docs[index]['mission_name'],
                    //               style: const TextStyle(
                    //                   fontSize: 30,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // );
                  });
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
