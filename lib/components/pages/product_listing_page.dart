import 'package:auto_picker/components/atoms/custom_app_bar%20copy.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/atoms/product_tile.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/pages/product_page.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductListingPage extends StatefulWidget {
  const ProductListingPage({Key key}) : super(key: key);

  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  final ScrollController _controller = ScrollController();
  var productController = ProductController();
  bool isLogged = false;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Product> productList = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      isLogged = _auth.currentUser != null;
    });
    getProductList();
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

  getProductList() async {
    //List<Product> prodList = [];
    QuerySnapshot res = await productController.getProducts();
    res.docs.forEach((element) async {
      QuerySnapshot res2 = await element.reference
          .collection(FirebaseCollections.ProductsList)
          .get();
      if (res2 != null) {
        print(res2);
        res2.docs.forEach((element) {
          print("ProductListingPage ${element}");
          setState(() {
            productList.add(Product.fromJson(element.data()));
          });
        });
      }
    });
    setState(() {
      isLoading = false;
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
              title: 'Product Listing',
              isLogged: isLogged,
              showBackButton: true,
            ),
            bottomNavigationBar: Footer(),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: ListView.builder(
                controller: _controller,
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      navigateToProductPage(index);
                    },
                    child: ProductTile(
                      title: productList[index].title ?? '',
                      description: productList[index].description ?? '',
                      price: "${productList[index].price} rs" ?? '',
                      imgUrl: productList[index].imagesList[0],
                    ),
                  );
                },
              ),
            ),
          ));
  }
}
