import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/image_corousal.dart';
import 'package:auto_picker/components/atoms/image_corousal_advertisment.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/atoms/product_tile.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/organisms/mechanics_horizontal_scroll.dart';
import 'package:auto_picker/components/pages/product_page.dart';
import 'package:auto_picker/models/carousel_data.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/spare_advertisement.dart';
import 'package:auto_picker/services/mechanic_controller.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/spare_advertisement_controller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../routes.dart';

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

  @override
  void initState() {
    super.initState();
    setState(() {
      isLogged = _auth.currentUser != null ? true : false;
    });
    controller.addListener(() {});
    setData();
    // setOneSignalToken();
    print("city  ${ReadCityJsonData()}");
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
        print("HomePagesortDate: ${list.aId}");

        if (list.isPaymentDone) {
          if (DateTime.parse(list.endDate).isAfter(DateTime.now())) {
            print("HomePagesortDate: ${list}");
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
    if (isLogged) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              product: productList[index],
            ),
          ));
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Need to Signup',
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

    return SafeArea(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
                appBar: CustomAppBar(
                  showBackButton: false,
                  title: 'Home',
                  isLogged: isLogged,
                ),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GenericText(
                                text: 'Mechanics', isBold: true, textSize: 24),
                            GenericTextButton(
                              color: AppColors.Blue,
                              text: 'See All',
                              onPressed: () {
                                navigate(context,
                                    RouteGenerator.mechanicsListingPage);
                              },
                            ),
                          ]),
                      const SizedBox(
                        height: 10,
                      ),
                      MechanicsHorizontalItemScroll(
                          ImageTileList: mechanicList,
                          onReachMax: () {
                            return Future.value([]);
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                      if (advertisementList.length > 0)
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GenericText(
                                text: 'Advertisements',
                                isBold: true,
                                textSize: 24,
                              ),
                              GenericTextButton(
                                color: AppColors.Blue,
                                text: 'See All',
                                onPressed: () {
                                  navigate(context,
                                      RouteGenerator.advertisementListingPage);
                                },
                              ),
                            ]),
                      const SizedBox(
                        height: 10,
                      ),
                      if (advertisementList.length > 0)
                        CustomCarouselAdvertisement(items: advertisementList),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GenericText(
                              text: 'Products',
                              isBold: true,
                              textSize: 24,
                            ),
                            GenericTextButton(
                              color: AppColors.Blue,
                              text: 'See All',
                              onPressed: () {
                                navigate(context,
                                    RouteGenerator.productsListingPage);
                              },
                            ),
                          ]),
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                        height: 400,
                        child: ListView.builder(
                          controller: controller,
                          itemCount: productList.length ?? 0,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => navigateToProductPage(index),
                              child: ProductTile(
                                imgUrl: productList[index].imagesList[0],
                                title: productList[index].title,
                                description: productList[index].description,
                                price: "${productList[index].price} rs",
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )),
                ),
                bottomNavigationBar: Footer(
                  isLogged: isLogged,
                  currentIndex: 0,
                ),
              ));
  }
}
