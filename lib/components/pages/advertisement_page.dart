import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/image_corousal.dart';
import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/pages/advertisement_payment_page.dart';
import 'package:auto_picker/components/pages/edit_existing_advertisement.dart';
import 'package:auto_picker/models/carousel_data.dart';
import 'package:auto_picker/models/seller.dart';
import 'package:auto_picker/models/spare_advertisement.dart';
import 'package:auto_picker/services/seller_controller.dart';
import 'package:auto_picker/services/spare_advertisement_controller.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/constands.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../routes.dart';

class AdvertisementPage extends StatefulWidget {
  SpareAdvertisement advertisement;
  bool isOwner = false;
  AdvertisementPage({Key key, this.advertisement, this.isOwner = false})
      : super(key: key);

  @override
  _AdvertisementPageState createState() => _AdvertisementPageState();
}

class _AdvertisementPageState extends State<AdvertisementPage> {
  var advertisementController = AdvertisementController();
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
    setState(() {
      isLogged = _auth.currentUser != null;
    });
    canLaunch('tel:123').then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
    setData();
  }

  void setData() async {
    var res = await sellerController.getSeller(widget.advertisement.uid);
    if (res != null) {
      seller = Seller.fromJson(res);
    }
    widget.advertisement.imageList.forEach((element) {
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
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  void deleteProduct() async {
    if (await advertisementController.deleteProduct(widget.advertisement)) {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/done.svg',
                titleText: 'Deleted',
                bodyText: "",
                primaryButtonText: 'Ok',
                onPressedPrimary: () =>
                    navigate(context, RouteGenerator.profilePage),
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => ItemDialogMessage(
                icon: 'assets/images/x-circle.svg',
                titleText: 'Deleting is failure',
                bodyText: "",
                primaryButtonText: 'Ok',
                onPressedPrimary: () =>
                    navigate(context, RouteGenerator.profilePage),
              ));
    }
  }

  void paymentPage() {
    var params = {
      'adId': widget.advertisement.aId,
      'item': widget.advertisement.title,
      'subTitle': widget.advertisement.subtitle
    };
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvertisementPaymentPage(params: params),
      ),
    );
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'Advertisement',
        showBackButton: true,
        isLogged: isLogged,
      ),
      bottomNavigationBar: Footer(
        currentIndex: -1,
        isLogged: isLogged,
      ),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GenericText(
                              text: widget.advertisement.title,
                              textSize: 24,
                            ),
                            GenericText(
                                text: widget.advertisement.subtitle,
                                textSize: 18),
                            if (widget.isOwner &&
                                !widget.advertisement.isPaymentDone)
                              GenericText(
                                  text: 'Payment not done', textSize: 18),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GenericText(
                                text: "Price  : ",
                                textAlign: TextAlign.left,
                                textSize: 18),
                            GenericText(
                                text: "Rs ${widget.advertisement.price}" ??
                                    PriceNegotiable,
                                textAlign: TextAlign.left,
                                textSize: 18),
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GenericText(
                              text: "Description  : ",
                              textAlign: TextAlign.left,
                              textSize: 18,
                            ),
                            Flexible(
                                child: GenericText(
                                    text: "${widget.advertisement.description}",
                                    textAlign: TextAlign.left,
                                    textSize: 18,
                                    maxLines: 3)),
                          ],
                        ),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GenericText(
                                text: "Contact Detail  : ",
                                textAlign: TextAlign.left,
                                textSize: 18,
                              ),
                              GenericText(
                                text: "${seller.contactDetails}",
                                textAlign: TextAlign.left,
                                textSize: 18,
                              )
                            ]),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GenericText(
                                text: "Address  : ",
                                textAlign: TextAlign.left,
                                textSize: 18,
                              ),
                              GenericText(
                                text: "${seller.address}",
                                textAlign: TextAlign.left,
                                textSize: 18,
                              ),
                            ]),
                        Divider(
                          thickness: 2,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GenericText(
                                text: "Created At  : ",
                                textAlign: TextAlign.left,
                                textSize: 18,
                              ),
                              GenericText(
                                text:
                                    "${widget.advertisement.createdDate.toString().substring(0, 16)}",
                                textAlign: TextAlign.left,
                                textSize: 18,
                              ),
                            ])
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    !widget.isOwner
                        ? Wrap(
                            spacing: 20,
                            children: [
                              GenericButton(
                                isBold: true,
                                text: _hasCallSupport
                                    ? CALL
                                    : CALLING_NOT_SUPPORTED,
                                paddingHorizontal: 4,
                                paddingVertical: 2,
                                onPressed: _hasCallSupport
                                    ? () => setState(() {
                                          _launched = _makePhoneCall(
                                              seller.contactDetails);
                                        })
                                    : null,
                                shadowColor: Colors.transparent,
                                backgroundColor: Colors.blue,
                                borderRadius: 14,
                              )
                            ],
                            alignment: WrapAlignment.center,
                          )
                        : Wrap(
                            spacing: 20,
                            children: [
                              GenericButton(
                                isBold: true,
                                text: 'Update',
                                paddingHorizontal: 4,
                                paddingVertical: 2,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EditExistingAdvertisementPage(
                                          spareAdvertisement:
                                              widget.advertisement,
                                        ),
                                      ));
                                },
                                shadowColor: Colors.transparent,
                                backgroundColor: Colors.blue,
                                borderRadius: 14,
                              ),
                              GenericButton(
                                text: 'Remove',
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
                              if (!widget.advertisement.isPaymentDone)
                                GenericButton(
                                  text: 'Pay',
                                  isBold: true,
                                  paddingHorizontal: 4,
                                  paddingVertical: 2,
                                  onPressed: () {
                                    var params = {
                                      'adId': widget.advertisement.aId,
                                      'item': widget.advertisement.title
                                    };
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AdvertisementPaymentPage(
                                            params: params,
                                          ),
                                        ));
                                  },
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
