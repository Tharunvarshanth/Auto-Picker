import 'package:auto_picker/components/atoms/custom_app_bar.dart';
import 'package:auto_picker/components/atoms/generic_text.dart';
import 'package:auto_picker/components/atoms/generic_text_button.dart';
import 'package:auto_picker/components/atoms/image_corousal.dart';
import 'package:auto_picker/components/atoms/product_tile.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:auto_picker/components/organisms/mechanics_horizontal_scroll.dart';
import 'package:auto_picker/models/carousel_data.dart';
import 'package:auto_picker/models/mechanic.dart';
import 'package:auto_picker/services/mechanic_controller.dart';
import 'package:auto_picker/services/product_controller.dart';
import 'package:auto_picker/services/spare_advertisement_controller.dart';
import 'package:auto_picker/store/cache/sharedPreferences/user_info.dart';
import 'package:auto_picker/themes/colors.dart';
import 'package:auto_picker/utilities/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../routes.dart';

class HomePage extends StatefulWidget {
  const HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController controller = ScrollController();
  var mechanicsController = MechanicController();
  var advertisementController = AdvertisementController();
  var productController = ProductController();
  List<Mechanic> mechanicList = [];

  var userInfo = UserInfoCache();
  bool isLogged = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {});
    getMechanicsList();
  }

  getMechanicsList() async {
    List<dynamic> res = await mechanicsController.getMechanics();
    if (res != null) {
      res.forEach((element) {
        print(element);
        setState(() {
          mechanicList.add(Mechanic.fromJson(element));
        });
      });
    }
  }

  signOut() {
    //redirect
    userInfo.clearValue();
    _auth.signOut().then((value) => navigate(context, RouteGenerator.homePage));
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
    Future<void> getLogged() async {
      if (await userInfo.getId() != null) {
        setState(() {
          isLogged = true;
        });
      }
    }

    getLogged();

    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        showBackButton: false,
        title: 'Home',
        isLogged: isLogged,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              GenericText(text: 'Mechanics', isBold: true, textSize: 24),
              GenericTextButton(
                color: AppColors.Blue,
                text: 'See All',
                onPressed: () {},
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            MechanicsHorizontalItemScroll(
                ImageTileList: mechanicList,
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
            ),
            GenericTextButton(
              text: 'logout',
              onPressed: signOut,
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
