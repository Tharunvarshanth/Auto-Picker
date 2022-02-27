import 'dart:async';

import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/pages/mechanic_profile_page.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/services/mechanic_controller.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_picker/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong/latlong.dart' as LatLonManager;
import 'package:location/location.dart';

class FindNearByMechanicsPage extends StatefulWidget {
  FindNearByMechanicsPage();

  @override
  _FindNearByMechanicsPageState createState() =>
      _FindNearByMechanicsPageState();
}

class _FindNearByMechanicsPageState extends State<FindNearByMechanicsPage> {
  List<String> imageList = ["value 1", "value 2"];
  bool isLoading = true;
  var mechanicsController = MechanicController();
  List<Mechanic> mechanicList = [];
  List<Mechanic> mechanicListFiltered = [];
  var _productController = ProductController();
  bool isLogged = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var distanceController = TextEditingController();
  LatLng userLocation;
  LatLng myCurrentLocation;
  Set<Marker> _markers = Set<Marker>();

  GoogleMapController mapController;
  bool isShowMap = false;
  double nearByDistance = 10.00;

  static CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.9271, 79.8612),
    zoom: 14.4746,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    [getMechanicsList(), _getCurrentLocation()];
    setState(() {
      isLogged = _auth.currentUser != null;
    });
  }

  void filteringNearByMechanics() {}

  _getCurrentLocation() async {
    var location = Location();

    try {
      var currentLocation = await location.getLocation();
      setState(() {
        myCurrentLocation = LatLng(6.9271, 79.8612);
        //Need to after production LatLng(currentLocation.latitude, currentLocation.longitude);
      });
      print(
          "My current Location: ${currentLocation.latitude}  ${currentLocation.longitude}");
    } on Exception {
      myCurrentLocation = null;
    }

    myCurrentLocation != null
        ? _setMyMarker(myCurrentLocation)
        : _setMyMarker(const LatLng(6.9271, 79.8612));
    _kGooglePlex = CameraPosition(
      target: myCurrentLocation,
      zoom: 14.4746,
    );
  }

  Future<void> _setMyMarker(LatLng point) async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/images/pin",
    );
    setState(() {
      _markers.add(Marker(
          markerId: const MarkerId('marker'),
          position: point,
          infoWindow: const InfoWindow(
            title: 'My Location ',
          )));
    });
  }

  void setNearbyPlacesMarker(Mechanic mechanic) async {
    print("setNearByPlaceMarker");
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('marker ${mechanic?.id}'),
          position: LatLng(double.parse(mechanic.location_lat),
              double.parse(mechanic.location_lon)),
          infoWindow: InfoWindow(
            title: mechanic?.specialist,
          )));
    });
  }

  getMechanicsList() async {
    List<dynamic> res = await mechanicsController.getMechanics();
    if (res != null) {
      for (var element in res) {
        print("Mechanics: $element");
        Mechanic _mechanic = Mechanic.fromJson(element);
        if (!_mechanic.isBlocked && _mechanic.isPayed) {
          setState(() {
            mechanicList.add(_mechanic);
            mechanicListFiltered.add(_mechanic);
          });
        }
      }
    }
    handleNearByMechanics();
    setState(() {
      isLoading = false;
    });
  }

  void handleNearByMechanics() {
    setState(() {
      isLoading = true;
      mechanicListFiltered = [];
    });
    mechanicList.forEach((element) {
      var distance = findDistanceBetweenLocations(
          LatLonManager.LatLng(6.9271, 79.8612), //myCurrentLocation
          LatLonManager.LatLng(double.parse(element.location_lat),
              double.parse(element.location_lon)));
      if (distance <= nearByDistance) {
        print("nearBy Mechanic ${element.id}");
        setState(() {
          mechanicListFiltered.add(element);
        });
        setNearbyPlacesMarker(element);
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void navigateToMechanicProfilePage(int index) {
    if (isLogged) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MechanicProfilePage(
              mechanic: mechanicListFiltered[index],
            ),
          ));
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Need to Signup',
                bodyText:
                    "Auto picker terms & conditions without an account user's cann't see informations",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => Navigator.pop(context, 'Cancel'),
              ));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Widget mapWindow() {
    return Expanded(
      child: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: _onMapCreated,
        initialCameraPosition: _kGooglePlex,
        markers: _markers,
        myLocationEnabled: true,
        onCameraMove: (position) => {print("onCameraMove $position")},
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Find Nearby',
        isLogged: false,
        showBackButton: true,
      ),
      body: isLoading
          ? const Center(child: (CircularProgressIndicator()))
          : SafeArea(
              child: Padding(
                padding: !isShowMap
                    ? const EdgeInsets.symmetric(horizontal: 10, vertical: 20)
                    : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    !isShowMap
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: distanceController,
                                  decoration: const InputDecoration(
                                      hintText: 'Enter distance in KM '),
                                  onChanged: (text) {},
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (distanceController.text != null &&
                                        (distanceController.text).trim() !=
                                            '' &&
                                        (distanceController.text).isNotEmpty) {
                                      print(
                                          "1 ${distanceController.text.isNotEmpty}");
                                      nearByDistance =
                                          double.parse(distanceController.text);
                                      handleNearByMechanics();
                                    }
                                  },
                                  icon: const Icon(Icons.search))
                            ],
                          )
                        : mapWindow()
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            isShowMap = !isShowMap;
          });
        },
        label: !isShowMap
            ? const Text('View in map')
            : const Text('Close the map'),
        icon: Icon(Icons.map),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
