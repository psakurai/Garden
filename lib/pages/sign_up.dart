import 'package:flutter/material.dart';
import 'package:garden/components/header_widget.dart';
import 'package:garden/components/loading.dart';
import 'package:garden/pages/email_verify.dart';
import 'package:garden/utils/theme_helper.dart';
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
  String Expertise = "";
  bool _obscured = false;

  String _selectedExpertise = "Beginner";
  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    double headerHeight = 300;
    return loading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: const Text('Garden'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
                child: Column(
              children: [
                SizedBox(
                  height: headerHeight,
                  child:
                      HeaderWidget(headerHeight, true, Icons.password_rounded),
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
                              'Sign Up',
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
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 4, 0),
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
                            DropdownButtonFormField(
                              value: _selectedExpertise,
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior
                                    .never, //Hides label on focus or if filled
                                labelText: "Expertise",
                                hintText: 'Expertise',
                                filled: true, // Needed for adding a fill color
                                fillColor: Colors.grey,
                                isDense: true, // Reduces height a bit
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none, // No border
                                  borderRadius: BorderRadius.circular(
                                      12), // Apply corner radius
                                ),
                                prefixIcon:
                                    const Icon(Icons.grade_rounded, size: 24),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: "Beginner",
                                  child: Text("Beginner"),
                                ),
                                DropdownMenuItem(
                                  value: "Intermediate",
                                  child: Text("intermediate"),
                                ),
                                DropdownMenuItem(
                                  value: "Expert",
                                  child: Text("Expert"),
                                ),
                              ],
                              onChanged: (Expertise) {
                                setState(() {
                                  _selectedExpertise = Expertise!;
                                });
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
                                child: const Text('Sign Up'),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    dynamic result =
                                        await _auth.signUpEmailPassword(
                                            email,
                                            username,
                                            password,
                                            _selectedExpertise);
                                    if (result == null) {
                                      setState(() => error = 'error beb');
                                      loading = false;
                                    } else {
                                      // ignore: use_build_context_synchronously
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const VerifyEmail()),
                                      );
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
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14.0),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            )));
  }
}
