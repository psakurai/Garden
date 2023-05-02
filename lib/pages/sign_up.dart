import 'package:flutter/material.dart';
import 'package:garden/components/loading.dart';

import '../services/auth.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String username = "";
  String password = "";
  String error = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: const Text('Dah sign in'),
            ),
            body: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "Enter an email" : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      TextFormField(
                        validator: (val) =>
                            (val!.length < 8 || val!.length > 21)
                                ? "Enter a username 8 to 20 chars long"
                                : null,
                        onChanged: (val) {
                          setState(() => username = val);
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) =>
                            (val!.length < 8 || val!.length > 21)
                                ? "Enter a password 8 to 20 chars long"
                                : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      ElevatedButton(
                          child: const Text('SIgn up '),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.signUpEmailPassword(
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
                      Text(
                        error,
                        style:
                            const TextStyle(color: Colors.red, fontSize: 14.0),
                      )
                    ],
                  ),
                )),
          );
  }
}
