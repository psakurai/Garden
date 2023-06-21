import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
            setState(() {
              isExist = "Not null";
            });
          });
        }
      } else {
        isExist = null;
      }

      setState(() {
        isExist = documentSnapshot.get('access_level').toString();
      });
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

  Widget build(BuildContext context) {
    getUserData();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // title: const Text(
        //   'Navigation Drawer',
        // ),
        // backgroundColor: const Color(0xff764abc),
        automaticallyImplyLeading: false,
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
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'HI $username!',
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          //backgroundColor: Colors.green,
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.album),
                              Text('Card 1'),
                              Text('This is the first card.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person),
                              Text('Card 2'),
                              Text('This is the second card.'),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.person),
                              Text('Card 2'),
                              Text('This is the second card.'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.album),
                            Text('Mission :$expertiseName',
                                textAlign: TextAlign.left),
                            Text('This is the first card.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, position) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.album),
                                Text('Mission :$expertiseName',
                                    textAlign: TextAlign.left),
                                Text(
                                  'Distance: ${missionName[position]} KM',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, position) {
                        return const Card(
                          color: Colors.grey,
                          child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              '',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                      itemCount: missionName.length,
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
                            Icon(Icons.album),
                            Text('Card 1'),
                            Text('This is the first card.'),
                          ],
                        ),
                      ),
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
                            Icon(Icons.album),
                            Text('Card 1'),
                            Text('This is the first card.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
//Container(
      //   padding: EdgeInsets.only(left: medium, top: 50, right: medium),
      //   child: Column(
      //     //child: Row(
      //     children: <Widget>[
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Row(
      //             children: [
      //               Container(
      //                 decoration: BoxDecoration(
      //                   color: text,
      //                   borderRadius: BorderRadius.circular(100),
      //                   // image: const DecorationImage(
      //                   //   image: AssetImage('/assets/images/profile.png'),
      //                   // ),
      //                 ),
      //                 height: 50,
      //                 width: 50,
      //               ),
      //               SizedBox(width: small),
      //               Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text('Welcome, ', style: p1),
      //                   Text('$username', style: heading3),
      //                 ],
      //               ),
      //             ],
      //           ),
      //           Icon(Icons.notifications, color: icon, size: 28)
      //         ],
      //       ),
      //       // Container(
      //       //   decoration: BoxDecoration(
      //       //     color: text,
      //       //     borderRadius: BorderRadius.circular(100),
      //       //     // image: const DecorationImage(
      //       //     //   image: AssetImage('/assets/images/profile.png'),
      //       //     // ),
      //       //   ),
      //       //   height: 50,
      //       //   width: 50,
      //       // ),
      //       // SizedBox(width: small),
      //       // Column(
      //       //   crossAxisAlignment: CrossAxisAlignment.start,
      //       //   children: [
      //       //     Text('Welcome', style: p1),
      //       //     Text('Spellthorn', style: heading3),
      //       //   ],
      //       // ),
      //       //const HeadingSection(),
      //       SizedBox(height: medium),

      //       // const SearchSection(),
      //       // SizedBox(height: medium),
      //       // LabelSection(text: 'Recommended', style: heading1),
      //       // SizedBox(height: medium),
      //       // const Recommended(),
      //       // SizedBox(height: medium),
      //       // LabelSection(text: 'Top Desination', style: heading2),
      //       // SizedBox(height: medium),
      //       // const Top(),
      //     ],
      //   ),
      // ),
      // ),