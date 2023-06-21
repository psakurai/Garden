import 'package:flutter/material.dart';
import 'package:garden/pages/sign_in.dart';

import '../services/auth.dart';
import '../utils/styles.dart';

class Deactivated extends StatefulWidget {
  const Deactivated({super.key});

  @override
  State<Deactivated> createState() => _DeactivatedState();
}

class _DeactivatedState extends State<Deactivated> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
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
      body: const Center(
        child: Text("User has been banned from playing the game."),
      ),
    );
  }
}
