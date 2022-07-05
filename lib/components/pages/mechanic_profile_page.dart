import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/models/feedback_data.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/services/feedback_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MechanicProfilePage extends StatefulWidget {
  Mechanic mechanic;
  MechanicProfilePage({Key key, this.mechanic}) : super(key: key);

  @override
  _MechanicProfilePageState createState() => _MechanicProfilePageState();
}

class _MechanicProfilePageState extends State<MechanicProfilePage> {
  String address = '';
  String workingHours = '';
  String phoneNumber = '';
  ScrollController _controller = ScrollController();
  var userController = UserController();
  var feedbackController = FeedBackController();
  List<FeedBackData> feedBackList = [];
  String profileUrl;
  UserModel userModel;
  FirebaseAuth existingUser;
  bool _hasCallSupport = false;
  bool isLoading = true;
  Future<void> _launched;
  String feedbackText = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    existingUser = FirebaseAuth.instance;
    profileUrl = existingUser.currentUser.photoURL;
    setData();

    // Check for phone call support.
    canLaunch('tel:123').then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
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

  void setData() async {
    var _user = await userController.getUser(widget.mechanic.id);
    userModel = UserModel.fromJson(_user);
    QuerySnapshot res =
        await feedbackController.getFeedbackList(widget.mechanic.id);
    print("feedback ${res.size}");
    if (res.size > 0) {
      res.docs.forEach((element) async {
        print("feedback $element");
        setState(() {
          feedBackList.add(FeedBackData.fromJson(element));
        });
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void addFeedback() async {
    var _user = await userController.getUser(widget.mechanic.id);
    userModel = UserModel.fromJson(_user);
    var feedback = FeedBackData(
        userModel.fullName, DateTime.now().toString(), feedbackText);
    var res = feedbackController.addFeedback(feedback, widget.mechanic.id);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: const CustomAppBar(
        title: 'Mechanic',
        isLogged: true,
        showBackButton: true,
      ),
      bottomNavigationBar: Footer(
        isLogged: true,
        currentIndex: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  getHeader(),
                  InfoTile(SvgPicture.asset("assets/images/map-pin.svg"),
                      title: widget.mechanic.workingCity, subTitle: "City"),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    endIndent: MediaQuery.of(context).size.width * 1 / 8,
                    indent: MediaQuery.of(context).size.width * 1 / 8,
                  ),
                  InfoTile(SvgPicture.asset("assets/images/map-pin.svg"),
                      title: widget.mechanic.workingAddress,
                      subTitle: "Working Address"),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    endIndent: MediaQuery.of(context).size.width * 1 / 8,
                    indent: MediaQuery.of(context).size.width * 1 / 8,
                  ),
                  InfoTile(SvgPicture.asset("assets/images/clock.svg"),
                      title:
                          "${utcTo12HourFormat(widget.mechanic.workingTime_From)} - ${utcTo12HourFormat(widget.mechanic.workingTime_To)}",
                      subTitle: "Working Hours"),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    endIndent: MediaQuery.of(context).size.width * 1 / 8,
                    indent: MediaQuery.of(context).size.width * 1 / 8,
                  ),
                  InfoTile(SvgPicture.asset("assets/images/phone.svg"),
                      title: userModel.phoneNumber, subTitle: 'Phone Number'),
                  Divider(
                    color: Colors.grey,
                    thickness: 1,
                    endIndent: MediaQuery.of(context).size.width * 1 / 8,
                    indent: MediaQuery.of(context).size.width * 1 / 8,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    'Feedbacks',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 20),
                  ),
                  TextFormField(
                    onChanged: (text) {
                      feedbackText = text;
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      hintText: 'Enter Feedback',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Your Name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: GenericButton(
                      text: 'Send Feedback',
                      onPressed: () {
                        addFeedback();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder(
                      future: Future.delayed(Duration(seconds: 5)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container(
                          child: feedBackList.length != 0
                              ? ListView.builder(
                                  controller: _controller,
                                  itemCount: feedBackList.length,
                                  itemBuilder: (context, index) {
                                    return feedBackTile(feedBackList[index]);
                                  },
                                )
                              : Image.network(
                                  'https://cdn.dribbble.com/users/683081/screenshots/2728654/exfuse_app_main_nocontent.png',
                                  height: 200,
                                ),
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                        );
                      })
                ],
              ),
            ),
    ));
  }

  Widget getHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
            child: Row(
          children: [
            CircularProfileAvatar(
              profileUrl ?? '',
              initialsText: Text(
                userModel.fullName[0],
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              radius: 40,
              imageFit: BoxFit.fitHeight,
              placeHolder: (context, url) => Container(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(),
              ),
              backgroundColor: AppColors.primaryVariant,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userModel.fullName,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 24),
                ),
                Text(
                  widget.mechanic.specialist,
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 20),
                ),
                Wrap(
                  children: [
                    GenericButton(
                      text: _hasCallSupport ? 'CALL' : 'Calling not supported',
                      textColor: AppColors.white,
                      backgroundColor: Colors.blue,
                      paddingHorizontal: 2,
                      paddingVertical: 2,
                      onPressed: _hasCallSupport
                          ? () => setState(() {
                                _launched =
                                    _makePhoneCall(userModel.phoneNumber);
                              })
                          : null,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                )
              ],
            ))
          ],
        ))
      ],
    );
  }

  Widget InfoTile(Widget icon,
      {String title = "Title", String subTitle = 'Sub title'}) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
      subtitle: Text(
        subTitle,
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

Widget feedBackTile(FeedBackData feedBackData) {
  return Card(
    child: ListTile(
      title: Column(
        children: [
          Text(
            feedBackData.userName,
            style: const TextStyle(fontSize: 18),
          ),
          Text(
            'Date: ${feedBackData.dateTime.substring(0, 16)}',
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      ),
      subtitle: Text(
        feedBackData.feedbackMessage,
        style: const TextStyle(fontSize: 14),
      ),
    ),
  );
}
