import 'dart:async';

import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/pages/mechanics_signup_page.dart';
import 'package:auto_picker/services/location_services.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapLatLonPage extends StatefulWidget {
  final Map<String, dynamic> params;
  const MapLatLonPage({Map<String, dynamic> this.params});
  @override
  State<MapLatLonPage> createState() => MapLatLonPageState();
}

class MapLatLonPageState extends State<MapLatLonPage> {
  var searchController = TextEditingController();
  Completer<GoogleMapController> _controller = Completer();

  Set<Marker> _markers = Set<Marker>();
  LatLng userLocation;
  LatLng myCurrentLocation;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  void initState() {
    super.initState();
    _getLocation();
  }

  void _setMarker(LatLng point) {
    setState(() {
      _markers.add(Marker(markerId: MarkerId('marker'), position: point));
      userLocation = point;
    });
  }

  _getLocation() async {
    var location = new Location();

    try {
      var currentLocation = await location.getLocation();
      setState(() {
        myCurrentLocation =
            LatLng(currentLocation.latitude, currentLocation.longitude);
      });
    } on Exception {
      myCurrentLocation = null;
    }

    myCurrentLocation != null
        ? _setMarker(myCurrentLocation)
        : _setMarker(LatLng(37.42796133580664, -122.085749655962));
  }

  void fixMyLocation() {
    widget.params["location-lat"] = (userLocation.latitude).toString();
    widget.params["location-lon"] = userLocation.longitude.toString();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MechanicsSignUpPage(params: widget.params),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(hintText: 'Enter the place'),
                  onChanged: (text) {},
                )),
                IconButton(
                    onPressed: () async {
                      var place = await LocationServices()
                          .getPlace(searchController.text);
                      _goToPlaces(place);
                    },
                    icon: Icon(Icons.search))
              ],
            ),
            Expanded(
              child: GoogleMap(
                mapType: MapType.normal,
                markers: _markers,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                myLocationEnabled: true,
                onTap: (argument) => {_setMarker(argument)},
                onLongPress: (argument) => {_setMarker(argument)},
                onCameraMove: (position) => {print("onCameraMove $position")},
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: fixMyLocation,
        label: Text('Get my location marker'),
        icon: Icon(Icons.done),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Future<void> _goToPlaces(Map<String, dynamic> place) async {
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    _setMarker(LatLng(lat, lng));
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
