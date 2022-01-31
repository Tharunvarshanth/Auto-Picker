import 'package:auto_picker/components/atoms/custom_app_bar%20copy.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/atoms/product_tile.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/pages/advertisement_page.dart';
import 'package:auto_picker/components/pages/product_page.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/spare_advertisement.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/spare_advertisement_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdvertisementListingPage extends StatefulWidget {
  const AdvertisementListingPage({Key key}) : super(key: key);

  @override
  _AdvertisementListingPageState createState() =>
      _AdvertisementListingPageState();
}

class _AdvertisementListingPageState extends State<AdvertisementListingPage> {
  final ScrollController _controller = ScrollController();
  var advertisementController = AdvertisementController();
  bool isLogged = false;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<SpareAdvertisement> advertisementList = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      isLogged = _auth.currentUser != null;
    });
    getAdvertisementList();
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

  getAdvertisementList() async {
    //List<Product> prodList = [];
    QuerySnapshot res = await advertisementController.getAdvertisments();
    res.docs.forEach((element) async {
      QuerySnapshot res2 = await element.reference
          .collection(FirebaseCollections.AdvertisementList)
          .get();
      if (res2 != null) {
        print(res2);
        res2.docs.forEach((element) {
          print("AdvertisementListingPage ${element}");
          setState(() {
            advertisementList.add(SpareAdvertisement.fromJson(element.data()));
          });
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void navigateToAdvertisementPage(int index) {
    if (isLogged) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdvertisementPage(
              advertisement: advertisementList[index],
            ),
          ));
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Need to Signup',
                bodyText:
                    "Auto picker terms & conditions without an account user's cann't see product informations detaily",
                primaryButtonText: 'Ok',
                onPressedPrimary: () => Navigator.pop(context, 'Cancel'),
              ));
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              backgroundColor: AppColors.white,
            ),
          )
        : SafeArea(
            child: Scaffold(
            appBar: CustomAppBar(
              title: 'Advertisement Listing',
              isLogged: isLogged,
              showBackButton: true,
            ),
            bottomNavigationBar: Footer(),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: ListView.builder(
                controller: _controller,
                itemCount: advertisementList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      navigateToAdvertisementPage(index);
                    },
                    child: ProductTile(
                      title: advertisementList[index].title ?? '',
                      description: advertisementList[index].description ?? '',
                      price: "${advertisementList[index].price} rs" ?? '',
                      imgUrl: advertisementList[index].imageList[0],
                    ),
                  );
                },
              ),
            ),
          ));
  }
}
