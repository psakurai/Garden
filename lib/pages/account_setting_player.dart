import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:garden/components/header_widget.dart';
import 'package:garden/services/auth.dart';
import 'package:garden/utils/styles.dart';

class AccountSettingPlayer extends StatefulWidget {
  const AccountSettingPlayer({super.key});

  @override
  State<AccountSettingPlayer> createState() => _AccountSettingPlayerState();
}

class _AccountSettingPlayerState extends State<AccountSettingPlayer> {
  final AuthService _auth = AuthService();
  String? isExist;
  String? expertiseName;
  String? username;

  String _selectedExpertise = "Beginner";
  List<DropdownMenuItem<String>> items = [
    const DropdownMenuItem(
      value: "Beginner",
      child: Text("Beginner"),
    ),
    const DropdownMenuItem(
      value: "Intermediate",
      child: Text("Intermediate"),
    ),
    const DropdownMenuItem(
      value: "Advanced",
      child: Text("Advanced"),
    ),
  ];

  Future<void> getUserData() async {
    User? userFirebase = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('user')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        expertiseName = documentSnapshot.get('expertise_name').toString();
        username = documentSnapshot.get('username').toString();

        setState(() {
          isExist = documentSnapshot.get('access_level').toString();
        });
      } else {
        isExist = null;
      }
    });
  }

  Future<void> updatePlayerDetails(String username, String expertise) async {
    try {
      User? userFirebase = FirebaseAuth.instance.currentUser;
      print(username);
      print(expertise);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userFirebase!.uid)
          .update({'username': username, 'expertise_name': expertise});

      Fluttertoast.showToast(
          msg: "Player details updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20.0,
          backgroundColor: Colors.green.withOpacity(0.8),
          textColor: Colors.white);
    } catch (e) {
      print(e.toString());
    }
  }

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
          actionsIconTheme: const IconThemeData(color: Colors.white, size: 25),
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
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior
                                          .never, //Hides label on focus or if filled
                                      labelText: "Username",
                                      hintText: 'Username',
                                      filled:
                                          true, // Needed for adding a fill color
                                      fillColor: Colors.grey[400],
                                      isDense: true, // Reduces height a bit
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide.none, // No border
                                        borderRadius: BorderRadius.circular(
                                            12), // Apply corner radius
                                      ),
                                      prefixIcon: const Icon(
                                          Icons.person_rounded,
                                          size: 24),
                                    ),
                                    validator: (val) => (val!.length < 8 ||
                                            val!.length > 21)
                                        ? "Enter a username 8 to 20 chars long"
                                        : null,
                                    onChanged: (val) {
                                      setState(() => username = val);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 12.0,
                                  ),
                                  DropdownButtonFormField(
                                    value: _selectedExpertise,
                                    decoration: InputDecoration(
                                      floatingLabelBehavior: FloatingLabelBehavior
                                          .never, //Hides label on focus or if filled
                                      labelText: "Expertise",
                                      hintText: 'Expertise',
                                      filled:
                                          true, // Needed for adding a fill color
                                      fillColor: Colors.grey[400],
                                      isDense: true, // Reduces height a bit
                                      border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide.none, // No border
                                        borderRadius: BorderRadius.circular(
                                            12), // Apply corner radius
                                      ),
                                      prefixIcon: const Icon(
                                          Icons.grade_rounded,
                                          size: 24),
                                    ),
                                    items: items,
                                    onChanged: (expertise) {
                                      setState(() {
                                        _selectedExpertise = expertise!;
                                      });
                                    },
                                  ),
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
                                        'Update details',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          //backgroundColor: Colors.green,
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (username!.isNotEmpty) {
                                          if (username!.length < 21 &&
                                              username!.length > 7) {
                                            print(username);
                                            print(_selectedExpertise);
                                            await _auth.updatePlayerDetails(
                                                username!, _selectedExpertise);
                                          }
                                        }
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
                                        'Forgot Password',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          //backgroundColor: Colors.green,
                                        ),
                                      ),
                                      onPressed: () {}),
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
