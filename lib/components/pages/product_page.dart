import 'package:auto_picker/components/atoms/generic_button.dart';
import 'package:auto_picker/components/atoms/image_corousal.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/models/carousel_data.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({Key key}) : super(key: key);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Product'),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.more_horiz,
                  size: 26.0,
                ),
              )),
        ],
        actionsIconTheme:
            IconThemeData(size: 30.0, color: Colors.grey, opacity: 10.0),
      ),
      bottomNavigationBar: Footer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Kasun Traders',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
              CustomCarousel(
                items: [
                  //**************** to be removed *****************/
                  CarouselItemData(
                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcThsbKGhH8Cy1G3PffQSiOnF3IUlLEs1r6Dmo96ZyC5fL-soXNzq9_UeDHBV-ZV9Q-ynMs&usqp=CAU',
                      'title1',
                      'subTitle1'),
                  CarouselItemData(
                      'https://china-gadgets.com/app/uploads/2021/08/CaDA_C61027W_Humvee.jpg',
                      'title2',
                      'subTitle2')
                  //**************** to be removed *******************/
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Product Name',
                        style: TextStyle(fontSize: 24),
                      ),
                      Text('Vehicle Type',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          )),
                    ],
                    mainAxisSize: MainAxisSize.min,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Product Price ',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Text(
                    'Phone number ',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Text(
                    'Product Address ',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18),
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  Text(
                    'Product Description',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Wrap(
                spacing: 20,
                children: [
                  GenericButton(
                    text: 'CALL',
                    paddingHorizontal: 4,
                    paddingVertical: 2,
                    onPressed: () {},
                    shadowColor: Colors.transparent,
                    borderRadius: 14,
                  ),
                  GenericButton(
                    text: 'CHAT',
                    paddingHorizontal: 4,
                    paddingVertical: 2,
                    onPressed: () {},
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
                    shadowColor: Colors.transparent,
                    borderRadius: 14,
                  ),
                  GenericButton(
                    text: 'ORDER',
                    paddingHorizontal: 4,
                    paddingVertical: 2,
                    onPressed: () {},
                    shadowColor: Colors.transparent,
                    borderRadius: 14,
                  ),
                  GenericButton(
                    text: 'VISIT SHOP',
                    paddingHorizontal: 4,
                    paddingVertical: 2,
                    onPressed: () {},
                    backgroundColor: Colors.blue,
                    textColor: Colors.white,
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
