import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' as Foundation;
import 'package:garden/services/database.dart';

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
  Future signUpEmailPassword(
      String email, String username, String password) async {
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

  Future<void> deleteAccount() async {
    try {
      User? userFirebase = FirebaseAuth.instance.currentUser;
      userFirebase!.delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deactivateAccountUsername(username) async {
    try {
      var playerUID = "";
      var kk = FirebaseFirestore.instance
          .collection('usernamePlayer')
          .doc(username)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        playerUID = documentSnapshot.get('uid').toString();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(playerUID)
            .update({
          'access_level': 69,
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> reactivateAccountUsername(username) async {
    try {
      var playerUID = "";
      var kk = FirebaseFirestore.instance
          .collection('usernamePlayer')
          .doc(username)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        playerUID = documentSnapshot.get('uid').toString();
        await FirebaseFirestore.instance
            .collection('user')
            .doc(playerUID)
            .update({
          'access_level': 1,
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

//emailPlayer
  Future<void> deactivateAccountEmail(email) async {
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
          'access_level': 69,
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> reactivateAccountEmail(email) async {
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
          'access_level': 1,
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteEmailPlayer(String email) async {
    try {
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

          UserCredential result = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          User? userFirebase = result.user;
          userFirebase!.delete();
          await signOut();
          await signInEmailPassword(
              "arifamiruddin@graduate.utm.my", "password");
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deleteUsernamePlayer(String username) async {
    try {
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

          UserCredential result = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          User? userFirebase = result.user;
          userFirebase!.delete();
          await signOut();
          await signInEmailPassword(
              "arifamiruddin@graduate.utm.my", "password");
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
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> addDistance(double distance, double speed) async {
    try {
      var userFirebase = _auth.currentUser;
      await DatabaseService(uid: userFirebase!.uid)
          .updateDistanceData(distance, speed);
    } catch (e) {
      print(e.toString());
    }
  }

  void addPlayerAccount(String email, String username, String password) async {
    try {
      _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
