import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference gardenCollection =
      FirebaseFirestore.instance.collection('user');

  final CollectionReference gardenCollectionUsernamePlayer =
      FirebaseFirestore.instance.collection('usernamePlayer');

  final CollectionReference gardenCollectionemailPlayer =
      FirebaseFirestore.instance.collection('emailPlayer');

  final CollectionReference gardenCollectionTotalDistance =
      FirebaseFirestore.instance.collection('totaldistance');

  final CollectionReference gardenCollectionDistanceHistory =
      FirebaseFirestore.instance.collection('distanceHistory');

  final CollectionReference gardenCollectionLevel =
      FirebaseFirestore.instance.collection('level');

  final CollectionReference gardenCollectionGold =
      FirebaseFirestore.instance.collection('gold');

  final CollectionReference gardenCollectionMission =
      FirebaseFirestore.instance.collection('mission');

  final CollectionReference gardenCollectionSeed =
      FirebaseFirestore.instance.collection('seed');

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

  Future updateUsernamePlayerData(String username, String email) async {
    return await gardenCollectionUsernamePlayer.doc(username).set({
      'uid': uid,
      'email': email,
    });
  }

  Future updateEmailPlayerData(String email) async {
    return await gardenCollectionemailPlayer.doc(email).set({
      'uid': uid,
    });
  }

  Future deleteEmailPlayerData(String email) async {
    return await gardenCollectionemailPlayer.doc(email).set({
      'uid': uid,
    });
  }

  Future deleteUsernamePlayerData(String email) async {}

  // total distance
  Future<void> updateDistanceData(
      double distance, double speed, String username) async {
    double currentDistance = 0.0;
    double pace = 0.0;
    User? userFirebase = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('totaldistance')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        currentDistance = documentSnapshot.get('distance');
        distance += currentDistance;
        pace = speed / distance;

        await gardenCollectionTotalDistance.doc(userFirebase.uid).set({
          'distance': distance,
          'speed': speed,
          'pace': pace,
          'username': username,
        });
      } else {
        await gardenCollectionTotalDistance.doc(userFirebase.uid).set({
          'distance': distance,
          'speed': speed,
          'pace': pace,
          'username': username,
        });
      }
    });
  }

  // all distance
  // error sebab dia rewrite data bukan add new doc
  Future<void> updateDistanceHistoryData(double distance, double speed) async {
    User? userFirebase = FirebaseAuth.instance.currentUser;
    final querySnapshot = await gardenCollectionDistanceHistory
        .doc(userFirebase!.uid)
        .collection('distance')
        .get();
    int distanceID = querySnapshot.docs.length;
    if (querySnapshot.docs.isEmpty) {
      distanceID = 0;
    }

    gardenCollectionDistanceHistory
        .doc(userFirebase.uid)
        .collection('distance')
        .doc(userFirebase.uid + distanceID.toString())
        .set({
      'distance': distance,
      'speed': speed,
      'pace': speed / distance,
    });
  }

  // function tambah level, tapi make sure call after update distance, sebab level call value distance
  Future updateLevelData() async {
    int? level = 1;
    User? userFirebase = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('totaldistance')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        if (documentSnapshot.get('distance').toInt() > 1) {
          level = documentSnapshot.get('distance').toInt();
          await gardenCollectionLevel.doc(uid).set({
            'level': level,
          });
        } else {
          await gardenCollectionLevel.doc(uid).set({
            'level': level,
          });
        }
      } else {
        await gardenCollectionLevel.doc(uid).set({
          'level': level,
        });
      }
    });
  }

  Future initialUpdateGoldData() async {
    int gold = 0;
    //User? userFirebase = FirebaseAuth.instance.currentUser;
    // var kk = FirebaseFirestore.instance
    //     .collection('gold')
    //     .doc(userFirebase!.uid)
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //   if (documentSnapshot.exists) {
    //     gold = int.tryParse(documentSnapshot.get('distance').toString());
    //   }
    // });
    return await gardenCollectionGold.doc(uid).set({
      'gold': gold,
    });
  }

  Future updateGoldData(double distance) async {
    int currentGold = 0;
    int distanceToGold = 0;
    User? userFirebase = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('gold')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        currentGold = documentSnapshot.get('gold');
        distanceToGold = currentGold + (distance * 10).toInt();
        await gardenCollectionGold.doc(userFirebase.uid).set({
          'gold': distanceToGold,
        });
      } else {
        await gardenCollectionGold.doc(userFirebase.uid).set({
          'gold': distanceToGold,
        });
      }
    });
  }

  //3,4,5   5,6,7    8,9,10
  Future<void> initialUpdateMissionData() async {
    String missionName = "";
    String missionDescription = "";
    int missionDistance = 0;
    int missionStatus = 0;
    User? userFirebase = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('user')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        String expertiseName =
            documentSnapshot.get('expertise_name').toString();

        for (int i = 0; i < 3; i++) {
          if (expertiseName == "beginner") {
            missionDistance = 3;
            missionName = "Complete $missionDistance KM";
            missionDescription = "Player has complete $missionDistance KM.";
          }
          if (expertiseName == "intermediate") {
            missionDistance = 5;
            missionName = "Complete $missionDistance KM";
            missionDescription = "Player has complete $missionDistance KM.";
          }
          if (expertiseName == "expert") {
            missionDistance = 8;
            missionName = "Complete $missionDistance KM";
            missionDescription = "Player has complete $missionDistance KM.";
          }
          gardenCollectionMission
              .doc(uid)
              .collection('whichmission')
              .doc(uid + i.toString())
              .set({
            'mission_name': missionName,
            'mission_description': missionDescription,
            'mission_distance': missionDistance + i,
            'mission_status': missionStatus,
          });
        }
      }
    });
  }

  Future<void> initialUpdateSeedData() async {
    String seedName = "";
    int seedPrice = 0;
    int seedStatus = 0;
    User? userFirebase = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('user')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot2) {
      for (int i = 0; i < 3; i++) {
        if (i == 0) {
          seedName = "Coconut seed";
          seedPrice = 150;
        } else if (i == 1) {
          seedName = "Banana seed";
          seedPrice = 750;
        } else if (i == 2) {
          seedName = "Rambutan seed";
          seedPrice = 950;
        }
        gardenCollectionSeed
            .doc(uid)
            .collection('whichseed')
            .doc(uid + i.toString())
            .set({
          'seed_name': seedName,
          'seed_price': seedPrice,
          'seed_status': seedStatus,
        });
      }
    });
  }

  //expertise_name, mission id ni index mission(bergantung pada expertise, dengan berapa value mission dia nak)
  Future<void> updateMissionStatusData(int missionID, int pass) async {
    User? userFirebase = FirebaseAuth.instance.currentUser;
    var kk = FirebaseFirestore.instance
        .collection('mission')
        .doc(userFirebase!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        gardenCollectionMission
            .doc(uid)
            .collection('whichmission')
            .doc(uid + missionID.toString())
            .update({
          'mission_status': pass,
        });
      }
    });
  }

  Future<void> updateSeedStatusData(int seedID, int newGold) async {
    String seedName = "";
    int seedPrice = 0;
    int seedStatus = 0;
    User? userFirebase = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('seed')
        .doc(userFirebase!.uid)
        .collection('whichseed')
        .doc(userFirebase.uid + seedID.toString())
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists) {
        seedName = (documentSnapshot.get('seed_name').toString());
        seedPrice = int.parse(documentSnapshot.get('seed_price').toString());

        await gardenCollectionSeed
            .doc(uid)
            .collection('whichseed')
            .doc(uid + seedID.toString())
            .set({
          'seed_name': seedName,
          'seed_price': seedPrice,
          'seed_status': 1,
        });
        await gardenCollectionGold.doc(userFirebase.uid).set({
          'gold': newGold,
        });
      }
    });
  }

  Stream<QuerySnapshot> get user {
    return gardenCollection.snapshots();
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
