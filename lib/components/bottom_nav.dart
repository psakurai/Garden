import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden/utils/styles.dart';
import 'package:garden/pages/home.dart';
import 'package:garden/pages/shop.dart';
import 'package:garden/pages/profile.dart';

import '../pages/admin.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _MyAppState();
}

class _MyAppState extends State<BottomNav> {
  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  List<Widget> pages = <Widget>[
    const Map(),
    const Shop(),
    UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    // User? userFirebase = FirebaseAuth.instance.currentUser;
    // var kk = FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(userFirebase!.uid)
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //     if (documentSnapshot.get('role') == 1) {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => const BottomNav()),
    //       );
    //     } else if (documentSnapshot.get('role') == 0) {
    //       Navigator.push(
    //         context,
    //         MaterialPageRoute(builder: (context) => Admin()),
    //       );
    //     }
    //   }
    // });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
          // body: GoogleMap(
          //   onMapCreated: _onMapCreated,
          //   initialCameraPosition: CameraPosition(
          //     target: _center,
          //     zoom: 17.0,
          //   ),
          body: Center(child: pages.elementAt(selectedIndex)),
          bottomNavigationBar: SizedBox(
            height: 94,
            child: BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: onItemTapped,
              selectedItemColor: accent,
              unselectedItemColor: icon,
              backgroundColor: white,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '',
                ),
              ],
            ),
          )),
    );
  }
}
