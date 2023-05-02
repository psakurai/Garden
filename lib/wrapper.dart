import 'package:flutter/material.dart';
import 'package:garden/components/bottom_nav.dart';
import 'package:garden/models/user.dart';
import 'package:garden/pages/sign_in.dart';
import 'package:garden/services/access_level.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData?>(context);
    print(user);
    //return home or signin
    //return BottomNav();
    if (user == null) {
      return const UserSignIn();
    } else {
      return const AccessLevel();
    }
  }
}
