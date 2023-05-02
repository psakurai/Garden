import 'package:flutter/material.dart';
import 'package:garden/pages/sign_up.dart';
import 'package:garden/services/auth.dart';
import 'package:garden/components/loading.dart';

class UserSignIn extends StatefulWidget {
  const UserSignIn({super.key});

  @override
  State<UserSignIn> createState() => _UserSignInState();
}

class _UserSignInState extends State<UserSignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = "";
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
              automaticallyImplyLeading: false,
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
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20),
                            minimumSize: Size.fromHeight(50),
                          ),
                          child: const Text('Sign in '),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.signInEmailPassword(
                                  email, password);
                              if (result == null) {
                                setState(() => error =
                                    'Could not sign in with those credentials.');
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
                      ),
                      // ElevatedButton(
                      //   child: const Text('SIgn in anon!'),
                      //   onPressed: () async {
                      //     dynamic result = await _auth.signInAnon();
                      //     if (result == null) {
                      //       print('CANNOT SIGNIN');
                      //     } else {
                      //       print('berjaya signin');
                      //       print(result.uid);
                      //     }
                      //   },
                      // ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20),
                            minimumSize: Size.fromHeight(50),
                          ),
                          child: const Text('Register'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const UserSignup()),
                            );
                          }),
                    ],
                  ),
                )),
          );
  }
}
