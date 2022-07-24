import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/image_corousal_advertisment.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/atoms/product_tile.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/organisms/mechanics_horizontal_scroll.dart';
import 'package:auto_picker/components/pages/product_page.dart';
import 'package:auto_picker/components/pages/user_payment_page.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/models/spare_advertisement.dart';
import 'package:auto_picker/services/mechanic_controller.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/push_messaging_service.dart';
import 'package:auto_picker/services/seller_controller.dart';
import 'package:auto_picker/services/spare_advertisement_controller.dart';
import 'package:auto_picker/services/user_controller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../../routes.dart';
import 'advertisement_page.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();
  var mechanicsController = MechanicController();
  var advertisementController = AdvertisementController();
  var productController = ProductController();
  List<Mechanic> mechanicList = [];
  List<Product> productList = [];
  List<SpareAdvertisement> advertisementList = [];
  bool isLoading = true;
  var userInfo = UserInfoCache();
  bool isLogged = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var sellerController = SellerController();
  var userController = UserController();
  var userRole;
  var pushMessagingService = PushMessagingSerivce();
  @override
  void initState() {
    super.initState();
    setState(() {
      isLogged = _auth?.currentUser != null ? true : false;
    });
    controller.addListener(() {});
    setData();
    validatePayedUser();
    if (isLogged) {
      setOneSignalToken();
    }
  }

  //validating mechanics and seller login then they payed or not
  void validatePayedUser() async {
    if (!isLogged) return;
    var _user = await userController.getUser(_auth.currentUser.uid);
    userRole = _user["role"];
    switch (userRole) {
      case Users.Mechanic:
        {
          var _m =
              await mechanicsController.getMechanic((_auth.currentUser.uid));
          var mechanicModel = Mechanic.fromJson(_m);
          print("user smechanics ${_m}");
          if (!mechanicModel.isPayed) showAlert(context);
        }

        break;
      case Users.Seller:
        {
          var _s = await sellerController.getSeller((_auth.currentUser.uid));
          var sellerModel = Seller.fromJson(_s);
          if (!sellerModel?.isPayed) showAlert(context);
        }
        break;
    }
  }

  void setOneSignalToken() async {
    var externalUserId = _auth.currentUser
        .uid; // You will supply the external user id to the OneSignal SDK

// Setting External User Id with Callback Available in SDK Version 3.9.3+
    OneSignal.shared.setExternalUserId(externalUserId).then((results) {
      print("setExternalUserId ${results.toString()}");
    }).catchError((error) {
      print("setExternalUserId:e ${error.toString()}");
    });
  }

  void setData() async {
    ([
      getProductList(),
      getMechanicsList(),
      getAdvertismentList(),
    ]);
    setState(() {
      isLoading = false;
    });
  }

  getMechanicsList() async {
    List<dynamic> res = await mechanicsController.getMechanics();
    if (res != null) {
      res.forEach((element) {
        var tM = Mechanic.fromJson(element);
        if (tM.isPayed) {
          setState(() {
            mechanicList.add(tM);
          });
        }
      });
    }
  }

  getAdvertismentList() async {
    List<SpareAdvertisement> advertisementTempList = [];
    QuerySnapshot res = await advertisementController.getAdvertisments();
    await asyncForEach(res, (SpareAdvertisement list) async {
      if (list != null) {
        print("HomePage Add ${list.aId}");

        if (list.isPaymentDone) {
          if (DateTime.parse(list.endDate).isAfter(DateTime.now())) {
            // print("HomePagesortDate: ${list}");
            setState(() {
              advertisementList.add(list);
            });
            //advertisementList.sort((a, b) => DateTime.parse(a.createdDate)
            //  .compareTo(DateTime.parse(b.createdDate)));
            print("final list ${advertisementList[0].createdDate}");
          } else {
            //remove add
            var res = await advertisementController.removeAdvertisement(
                list.uid, list.aId);
          }
        } else {}
      }
    });
  }

  asyncForEach(QuerySnapshot<Object> listQuery, callback) async {
    List<SpareAdvertisement> advertisementTempList = [];
    listQuery.docs.forEach((element) async {
      QuerySnapshot res2 = await element.reference
          .collection(FirebaseCollections.AdvertisementList)
          .get();
      print("res 2: ${res2.docs}");
      if (res2 != null) {
        res2.docs.forEach((element) async {
          await callback(SpareAdvertisement.fromJson(element.data()));
        });
      }
    });
  }

  getProductList() async {
    //List<Product> prodList = [];
    QuerySnapshot res = await productController.getProducts();
    print("HomeproductList $res");
    res.docs.forEach((element) async {
      QuerySnapshot res2 = await element.reference
          .collection(FirebaseCollections.ProductsList)
          .get();
      if (res2 != null) {
        print(res2);
        res2.docs.forEach((element) {
          var tP = Product.fromJson(element.data());
          if (tP.isPayed) {
            setState(() {
              productList.add(tP);
            });
          }
        });
      }
    });
  }

  void navigateToProductPage(int index) {
    var isOwner =
        productList[index].uid == _auth.currentUser?.uid ? true : false;
    if (isLogged) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProductPage(product: productList[index], isOwner: isOwner),
          ));
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Need to Signin',
                bodyText:
                    "Auto picker terms & conditions without an account user's cann't see detail view",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => Navigator.pop(context, 'Cancel'),
              ));
    }
  }

  testFunction() {
    navigate(context, RouteGenerator.mapLatLonGetter);
  }

  void showAlert(BuildContext context) {
    // show the dialog
    showDialog(
        context: context,
        builder: (context) => ItemDialogMessage(
            icon: 'assets/images/x-circle.svg',
            titleText: 'Payment Pending',
            bodyText:
                'You need to complete a payment to continue on this application',
            primaryButtonText: "Retry",
            secondaryButtonText: "Log out",
            onPressedSecondary: () {
              signOut();
            },
            onPressedPrimary: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserSignUpPaymentPage(
                      id: _auth.currentUser.uid,
                      isSeller: userRole == Users.Seller),
                ),
              );
            }));
  }

  void signOut() {
    //usually called after the user logs out of your app
    OneSignal.shared.removeExternalUserId();
    //redirect
    userInfo.clearValue();
    _auth.signOut().then((value) => navigate(context, RouteGenerator.homePage));
  }

  void navigateToAdvertisementPage(int index) {
    var isOwner =
        advertisementList[index].uid == _auth.currentUser?.uid ? true : false;
    print("advert");
    if (isLogged) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdvertisementPage(
              advertisement: advertisementList[index],
              isOwner: isOwner,
            ),
          ));
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Need to Signin',
                bodyText:
                    "Auto picker terms & conditions without an account user's cann't see detail view",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => Navigator.pop(context, 'Cancel'),
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> getLogged() async {
      if (await userInfo.getId() != null) {
        setState(() {
          isLogged = true;
        });
      }
    }

    getLogged();
    bool _pinned = true;
    bool _snap = false;
    bool _floating = false;

    return SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                body: CustomScrollView(slivers: <Widget>[
                  SliverAppBar(
                    pinned: _pinned,
                    snap: _snap,
                    floating: _floating,
                    backgroundColor: AppColors.themePrimary,
                    automaticallyImplyLeading: false,
                    expandedHeight: 140.0,
                    flexibleSpace: FlexibleSpaceBar(
                      /*centerTitle: false,
                        titlePadding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                        title: Text('Welcome To Auto Picker'),*/
                      background: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(25, 90, 25, 0),
                            child: null,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: ExactAssetImage(
                                    "assets/images/Asset-2.png"),
                                fit: BoxFit.none,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 5, 0, 10),
                            child: GenericText(
                              isBold: true,
                              textAlign: TextAlign.left,
                              textSize: 22,
                              color: AppColors.ashWhite,
                              text: 'Welcome To Auto Picker',
                            ),
                          )
                        ],
                      ),
                      /*Container(
                          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                          child: null,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  ExactAssetImage("assets/images/Asset-2.png"),
                              fit: BoxFit.none,
                            ),
                          ),
                        )*/
                    ),
                    actions: <Widget>[
                      if (!isLogged)
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: GestureDetector(
                            onTap: () => Navigator.of(context)
                                ?.pushNamed(RouteGenerator.loginPage),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                    ],
                  ),
                  SliverList(
                      delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (advertisementList.isNotEmpty)
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GenericText(
                                      text: 'Advertisements',
                                      isBold: true,
                                      textSize: 24,
                                    ),
                                    GenericTextButton(
                                      isBold: true,
                                      color: AppColors.darkBlue,
                                      text: 'See All',
                                      onPressed: () {
                                        navigate(
                                            context,
                                            RouteGenerator
                                                .advertisementListingPage);
                                      },
                                    ),
                                  ]),
                            const SizedBox(
                              height: 10,
                            ),
                            if (advertisementList.isNotEmpty)
                              CustomCarouselAdvertisement(
                                items: advertisementList,
                                onPressedAd: (index) =>
                                    navigateToAdvertisementPage(index),
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GenericText(
                                      text: 'Mechanics',
                                      isBold: true,
                                      textSize: 24),
                                  GenericTextButton(
                                    isBold: true,
                                    color: AppColors.darkBlue,
                                    text: 'See All',
                                    onPressed: () {
                                      if (isLogged) {
                                        navigate(
                                            context,
                                            RouteGenerator
                                                .mechanicsListingPage);
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) =>
                                                ItemDialogMessage(
                                                  icon:
                                                      'assets/images/x-circle.svg',
                                                  titleText: 'Need to Signin',
                                                  bodyText:
                                                      "Auto picker terms & conditions without an account user's cann't see detail view",
                                                  primaryButtonText: 'Ok',
                                                  onPressedPrimary: () =>
                                                      Navigator.pop(
                                                          context, 'Cancel'),
                                                ));
                                      }
                                    },
                                  ),
                                ]),
                            const SizedBox(
                              height: 0,
                            ),
                            MechanicsHorizontalItemScroll(
                                ImageTileList: mechanicList,
                                onReachMax: () {
                                  return Future.value([]);
                                }),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GenericText(
                                    text: 'Products',
                                    isBold: true,
                                    textSize: 24,
                                  ),
                                  GenericTextButton(
                                    text: "See All",
                                    isBold: true,
                                    color: AppColors.darkBlue,
                                    onPressed: () {
                                      navigate(context,
                                          RouteGenerator.productsListingPage);
                                    },
                                  ),
                                ]),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 5),
                              height: productList.length < 4 ? 250 : 400,
                              child: ListView.builder(
                                controller: controller,
                                itemCount: productList.length ?? 0,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => navigateToProductPage(index),
                                    child: ProductTile(
                                      imgUrl: productList[index].imagesList[0],
                                      title: productList[index].title,
                                      description:
                                          productList[index].description,
                                      price: "${productList[index].price} rs",
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: 1,
                  ))
                ]),
                bottomNavigationBar: Footer(
                  isLogged: isLogged,
                  currentIndex: 0,
                ),
              ));
  }
}
