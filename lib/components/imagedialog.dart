import 'package:flutter/material.dart';

// Code to Show Image Widget
class ImageDialog extends StatelessWidget {
  final String imageUrl;

  ImageDialog(this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.contain,
          )

              // image: DecorationImage(
              //   image: NetworkImage(imageUrl),
              //   fit: BoxFit.contain,
              // ),
              ),
        ),
      ),
    );
  }
}
