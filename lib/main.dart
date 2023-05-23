// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'components/bottom_nav.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: BottomNav(),
//     );
//   }
// }

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'location_page.dart';
import 'wrapper.dart';
import 'package:provider/provider.dart';
import 'services/auth.dart';
import 'models/user.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   runApp(MyApp());
// }

// void main() => runApp(MyApp());
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return const MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   //home: BottomNav(),
    //   home: Wrapper(),
    // );
    return StreamProvider<UserData?>.value(
      initialData: null,
      value: AuthService().user,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
        //home: OrderTrackingPage(),
      ),
    );
  }
}

// return StreamProvider<Customer?>.value(
//       initialData: null,
//       value: AuthService().customer,
//       child: MaterialApp(
//         home: const Wrapper(),
//       ),
//     )
