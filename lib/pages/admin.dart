import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden/components/header_widget.dart';
import 'package:garden/pages/sign_in.dart';
import 'package:garden/services/auth.dart';
import 'package:garden/utils/styles.dart';
import 'package:provider/provider.dart';
import 'package:garden/services/database.dart';

class Admin extends StatefulWidget {
  Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String username = "";
  String password = "";
  String error = "";
  bool loading = false;
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    double headerHeight = 150;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          elevation: 0.0,
          title: const Text('Admin Control Panel'),
          centerTitle: true,
          automaticallyImplyLeading: false,
          actionsIconTheme: const IconThemeData(color: Colors.white, size: 25),
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: headerHeight,
                child:
                    HeaderWidget(headerHeight, false, Icons.password_rounded),
              ),
              Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 50.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior
                                .never, //Hides label on focus or if filled
                            labelText: "Email",
                            hintText: 'email@gmail.com',
                            filled: true, // Needed for adding a fill color
                            fillColor: Colors.grey[400],
                            isDense: true, // Reduces height a bit
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // No border
                              borderRadius: BorderRadius.circular(
                                  12), // Apply corner radius
                            ),
                            prefixIcon:
                                const Icon(Icons.email_rounded, size: 24),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? "Enter an email" : null,
                          onChanged: (val) {
                            setState(() => email = val);
                          },
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior
                                .never, //Hides label on focus or if filled
                            labelText: "Username",
                            hintText: 'Username',
                            filled: true, // Needed for adding a fill color
                            fillColor: Colors.grey[400],
                            isDense: true, // Reduces height a bit
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // No border
                              borderRadius: BorderRadius.circular(
                                  12), // Apply corner radius
                            ),
                            prefixIcon:
                                const Icon(Icons.person_rounded, size: 24),
                          ),
                          validator: (val) =>
                              (val!.length < 8 || val!.length > 21)
                                  ? "Enter a username 8 to 20 chars long"
                                  : null,
                          onChanged: (val) {
                            setState(() => username = val);
                          },
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior
                                .never, //Hides label on focus or if filled
                            labelText: "Password",
                            hintText: 'Password',
                            filled: true, // Needed for adding a fill color
                            fillColor: Colors.grey[400],
                            isDense: true, // Reduces height a bit
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none, // No border
                              borderRadius: BorderRadius.circular(
                                  12), // Apply corner radius
                            ),
                            prefixIcon:
                                const Icon(Icons.lock_rounded, size: 24),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                              child: GestureDetector(
                                onTap: _toggleObscured,
                                child: Icon(
                                  _obscured
                                      ? Icons.visibility_rounded
                                      : Icons.visibility_off_rounded,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _obscured,
                          validator: (val) =>
                              (val!.length < 8 || val!.length > 21)
                                  ? "Enter a password 8 to 20 chars long"
                                  : null,
                          onChanged: (val) {
                            setState(() => password = val);
                          },
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size.fromHeight(50),
                              primary: Colors.teal,
                              onPrimary: Colors.white,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Add Player'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);
                                dynamic result = await _auth.createPlayer(
                                    email, username, password);
                                if (result == null) {
                                  setState(() => error = 'error beb');
                                  loading = false;
                                } else {
                                  setState(() => error = '');
                                  loading = false;
                                }
                              }
                            }),
                        const SizedBox(
                          height: 12.0,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size.fromHeight(50),
                              primary: Colors.teal,
                              onPrimary: Colors.white,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Delete Player'),
                            onPressed: () async {
                              if (username.isNotEmpty) {
                                await _auth.deactivateAccountUsername(username);
                              } else if (email.isNotEmpty) {
                                await _auth.deleteEmailPlayer(email);
                              }
                            }),
                        const SizedBox(
                          height: 12.0,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size.fromHeight(50),
                              primary: Colors.teal,
                              onPrimary: Colors.white,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Deactivate Player'),
                            onPressed: () async {
                              if (username.isNotEmpty) {
                                await _auth.deactivateAccountUsername(username);
                              } else if (email.isNotEmpty) {
                                await _auth.deactivateAccountEmail(email);
                              }
                            }),
                        const SizedBox(
                          height: 12.0,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size.fromHeight(50),
                              primary: Colors.teal,
                              onPrimary: Colors.white,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Reactivate Player'),
                            onPressed: () async {
                              if (username.isNotEmpty) {
                                await _auth.reactivateAccountUsername(username);
                              } else if (email.isNotEmpty) {
                                await _auth.reactivateAccountEmail(email);
                              }
                            }),
                        const SizedBox(
                          height: 12.0,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20),
                              minimumSize: Size.fromHeight(50),
                              primary: Colors.teal,
                              onPrimary: Colors.white,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Update Username'),
                            onPressed: () async {
                              if (username.isNotEmpty) {
                                if (email.isNotEmpty) {
                                  await _auth.updatePlayerUsername(
                                      email, username);
                                }
                              }
                            }),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Text(
                          error,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14.0),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ));
  }
}
