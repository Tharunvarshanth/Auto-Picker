import 'package:auto_picker/themes/colors.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  String title;
  String description;
  String price;
  double titleTextSize;
  double descriptionTextSize;
  Color priceTextColor;
  Color titleColor;
  Color descriptionColor;
  String imgUrl;
  String errorBuilderAssetName;
  double priceTextSize;
  double imgBorderRadius;

  ProductTile(
      {Key key,
      this.description = 'no decription',
      this.descriptionColor = Colors.white,
      this.descriptionTextSize = 14,
      this.errorBuilderAssetName = '',
      this.imgUrl = '',
      this.price = 'price',
      this.priceTextColor = Colors.white,
      this.title = 'title',
      this.titleColor = Colors.white,
      this.titleTextSize = 16,
      this.priceTextSize = 14,
      this.imgBorderRadius = 20})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      height: 100,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColors.ash,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blue[400].withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 4,
              // changes position of shadow
            ),
          ],
          gradient: LinearGradient(
            begin: FractionalOffset.topCenter,
            end: FractionalOffset.bottomCenter,
            colors: [
              // Colors.blue[100].withOpacity(0.4),
              Colors.blue[600],
              Colors.blue[700],
            ],
            stops: [0.95, 5.0],
          )),
      child: Row(
        children: [
          Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                width: 175,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(imgBorderRadius),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(imgBorderRadius),
                  child: Image.network(
                    imgUrl,
                    fit: BoxFit.fill,
                    width: 150,
                    height: 75,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(errorBuilderAssetName);
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                          child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes
                            : null,
                      ));
                    },
                  ),
                ),
              ),
              flex: 2),
          Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: titleTextSize,
                          color: titleColor,
                          fontWeight: FontWeight.w900),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          fontSize: descriptionTextSize,
                          color: descriptionColor),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              flex: 4),
          Expanded(
              child: Text(
                price,
                style: TextStyle(
                    fontSize: priceTextSize,
                    color: priceTextColor,
                    fontWeight: FontWeight.w600),
                textAlign: TextAlign.start,
              ),
              flex: 2),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );
  }
}
