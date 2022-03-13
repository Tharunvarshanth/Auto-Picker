import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/vehicle_service_record.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/vehicle_service_record_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class VehicleServiceAddPage extends StatefulWidget {
  const VehicleServiceAddPage();

  @override
  _VehicleServiceAddPageState createState() => _VehicleServiceAddPageState();
}

class _VehicleServiceAddPageState extends State<VehicleServiceAddPage> {
  var vehicleServiceController = VehicleServiceController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final descriptionController = TextEditingController();
  final currentMileage = TextEditingController();

  String serviceDate;
  String notificationDate;

  final _formKey = GlobalKey<FormState>();

  addVehcileServiceHistory() async {
    var vehicleService = VehicleServiceRecord('', serviceDate, notificationDate,
        false, descriptionController.text, currentMileage.text);
    var res = await vehicleServiceController.addvehicleService(
        vehicleService, _auth.currentUser.uid);
    if (res != null) {
      var pRes = await vehicleServiceController.updateServiceRecord(
          _auth.currentUser.uid, res, 'serviceId', res);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      IconButton(
        padding: EdgeInsets.all(12),
        iconSize: 36,
        alignment: Alignment.topLeft,
        icon: const Icon(Icons.arrow_back),
        color: AppColors.black,
        onPressed: () {
          navigateBack(context);
        },
      ),
      SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 75, 10, 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            GenericText(
              text: 'Add Vehicle Service',
              textSize: 36,
              isBold: true,
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    GenericTextField(
                      controller: currentMileage,
                      labelText: 'Current Mileage',
                      hintText: "150,000",
                      borderColor: AppColors.ash,
                    ),
                    GenericTextButton(
                      text: serviceDate ?? 'Serviced Date',
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(DateTime.now().year,
                                DateTime.now().month - 1, 0),
                            maxTime: DateTime(DateTime.now().year,
                                DateTime.now().month + 1, 0),
                            theme: const DatePickerTheme(
                                headerColor: AppColors.skyBlue,
                                backgroundColor: Colors.blue,
                                itemStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16)), onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          print('confirm $date');
                          setState(() {
                            serviceDate = date
                                .toString()
                                .replaceRange(10, date.toString().length, '');
                            ;
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                    ),
                    GenericTextButton(
                      text: notificationDate ?? 'Next Serivce Remainder Date',
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(DateTime.now().year,
                                DateTime.now().month + 1, 0),
                            maxTime: DateTime(DateTime.now().year + 1,
                                DateTime.now().month + 1, 0),
                            theme: const DatePickerTheme(
                                headerColor: AppColors.skyBlue,
                                backgroundColor: Colors.blue,
                                itemStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                                doneStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16)), onChanged: (date) {
                          print('change $date in time zone ' +
                              date.timeZoneOffset.inHours.toString());
                        }, onConfirm: (date) {
                          print('confirm $date');
                          setState(() {
                            notificationDate = date
                                .toString()
                                .replaceRange(10, date.toString().length, '');
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                    ),
                    GenericTextField(
                      controller: descriptionController,
                      labelText: 'Description',
                      hintText: '',
                      borderColor: AppColors.ash,
                    ),
                    SizedBox(height: size.height * 0.015),
                    GenericButton(
                      textColor: AppColors.white,
                      backgroundColor: AppColors.Blue,
                      paddingVertical: 20,
                      paddingHorizontal: 80,
                      text: 'Next',
                      onPressed: () {
                        //validations ok
                      },
                      isBold: true,
                    )
                  ],
                ))
          ],
        ),
      ),
    ])));
  }
}
