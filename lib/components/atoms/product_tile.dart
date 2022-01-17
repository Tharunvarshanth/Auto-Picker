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
      this.descriptionTextSize = 20,
      this.errorBuilderAssetName = '',
      this.imgUrl = '',
      this.price = 'price',
      this.priceTextColor = Colors.black,
      this.title = 'title',
      this.titleColor = Colors.black,
      this.titleTextSize = 20,
      this.priceTextSize = 20,
      this.imgBorderRadius = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(imgBorderRadius),
              child: Image.network(
                imgUrl,
                fit: BoxFit.cover,
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
            flex: 3),
        Expanded(
            child: Text(
              price,
              style: TextStyle(fontSize: priceTextSize, color: priceTextColor),
              textAlign: TextAlign.start,
            ),
            flex: 2),
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}
