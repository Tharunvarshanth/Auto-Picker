import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/models/feedback_data.dart';
import 'package:flutter/material.dart';

class MechanicProfile extends StatefulWidget {
  const MechanicProfile({Key key}) : super(key: key);

  @override
  _MechanicProfileState createState() => _MechanicProfileState();
}

class _MechanicProfileState extends State<MechanicProfile> {
  String address = '';
  String workingHours = '';
  String phoneNumber = '';
  ScrollController _controller = ScrollController();
  List<FeedBackData> feedBackList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            getHeader(),
            InfoTile(Icons.location_pin,
                title: "Working Address", subTitle: address),
            Divider(
              color: Colors.grey,
              thickness: 1,
              endIndent: MediaQuery.of(context).size.width * 1 / 8,
              indent: MediaQuery.of(context).size.width * 1 / 8,
            ),
            InfoTile(Icons.lock_clock,
                title: "Working Hours", subTitle: workingHours),
            Divider(
              color: Colors.grey,
              thickness: 1,
              endIndent: MediaQuery.of(context).size.width * 1 / 8,
              indent: MediaQuery.of(context).size.width * 1 / 8,
            ),
            InfoTile(Icons.phone_android_outlined,
                title: 'Phone Number', subTitle: phoneNumber),
            Divider(
              color: Colors.grey,
              thickness: 1,
              endIndent: MediaQuery.of(context).size.width * 1 / 8,
              indent: MediaQuery.of(context).size.width * 1 / 8,
            ),
            Text(
              'Description',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Phone authentication allows users to sign in to Firebase using their phone as the authenticator. An SMS message is sent to the user (using the provided phone number) containing a unique code. Once the code has been authorized, the user is able to sign into Firebase.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16),
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Feedbacks',
              textAlign: TextAlign.start,
              style: TextStyle(fontSize: 20),
            ),
            FutureBuilder(
                future: Future.delayed(Duration(seconds: 5)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
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
                            'https://cdn.dribbble.com/users/683081/screenshots/2728654/exfuse_app_main_nocontent.png'),
                    height: MediaQuery.of(context).size.height * 2 / 3,
                  );
                })
          ],
        ),
      ),
    ));
  }
}

Widget getHeader() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.arrow_back,
        color: Colors.cyan,
      ),
      SizedBox(
        width: 8,
      ),
      Expanded(
          child: Row(
        children: [
          CircleAvatar(
            radius: 48,
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Gunnar',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'All kind of services',
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 20),
              ),
              Wrap(
                children: [
                  GenericButton(
                    text: 'CALL',
                    textColor: Colors.white,
                    backgroundColor: Colors.blue,
                    paddingHorizontal: 2,
                    paddingVertical: 2,
                    shadowColor: Colors.transparent,
                    onPressed: () {},
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GenericButton(
                    text: 'CHAT',
                    onPressed: () {},
                    paddingHorizontal: 2,
                    paddingVertical: 2,
                    shadowColor: Colors.transparent,
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

Widget InfoTile(IconData icon,
    {String title = "Title", String subTitle = 'Sub title'}) {
  return ListTile(
    leading: Icon(
      icon,
      color: Colors.cyan,
    ),
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

Widget feedBackTile(FeedBackData feedBackData) {
  return Card(
    child: ListTile(
      leading: CircleAvatar(
        foregroundImage: NetworkImage(feedBackData.profilePicUrl),
        backgroundImage: AssetImage(''),
        radius: 20,
      ),
      title: Column(
        children: [
          Text(
            feedBackData.userName,
            style: TextStyle(fontSize: 18),
          ),
          Text(
            'Date: ${feedBackData.dateTime}',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
      ),
      subtitle: Text(
        feedBackData.feedbackMessage,
        style: TextStyle(fontSize: 14),
      ),
    ),
  );
}
