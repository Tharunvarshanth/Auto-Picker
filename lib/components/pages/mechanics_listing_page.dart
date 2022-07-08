import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_icon_button.dart';
import 'package:auto_picker/components/atoms/generic_input_option_citys_select.dart';
import 'package:auto_picker/components/atoms/generic_input_option_select.dart';
import 'package:auto_picker/components/atoms/generic_input_option_specialist_select.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/generic_time_picker.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/atoms/service_card.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/pages/mechanic_profile_page.dart';
import 'package:auto_picker/models/city.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/services/mechanic_controller.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../routes.dart';

class MechanicsListingPage extends StatefulWidget {
  const MechanicsListingPage({Key key}) : super(key: key);

  @override
  _MechanicsListingPageState createState() => _MechanicsListingPageState();
}

class _MechanicsListingPageState extends State<MechanicsListingPage> {
  ScrollController _controller = ScrollController();
  final timePickerToController = TextEditingController();
  final timePickerFromController = TextEditingController();
  var mechanicsController = MechanicController();
  List<Mechanic> mechanicList = [];
  List<Mechanic> mechanicListFiltered = [];
  bool isLogged = false;
  bool isLoading = true;
  String specialist;

  String _valueChangedTo = '';
  String _valueToValidateTo = '';
  String _valueSavedTo = '';

