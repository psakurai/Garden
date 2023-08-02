import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garden/utils/styles.dart';

class Mission extends StatefulWidget {
  const Mission({super.key});

  @override
  MissionState createState() => MissionState();
}

class MissionState extends State<Mission> {
  String currentUsername = "";

  String? isExist;
  List<String> missionName = [];
  List<String> missionDescription = [];
  List<String> missionStatus = [];

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
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Mission',
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
                      );
                    } else {
                      return ListTile(
                        leading: const Icon(Icons.album,
                            color: Colors.red, size: 25),
                        title: Text(
                          snapshot.data!.docs[index]['mission_name'],
                        ),
                        subtitle: Text(
                          snapshot.data!.docs[index]['mission_description'],
                        ),
                        tileColor: Colors.red[100],
                      );
                    }
                  });
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
