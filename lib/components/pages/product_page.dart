import 'package:auto_picker/components/atoms/custom_app_bar%20copy.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/image_corousal.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/models/carousel_data.dart';
import 'package:auto_picker/models/product.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/seller_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductPage extends StatefulWidget {
  Product product;
  ProductPage({Key key, this.product}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  var productController = ProductController();
  var sellerController = SellerController();
  bool _hasCallSupport = false;
  Future<void> _launched;
  Seller seller;
  bool isLogged = false;
  bool isLoading = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<CarouselItemData> imageList = [];

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
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
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
      bottomNavigationBar: Footer(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                backgroundColor: AppColors.white,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
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
                        GenericText(
                            text:
                                "Rs ${widget.product.price}" ?? PriceNegotiable,
                            textAlign: TextAlign.left,
                            textSize: 18),
                        Divider(
                          thickness: 2,
                        ),
                        GenericText(
                          text: widget.product.description,
                          textAlign: TextAlign.left,
                          textSize: 18,
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        GenericText(
                          text: seller.contactDetails,
                          textAlign: TextAlign.left,
                          textSize: 18,
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        GenericText(
                          text: seller.address,
                          textAlign: TextAlign.left,
                          textSize: 18,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Wrap(
                      spacing: 20,
                      children: [
                        GenericButton(
                          isBold: true,
                          text: _hasCallSupport
                              ? 'CALL'
                              : 'Calling not supported',
                          paddingHorizontal: 4,
                          paddingVertical: 2,
                          onPressed: _hasCallSupport
                              ? () => setState(() {
                                    _launched =
                                        _makePhoneCall(seller.contactDetails);
                                  })
                              : null,
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.blue,
                          borderRadius: 14,
                        ),
                        GenericButton(
                          text: 'CHAT',
                          isBold: true,
                          paddingHorizontal: 4,
                          backgroundColor: AppColors.white,
                          paddingVertical: 2,
                          onPressed: () {},
                          elevation: 0,
                          textColor: Colors.blue,
                          shadowColor: Colors.transparent,
                          borderRadius: 14,
                        ),
                        GenericButton(
                          text: 'ORDER',
                          isBold: true,
                          paddingHorizontal: 4,
                          paddingVertical: 2,
                          onPressed: () {},
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
