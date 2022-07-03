import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/organisms/notification_tile.dart';
import 'package:auto_picker/models/notification.dart';
import 'package:auto_picker/models/notification_data.dart';
import 'package:auto_picker/services/notification_controller.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key key}) : super(key: key);

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  ScrollController _controller = ScrollController();
  List<NotificationModel> notificationsList = [];
  bool isLoading = true;
  var notificationController = NotificationController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      //add scroll listener to load data from database
    });
    getNotifications();
  }

  void getNotifications() async {
    QuerySnapshot res =
        await notificationController.getNotifications(_auth.currentUser.uid);

    if (res.size > 0) {
      res.docs.forEach((element) async {
        setState(() {
          notificationsList.add(NotificationModel.fromJson(element));
        });
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  getimageUrl(String type) {
    switch (type) {
      case NOTIFICATION_TYPE_ORDER:
        {
          return 'assets/images/order-now.png';
        }
        break;
      default:
        {
          break;
        }
    }
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
        title: 'My Notifications',
        isLogged: true,
        showBackButton: true,
      ),
      bottomNavigationBar: Footer(
        isLogged: true,
        currentIndex: 1,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Card(
                    elevation: 8,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                    child: notificationsList.isNotEmpty
                        ? ListView.builder(
                            controller: _controller,
                            itemCount: notificationsList.length,
                            itemBuilder: (context, index) {
                              var data = notificationsList[index];
                              return NotificationTile(
                                dateTime: data.timeStamp,
                                description: data.message,
                                notificationImgUrl:
                                    getimageUrl(data.messageType),
                                read: data.isRead,
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
