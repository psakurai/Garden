import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden/components/header_widget.dart';
import 'package:garden/pages/sign_in.dart';
import 'package:garden/services/access_level.dart';
import 'package:garden/utils/styles.dart';
import 'package:garden/utils/theme_helper.dart';

import '../services/auth.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  bool canResendEmail = true;
  final _formKey = GlobalKey<FormState>();
  Timer? timer;
  final AuthService _auth = AuthService();

  double headerHeight = 300;

  @override
  void initState() {
    super.initState();
    _auth.sendVerificationEmail();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const AccessLevel()
      : Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0.0,
            automaticallyImplyLeading: false,
          ),
          endDrawer: Drawer(
            width: MediaQuery.of(context).size.width * 0.5,
            child: ListView(
              // Important: Remove any padding from the ListView.
              // padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.delete_forever),
                  title: const Text('Delete Account'),
                  onTap: () async {
                    //Navigator.pop(context);
                    await _auth.deleteAccount();
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const UserSignIn()),
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
                      MaterialPageRoute(
                          builder: (context) => const UserSignIn()),
                    );
                  },
                ),
              ],
            ),
          ),
          backgroundColor: background,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: headerHeight,
                  child: HeaderWidget(headerHeight, true, Icons.email_rounded),
                ),
                SafeArea(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Please verify your email',
                                style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54),
                                // textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'We will email you a verification code to check your authenticity.',
                                style: TextStyle(
                                  color: Colors.black38,
                                  // fontSize: 20,
                                ),
                                // textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  onPressed: canResendEmail
                                      ? () async {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            _auth.sendVerificationEmail();
                                            setState(
                                                () => canResendEmail = false);
                                            await Future.delayed(
                                                const Duration(seconds: 60));
                                            setState(
                                                () => canResendEmail = true);
                                          }
                                        }
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      "Send".toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ));
}
