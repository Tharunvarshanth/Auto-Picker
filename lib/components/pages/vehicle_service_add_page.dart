import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/generic_text_field.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/vehicle_service_record.dart';
import 'package:auto_picker/models/vehicle_service_remainder_notification.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/services/notification_service_imple.dart';
import 'package:auto_picker/services/vehicle_service_record_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'dart:math';

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
  var _notificationService = NotificationServiceImpl();

  String serviceDate;
  String notificationDate;
  DateTime notificationDateTime;

  final _formKey = GlobalKey<FormState>();

  addVehcileServiceHistory() async {
    var vehicleService = VehicleService('', serviceDate, notificationDate,
        false, descriptionController.text, currentMileage.text);
    var res = await vehicleServiceController.addvehicleService(
        vehicleService, _auth.currentUser.uid);

    if (res != null) {
      var pRes = await vehicleServiceController.updateServiceRecord(
          _auth.currentUser.uid, res, 'serviceId', res);
      //success
      Random random = new Random();
      int randomNumber = random.nextInt(100); //
      var vehicleServiceRemainderNotification =
          VehicleServiceRemainderNotification(randomNumber,
              vehicleService.description, VEHICLE_SERVICE_REMAINDER, true);
      print("notification date ${notificationDateTime}");

      _notificationService.scheduleNotificationServieDate(
          vehicleServiceRemainderNotification,
          vehicleService.description,
          notificationDateTime);

      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/done.svg',
                titleText: 'Successfully Added',
                bodyText: "",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => navigate(
                    context, RouteGenerator.vehicleServiceMaintainancePage),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Failure',
                bodyText: "",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => Navigator.pop(context),
              ));
    }
  }

  void fillRequiredFields() {
    showDialog(
        context: context,
        builder: (context) => ItemDialogMessage(
              icon: 'assets/images/x-circle.svg',
              titleText: 'Fill All Fields',
              bodyText: "",
              primaryButtonText: 'Ok',
              onPressedPrimary: () => Navigator.pop(context),
            ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
      child: Stack(children: [
        IconButton(
          padding: EdgeInsets.all(12),
          iconSize: 40,
          alignment: Alignment.topLeft,
          icon: Image.asset(
            "assets/images/back-arrow.png",
            scale: 1.2,
          ),
          onPressed: () {
            navigateBack(context);
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 200,
              margin: EdgeInsets.symmetric(vertical: 40.0, horizontal: 0.0),
              child: Image.asset(
                "assets/images/calendar.png",
                scale: 0.5,
              ),
            ),
            const Text(
              "Add Vehicle Service",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            GenericText(
              textAlign: TextAlign.left,
              text: 'Required *',
              color: AppColors.red,
              isBold: true,
            ),
            Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: <Widget>[
                      GenericTextField(
                          controller: currentMileage,
                          labelText: "Current Mileage",
                          prefixIcon: Icons.social_distance),
                      SizedBox(height: size.height * 0.015),
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
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                      ),
                      SizedBox(height: size.height * 0.015),
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
                              notificationDateTime = date;
                              notificationDate = date
                                  .toString()
                                  .replaceRange(10, date.toString().length, '');
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                      ),
                      SizedBox(height: size.height * 0.015),
                      GenericTextField(
                          controller: descriptionController,
                          labelText: "Description",
                          prefixIcon: Icons.description),
                      SizedBox(height: size.height * 0.015),
                      GenericButton(
                        textColor: AppColors.white,
                        backgroundColor: AppColors.Blue,
                        paddingVertical: 20,
                        paddingHorizontal: 80,
                        text: 'Next',
                        onPressed: () {
                          print(serviceDate);
                          if (serviceDate == null ||
                              descriptionController.text.isEmpty ||
                              notificationDate == null ||
                              currentMileage.text.isEmpty) {
                            fillRequiredFields();
                            return;
                          }
                          addVehcileServiceHistory();
                        },
                        isBold: true,
                      )
                    ],
                  ),
                ))
          ],
        ),
      ]),
    )));
  }
}
