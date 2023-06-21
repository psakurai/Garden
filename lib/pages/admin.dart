import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: background,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actionsIconTheme: IconThemeData(color: Colors.black, size: 25),
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
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    filled: true,
                    fillColor: Colors.grey,
                    hintText: 'email@gmail.com',
                  ),
                  validator: (val) => val!.isEmpty ? "Enter an email" : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Username",
                      prefixIcon: Icon(Icons.person),
                      filled: true,
                      fillColor: Colors.grey,
                      hintText: "Username"),
                  validator: (val) => (val!.length < 8 || val!.length > 21)
                      ? "Enter a username 8 to 20 chars long"
                      : null,
                  onChanged: (val) {
                    setState(() => username = val);
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.password),
                      filled: true,
                      fillColor: Colors.grey,
                      hintText: "Password"),
                  obscureText: true,
                  validator: (val) => (val!.length < 8 || val!.length > 21)
                      ? "Enter a password 8 to 20 chars long"
                      : null,
                  onChanged: (val) {
                    setState(() => password = val);
                  },
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 20),
                      minimumSize: Size.fromHeight(50),
                    ),
                    child: const Text('Add Player'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => loading = true);
                        dynamic result =
                            await _auth.createPlayer(email, username, password);
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
                    ),
                    child: const Text('Update Detail'),
                    onPressed: () async {}),
                const SizedBox(
                  height: 12.0,
                ),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14.0),
                ),
              ],
            ),
          )),
    );
  }
}
