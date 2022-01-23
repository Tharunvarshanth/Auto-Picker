import 'package:auto_picker/components/atoms/image_corousal.dart';
import 'package:auto_picker/components/atoms/product_tile.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/organisms/horizontal_scroll.dart';
import 'package:auto_picker/models/carousel_data.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {});
  }

  //**************** to be removed *************/
  var productList = [
    ProductTile(
      imgUrl:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTChtPT6q3LdPw2-KygtlEaatQjJCffmLPZNw&usqp=CAU',
    ),
  ];
  //**************** to be removed **********/
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                const Center(
                  child: Text(
                    'Home',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  ),
                ),
                Positioned(
                    child: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.notifications_outlined,
                          color: Colors.blue,
                          size: 32,
                        )))
              ],
            ),
            Divider(
              thickness: 2,
            ),
            Text(
              'Mechanics',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 20,
            ),
            HorizontalItemScroll(
                ImageTileList: [],
                onReachMax: () {
                  return Future.value([]);
                }),
            SizedBox(
              height: 20,
            ),
            Text(
              'Products',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(
              height: 20,
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              height: 400,
              child: ListView.builder(
                controller: controller,
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return productList[index];
                },
              ),
            )
          ],
        )),
      ),
      bottomNavigationBar: Footer(
        items: [
          IconLabelPair(icon: Icon(Icons.home), label: 'Home'),
          IconLabelPair(icon: Icon(Icons.home), label: 'Home'),
          IconLabelPair(icon: Icon(Icons.home), label: 'Home'),
        ],
        onTap: (int index) {},
      ),
    ));
  }
}
