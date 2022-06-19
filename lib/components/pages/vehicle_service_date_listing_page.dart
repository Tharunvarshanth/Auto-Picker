import 'package:auto_picker/components/atoms/custom_app_bar%20copy.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/atoms/product_tile.dart';
import 'package:auto_picker/components/atoms/vehicle_service_record.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/pages/advertisement_page.dart';
import 'package:auto_picker/components/pages/product_page.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/spare_advertisement.dart';
import 'package:auto_picker/models/vehicle_service_record.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/spare_advertisement_controller.dart';
import 'package:auto_picker/services/vehicle_service_record_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class VehicleServiceDateListingPage extends StatefulWidget {
  const VehicleServiceDateListingPage({Key key}) : super(key: key);

  @override
  _VehicleServiceDateListingPageState createState() =>
      _VehicleServiceDateListingPageState();
}

class _VehicleServiceDateListingPageState
    extends State<VehicleServiceDateListingPage> {
  final ScrollController _controller = ScrollController();
  var serviceRecordController = VehicleServiceController();
  bool isLogged = false;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<VehicleService> serviceRecordList = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      isLogged = _auth.currentUser != null;
    });
    getServiceRecordList();
    _controller.addListener(() async {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        //fetch new data
        // if (no data!!) {
        //   return;
        // }
        setState(() {
          //put data
        });
      }
    });
  }

  getServiceRecordList() async {
    QuerySnapshot res = await serviceRecordController
        .getVehicleServiceRecords(_auth.currentUser.uid);

    if (res.size > 0) {
      res.docs.forEach((element) {
        serviceRecordList.add(VehicleService.fromJson(element.data()));
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              backgroundColor: AppColors.white,
            ),
          )
        : SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                title: 'Service Records Listing',
                isLogged: isLogged,
                showBackButton: true,
              ),
              bottomNavigationBar: Footer(),
              body: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListView.builder(
                  controller: _controller,
                  itemCount: serviceRecordList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        //navigate(context, RouteGenerator.addVehcileServicePage);
                      },
                      child: VehicleServiceRecord(
                        title: serviceRecordList[index].description ?? '',
                        desciption: serviceRecordList[index].mileage ?? '',
                        notificationsDate:
                            serviceRecordList[index].notificationDate ?? '',
                        date: serviceRecordList[index].date,
                      ),
                    );
                  },
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () =>
                    navigate(context, RouteGenerator.addVehcileServicePage),
                label: Text(''),
                icon: Icon(Icons.add),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.startFloat,
            ),
          );
  }
}
