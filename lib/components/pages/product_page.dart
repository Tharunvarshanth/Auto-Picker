import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/image_corousal.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/atoms/popup_modal_order.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/pages/edit_existing_product_page.dart';
import 'package:auto_picker/components/pages/product_payment_page.dart';
import 'package:auto_picker/models/carousel_data.dart';
import 'package:auto_picker/models/notification.dart';
import 'package:auto_picker/models/order.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/models/user_model.dart';
import 'package:auto_picker/services/notification_controller.dart';
import 'package:auto_picker/services/order_controller.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/push_messaging_service.dart';
import 'package:auto_picker/services/seller_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../routes.dart';

class ProductPage extends StatefulWidget {
  Product product;
  bool isOwner = false;
  ProductPage({Key key, this.product, this.isOwner = false}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var productController = ProductController();
  var sellerController = SellerController();
  var orderController = OrderController();
  bool _hasCallSupport = false;
  Future<void> _launched;
  Seller seller;
  bool isLogged = false;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<CarouselItemData> imageList = [];
  var noOfItemsController = TextEditingController();
  var pushMessagingService = PushMessagingSerivce();
  var notificationController = NotificationController();
  var userControlller = UserController();
  UserModel currentUser;

  void initState() {
    super.initState();
// Check for phone call support.
    canLaunch('tel:123').then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
    setData();
  }

  void setData() async {
    var res = await sellerController.getSeller(widget.product.uid);
    if (res != null) {
      seller = Seller.fromJson(res);
    }
    widget.product.imagesList.forEach((element) {
      var temp = CarouselItemData(element, '', '');
      setState(() {
        imageList.add(temp);
      });
    });
    setState(() {
      isLoading = false;
    });
    currentUser = UserModel.fromJson(
        await userControlller.getUser(_auth.currentUser.uid));
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  void deleteProduct() async {
    if (await productController.deleteProduct(widget.product)) {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/done.svg',
                titleText: 'Deleted',
                bodyText: "",
                primaryButtonText: 'Ok',
                onPressedPrimary: () =>
                    navigate(context, RouteGenerator.profilePage),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Deleting is failure',
                bodyText: "",
                primaryButtonText: 'Ok',
                onPressedPrimary: () =>
                    navigate(context, RouteGenerator.profilePage),
              ));
    }
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  void makeOrder() {
    showDialog(
        context: context,
        builder: (context) => PopUpModalOrder(
              icon: 'assets/images/order-now.png',
              titleText: 'No of Items',
              bodyText:
                  "You can order your products we will send a notification seller's mobile",
              primaryButtonText: "Done",
              onPressedPrimary: () {
                if (noOfItemsController.text != null &&
                    isNumeric(noOfItemsController.text)) {
                  print("no of Items ${isNumeric(noOfItemsController.text)}");
                  processOrder(noOfItemsController.text);
                }
                ;
              },
              secondaryButtonText: "Cancel",
              controller: noOfItemsController,
              onPressedSecondary: () {
                Navigator.pop(context, 'Cancel');
              },
            ));
  }

  void processOrder(String numberItems) async {
    var order = Order(
        '',
        _auth.currentUser.uid,
        widget.product.pId,
        widget.product.uid,
        false,
        int.parse(numberItems),
        '',
        false,
        DateTime.now().toString(),
        false);
    var res = await orderController.addOrder(order);
    if (res != null) {
      var res1 = false;
      order.orderId = res;
      res1 = await orderController.updateOrderField(order, 'orderId', res);
      if (res1) {
        List<String> list = [order.sellerId]; //[order.sellerId];

        var pmBody =
            'You have got a order from  ${currentUser.fullName} for product : ${widget.product.title}';

        var no = NotificationModel(ORDERTITLTE, pmBody,
            DateTime.now().toString(), NOTIFICATIONTYPES[0], false);
        pushMessagingService.sendOrderNotification(list, ORDERTITLTE, pmBody);

        notificationController.addNotification(no, order.sellerId);
        Navigator.pop(context, 'Cancel');
        showDialog(
            context: context,
            builder: (context) => ItemDialogMessage(
                  icon: 'assets/images/done.svg',
                  titleText: 'Success',
                  bodyText: "Order successfully placed",
                  primaryButtonText: "Ok",
                  onPressedPrimary: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  secondaryButtonText: 'Go Home',
                  onPressedSecondary: () =>
                      navigate(context, RouteGenerator.homePage),
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Failure',
                bodyText: "Please Try again",
                primaryButtonText: "Ok",
                onPressedPrimary: () {
                  Navigator.pop(context, 'Cancel');
                },
              ));
    }
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: const CustomAppBar(
        title: 'Product',
        showBackButton: true,
      ),
      bottomNavigationBar: Footer(
        isLogged: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: AppColors.white,
              ),
            )
          : Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GenericText(
                            text: seller.shopName ?? '',
                            textSize: 24,
                            isBold: true,
                          )),
                    ),
                    CustomCarousel(items: imageList),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            GenericText(
                              text: widget.product.title,
                              textSize: 24,
                            ),
                            GenericText(
                                text: widget.product.condition, textSize: 18),
                          ],
                          mainAxisSize: MainAxisSize.min,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GenericText(
                                text: "Price  :",
                                textAlign: TextAlign.left,
                                textSize: 18),
                            GenericText(
                                text: "Rs ${widget.product.price}" ??
                                    PriceNegotiable,
                                textAlign: TextAlign.left,
                                textSize: 18),
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GenericText(
                              text: "Description  : ",
                              textAlign: TextAlign.left,
                              textSize: 18,
                              maxLines: 2,
                            ),
                            GenericText(
                              text: "${widget.product.description}",
                              textAlign: TextAlign.left,
                              textSize: 18,
                            ),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GenericText(
                                text: "Contact Detail  : ",
                                textAlign: TextAlign.left,
                                textSize: 18,
                              ),
                              GenericText(
                                text: "${seller.contactDetails}",
                                textAlign: TextAlign.left,
                                textSize: 18,
                              )
                            ]),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GenericText(
                                text: "Address  : ",
                                textAlign: TextAlign.left,
                                textSize: 18,
                              ),
                              GenericText(
                                text: "${seller.address}",
                                textAlign: TextAlign.left,
                                textSize: 18,
                              ),
                            ])
                      ],
                    ),
                    !widget.isOwner
                        ? Wrap(
                            spacing: 25,
                            children: [
                              GenericButton(
                                isBold: true,
                                text: _hasCallSupport
                                    ? CALL
                                    : CALLING_NOT_SUPPORTED,
                                paddingHorizontal: 4,
                                paddingVertical: 2,
                                onPressed: _hasCallSupport
                                    ? () => setState(() {
                                          _launched = _makePhoneCall(
                                              seller.contactDetails);
                                        })
                                    : null,
                                shadowColor: Colors.transparent,
                                backgroundColor: Colors.blue,
                                borderRadius: 14,
                              ),
                              GenericButton(
                                text: 'ORDER',
                                isBold: true,
                                paddingHorizontal: 4,
                                paddingVertical: 2,
                                onPressed: () => makeOrder(),
                                backgroundColor: Colors.blue,
                                shadowColor: Colors.transparent,
                                borderRadius: 14,
                              ),
                            ],
                            alignment: WrapAlignment.center,
                          )
                        : Wrap(
                            spacing: 20,
                            children: [
                              GenericButton(
                                isBold: true,
                                text: 'Update',
                                paddingHorizontal: 4,
                                paddingVertical: 2,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditExistingProductPage(
                                          product: widget.product,
                                        ),
                                      ));
                                },
                                shadowColor: Colors.transparent,
                                backgroundColor: Colors.blue,
                                borderRadius: 14,
                              ),
                              GenericButton(
                                text: 'Remove',
                                isBold: true,
                                paddingHorizontal: 4,
                                backgroundColor: AppColors.white,
                                paddingVertical: 2,
                                onPressed: () => deleteProduct(),
                                elevation: 0,
                                textColor: Colors.blue,
                                shadowColor: Colors.transparent,
                                borderRadius: 14,
                              ),
                              if (!widget.product.isPayed)
                                GenericButton(
                                  text: 'Pay',
                                  isBold: true,
                                  paddingHorizontal: 4,
                                  paddingVertical: 2,
                                  onPressed: () => {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProductPaymentPage(
                                            productId: widget.product.pId,
                                          ),
                                        ))
                                  },
                                  backgroundColor: Colors.blue,
                                  shadowColor: Colors.transparent,
                                  borderRadius: 14,
                                ),
                            ],
                            alignment: WrapAlignment.center,
                          )
                  ],
                ),
              ),
            ),
    ));
  }
}