  String _valueChangedFrom = '';
  String _valueToValidateFrom = '';
  String _valueSavedFrom = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  City city;
  List<City> dropDownCityList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {});
    getMechanicsList();
    setState(() {
      isLogged = _auth.currentUser != null;
    });
    setData();
  }

  void setData() async {
    var citys = await readCityJsonData();
    setState(() {
      dropDownCityList = citys;
    });
  }

  void handleCity(City cityName) {
    setState(() {
      city = cityName;
    });
  }

  void handleSpecialist(specia) {
    if (specia == specialist) {
      specialist = null;
      return;
    }
    setState(() {
      specialist = specia;
    });
    print("Tharun ${specialist}");
  }

  getMechanicsList() async {
    List<dynamic> res = await mechanicsController.getMechanics();
    if (res != null) {
      res.forEach((element) {
        print("Mechanics: $element");
        Mechanic _mechanic = Mechanic.fromJson(element);
        if (!_mechanic.isBlocked && _mechanic.isPayed) {
          setState(() {
            mechanicList.add(_mechanic);
            mechanicListFiltered.add(_mechanic);
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
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MechanicProfilePage(
              mechanic: mechanicListFiltered[index],
            ),
          ));
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Need to Signin',
                bodyText:
                    "Auto picker terms & conditions without an account user's cann't see informations",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => Navigator.pop(context, 'Cancel'),
              ));
    }
  }

  void filtering() {
    print("filtering  $specialist");
    setState(() {
      isLoading = true;
    });
    mechanicListFiltered = mechanicList;
    _filteredCity(city);
    _filteredSpecialist(specialist);
    _filteredTime(_valueChangedFrom, _valueChangedTo);
    setState(() {
      isLoading = false;
    });
  }

  void _filteredCity(City city) {
    if (city != null) {
      print("filteredCity");
      setState(() {
        mechanicListFiltered = mechanicListFiltered
            .where((element) => element.workingCity == city.city)
            .toList();
      });
    }
  }

  void _filteredSpecialist(specialist) {
    if (specialist != null) {
      setState(() {
        mechanicListFiltered = mechanicListFiltered
            .where((element) => element.specialist == specialist)
            .toList();
      });
    }
  }

  void _filteredTime(var v1, var v2) {
    if (v1 != '') {
      DateTime from = stringToTimeFormat(v1);
      print("form Time ${from}");
      mechanicListFiltered = mechanicListFiltered
          .where((element) => stringToTimeFormat((element.workingTime_From))
              .isAfter(from.subtract(Duration(minutes: 1))))
          .toList();
    }
    if (v2 != '') {
      DateTime to = stringToTimeFormat(v2);
      mechanicListFiltered = mechanicListFiltered
          .where((element) => stringToTimeFormat((element.workingTime_To))
              .isBefore(to.add(Duration(minutes: 1))))
          .toList();
    }
  }

  void createFilter(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            scrollable: true,
            title: Text('Sort'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                child: Column(
                  children: <Widget>[
                    GenericInputOptionSpecialistSelect(
                        width: size.width,
                        labelText: 'Specialist',
                        hintText: 'Choose Specialist',
                        value: specialist,
                        itemList: MechanicSpecialistSkills,
                        onValueChange: (text) => handleSpecialist(text)),
                    SizedBox(height: size.height * 0.015),
                    GenericInputOptionCitysSelect(
                      width: size.width,
                      labelText: '  Working City',
                      value: city,
                      itemList: dropDownCityList,
                      onValueChange: (text) => handleCity(text),
                    ),
                    SizedBox(height: size.height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Container(
                          width: 100,
                          child: GenericTimePicker(
                              controller: timePickerToController,
                              labelText: 'Start',
                              onChanged: (value) => {
                                    print("time ${value}"),
                                    setState(() {
                                      _valueChangedTo = value;
                                    })
                                  },
                              onSaved: (value) => {
                                    setState(() {
                                      _valueSavedTo = value;
                                    })
                                  }),
                        ),
                        SizedBox(height: size.height * 0.015),
                        Container(
                          width: 100,
                          child: GenericTimePicker(
                              controller: timePickerFromController,
                              labelText: 'Finish',
                              onChanged: (value) => {
                                    print("time ${value}"),
                                    setState(() {
                                      _valueChangedFrom = value;
                                    })
                                  },
                              onSaved: (value) => {
                                    print("time onsave ${value}}"),
                                    setState(() {
                                      _valueSavedFrom = value;
                                    })
                                  }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              RaisedButton(
                  child: Text("Filter"),
                  onPressed: () {
                    filtering();
                    Navigator.pop(context, 'Cancel');
                  }),
              RaisedButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    setState(() {
                      _valueChangedFrom = '';
                      _valueChangedTo = '';
                      city = null;
                      specialist = null;
                      mechanicListFiltered = mechanicList;
                    });
                    Navigator.pop(context, 'Cancel');
                  })
            ],
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'Mechanics Listing',
        isLogged: isLogged,
        showBackButton: true,
      ),
      bottomNavigationBar: Footer(
        isLogged: true,
        currentIndex: -1,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  GenericTextButton(
                    onPressed: () => {
                      navigate(context, RouteGenerator.findNearByMechanicsPage)
                    },
                    text: 'Find Nearby Mechanics',
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GenericIconButton(
                            text: 'Sort by request',
                            iconLeft: "assets/images/filter.svg",
                            onPressed: () {
                              createFilter(context);
                            }),
                        GenericIconButton(
                            text: 'Clear',
                            iconLeft: "assets/images/filter.svg",
                            onPressed: () {
                              setState(() {
                                setState(() {
                                  _valueChangedFrom = '';
                                  _valueChangedTo = '';
                                  city = null;
                                  specialist = null;
                                  mechanicListFiltered = mechanicList;
                                });
                              });
                            })
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 3 / 5,
                    child: ListView.builder(
                      controller: _controller,
                      itemCount: mechanicListFiltered.length,
                      itemBuilder: (context, index) {
                        return ServiceCard(
                          padding: 20,
                          miniTitle: mechanicListFiltered[index].specialist,
                          miniSubTitle: 'Specialist Field',
                          location: mechanicListFiltered[index].workingCity,
                          buttonTitle: 'More Info',
                          buttonPressed: () =>
                              navigateToMechanicProfilePage(index),
                          openHours:
                              "${TwentryFourTo12HourFormat(mechanicListFiltered[index].workingTime_From)} - ${TwentryFourTo12HourFormat(mechanicListFiltered[index].workingTime_To)}",
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
