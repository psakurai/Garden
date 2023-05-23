import 'package:flutter/material.dart';
import 'package:garden/pages/sign_in.dart';
import 'package:garden/services/auth.dart';
import 'package:garden/utils/styles.dart';
import 'package:garden/components/heading.dart';

class UserProfile extends StatelessWidget {
  UserProfile({super.key});
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
              title: const Text('Logout'),
              onTap: () async {
                //Navigator.pop(context);
                await _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserSignIn()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: medium, top: 50, right: medium),
          child: Column(
            children: [
              const HeadingSection(),
              SizedBox(height: medium),
              // const SearchSection(),
              // SizedBox(height: medium),
              // LabelSection(text: 'Recommended', style: heading1),
              // SizedBox(height: medium),
              // const Recommended(),
              // SizedBox(height: medium),
              // LabelSection(text: 'Top Desination', style: heading2),
              // SizedBox(height: medium),
              // const Top(),
            ],
          ),
        ),
      ),
    );
  }
}
