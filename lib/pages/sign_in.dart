import 'package:flutter/material.dart';
import 'package:garden/components/bottom_nav.dart';
import 'package:garden/onboard_screen/onboarding.dart';
import 'package:garden/pages/forgot_password.dart';
import 'package:garden/pages/sign_up.dart';
import 'package:garden/services/access_level.dart';
import 'package:garden/services/auth.dart';
import 'package:garden/components/loading.dart';
import 'package:garden/utils/styles.dart';

import 'package:garden/components/header_widget.dart';
import 'package:garden/utils/theme_helper.dart';

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
  //final textFieldFocusNode = FocusNode();
  bool _obscured = false;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      // if (textFieldFocusNode.hasPrimaryFocus)
      //   return; // If focus is on text field, dont unfocus
      // textFieldFocusNode.canRequestFocus =
      //     false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    double headerHeight = 150;
    return loading
        ? const Loading()
        : Scaffold(
            backgroundColor: background,
            appBar: AppBar(
              backgroundColor: Colors.teal,
              elevation: 0.0,
              title: const Text('Garden'),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            body: SingleChildScrollView(
                child: Column(children: [
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
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Sign In',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              //fontFamily: 'Satoshi',
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? "Enter an email" : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
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
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: _obscured,
                            //focusNode: textFieldFocusNode,
                            validator: (val) =>
                                (val!.length < 8 || val.length > 21)
                                    ? "Enter a password 8 to 20 chars long"
                                    : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
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
                          ),
                          const SizedBox(
                            height: 20.0,
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
                              child: const Text('Sign In '),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() => loading = true);
                                  dynamic result = await _auth
                                      .signInEmailPassword(email, password);
                                  if (result == null) {
                                    setState(() => error =
                                        'Could not sign in with those credentials.');
                                    loading = false;
                                  } else {
                                    setState(() => error = '');

                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AccessLevel()),
                                    );
                                    loading = false;
                                  }
                                }
                              }),
                          const SizedBox(
                            height: 10.0,
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
                              child: const Text('Register An Account'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const UserSignup()),
                                );
                              }),
                          const SizedBox(
                            height: 10.0,
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
                              child: const Text('Forgot Password'),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()),
                                );
                              }),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 14.0),
                          ),
                        ],
                      ),
                    ),
                  )),
            ])));
  }
}
