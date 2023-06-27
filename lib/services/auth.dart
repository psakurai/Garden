import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:flutter/material.dart';
import 'package:garden/services/database.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserData? _userFromFirebaseUser(User? user) {
    return user != null ? UserData(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<UserData?> get user {
    return _auth
        .authStateChanges()
        //.map((User? user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }

  // sign in anon
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      if (Foundation.kDebugMode) {
        print("TEST DEBUG MODE KE TAK");
      }
      return _userFromFirebaseUser(user);
    } catch (e) {
      if (Foundation.kDebugMode) {
        print(e.toString());
      }
      return null;
    }
  }

  // sign in email pass
  Future signInEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register email pass
  Future signUpEmailPassword(String email, String username, String password,
      String _selectedExpertise) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      //var userFirebase = _auth.currentUser;
      // int role = 1;
      // CollectionReference ref = FirebaseFirestore.instance.collection('users');
      // ref.doc(userFirebase!.uid).set({'email': email, 'role': role});
      await DatabaseService(uid: user!.uid).updateUserData(
          email, username, password, _selectedExpertise.toLowerCase(), 1);
      await DatabaseService(uid: user.uid).updateEmailPlayerData(email);
      await DatabaseService(uid: user.uid)
          .updateUsernamePlayerData(username, email);
      await DatabaseService(uid: user.uid).updateLevelData();
      await DatabaseService(uid: user.uid).initialUpdateGoldData();
      await DatabaseService(uid: user.uid).initialUpdateMissionData();
      await DatabaseService(uid: user.uid).initialUpdateSeedData();
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future createPlayer(String email, String username, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      //var userFirebase = _auth.currentUser;
      // int role = 1;
      // CollectionReference ref = FirebaseFirestore.instance.collection('users');
      // ref.doc(userFirebase!.uid).set({'email': email, 'role': role});
      await DatabaseService(uid: user!.uid)
          .updateUserData(email, username, password, 'beginner', 1);
      await DatabaseService(uid: user.uid).updateEmailPlayerData(email);
      await DatabaseService(uid: user.uid)
          .updateUsernamePlayerData(username, email);
      await DatabaseService(uid: user.uid).updateLevelData();
      await DatabaseService(uid: user.uid).initialUpdateGoldData();
      await DatabaseService(uid: user.uid).initialUpdateMissionData();
      await DatabaseService(uid: user.uid).initialUpdateSeedData();
      await sendVerificationEmail();
      await signOut();
      await signInEmailPassword("arifamiruddin@graduate.utm.my", "password");
      return 1;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Fluttertoast.showToast(
          msg: "Email sent successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20.0,
          backgroundColor: Colors.green.withOpacity(0.8),
          textColor: Colors.white);
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          fontSize: 20.0,
          backgroundColor: Colors.redAccent.withOpacity(0.8),
          textColor: Colors.white);
    }
  }

  Future<void> deleteAccount() async {
    try {
      User? userFirebase = FirebaseAuth.instance.currentUser;
      userFirebase!.delete();

      Fluttertoast.showToast(
          msg: "Account deleted successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20.0,
          backgroundColor: Colors.green.withOpacity(0.8),
          textColor: Colors.white);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deactivateAccountUsername(username) async {
    try {
      var playerUID = "";
      var accessLevel = "";
      var kk = FirebaseFirestore.instance
          .collection('usernamePlayer')
          .doc(username)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        playerUID = documentSnapshot.get('uid').toString();
        FirebaseFirestore.instance
            .collection('user')
            .doc(playerUID)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          accessLevel = documentSnapshot.get('access_level').toString();
          if (accessLevel != "0") {
            await FirebaseFirestore.instance
                .collection('user')
                .doc(playerUID)
                .update({
              'access_level': 69,
            });

            Fluttertoast.showToast(
                msg: "Account deactivated successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: "Admin account cannot be deactivated",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> reactivateAccountUsername(username) async {
    try {
      var accessLevel = "";
      var playerUID = "";
      var kk = FirebaseFirestore.instance
          .collection('usernamePlayer')
          .doc(username)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        playerUID = documentSnapshot.get('uid').toString();

        FirebaseFirestore.instance
            .collection('user')
            .doc(playerUID)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          accessLevel = documentSnapshot.get('access_level').toString();
          if (accessLevel != "0") {
            await FirebaseFirestore.instance
                .collection('user')
                .doc(playerUID)
                .update({
              'access_level': 1,
            });

            Fluttertoast.showToast(
                msg: "Account reactivated successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: "Admin account cannot be reactivated",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

//emailPlayer
  Future<void> deactivateAccountEmail(email) async {
    try {
      var accessLevel = "";
      var playerUID = "";
      var kk = FirebaseFirestore.instance
          .collection('emailPlayer')
          .doc(email)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        playerUID = documentSnapshot.get('uid').toString();
        FirebaseFirestore.instance
            .collection('user')
            .doc(playerUID)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          accessLevel = documentSnapshot.get('access_level').toString();
          if (accessLevel != "0") {
            await FirebaseFirestore.instance
                .collection('user')
                .doc(playerUID)
                .update({
              'access_level': 69,
            });

            Fluttertoast.showToast(
                msg: "Account deactivated successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: "Admin account cannot be deactivated",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> reactivateAccountEmail(email) async {
    try {
      var accessLevel = "";
      var playerUID = "";
      var kk = FirebaseFirestore.instance
          .collection('emailPlayer')
          .doc(email)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        playerUID = documentSnapshot.get('uid').toString();

        FirebaseFirestore.instance
            .collection('user')
            .doc(playerUID)
            .get()
            .then((DocumentSnapshot documentSnapshot) async {
          accessLevel = documentSnapshot.get('access_level').toString();
          if (accessLevel != "0") {
            await FirebaseFirestore.instance
                .collection('user')
                .doc(playerUID)
                .update({
              'access_level': 1,
            });

            Fluttertoast.showToast(
                msg: "Account reactivated successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: "Admin account cannot be reactivated",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteEmailPlayer(String email) async {
    try {
      var accessLevel = "";
      var playerUID = "";
      var password = "";
      var kk = FirebaseFirestore.instance
          .collection('emailPlayer')
          .doc(email)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        playerUID = documentSnapshot.get('uid').toString();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(playerUID)
            .get()
            .then((DocumentSnapshot documentSnapshot2) async {
          password = documentSnapshot2.get('password').toString();
          accessLevel = documentSnapshot2.get('access_level').toString();
          if (accessLevel != "0") {
            UserCredential result = await _auth.signInWithEmailAndPassword(
                email: email, password: password);
            User? userFirebase = result.user;
            userFirebase!.delete();
            await signOut();
            await signInEmailPassword(
                "arifamiruddin@graduate.utm.my", "Hololo122");
            Fluttertoast.showToast(
                msg: "Account deleted successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: "Admin account cannot be deleted",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteUsernamePlayer(String username) async {
    try {
      var accessLevel = "";
      var playerUID = "";
      var password = "";
      var email = "";
      var kk = FirebaseFirestore.instance
          .collection('usernamePlayer')
          .doc(username)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        playerUID = documentSnapshot.get('uid').toString();
        email = documentSnapshot.get('email').toString();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(playerUID)
            .get()
            .then((DocumentSnapshot documentSnapshot2) async {
          password = documentSnapshot2.get('password').toString();
          accessLevel = documentSnapshot2.get('access_level').toString();
          if (accessLevel != "0") {
            UserCredential result = await _auth.signInWithEmailAndPassword(
                email: email, password: password);
            User? userFirebase = result.user;
            userFirebase!.delete();
            await signOut();
            await signInEmailPassword(
                "arifamiruddin@graduate.utm.my", "password");

            Fluttertoast.showToast(
                msg: "Account deleted successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          } else {
            Fluttertoast.showToast(
                msg: "Admin account cannot be deleted",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                fontSize: 20.0,
                backgroundColor: Colors.green.withOpacity(0.8),
                textColor: Colors.white);
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      Fluttertoast.showToast(
          msg: "Email sent successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20.0,
          backgroundColor: Colors.green.withOpacity(0.8),
          textColor: Colors.white);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addDistance(double distance, double speed) async {
    try {
      var userFirebase = _auth.currentUser;
      var kk = FirebaseFirestore.instance
          .collection('user')
          .doc(userFirebase!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        String username = documentSnapshot.get('username').toString();

        await DatabaseService(uid: userFirebase!.uid)
            .updateDistanceData(distance, speed, username);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void addPlayerAccount(String email, String username, String password) async {
    try {
      _auth.createUserWithEmailAndPassword(email: email, password: password);
      Fluttertoast.showToast(
          msg: "Account added successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20.0,
          backgroundColor: Colors.green.withOpacity(0.8),
          textColor: Colors.white);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<void> updatePlayerUsername(String email, String username) async {
    try {
      var playerUID = "";
      var kk = FirebaseFirestore.instance
          .collection('emailPlayer')
          .doc(email)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        playerUID = documentSnapshot.get('uid').toString();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(playerUID)
            .update({
          'username': username,
        });

        await FirebaseFirestore.instance
            .collection('usernamePlayer')
            .doc(username)
            .set({
          'uid': playerUID,
          'email': email,
        });

        Fluttertoast.showToast(
            msg: "Username updated successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            fontSize: 20.0,
            backgroundColor: Colors.green.withOpacity(0.8),
            textColor: Colors.white);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> updatePlayerDetails(String username, String expertise) async {
    try {
      String missionName = "";
      String missionDescription = "";
      int missionDistance = 0;
      int missionStatus = 0;

      User? userFirebase = FirebaseAuth.instance.currentUser;
      print(username);
      print(expertise);
      await FirebaseFirestore.instance
          .collection('user')
          .doc(userFirebase!.uid)
          .update({
        'username': username,
        'expertise_name': expertise.toLowerCase()
      });
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
            FirebaseFirestore.instance
                .collection('mission')
                .doc(userFirebase.uid)
                .collection('whichmission')
                .doc(userFirebase.uid + i.toString())
                .set({
              'mission_name': missionName,
              'mission_description': missionDescription,
              'mission_distance': missionDistance + i,
              'mission_status': missionStatus,
            });
          }
        }
      });
      Fluttertoast.showToast(
          msg: "Player details updated successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20.0,
          backgroundColor: Colors.green.withOpacity(0.8),
          textColor: Colors.white);
    } catch (e) {
      print(e.toString());
    }
  }
}
