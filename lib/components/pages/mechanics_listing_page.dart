import 'package:auto_picker/components/atoms/custom_app_bar%20copy.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/atoms/service_card.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/services/mechanic_controller.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import '../../routes.dart';

class MechanicsListingPage extends StatefulWidget {
  const MechanicsListingPage({Key key}) : super(key: key);

  @override
  _MechanicsListingPageState createState() => _MechanicsListingPageState();
}

class _MechanicsListingPageState extends State<MechanicsListingPage> {
  ScrollController _controller = ScrollController();

  var mechanicsController = MechanicController();
  List<Mechanic> mechanicList = [];
  bool isLogged = false;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {});
    getMechanicsList();
    setState(() {
      isLogged = _auth.currentUser != null;
    });
  }

  getMechanicsList() async {
    List<dynamic> res = await mechanicsController.getMechanics();
    if (res != null) {
      res.forEach((element) {
        print("Mechanics: $element");
        Mechanic _mechanic = Mechanic.fromJson(element);
        if (!_mechanic.isBlocked) {
          setState(() {
            mechanicList.add(_mechanic);
          });
        }
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToMechanicProfilePage(int index) {
    if (isLogged) {
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: CustomAppBar(
                  title: 'Mechanics Listing',
                  isLogged: isLogged,
                  showBackButton: true,
                ),
                bottomNavigationBar: Footer(),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Icon(Icons.search),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(2),
                        child: Center(
                          child: Text('Find Nearby Garage'),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          children: [
                            const Expanded(
                                flex: 2,
                                child: ListTile(
                                  title: Text('Sorted By'),
                                  subtitle: Text(
                                    'Recommended',
                                    style: TextStyle(color: Colors.cyan),
                                  ),
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.sync_rounded))
                          ],
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 3 / 5,
                        child: ListView.builder(
                          controller: _controller,
                          itemCount: mechanicList.length,
                          itemBuilder: (context, index) {
                            return ServiceCard(
                              padding: 20,
                              miniTitle: mechanicList[index].specialist,
                              miniSubTitle: 'Specialist Field',
                              location: mechanicList[index].workingCity,
                              buttonTitle: 'More Info',
                              buttonPressed: () =>
                                  navigateToMechanicProfilePage(index),
                              openHours:
                                  "${utcTo12HourFormat(mechanicList[index].workingTime_From)} - ${utcTo12HourFormat(mechanicList[index].workingTime_To)}",
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ));
  }
}
