import 'package:flutter/material.dart';
import 'package:garden/pages/shop.dart';
// import 'package:garden/components/heading.dart';
// import 'package:garden/components/label_section.dart';
// import 'package:garden/components/recommended.dart';
// import 'package:garden/components/search.dart';
// import 'package:garden/components/top.dart';
import 'package:garden/utils/styles.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'profile.dart';
import 'shop.dart';

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: background,
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.only(left: medium, top: 50, right: medium),
//           child: Column(
//             children: [
//               const HeadingSection(),
//               SizedBox(height: medium),
//               // const SearchSection(),
//               // SizedBox(height: medium),
//               // LabelSection(text: 'Recommended', style: heading1),
//               // SizedBox(height: medium),
//               // const Recommended(),
//               // SizedBox(height: medium),
//               // LabelSection(text: 'Top Desination', style: heading2),
//               // SizedBox(height: medium),
//               // const Top(),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: SizedBox(
//         height: 94,
//         child: BottomNavigationBar(
//           currentIndex: 0,
//           selectedItemColor: accent,
//           unselectedItemColor: icon,
//           backgroundColor: white,
//           elevation: 0,
//           type: BottomNavigationBarType.fixed,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shopping_cart),
//               label: '',
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.person),
//               label: '',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:geolocator/geolocator.dart';

class Map extends StatefulWidget {
  const Map({super.key});
  @override
  State<Map> createState() => _MyAppState();
}

class _MyAppState extends State<Map> {
  late GoogleMapController mapController;
  String statusStartOrEnd = "Start";
  bool _isVisible = false;

  // final LatLng _center = const LatLng(1.5621690031757391, 103.62844728458849);
  final LatLng _center = const LatLng(1.5621690031757391, 103.62844728458849);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  int selectedIndex = 0;
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  // static const List<Widget> pages = <Widget>[
  //   Map(),
  //   Shop(),
  //   UserProfile(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 17.0,
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              textStyle: TextStyle(fontSize: 20),
              minimumSize: const Size.fromHeight(50),
            ),
            child: const Text('Total Distance: 0.45 KM'),
            onPressed: () async {}),
        SlidingUpPanel(
          panel: Stack(
            children: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                    minimumSize: Size.fromHeight(50),
                  ),
                  child: Text(statusStartOrEnd),
                  onPressed: () async {
                    if (statusStartOrEnd == "Start") {
                      setState(() => statusStartOrEnd = "End");
                      _isVisible = true;
                    } else if (statusStartOrEnd == "End") {
                      setState(() => statusStartOrEnd = "Start");
                      _isVisible = false;
                    }
                  }),
              Visibility(
                visible: _isVisible,
                child: Image.asset(
                  'assets/images/profile.png',
                  height: 300,
                  //fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}
