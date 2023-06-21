import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden/pages/deactivate.dart';
import 'package:garden/pages/email_verify.dart';
import 'package:garden/pages/sign_in.dart';
import '../pages/admin.dart';
import '../utils/styles.dart';
import '../components/bottom_nav.dart';

class AccessLevel extends StatefulWidget {
  const AccessLevel({super.key});

  @override
  State<AccessLevel> createState() => _MyAppState();
}

class _MyAppState extends State<AccessLevel> {
  @override
  Widget build(BuildContext context) {
    User? userFirebase = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('user')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (FirebaseAuth.instance.currentUser!.emailVerified == false) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VerifyEmail()),
          );
        } else if (documentSnapshot.get('access_level') == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BottomNav()),
          );
        } else if (documentSnapshot.get('access_level') == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Admin()),
          );
        } else if (documentSnapshot.get('access_level') == 69) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Deactivated()),
          );
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserSignIn()),
        );
      }
    });
    return Scaffold(
      backgroundColor: background,
    );
  }
}
