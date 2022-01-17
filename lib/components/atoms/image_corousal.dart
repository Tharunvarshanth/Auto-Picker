import 'package:auto_picker/models/carousel_data.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomCarousel extends StatefulWidget {
  List<CarouselItemData> items;
  double heightPercentage;
  bool autoplay;
  Color titleColor;
  Color subTitleColor;
  Color arrowColor;
  double titleTextSize;
  double subtitleTextSize;
  double arrowSize;
  CustomCarousel(
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
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  CarouselController controller = CarouselController();
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            CarouselSlider(
              carouselController: controller,
              items: widget.items
                  .map((e) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(
                              e.imageUrl,
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ))
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
                        ? widget.items[counter].subTitle
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
        );
      },
    );
  }
}
