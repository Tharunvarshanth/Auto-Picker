import 'package:auto_picker/components/atoms/popup_modal_message.dart';
import 'package:auto_picker/components/pages/advertisement_page.dart';
import 'package:auto_picker/models/carousel_data.dart';
import 'package:auto_picker/models/spare_advertisement.dart';
import 'package:auto_picker/themes/colors.dart';
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
  void Function(int index) onPressedAd;
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
      this.titleTextSize = 20,
      this.onPressedAd})
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () => widget.onPressedAd(counter),
          child: Stack(
            children: [
              CarouselSlider.builder(
                itemCount: widget.items.length,
                carouselController: controller,
                itemBuilder:
                    (BuildContext context, int itemIndex, int pageViewIndex) {
                  counter = itemIndex;
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.items[itemIndex].imageList[0],
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                    initialPage: 0,
                    height: MediaQuery.of(context).size.height *
                        widget.heightPercentage,
                    enlargeCenterPage: true,
                    autoPlay: widget.autoplay,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 100),
                    viewportFraction: 1.0,
                    onScrolled: (value) {
                      print("OnScolled ${value.toInt()}");
                      print("OnScolled ");
                      //setState(() {
                      // counter =  itemIndex// widget.items.length;

                      print("OnScolled counter ${counter}");
                      //});
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
                          backgroundColor: AppColors.primaryVariant,
                          color: widget.titleColor,
                          fontSize: widget.titleTextSize),
                    ),
                    Text(
                      widget.items[counter] != null
                          ? widget.items[counter].subtitle
                          : '',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          backgroundColor: AppColors.primaryVariant,
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
