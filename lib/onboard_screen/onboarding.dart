import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:garden/pages/sign_in.dart';
import 'package:garden/onboard_screen/data.dart';
import 'package:sizer/sizer.dart';

import '../services/access_level.dart';
import '../utils/styles.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  List<SliderModel> mySlides = <SliderModel>[];
  PageController? controller;
  int slectIndex = 0;
  Future<void> checkWhichScreen() async {
    User? userFirebase = FirebaseAuth.instance.currentUser;
    print(userFirebase);
    if (userFirebase == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const UserSignIn()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const AccessLevel()));
    }
  }

  @override
  void initState() {
    mySlides = getSlides();
    controller = PageController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height - 100;
    return Scaffold(
      body: Container(
        height: height,
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              slectIndex = index;
            });
          },
          children: <Widget>[
            SlideTile(
              index: 0,
              imagePath: mySlides[0].getImageassetPath(),
              title: mySlides[0].getTitle(),
              desc: mySlides[0].desc,
            ),
            SlideTile(
              index: 1,
              imagePath: mySlides[1].getImageassetPath(),
              title: mySlides[1].getTitle(),
              desc: mySlides[1].desc,
            ),
            SlideTile(
              index: 2,
              imagePath: mySlides[2].getImageassetPath(),
              title: mySlides[2].getTitle(),
              desc: mySlides[2].desc,
            ),
          ],
        ),
      ),
      bottomSheet: slectIndex != 2
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 12),
              child: Container(
                height: 8.5.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: const Color(0xff28292a),
                    borderRadius: BorderRadius.circular(45),
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 2,
                          color: const Color(0xff28292a),
                          offset: Offset(3, 3),
                          blurRadius: 15)
                    ]),
                margin: EdgeInsets.only(bottom: 6.h),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff28292a),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                  ),
                  onPressed: () {
                    print("this is slideIndex: $slectIndex");
                    controller!.animateToPage(slectIndex + 1,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.linear);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(),
                        const Text(
                          "NEXT",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        Image.asset(
                          'assets/images/next.png',
                          height: 5.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 15),
              child: Container(
                height: 8.5.h,
                width: 100.w,
                decoration: BoxDecoration(
                    color: const Color(0xff28292a),
                    borderRadius: BorderRadius.circular(45),
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 2,
                          color: const Color(0xff28292a),
                          offset: Offset(3, 3),
                          blurRadius: 15)
                    ]),
                margin: EdgeInsets.only(bottom: 6.h),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff28292a),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45.0),
                    ),
                  ),
                  onPressed: () {
                    checkWhichScreen();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Get Started",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        Image.asset(
                          'assets/images/next.png',
                          height: 5.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class SlideTile extends StatelessWidget {
  String? imagePath, title, desc;
  int? index;

  SlideTile(
      {Key? key, this.imagePath, this.title, this.desc, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
              height: 48.5.h,
              width: 100.w,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.shade100,
                      spreadRadius: 0,
                      offset: Offset(3, 3),
                      blurRadius: 10)
                ],
                borderRadius: BorderRadius.circular(38),
                // image: DecorationImage(
                //   image: AssetImage(imagePath!,),fit: BoxFit.cover,
                // )
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    Image.asset(
                      imagePath!,
                      height: index == 0 ? 40.h : 35.h,
                    ),
                  ],
                ),
              )),
          SizedBox(
            height: 3.4.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
                color: const Color(0xff28292a),
              ),
            ),
          ),
          SizedBox(
            height: 1.h,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              desc!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 12.sp,
                color: const Color(0xff28292a),
              ),
            ),
          )
        ],
      ),
    );
  }
}
