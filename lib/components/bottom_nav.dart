import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden/location_page.dart';
import 'package:garden/pages/distance.dart';
import 'package:garden/utils/styles.dart';
import 'package:garden/pages/home.dart';
import 'package:garden/pages/shop.dart';
import 'package:garden/pages/profile.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../pages/admin.dart';
import '../pages/sign_in.dart';

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
    //const Map(),
    const OrderTrackingPage(),
    const Distance(),
    const Shop(),
    const UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: GoogleMap(
        //   onMapCreated: _onMapCreated,
        //   initialCameraPosition: CameraPosition(
        //     target: _center,
        //     zoom: 17.0,
        //   ),
        body: Center(child: pages.elementAt(selectedIndex)),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: SizedBox(
                  height: 110,
                  child: BottomNavigationBar(
                    currentIndex: selectedIndex,
                    onTap: onItemTapped,
                    selectedItemColor: Colors.teal,
                    unselectedItemColor: icon,
                    backgroundColor: const Color(0xff28292a),
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: '',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.view_list),
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
                ))));
  }
}
