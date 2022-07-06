import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class FuelAlertTile extends StatelessWidget {
  String timeStamp;
  String message;
  String senderId;
  String fillingStationLat;
  String fillingStationLon;
  String city;
  bool diesel;
  bool petrol;
  void Function() onView;

  FuelAlertTile(
      {Key key,
      this.timeStamp = 'no time',
      this.message,
      this.senderId,
      this.fillingStationLat = '',
      this.fillingStationLon = '',
      this.city = '',
      this.diesel,
      this.petrol,
      this.onView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
        margin: EdgeInsets.fromLTRB(5, 10, 5, 10),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          side: BorderSide(
            color: AppColors.whitishBlue,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 10, 5, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      message,
                      maxLines: 2,
                      style: TextStyle(fontSize: 16, color: AppColors.black),
                      textAlign: TextAlign.start,
                    ),
                    fillingStationLat != ""
                        ? IconButton(
                            icon: Image.asset('assets/images/gas-station.png'),
                            iconSize: 35,
                            onPressed: onView,
                          )
                        : Text(''),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: <Widget>[
                      ListTile(
                          title: const Text('Diesel'),
                          leading: diesel
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                  size: 30.0,
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'X',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.red[400],
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.right,
                                  ),
                                )),
                      ListTile(
                          title: const Text('Petrol'),
                          leading: petrol
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.green,
                                  size: 30.0,
                                )
                              : Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    'X',
                                    style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.red[400],
                                        fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.right,
                                  ),
                                )),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'City : ${city}',
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    timeStamp,
                    maxLines: 2,
                    style: TextStyle(fontSize: 12, color: AppColors.black),
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
