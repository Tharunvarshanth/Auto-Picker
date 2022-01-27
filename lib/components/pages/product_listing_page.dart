import 'package:auto_picker/components/atoms/product_tile.dart';
import 'package:auto_picker/components/organisms/footer.dart';
import 'package:flutter/material.dart';

class ProductListingPage extends StatefulWidget {
  const ProductListingPage({Key key}) : super(key: key);

  @override
  _ProductListingPageState createState() => _ProductListingPageState();
}

class _ProductListingPageState extends State<ProductListingPage> {
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() async {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        //fetch new data
        // if (no data!!) {
        //   return;
        // }
        setState(() {
          //put data
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Footer(),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Product Listing'),
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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: ListView.builder(
          controller: _controller,
          itemCount: 24,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                print('tapped ${index}');
              },
              child: ProductTile(
                price: '149.44',
                imgUrl:
                    'https://www.baltimoresun.com/resizer/3XTrUJijX5I0A8tHWFaZTPcuwVA=/1200x0/top/arc-anglerfish-arc2-prod-tronc.s3.amazonaws.com/public/TA4KIUWDXRHVVKRNR22O6HXMNI.jpg',
              ),
            );
          },
        ),
      ),
    ));
  }
}
