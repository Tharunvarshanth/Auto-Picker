import 'package:auto_picker/components/organisms/order_tile.dart';
import 'package:auto_picker/models/order_data.dart';
import 'package:flutter/material.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({Key key}) : super(key: key);

  @override
  _OrdersListState createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  ScrollController _controller = ScrollController();
  List<OrderData> ordersList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      //add scroll listener to load data from database
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
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Orders'),
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
      // bottomNavigationBar: Footer(
      //   items: [
      //     IconLabelPair(icon: Icon(Icons.home), label: 'Home'),
      //     IconLabelPair(icon: Icon(Icons.home), label: 'Home'),
      //     IconLabelPair(icon: Icon(Icons.home), label: 'Home'),
      //   ],
      //   onTap: (int index) {},
      // ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                    flex: 2,
                    child: ListTile(
                      title: Text('Sorted By'),
                      subtitle: Text(
                        'Recommended',
                        style: TextStyle(color: Colors.cyan),
                      ),
                    )),
                IconButton(onPressed: () {}, icon: Icon(Icons.sync_rounded))
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: ordersList.length != 0
                  ? ListView.builder(
                      controller: _controller,
                      itemCount: ordersList.length,
                      itemBuilder: (context, index) {
                        return OrderTile(
                            ItemTitle: ordersList[index].ItemTitle,
                            itemCount: ordersList[index].itemCount,
                            itemPrice: ordersList[index].itemPrice,
                            itemSubTitle: ordersList[index].itemSubTitle,
                            itemImgUrl: ordersList[index].itemImgUrl,
                            orderedBy: ordersList[index].orderedBy);
                      },
                    )
                  : Center(
                      child: Image.network(
                          'https://shuvautsav.com/frontend/dist/images/logo/no-item-found-here.png'),
                    ),
            ),
          )
        ],
      ),
    ));
  }
}
