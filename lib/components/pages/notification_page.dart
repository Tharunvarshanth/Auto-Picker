import 'package:auto_picker/components/organisms/notification_tile.dart';
import 'package:auto_picker/models/notification_data.dart';
import 'package:auto_picker/services/notification_controller.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  ScrollController _controller = ScrollController();
  List<NotificationData> notificationsList = [];
  var notificationController = NotificationController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      //add scroll listener to load data from database
    });
    getNotifications();
  }

  void getNotifications() {}
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
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 4,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const ListTile(
          leading: Icon(
            Icons.notifications_outlined,
            size: 48,
            color: Colors.cyan,
          ),
          title: Text(
            'Notifications',
            style: TextStyle(fontSize: 24),
          ),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: const Icon(
                  Icons.more_horiz,
                  size: 26.0,
                ),
              )),
        ],
        actionsIconTheme:
            const IconThemeData(size: 30.0, color: Colors.grey, opacity: 10.0),
      ),
      // bottomNavigationBar: Footer(
      //   items: [
      //     IconLabelPair(icon: const Icon(Icons.home), label: 'Home'),
      //     IconLabelPair(icon: const Icon(Icons.home), label: 'Home'),
      //     IconLabelPair(icon: const Icon(Icons.home), label: 'Home'),
      //   ],
      //   onTap: (int index) {},
      // ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 8,
              child: Row(
                children: [
                  const Expanded(
                      flex: 2,
                      child: ListTile(
                        title: Text(
                          'Show',
                          style: TextStyle(fontSize: 16),
                        ),
                        subtitle: Text(
                          'All',
                          style: TextStyle(color: Colors.cyan, fontSize: 24),
                        ),
                      )),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.sync_alt_outlined,
                        size: 32,
                        color: Colors.cyan,
                      ))
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: notificationsList.isNotEmpty
                  ? ListView.builder(
                      controller: _controller,
                      itemCount: notificationsList.length,
                      itemBuilder: (context, index) {
                        var data = notificationsList[index];
                        return NotificationTile(
                          byOwner: data.byOwner,
                          dateTime: data.dateTime,
                          description: data.description,
                          notificationImgUrl: data.notificationImgUrl,
                          read: data.read,
                          title: data.title,
                        );
                      },
                    )
                  : Center(
                      child: Image.network(
                          'https://shuvautsav.com/frontend/dist/images/logo/no-item-found-here.png'),
                    ),
            ),
          )
        ],
      ),
    ));
  }
}
