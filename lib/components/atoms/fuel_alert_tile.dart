import 'package:auto_picker/components/ui/custom_painter.dart';
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
  int index;

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
      this.onView,
      this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 10, 5, 15),
            child: Stack(children: <Widget>[
              Container(
                height: 225,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                        colors: [Colors.blue[400], Colors.blue[600]],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue[200],
                          blurRadius: 12,
                          offset: Offset(0, 6))
                    ]),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: CustomPaint(
                  size: Size(100, 150),
                  painter: CustomCardShapePainter(
                      10, Colors.blue[400], Colors.blue[600]),
                ),
              ),
              Positioned.fill(
                  child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 10, 0, 10),
                          child: Text(
                            message,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 0, 0),
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
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 0, 0),
                                          child: Text(
                                            'X',
                                            style: TextStyle(
                                                fontSize: 22,
                                                color: Colors.red[400],
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.right,
                                          ),
                                        )),
                              Row(
                                children: <Widget>[
                                  fillingStationLat != ""
                                      ? IconButton(
                                          icon: Image.asset(
                                              'assets/images/gas-station.png'),
                                          iconSize: 35,
                                          onPressed: onView,
                                        )
                                      : Text(''),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                    child: Text(
                                      'City :  ${city}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        fontFamily: 'Avenir',
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                ],
                              ),
                              Text(
                                timeStamp,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Avenir',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: CustomPaint(
                  size: Size(100, 150),
                  painter: CustomCardShapePainter(
                      10, Colors.blue[400], Colors.blue[600]),
                ),
              ),
            ])));
  }
}
