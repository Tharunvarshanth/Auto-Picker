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

class MyOwnAdvertismentListingPage extends StatefulWidget {
  const MyOwnAdvertismentListingPage({Key key}) : super(key: key);

  @override
  _MyOwnAdvertismentListingPageState createState() =>
      _MyOwnAdvertismentListingPageState();
}

class _MyOwnAdvertismentListingPageState
    extends State<MyOwnAdvertismentListingPage> {
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
    QuerySnapshot res = await advertisementController
        .getAdvertisementsBySeller(_auth.currentUser.uid);

    if (res.size > 0) {
      res.docs.forEach((element) {
        advertisementList.add(SpareAdvertisement.fromJson(element.data()));
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToAdPage(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvertisementPage(
            advertisement: advertisementList[index],
            isOwner: true,
          ),
        ));
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
              title: 'My Advertisement Listing',
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
                      navigateToAdPage(index);
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
