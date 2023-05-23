import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden/pages/sign_in.dart';
import 'package:garden/services/auth.dart';
import 'package:garden/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:garden/services/database.dart';

// class Admin extends StatelessWidget {
//   Admin({super.key});
//   final AuthService _auth = AuthService();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         // title: const Text(
//         //   'Navigation Drawer',
//         // ),
//         // backgroundColor: const Color(0xff764abc),
//         automaticallyImplyLeading: false,
//       ),
//       endDrawer: Drawer(
//         width: MediaQuery.of(context).size.width * 0.5,
//         child: ListView(
//           // Important: Remove any padding from the ListView.
//           // padding: EdgeInsets.zero,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.manage_accounts),
//               title: const Text('Account Setting'),
//               onTap: () {
//                 Navigator.pop(context);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Logout'),
//               onTap: () async {
//                 //Navigator.pop(context);
//                 await _auth.signOut();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => UserSignIn()),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: background,
//     );
//   }
// }

class Admin extends StatefulWidget {
  Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final AuthService _auth = AuthService();
  int test = 5;

  Future<void> getStart() async {
    User? userFirebase = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('user')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('access_level') == 1) {
          test = documentSnapshot.get('access_level');
        } else if (documentSnapshot.get('access_level') == 0) {
          test = documentSnapshot.get('access_level');
          print("object");
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserSignIn()),
        );
      }
    });
  }

  @override
  void initState() {
    getStart();
    super.initState();
  }

  Widget build(BuildContext context) {
    if (test == 5) {
      return Placeholder();
    } else {
      return Scaffold(
        body: Text('test: ${test.toString()}'),
        //backgroundColor: background,
      );
    }
    // return Scaffold(
    //     body: test == 5
    //         ? const Center(child: Text("Loading"))
    //         : Text('test: ${test.toString()}')
    //     //backgroundColor: background,
    //     );
  }
}
  //   return Scaffold(
  //     appBar: AppBar(
  //       centerTitle: true,
  //       // title: const Text(
  //       //   'Navigation Drawer',
  //       // ),
  //       // backgroundColor: const Color(0xff764abc),
  //       automaticallyImplyLeading: false,
  //     ),
  //     endDrawer: Drawer(
  //       width: MediaQuery.of(context).size.width * 0.5,
  //       child: ListView(
  //         // Important: Remove any padding from the ListView.
  //         // padding: EdgeInsets.zero,
  //         children: [
  //           ListTile(
  //             leading: const Icon(Icons.manage_accounts),
  //             title: const Text('Account Setting'),
  //             onTap: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //           ListTile(
  //             leading: const Icon(Icons.logout),
  //             title: const Text('Logout'),
  //             onTap: () async {
  //               await _auth.signOut();
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => UserSignIn()),
  //               );
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //     backgroundColor: background,
  //   );
  // }
//}
