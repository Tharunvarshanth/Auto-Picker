import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/fuel_alert_tile.dart';
import 'package:auto_picker/models/fuel_alert.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/services/fuel_alert_controller.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FuelAlertChatPage extends StatefulWidget {
  const FuelAlertChatPage();

  @override
  _FuelAlertChatPageState createState() => _FuelAlertChatPageState();
}

class _FuelAlertChatPageState extends State<FuelAlertChatPage> {
  ScrollController _controller = ScrollController();
  var _fuelController = FuelAlertController();
  List<FuelAlert> fuelAlertList = [];

  Set<Marker> _markers = Set<Marker>();
  List<double> distanceList = [];

  GoogleMapController mapController;
  bool isShowMap = false;
  double nearByDistance = 10.00;

  static CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(6.9271, 79.8612),
    zoom: 14.4746,
  );

  void initState() {
    super.initState();
    setData();
  }

  void setData() async {
    List<dynamic> res = await _fuelController.getFuelAlerts();

    if (res != null) {
      res.forEach((element) {
        print("Mechanics: $element");
        FuelAlert _fuelAlert = FuelAlert.fromJson(element);
        setState(() {
          fuelAlertList.add(_fuelAlert);
        });
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  viewPetrolStationLoc(FuelAlert fuelAlert) {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId('marker 1'),
          position: LatLng(double.parse(fuelAlert.fillingStationLat),
              double.parse(fuelAlert.fillingStationLon)),
          infoWindow: const InfoWindow(
            title: 'Petrol Station',
          )));
    });
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
        title: 'Fuel Alert',
        isLogged: true,
        showBackButton: false,
      ),
      body: SafeArea(
        child: Padding(
            padding: !isShowMap
                ? const EdgeInsets.symmetric(horizontal: 10, vertical: 20)
                : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: !isShowMap
                ? fuelAlertList.length != 0
                    ? ListView.builder(
                        controller: _controller,
                        itemCount: fuelAlertList.length,
                        itemBuilder: (context, index) {
                          return FuelAlertTile(
                              timeStamp: fuelAlertList[index].timeStamp,
                              message: fuelAlertList[index].message,
                              senderId: fuelAlertList[index].senderId,
                              fillingStationLat:
                                  fuelAlertList[index].fillingStationLat,
                              fillingStationLon:
                                  fuelAlertList[index].fillingStationLon,
                              petrol: fuelAlertList[index].petrol,
                              diesel: fuelAlertList[index].diesel,
                              city: fuelAlertList[index].city);
                        },
                      )
                    : Text('No Messages')
                : mapWindow()),
      ),
    );
  }
}
