import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/text_description.dart';
import 'package:auto_picker/components/atoms/text_description_with_button.dart';
import 'package:auto_picker/components/pages/add_new_advertisement.dart';
import 'package:auto_picker/components/pages/add_new_product.dart';
import 'package:auto_picker/components/pages/my_own_advertisement_listing_page.dart';
import 'package:auto_picker/components/pages/my_own_product_listing_page.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';

class SellerProfile extends StatefulWidget {
  final Seller seller;
  const SellerProfile(this.seller);

  @override
  _SellerProfileState createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  bool isLoading = true;
  String userRole;

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        GenericText(
          text: 'Shop Controll',
          textSize: 30,
          isBold: true,
        ),
        TextDescriptionWithButton(
          title: 'Add New Product',
          description: 'You can add new products to your shop collections',
          onPress: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewProductPage()),
          ),
        ),
        TextDescriptionWithButton(
            title: 'My Orders',
            description: 'You can view received order',
            onPress: () => navigate(context, RouteGenerator.orderSellerPage)),
        TextDescriptionWithButton(
          title: 'My Products',
          description: 'You can view and edit your own products',
          onPress: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MyOwnProductListingPage()),
          ),
        ),
        TextDescriptionWithButton(
          title: 'My ADS',
          description: 'You can view and edit your Advertisements',
          onPress: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MyOwnAdvertismentListingPage()),
          ),
        ),
        TextDescriptionWithButton(
          title: 'Add Advertisements',
          description: 'You can add advertisements to your product',
          onPress: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddNewAdvertisementPage()),
          ),
        ),
        TextDescription(
          title: widget.seller.address,
          description: 'Shop Address',
        ),
        TextDescription(
          title: widget.seller.city,
          description: 'Shop City',
        ),
        TextDescription(
          title: widget.seller.shopName,
          description: 'Shop Name',
        ),
        TextDescription(
          title: widget.seller.contactDetails,
          description: 'Shop Contact Details',
        ),
      ],
    );
  }
}
