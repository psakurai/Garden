import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:garden/models/user.dart';
import 'package:garden/utils/styles.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:math';

import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:garden/services/database.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);
  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);
  Position? _currentLocation;
  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 1,
  );
  String statusStartOrEnd = "Start";
  int isRecord = 0;
  double distance = 0.00;
  double averagespeed = 0.00;
  double totalspeed = 0.00;
  String username = "";
  Color whichColor = Colors.teal;
  // BitmapDescriptor startIcon = BitmapDescriptor.defaultMarker;
  // BitmapDescriptor endIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  List<LatLng> polylineCoordinates = [];
  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyBWfolKgu3J2TdDyMy3_H-_jLTnMMuH1GM",
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

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

  Future<void> getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position location) {
      setState(() => _currentLocation = location);
    }).catchError((e) {
      debugPrint(e);
    });
    GoogleMapController googleMapController = await _controller.future;
    StreamSubscription<Position> locationStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? newlocation) {
      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 20,
            target: LatLng(
              newlocation!.latitude,
              newlocation.longitude,
            ),
          ),
        ),
      );
      if (isRecord == 1) {
        //prevpolylineCoordinates.clear();
        polylineCoordinates
            .add(LatLng(newlocation.latitude, newlocation.longitude));

        start(newlocation.speed * 3.6);
      } else if (isRecord == 2) {
        //prevpolylineCoordinates = polylineCoordinates;

        end();
        polylineCoordinates.clear();
        isRecord = 0;
      }
      setState(() {
        _currentLocation = newlocation;
      });

      // print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
    });
  }

  void setCustomMarkerIcon() {
    //   BitmapDescriptor.fromAssetImage(
    //           ImageConfiguration.empty, "assets/images/Pin_source.png")
    //       .then(
    //     (icon) {
    //       startIcon = icon;
    //     },
    //   );
    //   BitmapDescriptor.fromAssetImage(
    //           ImageConfiguration.empty, "assets/images/Pin_destination.png")
    //       .then(
    //     (icon) {
    //       endIcon = icon;
    //     },
    //   );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/images/Badge.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Future<void> start(double speed) async {
    double totalDistance = 0;
    for (var i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += calculateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    distance = totalDistance;
    totalspeed += speed;
    averagespeed = totalspeed / distance;
  }

  Future<void> end() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var userFirebase = _auth.currentUser;
    if (distance != 0) {
      var kk = FirebaseFirestore.instance
          .collection('user')
          .doc(userFirebase!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          username = documentSnapshot.get('username').toString();

          await DatabaseService(uid: userFirebase!.uid)
              .updateDistanceData(distance, averagespeed, username);

          await DatabaseService(uid: userFirebase.uid)
              .updateDistanceHistoryData(distance, averagespeed);

          await DatabaseService(uid: userFirebase.uid).updateGoldData(distance);

          await DatabaseService(uid: userFirebase.uid).updateLevelData();
        }
      });
    }
  }

  Future<void> startPolylineCoordinates() async {
    if (statusStartOrEnd == "Start") {
      setState(() => isRecord = 1);
      statusStartOrEnd = "End";
      whichColor = Colors.red;
    } else {
      setState(() => isRecord = 2);
      statusStartOrEnd = "Start";
      whichColor = Colors.teal;
    }
  }

  @override
  void initState() {
    //getPolyPoints();
    getCurrentLocation();
    setCustomMarkerIcon();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? const Center(child: Text("Loading"))
          : Stack(children: <Widget>[
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(_currentLocation!.latitude!,
                      _currentLocation!.longitude!),
                  zoom: 20,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("currentLocation"),
                    position: LatLng(_currentLocation!.latitude,
                        _currentLocation!.longitude),
                    icon: currentLocationIcon,
                  ),
                  const Marker(
                    markerId: MarkerId("source"),
                    position: sourceLocation,
                  ),
                  const Marker(
                    markerId: MarkerId("destination"),
                    position: destination,
                  ),
                },
                onMapCreated: (mapController) {
                  _controller.complete(mapController);
                },
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("route"),
                    points: polylineCoordinates,
                    color: Colors.teal,
                    width: 6,
                  ),
                },
              ),
              SlidingUpPanel(
                maxHeight: 100,
                panel: Container(
                  width: 100,
                  height: 100,
                  color: Colors.teal[400],
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Column(
                    children: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(fontSize: 20),
                            minimumSize: Size.fromHeight(50),
                            primary: whichColor, //Colors.teal,
                            onPrimary: Colors.white,
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(statusStartOrEnd),
                          onPressed: () async {
                            startPolylineCoordinates();
                          }),
                    ],

                    // child: ElevatedButton(
                    //     child: Text(statusStartOrEnd),
                    //     onPressed: () async {
                    //       startPolylineCoordinates();
                    //     }),
                  ),
                ),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 20),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text("${distance.toStringAsFixed(3)} KM"),
                  onPressed: () async {}),
            ]),
    );
  }
}
