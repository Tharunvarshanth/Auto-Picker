import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/fuel_alert_tile.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_citys_select.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/pages/map_gas_station_page.dart';
import 'package:auto_picker/models/city.dart';
import 'package:auto_picker/models/fuel_alert.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/services/fuel_alert_controller.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'map_page.dart';

class FuelAlertChatPage extends StatefulWidget {
  Map<String, dynamic> params;

  FuelAlertChatPage({Map<String, dynamic> this.params});

  @override
  _FuelAlertChatPageState createState() => _FuelAlertChatPageState();
}

class _FuelAlertChatPageState extends State<FuelAlertChatPage> {
  ScrollController _controller = ScrollController();
  var fuelController = FuelAlertController();
  List<FuelAlert> fuelAlertList = [];
  final messageController = TextEditingController();

  Set<Marker> _markers = Set<Marker>();
  List<double> distanceList = [];

  GoogleMapController mapController;
  bool isShowMap = false;
  double nearByDistance = 10.00;
  City city;
  List<City> dropDownCityList = [];
  bool dieselMsg = false;
  bool petrolMsg = false;

  static CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(6.9271, 79.8612),
    zoom: 14.4746,
  );

  void initState() {
    super.initState();
    setData();
    if (widget.params?.isEmpty != null) {
      buildWidget();
    }
  }

  void buildWidget() {
    setState(() {
      dieselMsg = widget.params["diesel"];
      petrolMsg = widget.params["petrol"];
      messageController.text = widget.params["messsage"];
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        createMessage(context);
      });
    });
  }

  void setData() async {
    List<dynamic> res = await fuelController.getFuelAlerts();
    if (res != null) {
      res.forEach((element) {
        print("Fuel Alert chat: $element");
        FuelAlert _fuelAlert = FuelAlert.fromJson(element);
        setState(() {
          fuelAlertList.add(_fuelAlert);
        });
      });
    }
    var citys = await readCityJsonData();
    setState(() {
      dropDownCityList = citys;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void createMessage(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                scrollable: true,
                title: Text('Add Fuel Status'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: messageController,
                          decoration: const InputDecoration(
                            labelText: 'Message',
                            icon: Icon(Icons.message),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          title: const Text('Diesel'),
                          leading: Checkbox(
                            checkColor: AppColors.Blue,
                            value: dieselMsg,
                            onChanged: (bool value) {
                              setState(() {
                                dieselMsg = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Petrol'),
                          leading: Checkbox(
                            checkColor: AppColors.Blue,
                            value: petrolMsg,
                            onChanged: (bool value) {
                              setState(() {
                                petrolMsg = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          width: 150,
                          child: GenericButton(
                              text: 'Choose Gas Station location',
                              onPressed: () {
                                Map<String, dynamic> m = {
                                  'petrol': petrolMsg,
                                  'diesel': dieselMsg,
                                  'messsage': messageController.text,
                                  'city': city
                                };
                                widget.params = m;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapGasStationPage(
                                        params: widget.params),
                                  ),
                                );
                              }),
                        ),
                        GenericInputOptionCitysSelect(
                          width: size.width,
                          labelText: 'City *',
                          value: city,
                          itemList: dropDownCityList,
                          onValueChange: (text) => {
                            setState(() {
                              city = text;
                            })
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  RaisedButton(
                      child: Text("Submit"),
                      onPressed: () {
                        if (city?.city == '' || city == null) {
                          return;
                        }
                        addMessage();
                      })
                ],
              );
            },
          );
        });
  }

  void addMessage() {
    var alert = FuelAlert(
        DateTime.now().toUtc().toString(),
        messageController.text,
        '',
        widget.params["location-lat"] ?? '',
        widget.params["location-lon"] ?? '',
        city.city,
        dieselMsg,
        petrolMsg);
    fuelController.addFuelAlert(alert);
    setData();
    Navigator.pop(context);
  }

  viewPetrolStationLoc(FuelAlert fuelAlert) {
    setState(() {
      isShowMap = true;
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

  void handleCity(City cityName) {
    setState(() {
      city = cityName;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Fuel Alert',
        isLogged: true,
        showBackButton: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: !isShowMap
              ? const EdgeInsets.symmetric(horizontal: 10, vertical: 20)
              : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Stack(children: <Widget>[
            !isShowMap
                ? fuelAlertList.length != 0
                    ? ListView.builder(
                        controller: _controller,
                        itemCount: fuelAlertList.length,
                        itemBuilder: (context, index) {
                          return FuelAlertTile(
                              onView: () =>
                                  viewPetrolStationLoc(fuelAlertList[index]),
                              timeStamp: fuelAlertList[index]?.timeStamp,
                              message: fuelAlertList[index]?.message,
                              senderId: fuelAlertList[index]?.senderId,
                              fillingStationLat:
                                  fuelAlertList[index]?.fillingStationLat,
                              fillingStationLon:
                                  fuelAlertList[index]?.fillingStationLon,
                              petrol: fuelAlertList[index]?.petrol,
                              diesel: fuelAlertList[index]?.diesel,
                              city: fuelAlertList[index]?.city);
                        },
                      )
                    : const Text('No Messages')
                : mapWindow(),
            if (!isShowMap)
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
                  height: 60,
                  width: double.infinity,
                  color: Colors.white,
                  child: Row(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => createMessage(context),
                        child: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: Colors.lightBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ]),
        ),
      ),
      floatingActionButton: isShowMap
          ? FloatingActionButton.extended(
              onPressed: () {
                setState(() {
                  isShowMap = !isShowMap;
                });
              },
              label: const Text('Close the map'),
              icon: Icon(Icons.map),
            )
          : null,
    );
  }
}
