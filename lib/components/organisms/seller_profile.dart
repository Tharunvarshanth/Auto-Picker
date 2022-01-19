import 'package:auto_picker/components/atoms/text_description.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:flutter/material.dart';

class SellerProfilePage extends StatefulWidget {
  final Seller seller;
  const SellerProfilePage(this.seller);

  @override
  _SellerProfilePageState createState() => _SellerProfilePageState();
}

class _SellerProfilePageState extends State<SellerProfilePage> {
  bool isLoading = true;
  String userRole;

  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return Column(
      children: [
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