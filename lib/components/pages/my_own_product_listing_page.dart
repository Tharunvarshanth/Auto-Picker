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

class MyOwnProductListingPage extends StatefulWidget {
  const MyOwnProductListingPage({Key key}) : super(key: key);

  @override
  _MyOwnProductListingPageState createState() =>
      _MyOwnProductListingPageState();
}

class _MyOwnProductListingPageState extends State<MyOwnProductListingPage> {
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
    QuerySnapshot res =
        await productController.getUserProducts(_auth.currentUser.uid);
    print(res.docs);
    if (res.size > 0) {
      res.docs.forEach((element) {
        productList.add(Product.fromJson(element.data()));
      });
    }
    setState(() {
      isLoading = false;
    });
    print("Tharun ${productList[0].imagesList[0]}");
  }

  void navigateToProductPage(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductPage(
            product: productList[index],
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
