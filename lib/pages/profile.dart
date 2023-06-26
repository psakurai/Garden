import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden/components/header_widget.dart';
import 'package:garden/pages/badge.dart';
import 'package:garden/pages/garden.dart';
import 'package:garden/pages/mission.dart';
import 'package:garden/pages/ranking.dart';
import 'package:garden/pages/sign_in.dart';
import 'package:garden/services/auth.dart';
import 'package:garden/utils/styles.dart';
import 'package:garden/components/heading.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthService _auth = AuthService();
  String? isExist;
  String? accessLevel;
  String? email;
  String? expertiseName;
  String? password;
  String? username;
  String? gold;
  String? level;
  List<String> missionName = [];
  List<String> missionDescription = [];
  List<String> missionStatus = [];

  Future<void> getUserData() async {
    User? userFirebase = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('user')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        accessLevel = documentSnapshot.get('access_level').toString();
        email = documentSnapshot.get('email').toString();
        expertiseName = documentSnapshot.get('expertise_name').toString();
        password = documentSnapshot.get('password').toString();
        username = documentSnapshot.get('username').toString();
        for (int i = 0; i < 3; i++) {
          FirebaseFirestore.instance
              .collection('mission')
              .doc(userFirebase!.uid + i.toString())
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            if (documentSnapshot.exists) {
              missionName.add(documentSnapshot.get('mission_name').toString());
              missionDescription
                  .add(documentSnapshot.get('mission_description').toString());
              missionStatus
                  .add(documentSnapshot.get('mission_status').toString());
            } else {
              isExist = null;
            }
          });
        }
        FirebaseFirestore.instance
            .collection('gold')
            .doc(userFirebase!.uid)
            .get()
            .then((DocumentSnapshot documentSnapshot2) {
          gold = documentSnapshot2.get('gold').toString();
          FirebaseFirestore.instance
              .collection('level')
              .doc(userFirebase!.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot3) {
            level = documentSnapshot3.get('level').toString();

            setState(() {
              isExist = documentSnapshot.get('access_level').toString();
            });
          });
        });
      } else {
        isExist = null;
      }
    });
  }

  // Future<void> getAllDistance() async {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection("collection").getDocuments();
  // for (int i = 0; i < querySnapshot.docs.length; i++) {
  //   var a = querySnapshot.docs[i];
  //   //print(a.distance);
  // }
  // }

  @override
  void initState() {
    getUserData();
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
          title: const Text('Profile'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actionsIconTheme: const IconThemeData(color: Colors.white, size: 25),
        ),
        endDrawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ListView(
            // Important: Remove any padding from the ListView.
            // padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(Icons.manage_accounts),
                title: const Text('Account Setting'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Delete Account'),
                onTap: () async {
                  //Navigator.pop(context);
                  await _auth.deleteAccount();
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserSignIn()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  //Navigator.pop(context);
                  await _auth.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const UserSignIn()),
                  );
                },
              ),
            ],
          ),
        ),
        backgroundColor: background,
        body: isExist == null
            ? const Center(child: Text("Loading"))
            : SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: headerHeight,
                    child: HeaderWidget(
                        headerHeight, false, Icons.password_rounded),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '  Hi $username!',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                //backgroundColor: Colors.green,
                              ),
                            ),
                          ],
                        ),
                        Row(children: [
                          Text(
                            '     Expertise: $expertiseName',
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              //backgroundColor: Colors.green,
                            ),
                          ),
                        ]),
                        const SizedBox(
                          height: 12.0,
                        ),
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
                                    subtitle: Text(gold!),
                                  ),
                                ),
                              ),
                              Card(
                                child: SizedBox(
                                  width: 170,
                                  height: 70,
                                  child: ListTile(
                                    leading: const Icon(Icons.album,
                                        color: Colors.cyan, size: 25),
                                    title: const Text("Level"),
                                    subtitle: Text(level!),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        textStyle: TextStyle(fontSize: 20),
                                        minimumSize: Size.fromHeight(50),
                                        primary: Colors.teal,
                                        onPrimary: Colors.white,
                                        elevation: 10,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'See All Ranking.',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          //backgroundColor: Colors.green,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Ranking()),
                                        );
                                      }),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: const Text(
                                        'See All Mission.',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          //backgroundColor: Colors.green,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Mission()),
                                        );
                                      }),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'See All Badge.',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          //backgroundColor: Colors.green,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PlayerBadge()),
                                        );
                                      }),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                      child: Text(
                                        'See ' + username! + "'s Garden",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          //backgroundColor: Colors.green,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PlayerGarden()),
                                        );
                                      }),
                                  // const SizedBox(
                                  //   height: 80,
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ));
  }
}
