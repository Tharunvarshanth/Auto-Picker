import 'dart:ffi';

import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/fuel_alert_tile.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_citys_select.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/organisms/footer.dart';
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
import 'package:intl/intl.dart';
import 'package:grouped_list/grouped_list.dart';

class GroupModel {
  String date;
  List fuelAlert;

  GroupModel(this.date, this.fuelAlert);

  GroupModel.fromJson(Map<String, dynamic> json) {
    date = json["date"];
    fuelAlert = json["fuelAlert"];
  }
}

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
  bool isLoading = true;
  City city;
  List<City> dropDownCityList = [];
  List<GroupModel> data = [];
  bool dieselMsg = false;
  bool petrolMsg = false;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

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

  getFormattedTimeStamp(String time) {
    DateFormat tileDateFormat = DateFormat("yyyy-MM-dd HH:mm");
    DateTime tempDateTime = tileDateFormat.parse(time);
    return tempDateTime.toString().substring(0, 16);
  }

  void setData() async {
    List<dynamic> res = await fuelController.getFuelAlerts();
    if (res != null) {
      data = [];
      List<FuelAlert> tempList = [];
      DateTime prevTimeStampe = null;
      int i = 0;
      for (var element in res) {
        print("Fuel Alert element:   $element");
        FuelAlert _fuelAlert = FuelAlert.fromJson(element);
        fuelAlertList.add(_fuelAlert);
        if (i == 0) {
          print("Fuel Alert index:   $i");
          prevTimeStampe = dateFormat.parse(_fuelAlert.timeStamp);
          tempList.add(_fuelAlert);
          if (res.length == 1) {
            setState(() {
              data.add(GroupModel(
                  prevTimeStampe.toString().substring(0, 10), tempList));
            });
          }
          i++;
          continue;
        }

        DateTime tempDateTime = dateFormat.parse(_fuelAlert.timeStamp);
        if (!tempDateTime.isAtSameMomentAs(prevTimeStampe)) {
          setState(() {
            data.add(GroupModel(
                prevTimeStampe.toString().substring(0, 10), tempList));
          });

          prevTimeStampe = dateFormat.parse(_fuelAlert.timeStamp);
          tempList = [];
          tempList.add(_fuelAlert);
        } else {
          tempList.add(_fuelAlert);
        }
        ++i;

        if (i == res.length - 1) {
          setState(() {
            data.add(GroupModel(
                prevTimeStampe.toString().substring(0, 10), tempList));
          });
        }
      }
    }

    //set city
    var citys = await readCityJsonData();
    setState(() {
      dropDownCityList = citys;
      isLoading = false;
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
                shape: const RoundedRectangleBorder(
                    side: BorderSide(
                        color: Color(0xFF2A8068)), //the outline color
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                scrollable: true,
                title: Text('Add Fuel Avialble'),
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
                        ListTile(
                          title: const Text('Diesel'),
                          leading: Checkbox(
                            splashRadius: 20,
                            activeColor: Colors.transparent,
                            checkColor: AppColors.themePrimary,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
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
                            splashRadius: 20,
                            activeColor: Colors.transparent,
                            checkColor: AppColors.themePrimary,
                            materialTapTargetSize: MaterialTapTargetSize.padded,
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
                        Navigator.pop(context, 'Cancel');
                      }),
                  RaisedButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context, 'Cancel');
                      })
                ],
              );
            },
          );
        });
  }

  void addMessage() {
    var alert = FuelAlert(
        DateTime.now().toLocal().toString(),
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
    _markers.clear();
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
    _kGooglePlex = CameraPosition(
      target: LatLng(double.parse(fuelAlert.fillingStationLat),
          double.parse(fuelAlert.fillingStationLon)),
      zoom: 14.4746,
    );
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
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Fuel Alert',
        isLogged: true,
        showBackButton: true,
      ),
      bottomNavigationBar: Footer(
        isLogged: true,
        currentIndex: -1,
      ),
      body: SafeArea(
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
              )
            : Padding(
                padding: !isShowMap
                    ? const EdgeInsets.fromLTRB(5, 5, 5, 40)
                    : const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Stack(children: <Widget>[
                  !isShowMap
                      ? data.length != 0
                          ? GroupedListView<FuelAlert, String>(
                              elements: fuelAlertList,
                              useStickyGroupSeparators: true,
                              groupSeparatorBuilder: (String value) =>
                                  Container(
                                width: screenSize.width / 5,
                                height: 40,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColors.Blue),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    value.toString().substring(0, 10),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColors.ashWhite,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              groupBy: (element) =>
                                  element.timeStamp.toString().substring(0, 10),

                              itemBuilder: (context, FuelAlert itemData) =>
                                  FuelAlertTile(
                                onView: () => viewPetrolStationLoc(itemData),
                                timeStamp:
                                    getFormattedTimeStamp(itemData?.timeStamp),
                                message: itemData?.message,
                                senderId: itemData?.senderId,
                                fillingStationLat: itemData?.fillingStationLat,
                                fillingStationLon: itemData?.fillingStationLon,
                                petrol: itemData?.petrol,
                                diesel: itemData?.diesel,
                                city: itemData?.city,
                              ),

                              order: GroupedListOrder.DESC, // optional
                            )
                          : const Text('No Messages')
                      : mapWindow()
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
          : FloatingActionButton(
              onPressed: () => createMessage(context),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
