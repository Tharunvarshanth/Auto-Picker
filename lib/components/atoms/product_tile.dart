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
      this.descriptionColor = Colors.black45,
      this.descriptionTextSize = 14,
      this.errorBuilderAssetName = '',
      this.imgUrl = '',
      this.price = 'price',
      this.priceTextColor = Colors.black,
      this.title = 'title',
      this.titleColor = Colors.black,
      this.titleTextSize = 16,
      this.priceTextSize = 14,
      this.imgBorderRadius = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Row(
      children: [
        Expanded(
            child: Container(
              width: 150,
              height: 75,
              decoration: BoxDecoration(
                  color: AppColors.black,
                  border: Border.all(
                    color: AppColors.black,
                    width: 1,
                  )),
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
                    style:
                        TextStyle(fontSize: titleTextSize, color: titleColor),
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    description,
                    style: TextStyle(
                        fontSize: descriptionTextSize, color: descriptionColor),
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
    );
  }
}
