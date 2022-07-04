import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/organisms/order_tile.dart';
import 'package:auto_picker/models/notification.dart';
import 'package:auto_picker/models/order.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/services/notification_controller.dart';
import 'package:auto_picker/services/order_controller.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/push_messaging_service.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersSellerListPage extends StatefulWidget {
  const OrdersSellerListPage({Key key}) : super(key: key);

  @override
  _OrdersSellerListState createState() => _OrdersSellerListState();
}

class _OrdersSellerListState extends State<OrdersSellerListPage> {
  ScrollController _controller = ScrollController();
  List<Order> ordersList = [];
  List<Product> productList = [];
  List<UserModel> userList = [];
  var orderController = OrderController();
  var userControlller = UserController();
  var productController = ProductController();
  var notificationController = NotificationController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = true;
  String role = "";
  var pushMessagingService = PushMessagingSerivce();
  @override
  void initState() {
    super.initState();
    getList();
  }

  void getList() async {
    var user = await userControlller.getUser(auth.currentUser.uid);
    role = user['role'];
    QuerySnapshot res;

    res = await orderController.getOrdersBySeller(auth.currentUser.uid);
    if (res.size > 0) {
      res.docs.forEach((element) async {
        setState(() {
          ordersList.add(Order.fromJson(element));
        });

        var prodRes = await productController.getProduct(
            element['sellerId'], element['productId']);
        print("orderListing product ${prodRes["pId"]}");
        if (prodRes["pId"] != null) {
          print("orderListing product1 ${prodRes}");
          setState(() {
            productList.add(Product.fromJson(prodRes));
          });
        } else {
          print("orderListing product2 $prodRes");
          setState(() {
            productList.add(Product.fromEmptyJson());
          });
        }
        UserModel _user = (UserModel.fromJson(
            await userControlller.getUser(element['customerId'])));
        setState(() {
          userList.add(_user);
        });
      });
    }

    Future.delayed(const Duration(milliseconds: 4000), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  void onPressConfirmOrder(int index) async {
    List<String> list = [ordersList[index].customerId];
    var no = NotificationModel(ORDER_CONFIRM_TITLE, ORDER_CONFIRM_BODY,
        DateTime.now().toString(), NOTIFICATIONTYPES[0], false);
    pushMessagingService.sendOrderNotification(
        list, ORDER_CONFIRM_TITLE, ORDER_CONFIRM_BODY);

    notificationController.addNotification(no, ordersList[index].customerId);
    var res = await orderController.updateOrderField(
        ordersList[index], 'isConfirmed', true);
  }

  void cancelOrder() {}

  void onPressIsCompleted(int index) async {
    if (!ordersList[index].isCompleted) {
      List<String> list = [ordersList[index].customerId];
      var no = NotificationModel(ORDER_COMPLETED_TITLE, ORDER_COMPLETED_BODY,
          DateTime.now().toString(), NOTIFICATIONTYPES[0], false);
      pushMessagingService.sendOrderNotification(
          list, ORDER_COMPLETED_TITLE, ORDER_COMPLETED_BODY);

      notificationController.addNotification(no, ordersList[index].customerId);
      var res = await orderController.updateOrderField(
          ordersList[index], 'isCompleted', true);
      setState(() {
        isLoading = true;
      });
      getList();
    } else {
      print("onPressIsCompleted ${ordersList[index].isCompleted}");
      // set up the button
      Widget okButton = TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      AlertDialog alert = AlertDialog(
        title: Text('Invalid Operation'),
        content: Text('You cannot edit the alredy marked value'),
        actions: [
          okButton,
        ],
      );
    }
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
        title: 'My Orders',
        isLogged: true,
        showBackButton: true,
      ),
      bottomNavigationBar: Footer(
        isLogged: true,
        currentIndex: 0,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
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
                          onPressed: () {}, icon: Icon(Icons.sync_rounded))
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: ordersList.length != 0
                        ? ListView.builder(
                            controller: _controller,
                            itemCount: ordersList.length,
                            itemBuilder: (context, index) {
                              if (productList[index].uid == 'Product Removed') {
                                return GenericText(
                                  text: 'Product Removed',
                                  isBold: true,
                                );
                              } else {
                                return (OrderTile(
                                    index: index,
                                    isConfirmed: ordersList[index].isConfirmed,
                                    isCompleted: ordersList[index].isCompleted,
                                    ItemTitle: productList[index].title,
                                    itemCount: ordersList[index].noOfItems,
                                    itemPrice: productList[index].price,
                                    makeCall: () => _makePhoneCall(
                                        userList[index].phoneNumber),
                                    itemSubTitle:
                                        productList[index].description,
                                    itemImgUrl:
                                        productList[index].imagesList[0],
                                    orderedBy: userList[index].fullName,
                                    handleIsCompleted: () =>
                                        onPressIsCompleted(index),
                                    handleConfirmOrder: () =>
                                        onPressConfirmOrder(index)));
                              }
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
