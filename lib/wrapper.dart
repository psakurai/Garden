import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden/components/bottom_nav.dart';
import 'package:garden/models/user.dart';
import 'package:garden/onboard_screen/onboarding.dart';
import 'package:garden/pages/email_verify.dart';
import 'package:garden/pages/sign_in.dart';
import 'package:garden/services/access_level.dart';
import 'package:provider/provider.dart';

// class Wrapper extends StatelessWidget {
//   const Wrapper({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<UserData?>(context);
//     if (user == null) {
//       return const UserSignIn();
//     } else {
//       return const AccessLevel();
//     }
//   }
// }

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  User? userFirebase = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    if (userFirebase == null) {
      return const OnBoardScreen();
    } else {
      return const VerifyEmail();
      //return const AccessLevel();
    }
  }
}
