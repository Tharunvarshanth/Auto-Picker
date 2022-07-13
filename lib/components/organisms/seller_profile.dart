import 'package:auto_picker/components/atoms/details_card_description.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/text_description.dart';
import 'package:auto_picker/components/atoms/text_description_with_button.dart';
import 'package:auto_picker/components/pages/add_new_advertisement.dart';
import 'package:auto_picker/components/pages/add_new_product.dart';
import 'package:auto_picker/components/pages/orders_seller_page.dart';
import 'package:auto_picker/components/pages/my_own_advertisement_listing_page.dart';
import 'package:auto_picker/components/pages/my_own_product_listing_page.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/routes.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:auto_picker/themes/colors.dart';

class SellerProfile extends StatefulWidget {
  final Seller seller;
  const SellerProfile(this.seller);

  @override
  _SellerProfileState createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  bool isLoading = true;
  String userRole;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Text(
          'Your Shop',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color.fromARGB(255, 255, 60, 0)),
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            shopControllerCard(
              (MediaQuery.of(context).size.width) / 1.075,
                'Add Product',
                'You can add new products to your shop collections',
                Icons.add_shopping_cart_outlined, const AddNewProductPage()),
          ],
        ),
        Row(
          children: [
            shopControllerCard((MediaQuery.of(context).size.width) / 2.19,'My Orders', 'You can view received order', Icons.production_quantity_limits_outlined, const OrdersSellerListPage()),
            shopControllerCard((MediaQuery.of(context).size.width) / 2.19,'My Products', 'You can view and edit your own products', Icons.inventory_2_outlined, const MyOwnProductListingPage()),
          ],

        ),
        Row(
          children: [
            shopControllerCard((MediaQuery.of(context).size.width) / 2.19,'My ADS', 'You can view and edit your Advertisements', Icons.newspaper_outlined, const MyOwnAdvertismentListingPage()),
            shopControllerCard((MediaQuery.of(context).size.width) / 2.19,'Add Ads', 'You can add advertisements to your product', Icons.add_card_outlined, const MyOwnAdvertismentListingPage()),
          ],

        ),
        const SizedBox(
          height: 20,
        ),
        shopDetailsCard(widget.seller.address, 'Shop Address', Icons.location_on_outlined),
        shopDetailsCard(widget.seller.city, 'Shop City', Icons.apartment_outlined),
        shopDetailsCard(widget.seller.shopName, 'Shop Name', Icons.store_outlined),
        shopDetailsCard(widget.seller.contactDetails, 'Shop Contact Details', Icons.phone_outlined),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  // Shop Controller Card Common component
  Widget shopControllerCard(width, title, description, icon, tap) => Card(
        shadowColor: AppColors.themePrimary,
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => tap),
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                width: width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 255, 60, 0),
                      Color.fromARGB(255, 248, 147, 100)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, size: 22, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 4),
                    // Text(
                    //   description,
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     color: AppColors.themePrimary,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

      // Shop Deatails Card Common component
  Widget shopDetailsCard(title, description, icon) => Card(
        shadowColor: AppColors.themePrimary,
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          alignment: Alignment.centerLeft,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.0, color: Color.fromARGB(255, 255, 60, 0)),
            ),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 255, 255),
                Color.fromARGB(255, 247, 161, 122)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 22, color: Colors.red),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  color: Color.fromARGB(255, 255, 60, 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
              // const SizedBox(height: 4),
              // Text(
              //   description,
              //   style: TextStyle(
              //     fontSize: 15,
              //     color: AppColors.themePrimary,
              //   ),
              // ),
            ],
          ),
        ),
      );
}
