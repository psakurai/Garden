// // import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'components/bottom_nav.dart';

// // void main() {
// //   runApp(const MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   const MyApp({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     return const MaterialApp(
// //       debugShowCheckedModeBanner: false,
// //       home: BottomNav(),
// //     );
// //   }
// // }

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'location_page.dart';
// import 'wrapper.dart';
// import 'package:provider/provider.dart';
// import 'services/auth.dart';
// import 'models/user.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // return const MaterialApp(
//     //   debugShowCheckedModeBanner: false,
//     //   //home: BottomNav(),
//     //   home: Wrapper(),
//     // );
//     return StreamProvider<UserData?>.value(
//       initialData: null,
//       value: AuthService().user,
//       child: const MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Wrapper(),
//         //home: OrderTrackingPage(),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garden/onboard_screen/onboarding.dart';
import 'package:garden/services/auth.dart';
import 'package:garden/wrapper.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData?>.value(
      initialData: null,
      value: AuthService().user,
      child: Sizer(
          builder: (BuildContext context, Orientation orientation,
                  DeviceType deviceType) =>
              MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Talking2Allah LMS',
                theme: ThemeData(
                    //primarySwatch: Colors.teal,
                    ),
                home: Wrapper(),
              )),
      // MaterialApp(
      //   debugShowCheckedModeBanner: false,
      //   home: OnBoardScreen(),
      //   //home: Wrapper(),
      //   //home: OrderTrackingPage(),
      // ),
    );
    // return Sizer(
    //     builder: (BuildContext context, Orientation orientation,
    //             DeviceType deviceType) =>
    //         MaterialApp(
    //           debugShowCheckedModeBanner: false,
    //           title: 'Talking2Allah LMS',
    //           theme: ThemeData(
    //             primarySwatch: Colors.blue,
    //           ),
    //           home: const OnBoardScreen(),
    //         ));
  }
}
