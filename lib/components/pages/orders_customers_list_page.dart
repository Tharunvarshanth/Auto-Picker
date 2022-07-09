import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/organisms/order__customer_tile.dart';
import 'package:auto_picker/components/organisms/order_tile.dart';
import 'package:auto_picker/models/order.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/services/notification_controller.dart';
import 'package:auto_picker/services/order_controller.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/push_messaging_service.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersCustomersListPage extends StatefulWidget {
  const OrdersCustomersListPage({Key key}) : super(key: key);

  @override
  _OrdersCustomersListState createState() => _OrdersCustomersListState();
}

class _OrdersCustomersListState extends State<OrdersCustomersListPage> {
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
    ordersList = [];

    var user = await userControlller.getUser(auth.currentUser.uid);
    role = user['role'];
    QuerySnapshot res;

    res = await orderController.getOrderByCustomer();
    res.docs.forEach((element) async {
      QuerySnapshot res2 = await element.reference
          .collection(FirebaseCollections.OrdersList)
          .get();
      if (res2 != null) {
        print(res2);
        res2.docs.forEach((element) async {
          var tP = Order.fromJson(element.data());
          if (tP.customerId == auth.currentUser.uid) {
            setState(() {
              ordersList.add(tP);
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
                await userControlller.getUser(element['sellerId'])));
            setState(() {
              userList.add(_user);
            });
          }
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 4000), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  showAlertDialog(BuildContext context, String title, Function() onYes) {
    // set up the button
    Widget yesButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        if (onYes != null) {
          onYes();
        }
        Navigator.pop(context, 'Cancel');
      },
    );

    Widget noButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(color: AppColors.black),
      ),
      onPressed: () {
        Navigator.pop(context, 'Cancel');
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(""),
      actions: [yesButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Container(
                    child: ordersList.length != 0
                        ? ListView.builder(
                            controller: _controller,
                            itemCount: ordersList.length,
                            itemBuilder: (context, index) {
                              if (productList[index]?.uid ==
                                  'Product Removed') {
                                return GenericText(
                                  text: 'Product Removed',
                                  isBold: true,
                                );
                              } else {
                                return (OrderCustomerTile(
                                  index: index,
                                  isConfirmed: ordersList[index]?.isConfirmed,
                                  isCompleted: ordersList[index]?.isCompleted,
                                  ItemTitle: productList[index]?.title,
                                  itemCount: ordersList[index]?.noOfItems,
                                  itemPrice: productList[index]?.price,
                                  makeCall: () => _makePhoneCall(
                                      userList[index].phoneNumber),
                                  itemSubTitle: productList[index]?.description,
                                  itemImgUrl: productList[index]?.imagesList[0],
                                  sellerBy: userList[index]?.fullName,
                                  handleIsCompleted: () => {},
                                  handleConfirmOrder: () => {},
                                  cancelled: ordersList[index]?.cancelled,
                                  cancelOrder: () => {
                                    showAlertDialog(
                                        context,
                                        "Are you want to cancel order",
                                        () => {})
                                  },
                                ));
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
