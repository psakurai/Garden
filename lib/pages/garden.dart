import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garden/utils/styles.dart';

class PlayerGarden extends StatefulWidget {
  const PlayerGarden({super.key});

  @override
  PlayerGardenState createState() => PlayerGardenState();
}

class PlayerGardenState extends State<PlayerGarden> {
  String currentUsername = "";

  String? isExist;
  List<String> seedName = [];
  List<String> seedPrice = [];
  List<String> seedStatus = [];

  Future<void> getSeedData() async {
    seedName.clear();
    seedPrice.clear();
    seedStatus.clear();
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

    CollectionReference<Map<String, dynamic>>;
  }

  late CollectionReference<Map<String, dynamic>> ref;
  @override
  void initState() {
    super.initState();
    User? userFirebase = FirebaseAuth.instance.currentUser;
    ref = FirebaseFirestore.instance
        .collection('seed')
        .doc(userFirebase!.uid)
        .collection('whichseed');
    getSeedData();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Garden',
        ),
      ),
      body: StreamBuilder(
          stream: ref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data!.docs[index]['seed_status'] == 1) {
                      return ListTile(
                        leading: const Icon(Icons.album,
                            color: Colors.green, size: 25),
                        title: Text(
                          snapshot.data!.docs[index]['seed_name'],
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal,
                            onPrimary: Colors.white,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('View Seed'),
                          onPressed: () {},
                        ),
                        tileColor: Colors.green[100],
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
