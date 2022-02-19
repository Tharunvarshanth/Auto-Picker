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
    var location = new Location();

    try {
      var currentLocation = await location.getLocation();
      setState(() {
        myCurrentLocation =
            LatLng(currentLocation.latitude, currentLocation.longitude);
      });
      print(
          "My current Location: ${currentLocation.latitude}  ${currentLocation.longitude}");
    } on Exception {
      myCurrentLocation = null;
    }

    myCurrentLocation != null
        ? _setMarker(myCurrentLocation)
        : _setMarker(LatLng(37.42796133580664, -122.085749655962));
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(Marker(markerId: MarkerId('marker'), position: point));
      userLocation = point;
    });
  }

  getMechanicsList() async {
    List<dynamic> res = await mechanicsController.getMechanics();
    if (res != null) {
      res.forEach((element) {
        print("Mechanics: $element");
        Mechanic _mechanic = Mechanic.fromJson(element);
        if (!_mechanic.isBlocked && _mechanic.isPayed) {
          setState(() {
            mechanicList.add(_mechanic);
            mechanicListFiltered.add(_mechanic);
          });
        }
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void handleNearByMechanics() {
    if (distanceController.text != null) {
      setState(() {
        isLoading = true;
        mechanicListFiltered = [];
      });
      mechanicList.forEach((element) {
        var distance = findDistanceBetweenLocations(
            const LatLng(6.9271, 79.8612), //myCurrentLocation
            LatLng(double.parse(element.location_lat),
                double.parse(element.location_lon)));
        if (distance <= double.parse(distanceController.text)) {
          print("nearBy Mechanic ${element.workingCity}");
          setState(() {
            mechanicListFiltered.add(element);
          });
        }
      });
      setState(() {
        isLoading = false;
      });
    }
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

  Widget build(BuildContext context) {
    //addProduct();

    return Scaffold(
        appBar: const CustomAppBar(
          title: 'Find NearBy',
          isLogged: false,
          showBackButton: true,
        ),
        body: isLoading
            ? (CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          TextFormField(
                            controller: distanceController,
                            decoration: InputDecoration(
                                hintText: 'Enter distance in KM '),
                            onChanged: (text) {},
                          ),
                          GenericButton(
                            text: 'Search',
                            onPressed: () => {},
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ));
  }
}
