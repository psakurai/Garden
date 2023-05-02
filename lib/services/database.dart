import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference gardenCollection =
      FirebaseFirestore.instance.collection('user');

  Future updateUserData(String email, String username, String password,
      String expertiseName, int accessLevel) async {
    return await gardenCollection.doc(uid).set({
      'email': email,
      'username': username,
      'password': password,
      'expertise_name': expertiseName,
      'access_level': accessLevel,
    });
  }

  // User? userFirebase = FirebaseAuth.instance.currentUser;
  //   var kk = FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(userFirebase!.uid)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     if (documentSnapshot.exists) {
  //       if (documentSnapshot.get('role') == 1) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => const BottomNav()),
  //         );
  //       } else if (documentSnapshot.get('role') == 0) {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => Admin()),
  //         );
  //       }
  //     } else {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const UserSignIn()),
  //       );
  //     }
  //   });
  //   return Scaffold(
  //     backgroundColor: background,
  //   );
}
