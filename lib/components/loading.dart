import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal[100],
      child: const Center(
          child: SpinKitThreeBounce(
        color: Colors.teal,
        size: 20.0,
      )),
    );
  }
}
