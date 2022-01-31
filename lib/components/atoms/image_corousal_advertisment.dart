import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/pages/advertisement_page.dart';
import 'package:auto_picker/models/carousel_data.dart';
import 'package:auto_picker/models/spare_advertisement.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CustomCarouselAdvertisement extends StatefulWidget {
  List<SpareAdvertisement> items;
  double heightPercentage;
  bool autoplay;
  Color titleColor;
  Color subTitleColor;
  Color arrowColor;
  double titleTextSize;
  double subtitleTextSize;
  double arrowSize;
  CustomCarouselAdvertisement(
      {Key key,
      this.items = const [],
      this.heightPercentage = 0.4,
      this.autoplay = true,
      this.arrowColor = Colors.white,
      this.arrowSize = 48,
      this.subTitleColor = Colors.white,
      this.subtitleTextSize = 16,
      this.titleColor = Colors.white,
      this.titleTextSize = 20})
      : super(key: key);

  @override
  State<CustomCarouselAdvertisement> createState() =>
      _CustomCarouselAdvertisementState();
}

class _CustomCarouselAdvertisementState
    extends State<CustomCarouselAdvertisement> {
  CarouselController controller = CarouselController();
  int counter = 0;
  bool isLogged = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void initState() {
    setState(() {
      isLogged = _auth.currentUser != null ? true : false;
    });
  }

  void navigateToAdvertisementPage(int index) {
    print("advert");
    if (isLogged) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdvertisementPage(
              advertisement: widget.items[index],
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () => navigateToAdvertisementPage(counter),
          child: Stack(
            children: [
              CarouselSlider(
                carouselController: controller,
                items: widget.items
                    .map(
                      (e) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(
                              e.imageList[0],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                    height: MediaQuery.of(context).size.height *
                        widget.heightPercentage,
                    enlargeCenterPage: true,
                    autoPlay: widget.autoplay,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 1.0,
                    onScrolled: (value) {
                      setState(() {
                        counter = value != null
                            ? value.toInt() % widget.items.length
                            : 0;
                      });
                    },
                    pageSnapping: true),
              ),
              Container(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Text(
                      widget.items[counter] != null
                          ? widget.items[counter].title
                          : '',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: widget.titleColor,
                          fontSize: widget.titleTextSize),
                    ),
                    Text(
                      widget.items[counter] != null
                          ? widget.items[counter].subtitle
                          : '',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: widget.subTitleColor,
                          fontSize: widget.subtitleTextSize),
                    ),
                  ],
                  mainAxisSize: MainAxisSize.min,
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints2) {
                  return Container(
                    decoration: BoxDecoration(color: Colors.transparent),
                    height: MediaQuery.of(context).size.height *
                        widget.heightPercentage,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          child: Icon(
                            Icons.arrow_left,
                            color: widget.arrowColor,
                            size: widget.arrowSize,
                          ),
                          onTap: () => controller.previousPage(),
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.arrow_right,
                            color: widget.arrowColor,
                            size: widget.arrowSize,
                          ),
                          onTap: () => controller.nextPage(),
                        )
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
