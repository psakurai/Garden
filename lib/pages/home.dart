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
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Map extends StatefulWidget {
  const Map({super.key});
  @override
  State<Map> createState() => _MyAppState();
}

class _MyAppState extends State<Map> {
  String? _currentAddress;
  Position? _currentPosition;
  late GoogleMapController mapController;
  String statusStartOrEnd = "Start";
  bool _isVisible = false;

  // final LatLng _center = const LatLng(1.5621690031757391, 103.62844728458849);

  LatLng _center = const LatLng(1.5621690031757391, 103.62844728458849);
  void _onMapCreated(GoogleMapController controller) async {
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

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _center = LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    double? a;
    double? b;
    dynamic aa;
    if (_currentPosition != null) {
      a = _currentPosition?.latitude;
      b = _currentPosition?.longitude;
      aa = LatLng(a!, b!);
    } else {
      a = 0;
      b = 0;
      aa = LatLng(a!, b!);
    }
    _getCurrentPosition();
    return Scaffold(
        body: Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: aa,
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
          panel: Column(children: [
            Text('LAT: ${_currentPosition?.latitude ?? ""}'),
            Text('LNG: ${_currentPosition?.longitude ?? ""}'),
            Text('ADDRESS: ${_currentAddress ?? ""}'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _getCurrentPosition,
              child: const Text("Get Current Location"),
            )
          ]),
          // panel: Stack(
          //   children: <Widget>[
          //     ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           textStyle: TextStyle(fontSize: 20),
          //           minimumSize: Size.fromHeight(50),
          //         ),
          //         child: Text(statusStartOrEnd),
          //         onPressed: () async {
          //           if (statusStartOrEnd == "Start") {
          //             setState(() => statusStartOrEnd = "End");
          //             _isVisible = true;
          //           } else if (statusStartOrEnd == "End") {
          //             setState(() => statusStartOrEnd = "Start");
          //             _isVisible = false;
          //           }
          //         }),
          //     Visibility(
          //       visible: _isVisible,
          //       child: Image.asset(
          //         'assets/images/profile.png',
          //         height: 300,
          //         //fit: BoxFit.contain,
          //       ),
          //     ),
          //   ],
          //),
        )
      ],
    ));
  }
}
